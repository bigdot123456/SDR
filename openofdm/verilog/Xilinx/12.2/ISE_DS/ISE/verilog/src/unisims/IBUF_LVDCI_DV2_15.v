// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/IBUF_LVDCI_DV2_15.v,v 1.6 2007/05/23 21:43:35 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Input Buffer with LVDCI_DV2_15 I/O Standard
// /___/   /\     Filename : IBUF_LVDCI_DV2_15.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:34 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module IBUF_LVDCI_DV2_15 (O, I);

    output O;

    input  I;

	buf B1 (O, I);


endmodule

