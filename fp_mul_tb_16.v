`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright: © 2019-2020, Chris Larsen
// Engineer:
//
// Create Date: 07/26/2019 07:19:00 PM
// Design Name:
// Module Name: fp_mul_tb_16
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module fp_mul_tb_16;
  parameter NEXP = 5;
  parameter NSIG = 10;
  reg [NEXP+NSIG:0] a, b;
  wire [NEXP+NSIG:0] p;
  `include "ieee-754-flags.v"
  wire [LAST_FLAG-1:0] flags;

  integer i, j, k, l, m, n;

  initial
  begin
    $monitor("p (%x %b) = a (%x) * b (%x)", p, flags, a, b);
  end

  initial
  begin
    $display("Test multiply circuit for binary%d:\n\n", NEXP+NSIG+1);

    // For these tests a is always a signalling NaN.
    $display("sNaN * {sNaN, qNaN, infinity, zero, subnormal, normal}:");
    #0  assign a = {1'b0, {NEXP{1'b1}}, 1'b0, ({NSIG-1{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b1}}, 1'b0, ({NSIG-1{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    // For these tests b is always a signalling NaN.
    #10 $display("\n{qNaN, infinity, zero, subnormal, normal} * sNaN:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, 1'b0, ({NSIG-1{1'b0}} | 4'hB)};
        assign a = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    // For these tests a is always a quiet NaN.
    #10 $display("\nqNaN * {qNaN, infinity, zero, subnormal, normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    // For these tests b is always a quiet NaN.
    #10 $display("\n{infinity, zero, subnormal, normal} * qNaN:");
    #10  assign b = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hB)};
         assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10  assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10  assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10  assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

// Broken code. See video for details.
//    for (i = 0; i < 2; i = i + 1)
//      for (j = 0; j < 2; j = j + 1)
//        begin
//         // For these tests a is always Infinity.
//          if (i == 0)
//            if (j == 0)
//              #10 $display("\n+infinity * {+infinity, +zero, +subnormal, +normal}:");
//            else
//              #10 $display("\n+infinity * {-infinity, -zero, -subnormal, -normal}:");
//          else
//            if (j == 0)
//              #10 $display("\n-infinity * {+infinity, +zero, +subnormal, +normal}:");
//            else
//              #10 $display("\n-infinity * {-infinity, -zero, -subnormal, -normal}:");
//          #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}} | (i << NEXP+NSIG);
//              assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}} | (j << NEXP+NSIG);
//          #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}} | (j << NEXP+NSIG);
//          #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)} | (j << NEXP+NSIG);
//          #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)} | (j << NEXP+NSIG);

//         // For these tests b is always Infinity.
//          if (i == 0)
//            if (j == 0)
//              #10 $display("\n{+zero, +subnormal, +normal} * +infinity:");
//            else
//              #10 $display("\n{+zero, +subnormal, +normal} * -infinity:");
//          else
//            if (j == 0)
//              #10 $display("\n{-zero, -subnormal, -normal} * +infinity:");
//            else
//              #10 $display("\n{-zero, -subnormal, -normal} * -infinity:");
//          #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}} | (j << NEXP+NSIG);
//              assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}} | (i << NEXP+NSIG);
//          #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)} | (i << NEXP+NSIG);
//          #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)} | (i << NEXP+NSIG);
//    end

    #10 $display("\n+infinity * {+infinity, +zero, +subnormal, +normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n{+zero, +subnormal, +normal} * +infinity:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\n+infinity * {-infinity, -zero, -subnormal, -normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n{+zero, +subnormal, +normal} * -infinity:");
    #10 assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\n-infinity * {+infinity, +zero, +subnormal, +normal}:");
    #10 assign a = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n{-zero, -subnormal, -normal} * +infinity:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\n-infinity * {-infinity, -zero, -subnormal, -normal}:");
    #10 assign a = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n{-zero, -subnormal, -normal} * -infinity:");
    #10 assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\n+zero * {+zero, +subnormal, +normal}:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n{+subnormal, +normal} * +zero:");
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\n-zero * {+zero, +subnormal, +normal}:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n{-subnormal, -normal} * +zero:");
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\n+zero * {-zero, -subnormal, -normal}:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n{+subnormal, +normal} * -zero:");
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\n-zero * {-zero, -subnormal, -normal}:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n{-subnormal, -normal} * -zero:");
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\n+subnormal * +subnormal:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n+subnormal * -subnormal:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n-subnormal * +subnormal:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n-subnormal * -subnormal:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\n1 * 2**15:");
    #10 assign a = 16'h3C00; assign b = 16'h7800;

    #10 $display("\n1 * 2**14:");
    #10 assign a = 16'h3C00; assign b = 16'h7400;

    #10 $display("\n1 * 2**13:");
    #10 assign a = 16'h3C00; assign b = 16'h7000;

    #10 $display("\n1 * 2**12:");
    #10 assign a = 16'h3C00; assign b = 16'h6C00;

    #10 $display("\n1 * 2**11:");
    #10 assign a = 16'h3C00; assign b = 16'h6800;

    #10 $display("\n1 * 2**10:");
    #10 assign a = 16'h3C00; assign b = 16'h6400;

    #10 $display("\n1 * 2**9:");
    #10 assign a = 16'h3C00; assign b = 16'h6000;

    #10 $display("\n1 * 2**8:");
    #10 assign a = 16'h3C00; assign b = 16'h5C00;

    #10 $display("\n1 * 2**7:");
    #10 assign a = 16'h3C00; assign b = 16'h5800;

    #10 $display("\n1 * 2**6:");
    #10 assign a = 16'h3C00; assign b = 16'h5400;

    #10 $display("\n1 * 2**5:");
    #10 assign a = 16'h3C00; assign b = 16'h5000;

    #10 $display("\n1 * 2**4:");
    #10 assign a = 16'h3C00; assign b = 16'h4C00;

    #10 $display("\n1 * 2**3:");
    #10 assign a = 16'h3C00; assign b = 16'h4800;

    #10 $display("\n1 * 2**2:");
    #10 assign a = 16'h3C00; assign b = 16'h4400;

    #10 $display("\n1 * 2**1:");
    #10 assign a = 16'h3C00; assign b = 16'h4000;

    #10 $display("\n1 * 2**0:");
    #10 assign a = 16'h3C00; assign b = 16'h3C00;

    #10 $display("\n1 * 2**-1:");
    #10 assign a = 16'h3C00; assign b = 16'h3800;

    #10 $display("\n1 * 2**-2:");
    #10 assign a = 16'h3C00; assign b = 16'h3400;

    #10 $display("\n1 * 2**-3:");
    #10 assign a = 16'h3C00; assign b = 16'h3000;

    #10 $display("\n1 * 2**-4:");
    #10 assign a = 16'h3C00; assign b = 16'h2C00;

    #10 $display("\n1 * 2**-5:");
    #10 assign a = 16'h3C00; assign b = 16'h2800;

    #10 $display("\n1 * 2**-6:");
    #10 assign a = 16'h3C00; assign b = 16'h2400;

    #10 $display("\n1 * 2**-7:");
    #10 assign a = 16'h3C00; assign b = 16'h2000;

    #10 $display("\n1 * 2**-8:");
    #10 assign a = 16'h3C00; assign b = 16'h1C00;

    #10 $display("\n1 * 2**-9:");
    #10 assign a = 16'h3C00; assign b = 16'h1800;

    #10 $display("\n1 * 2**-10:");
    #10 assign a = 16'h3C00; assign b = 16'h1400;

    #10 $display("\n1 * 2**-11:");
    #10 assign a = 16'h3C00; assign b = 16'h1000;

    #10 $display("\n1 * 2**-12:");
    #10 assign a = 16'h3C00; assign b = 16'h0C00;

    #10 $display("\n1 * 2**-13:");
    #10 assign a = 16'h3C00; assign b = 16'h0800;

    #10 $display("\n1 * 2**-14:");
    #10 assign a = 16'h3C00; assign b = 16'h0400;

    #10 $display("\n1 * 2**-15:");
    #10 assign a = 16'h3C00; assign b = 16'h0200;

    #10 $display("\n1 * 2**-16:");
    #10 assign a = 16'h3C00; assign b = 16'h0100;

    #10 $display("\n1 * 2**-17:");
    #10 assign a = 16'h3C00; assign b = 16'h0080;

    #10 $display("\n1 * 2**-18:");
    #10 assign a = 16'h3C00; assign b = 16'h0040;

    #10 $display("\n1 * 2**-19:");
    #10 assign a = 16'h3C00; assign b = 16'h0020;

    #10 $display("\n1 * 2**-20:");
    #10 assign a = 16'h3C00; assign b = 16'h0010;

    #10 $display("\n1 * 2**-21:");
    #10 assign a = 16'h3C00; assign b = 16'h0008;

    #10 $display("\n1 * 2**-22:");
    #10 assign a = 16'h3C00; assign b = 16'h0004;

    #10 $display("\n1 * 2**-23:");
    #10 assign a = 16'h3C00; assign b = 16'h0002;

    #10 $display("\n1 * 2**-24:");
    #10 assign a = 16'h3C00; assign b = 16'h0001;

    #10 $display("\n2**15 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h7800;

    #10 $display("\n2**14 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h7400;

    #10 $display("\n2**13 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h7000;

    #10 $display("\n2**12 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h6C00;

    #10 $display("\n2**11 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h6800;

    #10 $display("\n2**10 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h6400;

    #10 $display("\n2**9 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h6000;

    #10 $display("\n2**8 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h5C00;

    #10 $display("\n2**7 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h5800;

    #10 $display("\n2**6 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h5400;

    #10 $display("\n2**5 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h5000;

    #10 $display("\n2**4 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h4C00;

    #10 $display("\n2**3 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h4800;

    #10 $display("\n2**2 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h4400;

    #10 $display("\n2**1 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h4000;

    #10 $display("\n2**0 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h3C00;

    #10 $display("\n2**-1 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h3800;

    #10 $display("\n2**-2 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h3400;

    #10 $display("\n2**-3 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h3000;

    #10 $display("\n2**-4 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h2C00;

    #10 $display("\n2**-5 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h2800;

    #10 $display("\n2**-6 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h2400;

    #10 $display("\n2**-7 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h2000;

    #10 $display("\n2**-8 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h1C00;

    #10 $display("\n2**-9 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h1800;

    #10 $display("\n2**-10 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h1400;

    #10 $display("\n2**-11 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h1000;

    #10 $display("\n2**-12 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0C00;

    #10 $display("\n2**-13 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0800;

    #10 $display("\n2**-14 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0400;

    #10 $display("\n2**-15 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0200;

    #10 $display("\n2**-16 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0100;

    #10 $display("\n2**-17 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0080;

    #10 $display("\n2**-18 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0040;

    #10 $display("\n2**-19 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0020;

    #10 $display("\n2**-20 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0010;

    #10 $display("\n2**-21 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0008;

    #10 $display("\n2**-22 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0004;

    #10 $display("\n2**-23 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0002;

    #10 $display("\n2**-24 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0001;

    #10 $display("\n2**0 * 2**15:");
    #10 assign a = 16'h3C00; assign b = 16'h7800;
    #10 assign a = 16'h3FFF; assign b = 16'h7BFF;

    #10 $display("\n2**1 * 2**14:");
    #10 assign a = 16'h4000; assign b = 16'h7400;
    #10 assign a = 16'h43FF; assign b = 16'h77FF;

    #10 $display("\n2**2 * 2**13:");
    #10 assign a = 16'h4400; assign b = 16'h7000;
    #10 assign a = 16'h47FF; assign b = 16'h73FF;

    #10 $display("\n2**3 * 2**12:");
    #10 assign a = 16'h4800; assign b = 16'h6C00;
    #10 assign a = 16'h4BFF; assign b = 16'h6FFF;

    #10 $display("\n2**4 * 2**11:");
    #10 assign a = 16'h4C00; assign b = 16'h6800;
    #10 assign a = 16'h4FFF; assign b = 16'h6BFF;

    #10 $display("\n2**5 * 2**10:");
    #10 assign a = 16'h5000; assign b = 16'h6400;
    #10 assign a = 16'h53FF; assign b = 16'h67FF;

    #10 $display("\n2**6 * 2**9:");
    #10 assign a = 16'h5400; assign b = 16'h6000;
    #10 assign a = 16'h57FF; assign b = 16'h63FF;

    #10 $display("\n2**7 * 2**8:");
    #10 assign a = 16'h5800; assign b = 16'h5C00;
    #10 assign a = 16'h5BFF; assign b = 16'h5FFF;

    #10 $display("\n2**8 * 2**7:");
    #10 assign a = 16'h5C00; assign b = 16'h5800;
    #10 assign a = 16'h5FFF; assign b = 16'h5BFF;

    #10 $display("\n2**9 * 2**6:");
    #10 assign a = 16'h6000; assign b = 16'h5400;
    #10 assign a = 16'h63FF; assign b = 16'h57FF;

    #10 $display("\n2**10 * 2**5:");
    #10 assign a = 16'h6400; assign b = 16'h5000;
    #10 assign a = 16'h67FF; assign b = 16'h53FF;

    #10 $display("\n2**11 * 2**4:");
    #10 assign a = 16'h6800; assign b = 16'h4C00;
    #10 assign a = 16'h6BFF; assign b = 16'h4FFF;

    #10 $display("\n2**12 * 2**3:");
    #10 assign a = 16'h6C00; assign b = 16'h4800;
    #10 assign a = 16'h6FFF; assign b = 16'h4BFF;

    #10 $display("\n2**13 * 2**2:");
    #10 assign a = 16'h7000; assign b = 16'h4400;
    #10 assign a = 16'h73FF; assign b = 16'h47FF;

    #10 $display("\n2**14 * 2**1:");
    #10 assign a = 16'h7400; assign b = 16'h4000;
    #10 assign a = 16'h77FF; assign b = 16'h43FF;

    #10 $display("\n2**15 * 2**0:");
    #10 assign a = 16'h7800; assign b = 16'h3C00;
    #10 assign a = 16'h7BFF; assign b = 16'h3FFF;

    #10 $display("\n2**-24 * 2**9:");
    #10 assign a = 16'h0001; assign b = 16'h6000;
    #10 assign a = 16'h0001; assign b = 16'h63FF;

    #10 $display("\n2**-23 * 2**8:");
    #10 assign a = 16'h0002; assign b = 16'h5C00;
    #10 assign a = 16'h0003; assign b = 16'h5FFF;

    #10 $display("\n2**-22 * 2**7:");
    #10 assign a = 16'h0004; assign b = 16'h5800;
    #10 assign a = 16'h0007; assign b = 16'h5BFF;

    #10 $display("\n2**-21 * 2**6:");
    #10 assign a = 16'h0008; assign b = 16'h5400;
    #10 assign a = 16'h000F; assign b = 16'h57FF;

    #10 $display("\n2**-20 * 2**5:");
    #10 assign a = 16'h0010; assign b = 16'h5000;
    #10 assign a = 16'h001F; assign b = 16'h53FF;

    #10 $display("\n2**-19 * 2**4:");
    #10 assign a = 16'h0020; assign b = 16'h4C00;
    #10 assign a = 16'h003F; assign b = 16'h4FFF;

    #10 $display("\n2**-18 * 2**3:");
    #10 assign a = 16'h0040; assign b = 16'h4800;
    #10 assign a = 16'h007F; assign b = 16'h4BFF;

    #10 $display("\n2**-17 * 2**2:");
    #10 assign a = 16'h0080; assign b = 16'h4400;
    #10 assign a = 16'h00FF; assign b = 16'h47FF;

    #10 $display("\n2**-16 * 2**1:");
    #10 assign a = 16'h0100; assign b = 16'h4000;
    #10 assign a = 16'h01FF; assign b = 16'h43FF;

    #10 $display("\n2**-15 * 2**0:");
    #10 assign a = 16'h0200; assign b = 16'h3C00;
    #10 assign a = 16'h03FF; assign b = 16'h3FFF;

    #10 $display("\n2**-14 * 2**-1:");
    #10 assign a = 16'h0400; assign b = 16'h3800;
    #10 assign a = 16'h07FF; assign b = 16'h3BFF;

    #10 $display("\n2**-13 * 2**-2:");
    #10 assign a = 16'h0800; assign b = 16'h3400;
    #10 assign a = 16'h0BFF; assign b = 16'h37FF;

    #10 $display("\n2**-12 * 2**-3:");
    #10 assign a = 16'h0C00; assign b = 16'h3000;
    #10 assign a = 16'h0FFF; assign b = 16'h33FF;

    #10 $display("\n2**-11 * 2**-4:");
    #10 assign a = 16'h1000; assign b = 16'h2C00;
    #10 assign a = 16'h13FF; assign b = 16'h2FFF;

    #10 $display("\n2**-10 * 2**-5:");
    #10 assign a = 16'h1400; assign b = 16'h2800;
    #10 assign a = 16'h17FF; assign b = 16'h2BFF;

    #10 $display("\n2**-9 * 2**-6:");
    #10 assign a = 16'h1800; assign b = 16'h2400;
    #10 assign a = 16'h1BFF; assign b = 16'h27FF;

    #10 $display("\n2**-8 * 2**-7:");
    #10 assign a = 16'h1C00; assign b = 16'h2000;
    #10 assign a = 16'h1FFF; assign b = 16'h23FF;

    #10 $display("\n2**-7 * 2**-8:");
    #10 assign a = 16'h2000; assign b = 16'h1C00;
    #10 assign a = 16'h23FF; assign b = 16'h1FFF;

    #10 $display("\n2**-6 * 2**-9:");
    #10 assign a = 16'h2400; assign b = 16'h1800;
    #10 assign a = 16'h27FF; assign b = 16'h1BFF;

    #10 $display("\n2**-5 * 2**-10:");
    #10 assign a = 16'h2800; assign b = 16'h1400;
    #10 assign a = 16'h2BFF; assign b = 16'h17FF;

    #10 $display("\n2**-4 * 2**-11:");
    #10 assign a = 16'h2C00; assign b = 16'h1000;
    #10 assign a = 16'h2FFF; assign b = 16'h13FF;

    #10 $display("\n2**-3 * 2**-12:");
    #10 assign a = 16'h3000; assign b = 16'h0C00;
    #10 assign a = 16'h33FF; assign b = 16'h0FFF;

    #10 $display("\n2**-2 * 2**-13:");
    #10 assign a = 16'h3400; assign b = 16'h0800;
    #10 assign a = 16'h37FF; assign b = 16'h0BFF;

    #10 $display("\n2**-1 * 2**-14:");
    #10 assign a = 16'h3800; assign b = 16'h0400;
    #10 assign a = 16'h3BFF; assign b = 16'h07FF;

    #10 $display("\n2**0 * 2**-15:");
    #10 assign a = 16'h3C00; assign b = 16'h0200;
    #10 assign a = 16'h3FFF; assign b = 16'h03FF;

    #10 $display("\n2**1 * 2**-16:");
    #10 assign a = 16'h4000; assign b = 16'h0100;
    #10 assign a = 16'h43FF; assign b = 16'h01FF;

    #10 $display("\n2**2 * 2**-17:");
    #10 assign a = 16'h4400; assign b = 16'h0080;
    #10 assign a = 16'h47FF; assign b = 16'h00FF;

    #10 $display("\n2**3 * 2**-18:");
    #10 assign a = 16'h4800; assign b = 16'h0040;
    #10 assign a = 16'h4BFF; assign b = 16'h007F;

    #10 $display("\n2**4 * 2**-19:");
    #10 assign a = 16'h4C00; assign b = 16'h0020;
    #10 assign a = 16'h4FFF; assign b = 16'h003F;

    #10 $display("\n2**5 * 2**-20:");
    #10 assign a = 16'h5000; assign b = 16'h0010;
    #10 assign a = 16'h53FF; assign b = 16'h001F;

    #10 $display("\n2**6 * 2**-21:");
    #10 assign a = 16'h5400; assign b = 16'h0008;
    #10 assign a = 16'h57FF; assign b = 16'h000F;

    #10 $display("\n2**7 * 2**-22:");
    #10 assign a = 16'h5800; assign b = 16'h0004;
    #10 assign a = 16'h5BFF; assign b = 16'h0007;

    #10 $display("\n2**8 * 2**-23:");
    #10 assign a = 16'h5C00; assign b = 16'h0002;
    #10 assign a = 16'h5FFF; assign b = 16'h0003;

    #10 $display("\n2**9 * 2**-24:");
    #10 assign a = 16'h6000; assign b = 16'h0001;
    #10 assign a = 16'h63FF; assign b = 16'h0001;

    #10 $display("\n2**-24 * 2**-1:");
    #10 assign a = 16'h0001; assign b = 16'h3800;
    #10 assign a = 16'h0001; assign b = 16'h3BFF;

    #10 $display("\n2**-23 * 2**-2:");
    #10 assign a = 16'h0002; assign b = 16'h3400;
    #10 assign a = 16'h0003; assign b = 16'h37FF;

    #10 $display("\n2**-22 * 2**-3:");
    #10 assign a = 16'h0004; assign b = 16'h3000;
    #10 assign a = 16'h0007; assign b = 16'h33FF;

    #10 $display("\n2**-21 * 2**-4:");
    #10 assign a = 16'h0008; assign b = 16'h2C00;
    #10 assign a = 16'h000F; assign b = 16'h2FFF;

    #10 $display("\n2**-20 * 2**-5:");
    #10 assign a = 16'h0010; assign b = 16'h2800;
    #10 assign a = 16'h001F; assign b = 16'h2BFF;

    #10 $display("\n2**-19 * 2**-6:");
    #10 assign a = 16'h0020; assign b = 16'h2400;
    #10 assign a = 16'h003F; assign b = 16'h27FF;

    #10 $display("\n2**-18 * 2**-7:");
    #10 assign a = 16'h0040; assign b = 16'h2000;
    #10 assign a = 16'h007F; assign b = 16'h23FF;

    #10 $display("\n2**-17 * 2**-8:");
    #10 assign a = 16'h0080; assign b = 16'h1C00;
    #10 assign a = 16'h00FF; assign b = 16'h1FFF;

    #10 $display("\n2**-16 * 2**-9:");
    #10 assign a = 16'h0100; assign b = 16'h1800;
    #10 assign a = 16'h01FF; assign b = 16'h1BFF;

    #10 $display("\n2**-15 * 2**-10:");
    #10 assign a = 16'h0200; assign b = 16'h1400;
    #10 assign a = 16'h03FF; assign b = 16'h17FF;

    #10 $display("\n2**-14 * 2**-11:");
    #10 assign a = 16'h0400; assign b = 16'h1000;
    #10 assign a = 16'h07FF; assign b = 16'h13FF;

    #10 $display("\n2**-13 * 2**-12:");
    #10 assign a = 16'h0800; assign b = 16'h0C00;
    #10 assign a = 16'h0BFF; assign b = 16'h0FFF;

    #10 $display("\n2**-12 * 2**-13:");
    #10 assign a = 16'h0C00; assign b = 16'h0800;
    #10 assign a = 16'h0FFF; assign b = 16'h0BFF;

    #10 $display("\n2**-11 * 2**-14:");
    #10 assign a = 16'h1000; assign b = 16'h0400;
    #10 assign a = 16'h13FF; assign b = 16'h07FF;

    #10 $display("\n2**-10 * 2**-15:");
    #10 assign a = 16'h1400; assign b = 16'h0200;
    #10 assign a = 16'h17FF; assign b = 16'h03FF;

    #10 $display("\n2**-9 * 2**-16:");
    #10 assign a = 16'h1800; assign b = 16'h0100;
    #10 assign a = 16'h1BFF; assign b = 16'h01FF;

    #10 $display("\n2**-8 * 2**-17:");
    #10 assign a = 16'h1C00; assign b = 16'h0080;
    #10 assign a = 16'h1FFF; assign b = 16'h00FF;

    #10 $display("\n2**-7 * 2**-18:");
    #10 assign a = 16'h2000; assign b = 16'h0040;
    #10 assign a = 16'h23FF; assign b = 16'h007F;

    #10 $display("\n2**-6 * 2**-19:");
    #10 assign a = 16'h2400; assign b = 16'h0020;
    #10 assign a = 16'h27FF; assign b = 16'h003F;

    #10 $display("\n2**-5 * 2**-20:");
    #10 assign a = 16'h2800; assign b = 16'h0010;
    #10 assign a = 16'h2BFF; assign b = 16'h001F;

    #10 $display("\n2**-4 * 2**-21:");
    #10 assign a = 16'h2C00; assign b = 16'h0008;
    #10 assign a = 16'h2FFF; assign b = 16'h000F;

    #10 $display("\n2**-3 * 2**-22:");
    #10 assign a = 16'h3000; assign b = 16'h0004;
    #10 assign a = 16'h33FF; assign b = 16'h0007;

    #10 $display("\n2**-2 * 2**-23:");
    #10 assign a = 16'h3400; assign b = 16'h0002;
    #10 assign a = 16'h37FF; assign b = 16'h0003;

    #10 $display("\n2**-1 * 2**-24:");
    #10 assign a = 16'h3800; assign b = 16'h0001;
    #10 assign a = 16'h3BFF; assign b = 16'h0001;

//    #10 $display("\n20 * 20:"); // 1.0100000000 * 2**4 or 0x4D00
//    #10 assign a = 16'h4D00; assign b = 16'h4D00; // 1.1001000000 x 2**8 or 0x5E40
//
//    #10 $display("\n400 * PI:"); // PI = 1.1001001000 * 2**1
//    #10 assign a = 16'h5E40; assign b = 16'h4248; // 1.0011101000 * 2**10 or 0x64E8

    #20 $display("\nEnd of tests : %t", $time);
    #20 $stop;
  end

  fp_mul #(NEXP, NSIG) inst1(
  .a(a),
  .b(b),
  .p(p),
  .pFlags(flags)
  );
endmodule
