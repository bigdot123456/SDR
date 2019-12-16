
// Xianjun jiao. putaoshu@msn.com; xianjun.jiao@imec.be;

`timescale 1 ns / 1 ps

	module rx_intf #
	(
        parameter integer GPIO_STATUS_WIDTH = 8,
        parameter integer RSSI_HALF_DB_WIDTH = 11,

		parameter integer ADC_PACK_DATA_WIDTH	= 64,
		parameter integer IQ_DATA_WIDTH	=     16,
		parameter integer RSSI_DATA_WIDTH	=     10,
		
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 7,

		parameter integer C_S00_AXIS_TDATA_WIDTH	= 64,
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 64,
		
        parameter integer WAIT_COUNT_BITS = 5,
		parameter integer MAX_NUM_DMA_SYMBOL = 8192,
        parameter integer TSF_TIMER_WIDTH = 64 // according to 802.11 standard
	)
	(
	    // from ad9361_adc_pack
        input wire adc_clk,
        //input wire adc_rst,
        input wire [(ADC_PACK_DATA_WIDTH-1) : 0] adc_data,
        //(* mark_debug = "true" *) input wire adc_sync,
        (* mark_debug = "true" *) input wire adc_valid,

	    // Ports to openofdm rx
        output wire [(2*IQ_DATA_WIDTH-1) : 0] sample,
	    output wire sample_strobe,
        input  wire pkt_header_valid,
        input  wire pkt_header_valid_strobe,
        input  wire ht_unsupport,
        input  wire [7:0] pkt_rate,
		input  wire [15:0] pkt_len,
		input  wire byte_in_strobe,
		input  wire [7:0] byte_in,
		input  wire [15:0] byte_count,
        input  wire fcs_in_strobe,
		input  wire fcs_ok,

	    // interrupt to PS
        (* mark_debug = "true" *) output wire rx_pkt_intr,
        
        // interrupt from xilixn axi dma
        (* mark_debug = "true" *) input wire s2mm_intr,
        
        // for xpu
        input  wire mute_adc_out_to_bb, // in acc clock domain
        input  wire block_rx_dma_to_ps, // if addr filter is on in xpu
        input  wire block_rx_dma_to_ps_valid, // if addr filter is on in xpu
 	    input wire [(RSSI_HALF_DB_WIDTH-1):0] rssi_half_db_lock_by_sig_valid,
        input wire [(GPIO_STATUS_WIDTH-1):0] gpio_status_lock_by_sig_valid,
        input wire [(TSF_TIMER_WIDTH-1):0]  tsf_runtime_val,
        input wire tsf_pulse_1M,

		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,

		// Ports of Axi Slave Bus Interface S00_AXIS to PS
		input wire  s00_axis_aclk,
		input wire  s00_axis_aresetn,
		output wire  s00_axis_tready,
		input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
		input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
		input wire  s00_axis_tlast,
		input wire  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXIS to PS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready
	);

	function integer clogb2 (input integer bit_depth);                                   
      begin                                                                              
        for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                                      
          bit_depth = bit_depth >> 1;                                                    
      end                                                                                
    endfunction   
    
    localparam integer MAX_BIT_NUM_DMA_SYMBOL  = clogb2(MAX_NUM_DMA_SYMBOL);
    
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg0; 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg1; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg2; 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg3; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg4; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg5; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg6; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg7; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg8; 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg9; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg10; 
    //wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg11; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg12; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg13; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg14; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg15; // 
    wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg16; 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg17; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg18; 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg19; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg20; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg21; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg22; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg23; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg24; 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg25; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg26; 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg27; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg28; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg29; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg30; // 
    // wire [(C_S00_AXI_DATA_WIDTH-1):0] slv_reg31; // 

    //for direct loop back
	wire  s00_axis_tready_inner;
	wire  m00_axis_tvalid_inner;
	wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata_inner;
	wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb_inner;
	wire  m00_axis_tlast_inner;
    wire  m00_axis_tlast_auto_recover;

    wire [(ADC_PACK_DATA_WIDTH-1) : 0] ant_data_in;
    wire [(ADC_PACK_DATA_WIDTH-1) : 0] ant_data_after_sel;

    wire acc_ask_data_from_s_axis;
    wire acc_ask_data_from_adc;
    wire ddc_ask_data_from_adc;
    (* mark_debug = "true" *) wire emptyn_from_adc_to_ddc;

    (* mark_debug = "true" *) wire [(IQ_DATA_WIDTH-1) : 0] rf_i_to_acc;
	wire [(IQ_DATA_WIDTH-1) : 0] rf_q_to_acc;

    wire ddc_bypass;
    (* mark_debug = "true" *) wire ask_data_from_adc;
    (* mark_debug = "true" *) wire ddc_bw20_iq_valid;
	wire [(IQ_DATA_WIDTH-1):0] ddc_bw20_i0;
    wire [(IQ_DATA_WIDTH-1):0] ddc_bw20_q0;
    wire [(IQ_DATA_WIDTH-1):0] ddc_bw20_i1;
    wire [(IQ_DATA_WIDTH-1):0] ddc_bw20_q1;
	wire [(IQ_DATA_WIDTH-1):0] adc_bw20_i0;
    wire [(IQ_DATA_WIDTH-1):0] adc_bw20_q0;
    wire [(IQ_DATA_WIDTH-1):0] adc_bw20_i1;
    wire [(IQ_DATA_WIDTH-1):0] adc_bw20_q1;
    
	wire [(IQ_DATA_WIDTH-1):0] bw20_i0;
    wire [(IQ_DATA_WIDTH-1):0] bw20_q0;
    wire [(IQ_DATA_WIDTH-1):0] bw20_i1;
    wire [(IQ_DATA_WIDTH-1):0] bw20_q1;
    wire bw20_iq_valid;
    wire [(IQ_DATA_WIDTH-1):0] bw02_i0;
    wire [(IQ_DATA_WIDTH-1):0] bw02_q0;
    wire [(IQ_DATA_WIDTH-1):0] bw02_i1;
    wire [(IQ_DATA_WIDTH-1):0] bw02_q1;
    wire bw02_iq_valid;
        
    wire [(C_S00_AXIS_TDATA_WIDTH-1):0] s_axis_data_to_acc;
    wire s_axis_emptyn_to_acc;
    wire [(MAX_BIT_NUM_DMA_SYMBOL-1) : 0] s_axis_fifo_data_count;
    
    wire [(C_S00_AXIS_TDATA_WIDTH-1):0] rf_iq_loopback;
    
	(* mark_debug = "true" *) wire start_1trans_from_acc_to_m_axis;
    (* mark_debug = "true" *) wire [(C_M00_AXIS_TDATA_WIDTH-1):0] data_from_acc_to_m_axis;
    (* mark_debug = "true" *) wire data_ready_from_acc_to_m_axis;
    (* mark_debug = "true" *) wire fulln_from_m_axis_to_acc;
    (* mark_debug = "true" *) wire [MAX_BIT_NUM_DMA_SYMBOL-1 : 0] m_axis_fifo_data_count;
    wire fcs_valid_internal;
    wire rx_pkt_intr_internal;
    wire intr_internal;
    
    (* mark_debug = "true" *) wire wifi_rx_iq_fifo_emptyn;
    
    //wire [(MAX_BIT_NUM_DMA_SYMBOL-1) : 0] monitor_num_dma_symbol_to_pl;
    wire [(MAX_BIT_NUM_DMA_SYMBOL-1) : 0] monitor_num_dma_symbol_to_ps;
    wire [(MAX_BIT_NUM_DMA_SYMBOL-1) : 0] num_dma_symbol_to_pl;
    (* mark_debug = "true" *) wire [(MAX_BIT_NUM_DMA_SYMBOL-1) : 0] num_dma_symbol_to_ps;

    //wire fcs_invalid_from_acc_delay;
    (* mark_debug = "true" *) wire m_axis_auto_rst;
    wire m_axis_rst;
    wire enable_m_axis_auto_rst;
    
    wire mute_adc_out_to_bb_in_rf_domain;
    wire [(ADC_PACK_DATA_WIDTH-1) : 0] adc_data_internal;

    (* mark_debug = "true" *) wire [(C_M00_AXIS_TDATA_WIDTH-1) : 0] data_from_acc;
	(* mark_debug = "true" *) wire data_ready_from_acc;

    wire fcs_valid;
    wire fcs_invalid;
    wire sig_valid;
    wire sig_invalid;

    wire rx_pkt_sn_plus_one;

    assign sample = {rf_i_to_acc,rf_q_to_acc};
    assign fcs_valid = (fcs_in_strobe&fcs_ok);
    assign fcs_invalid = (fcs_in_strobe&(~fcs_ok));
    assign sig_valid = (pkt_header_valid_strobe&pkt_header_valid);
    assign sig_invalid = (pkt_header_valid_strobe&(~pkt_header_valid));

    //for direct loopback
	assign s00_axis_tready = (slv_reg5[12]==1)?m00_axis_tready:s00_axis_tready_inner;
	assign m00_axis_tvalid = (slv_reg5[12]==1)?s00_axis_tvalid:m00_axis_tvalid_inner;
	assign m00_axis_tdata = (slv_reg5[12]==1)?s00_axis_tdata:m00_axis_tdata_inner;
	assign m00_axis_tstrb = (slv_reg5[12]==1)?s00_axis_tstrb:m00_axis_tstrb_inner;
	assign m00_axis_tlast = (slv_reg5[12]==1)?s00_axis_tlast:(m00_axis_tlast_inner|m00_axis_tlast_auto_recover);

    //assign slv_reg23[(GPIO_STATUS_WIDTH-1):0] = gpio_status;

    assign fcs_valid_internal = (slv_reg5[3]==0?fcs_valid:fcs_in_strobe);
    assign rx_pkt_intr = (slv_reg2[8]==0?intr_internal:slv_reg2[0]);
    
    assign intr_internal = (slv_reg2[12]==0?rx_pkt_intr_internal:fcs_valid_internal);

    //assign num_dma_symbol_to_pl = (slv_reg5[4]==1)?(monitor_num_dma_symbol_to_pl-1):(slv_reg8[(MAX_BIT_NUM_DMA_SYMBOL-1):0]-1);
    assign num_dma_symbol_to_pl = (slv_reg8[(MAX_BIT_NUM_DMA_SYMBOL-1):0]-1);
    assign num_dma_symbol_to_ps = (slv_reg5[5]==1)?(monitor_num_dma_symbol_to_ps-1):(slv_reg9[(MAX_BIT_NUM_DMA_SYMBOL-1):0]-1);

    assign enable_m_axis_auto_rst = slv_reg5[16];
    assign m_axis_auto_rst = (m_axis_rst&enable_m_axis_auto_rst);

    assign adc_bw20_i0 = ant_data_after_sel[15:0];
    assign adc_bw20_q0 = ant_data_after_sel[31:16];
    assign adc_bw20_i1 = ant_data_after_sel[47:32];
    assign adc_bw20_q1 = ant_data_after_sel[63:48];
  
    assign ddc_bypass = slv_reg10[4];
    assign ask_data_from_adc = (ddc_bypass? acc_ask_data_from_adc : ddc_ask_data_from_adc);
    assign bw20_iq_valid     = (ddc_bypass?emptyn_from_adc_to_ddc : ddc_bw20_iq_valid);
    assign bw20_i0           = (ddc_bypass?           adc_bw20_i0 : ddc_bw20_i0);
    assign bw20_q0           = (ddc_bypass?           adc_bw20_q0 : ddc_bw20_q0);
    assign bw20_i1           = (ddc_bypass?           adc_bw20_i1 : ddc_bw20_i1);
    assign bw20_q1           = (ddc_bypass?           adc_bw20_q1 : ddc_bw20_q1);
    
    assign adc_data_internal = (mute_adc_out_to_bb_in_rf_domain?0:adc_data);
    
// ---------------------------fro mute_adc_out_to_bb control from acc domain to adc domain-------------------------------------
    xpm_cdc_array_single #(
      //Common module parameters
      .DEST_SYNC_FF   (4), // integer; range: 2-10
      .INIT_SYNC_FF   (0), // integer; 0=disable simulation init values, 1=enable simulation init values
      .SIM_ASSERT_CHK (0), // integer; 0=disable simulation messages, 1=enable simulation messages
      .SRC_INPUT_REG  (1), // integer; 0=do not register input, 1=register input
      .WIDTH          (1)  // integer; range: 1-1024
    ) xpm_cdc_array_single_inst_mute_adc (
      .src_clk  (s00_axi_aclk),  // optional; required when SRC_INPUT_REG = 1
      .src_in   (mute_adc_out_to_bb),
      .dest_clk (adc_clk),
      .dest_out (mute_adc_out_to_bb_in_rf_domain)
    );

    adc_intf # (
        .ADC_PACK_DATA_WIDTH(ADC_PACK_DATA_WIDTH)
    ) adc_intf_i (
        //.adc_rst(adc_rst|slv_reg0[0]),
        .adc_clk(adc_clk),
        .adc_data(adc_data_internal),
        //.adc_sync(adc_sync),
        .adc_valid(adc_valid),
        .acc_clk(s00_axis_aclk),
        .acc_rstn(s00_axis_aresetn&(~slv_reg0[5])),
        .data_to_acc(ant_data_in),
        .emptyn_to_acc(emptyn_from_adc_to_ddc),
        .acc_ask_data(ask_data_from_adc&(~slv_reg10[1]))
    );
    
    rx_intf_ant_selection # (
        .ADC_PACK_DATA_WIDTH(ADC_PACK_DATA_WIDTH)
    ) rx_intf_ant_selection_i (
        .data_in(ant_data_in),
        .ant_flag(slv_reg16[1:0]),
        .data_out(ant_data_after_sel)
    );
    
    ddc_bank_core_intf # (
    ) ddc_bank_core_intf_i (
        .cfg0(slv_reg1),
        .clk(s00_axis_aclk),
        .iq_rd_data(ant_data_after_sel),
        .iq_rd_en(ddc_ask_data_from_adc),
        .iq_empty_n(emptyn_from_adc_to_ddc),
        .rstn(s00_axis_aresetn&(~slv_reg0[1])),
        .bw20_data_tvalid(ddc_bw20_iq_valid),
//        .gain_cfg(slv_reg10[9:8]),
        .bw20_i0(ddc_bw20_i0),
        .bw20_q0(ddc_bw20_q0),
        .bw20_i1(ddc_bw20_i1),
        .bw20_q1(ddc_bw20_q1),
        .bw02_i0(bw02_i0),
        .bw02_q0(bw02_q0),
        .bw02_i1(bw02_i1),
        .bw02_q1(bw02_q1),
        .bw02_data_tvalid(bw02_iq_valid)
    );

// Instantiation of Axi Bus Interface S00_AXI
	rx_intf_s_axi # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) rx_intf_s_axi_i (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),

		.SLV_REG0(slv_reg0),
		.SLV_REG1(slv_reg1),
		.SLV_REG2(slv_reg2),
		.SLV_REG3(slv_reg3),
		.SLV_REG4(slv_reg4),
        .SLV_REG5(slv_reg5),
        .SLV_REG6(slv_reg6),
        .SLV_REG7(slv_reg7),
		.SLV_REG8(slv_reg8),
        .SLV_REG9(slv_reg9),
        .SLV_REG10(slv_reg10),
        //.SLV_REG11(slv_reg11),
        .SLV_REG12(slv_reg12),
        .SLV_REG13(slv_reg13),
        //.SLV_REG14(slv_reg14),
        //.SLV_REG15(slv_reg15),
		.SLV_REG16(slv_reg16)/*,
        .SLV_REG17(slv_reg17),
        .SLV_REG18(slv_reg18),
        .SLV_REG19(slv_reg19),
        .SLV_REG20(slv_reg20),
        .SLV_REG21(slv_reg21),
        .SLV_REG22(slv_reg22),
        .SLV_REG23(slv_reg23),
		.SLV_REG24(slv_reg24),
        .SLV_REG25(slv_reg25),
        .SLV_REG26(slv_reg26),
        .SLV_REG27(slv_reg27),
        .SLV_REG28(slv_reg28),
        .SLV_REG29(slv_reg29),
        .SLV_REG30(slv_reg30),
        .SLV_REG31(slv_reg31)*/
	);
	
// Instantiation of Axi Bus Interface S00_AXIS
	rx_intf_s_axis # ( 
		.C_S_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH),
		.MAX_NUM_DMA_SYMBOL(MAX_NUM_DMA_SYMBOL),
        .MAX_BIT_NUM_DMA_SYMBOL(MAX_BIT_NUM_DMA_SYMBOL)
	) rx_intf_s_axis_i (
		.S_AXIS_ACLK(s00_axis_aclk),
		.S_AXIS_ARESETN(s00_axis_aresetn&(~slv_reg0[2])),
		.S_AXIS_TREADY(s00_axis_tready_inner),
		.S_AXIS_TDATA(s00_axis_tdata),
		.S_AXIS_TSTRB(s00_axis_tstrb),
		.S_AXIS_TLAST(s00_axis_tlast),
		.S_AXIS_TVALID(s00_axis_tvalid),
		.S_AXIS_NUM_DMA_SYMBOL(num_dma_symbol_to_pl),

        .endless_mode(slv_reg5[8]),
		.data_count(s_axis_fifo_data_count),
        .DATA_TO_ACC(s_axis_data_to_acc),
        .EMPTYN_TO_ACC(s_axis_emptyn_to_acc),
        .ACC_ASK_DATA(acc_ask_data_from_s_axis&(~slv_reg10[0]))
	);

    rx_iq_intf # (
        .C_S00_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH),
        .IQ_DATA_WIDTH(IQ_DATA_WIDTH)
    ) rx_iq_intf_i (
        .rstn(s00_axis_aresetn&(~slv_reg0[3])),
        .clk(s00_axis_aclk),
        .bw20_i0(bw20_i0),
        .bw20_q0(bw20_q0),
        .bw20_i1(bw20_i1),
        .bw20_q1(bw20_q1),
        .bw20_iq_valid(bw20_iq_valid),
        .bw02_i0(bw02_i0),
        .bw02_q0(bw02_q0),
        .bw02_i1(bw02_i1),
        .bw02_q1(bw02_q1),
        .bw02_iq_valid(bw02_iq_valid),
        .data_from_s_axis(s_axis_data_to_acc),
        .emptyn_from_s_axis(s_axis_emptyn_to_acc),
        .ask_data_from_s_axis(acc_ask_data_from_s_axis),
        .ask_data_from_adc(acc_ask_data_from_adc),
        .fifo_in_sel(slv_reg3[2:0]),
        .fifo_out_sel(slv_reg3[3]),
        .ask_data_from_s_axis_en(~slv_reg4[0]),
        .fifo_in_en(~slv_reg4[1]),
        .fifo_out_en(~slv_reg4[2]),
        .bb_20M_en(slv_reg4[3]),
        .rf_i(rf_i_to_acc),
        .rf_q(rf_q_to_acc),
        .rf_iq_valid(sample_strobe),
        .rf_iq_valid_delay_sel(slv_reg3[4]),
        .rf_iq(rf_iq_loopback),
        .wifi_rx_iq_fifo_emptyn(wifi_rx_iq_fifo_emptyn)
    );

    byte_to_word_fcs_sn_insert byte_to_word_fcs_sn_insert_inst (
        .clk(m00_axis_aclk),
        .rstn(m00_axis_aresetn&(~slv_reg0[7])&(~pkt_header_valid_strobe)),
        .rstn_sn(m00_axis_aresetn&(~slv_reg0[7])),

        .byte_in(byte_in),
        .byte_in_strobe(byte_in_strobe),
        .byte_count(byte_count),
        .num_byte(pkt_len),
        .fcs_in_strobe(fcs_in_strobe),
        .fcs_ok(fcs_ok),
        .rx_pkt_sn_plus_one(rx_pkt_sn_plus_one),

        .word_out(data_from_acc),
        .word_out_strobe(data_ready_from_acc)
    );

    rx_intf_pl_to_m_axis # ( 
        .GPIO_STATUS_WIDTH(GPIO_STATUS_WIDTH),
        .RSSI_HALF_DB_WIDTH(RSSI_HALF_DB_WIDTH),
        .IQ_DATA_WIDTH(IQ_DATA_WIDTH),
        .TSF_TIMER_WIDTH(TSF_TIMER_WIDTH),
        .C_M00_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
        .MAX_BIT_NUM_DMA_SYMBOL(MAX_BIT_NUM_DMA_SYMBOL)
    ) rx_intf_pl_to_m_axis_i (
        .clk(m00_axis_aclk),
        .rstn(m00_axis_aresetn&(~slv_reg0[8])),

	    // port to xpu
	    .block_rx_dma_to_ps(block_rx_dma_to_ps),
        .block_rx_dma_to_ps_valid(block_rx_dma_to_ps_valid),
	    .rssi_half_db_lock_by_sig_valid(rssi_half_db_lock_by_sig_valid),
	    .gpio_status_lock_by_sig_valid(gpio_status_lock_by_sig_valid),
	    
        // to m_axis and PS
        .start_1trans_to_m_axis(start_1trans_from_acc_to_m_axis),
        .data_to_m_axis_out(data_from_acc_to_m_axis),
        .data_ready_to_m_axis_out(data_ready_from_acc_to_m_axis),
	    .monitor_num_dma_symbol_to_ps(monitor_num_dma_symbol_to_ps),
        .m_axis_rst(m_axis_rst),
        .m_axis_tlast(m00_axis_tlast_inner),
        .m_axis_tlast_auto_recover(m00_axis_tlast_auto_recover),

        // port to xilinx axi dma
        .s2mm_intr(s2mm_intr),
        .rx_pkt_intr(rx_pkt_intr_internal),

        // to byte_to_word_fcs_sn_intert
        .rx_pkt_sn_plus_one(rx_pkt_sn_plus_one),

        .m_axis_tlast_auto_recover_enable(~slv_reg12[31]),
        .m_axis_tlast_auto_recover_timeout_top(slv_reg12[12:0]),
        .start_1trans_mode(slv_reg5[2:0]),
        .start_1trans_ext_trigger(slv_reg6[0]),
        .start_1trans_s_axis_tlast_trigger(s00_axis_tlast),
        .start_1trans_s_axis_tready_trigger(s00_axis_tready),
        .src_sel(slv_reg7[0]),
        .tsf_runtime_val(tsf_runtime_val),
        .count_top(slv_reg13[14:0]),
//        .pad_test(slv_reg13[31]),
        
        .data_from_acc(data_from_acc),
        .data_ready_from_acc(data_ready_from_acc),
        .pkt_rate(pkt_rate),
	    .pkt_len(pkt_len),
        .sig_valid(sig_valid),
        .ht_unsupport(ht_unsupport),
        .fcs_valid(fcs_valid),
        
        .rf_iq(rf_iq_loopback),
        .rf_iq_valid(sample_strobe),

        .tsf_pulse_1M(tsf_pulse_1M)
    );
    
	rx_intf_m_axis # (
		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
		.WAIT_COUNT_BITS(WAIT_COUNT_BITS),
		.MAX_NUM_DMA_SYMBOL(MAX_NUM_DMA_SYMBOL),
		.MAX_BIT_NUM_DMA_SYMBOL(MAX_BIT_NUM_DMA_SYMBOL)
	) rx_intf_m_axis_i (
		.M_AXIS_ACLK(m00_axis_aclk),
		.M_AXIS_ARESETN( m00_axis_aresetn&(~slv_reg0[4])&(~m_axis_auto_rst) ),
		.M_AXIS_TVALID(m00_axis_tvalid_inner),
		.M_AXIS_TDATA(m00_axis_tdata_inner),
		.M_AXIS_TSTRB(m00_axis_tstrb_inner),
		.M_AXIS_TLAST(m00_axis_tlast_inner),
		.M_AXIS_TREADY(m00_axis_tready),
		.START_COUNT_CFG(0),
		.M_AXIS_NUM_DMA_SYMBOL(num_dma_symbol_to_ps),
		.start_1trans(start_1trans_from_acc_to_m_axis),
		
        .endless_mode(slv_reg5[9]),
        .DATA_FROM_ACC(data_from_acc_to_m_axis),
        .ACC_DATA_READY(data_ready_from_acc_to_m_axis),
        .data_count(m_axis_fifo_data_count),
        .FULLN_TO_ACC(fulln_from_m_axis_to_acc)
	);

	endmodule
