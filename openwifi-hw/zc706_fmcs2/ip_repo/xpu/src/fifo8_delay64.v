// Xianjun jiao. putaoshu@msn.com; xianjun.jiao@imec.be;

`timescale 1 ns / 1 ps

	module fifo8_delay64 #
	(
      parameter integer DATA_WIDTH	= 8,
	    parameter integer DELAY_CTL_WIDTH	= 7
	)
	(// main function: after receive data, send ack; after send data, disable tx for a while because need to wait for ack from peer.
        input wire clk,
        input wire rstn,

        input wire [(DELAY_CTL_WIDTH-1):0] delay_ctl,

        input wire [(DATA_WIDTH-1):0] data_in,
        input wire data_in_valid,
        output wire [(DATA_WIDTH-1):0] data_out,
        output wire data_out_valid
	);

    localparam [1:0]   IDLE =       2'b00,
                       WAIT_FILL =  2'b01,
                       NORMAL_RW =  2'b10;

    reg [1:0] rw_state;
    reg [2:0] rst_count;
    reg rden_internal;
    reg wren_internal;
    wire [(DELAY_CTL_WIDTH-1):0] data_count;
    wire full;
    wire empty;

    assign data_out_valid = rden_internal;

    fifo8_1clk_dep64 fifo8_1clk_dep64_i (
        .CLK(clk),
        .DATAO(data_out),
        .DI(data_in),
        .EMPTY(empty),
        .FULL(full),
        .RDEN(rden_internal),
        .RST(~rstn),
        .WREN(wren_internal),
        .data_count(data_count)
    );
    
	always @(posedge clk)                                             
    begin
      if (!rstn)
        begin
          rw_state<=IDLE;
          rst_count<=0;
          rden_internal<=0;
          wren_internal<=0;
        end                                                                   
      else                                                                    
        case (rw_state)
          IDLE: begin
            if (rst_count==7) begin
                rw_state<=WAIT_FILL;
                end
            else begin
                rw_state<=rw_state;
                end
            rst_count <= rst_count + 1;
            rden_internal<=rden_internal;
            wren_internal<=wren_internal;
          end

          WAIT_FILL: begin // data is calculated by calc_phy_header C program
            if (data_count == delay_ctl) begin
              rw_state<=NORMAL_RW;
              end
            else begin
              rw_state<=rw_state;
              end
            rst_count <= rst_count;
            rden_internal<=rden_internal;
            wren_internal<=data_in_valid;
          end
          
          NORMAL_RW: begin
            rw_state<=rw_state;
            rst_count <= rst_count;
            rden_internal<=data_in_valid;
            wren_internal<=data_in_valid;
          end

        endcase                                                               
    end

	endmodule
