`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright: © 2019-2020, Chris Larsen
// Engineer:
//
// Create Date: 07/26/2019 07:19:00 PM
// Design Name:
// Module Name: fp_mul_tb_32
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


module fp_mul_tb_32;
  parameter NEXP = 8;
  parameter NSIG = 23;
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

    #10 $display("\n1 * 2**127:");
    #10 assign a = 32'h3F800000; assign b = 32'h7F000000;

    #10 $display("\n1 * 2**126:");
    #10 assign a = 32'h3F800000; assign b = 32'h7E800000;

    #10 $display("\n1 * 2**125:");
    #10 assign a = 32'h3F800000; assign b = 32'h7E000000;

    #10 $display("\n1 * 2**124:");
    #10 assign a = 32'h3F800000; assign b = 32'h7D800000;

    #10 $display("\n1 * 2**123:");
    #10 assign a = 32'h3F800000; assign b = 32'h7D000000;

    #10 $display("\n1 * 2**122:");
    #10 assign a = 32'h3F800000; assign b = 32'h7C800000;

    #10 $display("\n1 * 2**121:");
    #10 assign a = 32'h3F800000; assign b = 32'h7C000000;

    #10 $display("\n1 * 2**120:");
    #10 assign a = 32'h3F800000; assign b = 32'h7B800000;

    #10 $display("\n1 * 2**119:");
    #10 assign a = 32'h3F800000; assign b = 32'h7B000000;

    #10 $display("\n1 * 2**118:");
    #10 assign a = 32'h3F800000; assign b = 32'h7A800000;

    #10 $display("\n1 * 2**117:");
    #10 assign a = 32'h3F800000; assign b = 32'h7A000000;

    #10 $display("\n1 * 2**116:");
    #10 assign a = 32'h3F800000; assign b = 32'h79800000;

    #10 $display("\n1 * 2**115:");
    #10 assign a = 32'h3F800000; assign b = 32'h79000000;

    #10 $display("\n1 * 2**114:");
    #10 assign a = 32'h3F800000; assign b = 32'h78800000;

    #10 $display("\n1 * 2**113:");
    #10 assign a = 32'h3F800000; assign b = 32'h78000000;

    #10 $display("\n1 * 2**112:");
    #10 assign a = 32'h3F800000; assign b = 32'h77800000;

    #10 $display("\n1 * 2**111:");
    #10 assign a = 32'h3F800000; assign b = 32'h77000000;

    #10 $display("\n1 * 2**110:");
    #10 assign a = 32'h3F800000; assign b = 32'h76800000;

    #10 $display("\n1 * 2**109:");
    #10 assign a = 32'h3F800000; assign b = 32'h76000000;

    #10 $display("\n1 * 2**108:");
    #10 assign a = 32'h3F800000; assign b = 32'h75800000;

    #10 $display("\n1 * 2**107:");
    #10 assign a = 32'h3F800000; assign b = 32'h75000000;

    #10 $display("\n1 * 2**106:");
    #10 assign a = 32'h3F800000; assign b = 32'h74800000;

    #10 $display("\n1 * 2**105:");
    #10 assign a = 32'h3F800000; assign b = 32'h74000000;

    #10 $display("\n1 * 2**104:");
    #10 assign a = 32'h3F800000; assign b = 32'h73800000;

    #10 $display("\n1 * 2**103:");
    #10 assign a = 32'h3F800000; assign b = 32'h73000000;

    #10 $display("\n1 * 2**102:");
    #10 assign a = 32'h3F800000; assign b = 32'h72800000;

    #10 $display("\n1 * 2**101:");
    #10 assign a = 32'h3F800000; assign b = 32'h72000000;

    #10 $display("\n1 * 2**100:");
    #10 assign a = 32'h3F800000; assign b = 32'h71800000;

    #10 $display("\n1 * 2**99:");
    #10 assign a = 32'h3F800000; assign b = 32'h71000000;

    #10 $display("\n1 * 2**98:");
    #10 assign a = 32'h3F800000; assign b = 32'h70800000;

    #10 $display("\n1 * 2**97:");
    #10 assign a = 32'h3F800000; assign b = 32'h70000000;

    #10 $display("\n1 * 2**96:");
    #10 assign a = 32'h3F800000; assign b = 32'h6F800000;

    #10 $display("\n1 * 2**95:");
    #10 assign a = 32'h3F800000; assign b = 32'h6F000000;

    #10 $display("\n1 * 2**94:");
    #10 assign a = 32'h3F800000; assign b = 32'h6E800000;

    #10 $display("\n1 * 2**93:");
    #10 assign a = 32'h3F800000; assign b = 32'h6E000000;

    #10 $display("\n1 * 2**92:");
    #10 assign a = 32'h3F800000; assign b = 32'h6D800000;

    #10 $display("\n1 * 2**91:");
    #10 assign a = 32'h3F800000; assign b = 32'h6D000000;

    #10 $display("\n1 * 2**90:");
    #10 assign a = 32'h3F800000; assign b = 32'h6C800000;

    #10 $display("\n1 * 2**89:");
    #10 assign a = 32'h3F800000; assign b = 32'h6C000000;

    #10 $display("\n1 * 2**88:");
    #10 assign a = 32'h3F800000; assign b = 32'h6B800000;

    #10 $display("\n1 * 2**87:");
    #10 assign a = 32'h3F800000; assign b = 32'h6B000000;

    #10 $display("\n1 * 2**86:");
    #10 assign a = 32'h3F800000; assign b = 32'h6A800000;

    #10 $display("\n1 * 2**85:");
    #10 assign a = 32'h3F800000; assign b = 32'h6A000000;

    #10 $display("\n1 * 2**84:");
    #10 assign a = 32'h3F800000; assign b = 32'h69800000;

    #10 $display("\n1 * 2**83:");
    #10 assign a = 32'h3F800000; assign b = 32'h69000000;

    #10 $display("\n1 * 2**82:");
    #10 assign a = 32'h3F800000; assign b = 32'h68800000;

    #10 $display("\n1 * 2**81:");
    #10 assign a = 32'h3F800000; assign b = 32'h68000000;

    #10 $display("\n1 * 2**80:");
    #10 assign a = 32'h3F800000; assign b = 32'h67800000;

    #10 $display("\n1 * 2**79:");
    #10 assign a = 32'h3F800000; assign b = 32'h67000000;

    #10 $display("\n1 * 2**78:");
    #10 assign a = 32'h3F800000; assign b = 32'h66800000;

    #10 $display("\n1 * 2**77:");
    #10 assign a = 32'h3F800000; assign b = 32'h66000000;

    #10 $display("\n1 * 2**76:");
    #10 assign a = 32'h3F800000; assign b = 32'h65800000;

    #10 $display("\n1 * 2**75:");
    #10 assign a = 32'h3F800000; assign b = 32'h65000000;

    #10 $display("\n1 * 2**74:");
    #10 assign a = 32'h3F800000; assign b = 32'h64800000;

    #10 $display("\n1 * 2**73:");
    #10 assign a = 32'h3F800000; assign b = 32'h64000000;

    #10 $display("\n1 * 2**72:");
    #10 assign a = 32'h3F800000; assign b = 32'h63800000;

    #10 $display("\n1 * 2**71:");
    #10 assign a = 32'h3F800000; assign b = 32'h63000000;

    #10 $display("\n1 * 2**70:");
    #10 assign a = 32'h3F800000; assign b = 32'h62800000;

    #10 $display("\n1 * 2**69:");
    #10 assign a = 32'h3F800000; assign b = 32'h62000000;

    #10 $display("\n1 * 2**68:");
    #10 assign a = 32'h3F800000; assign b = 32'h61800000;

    #10 $display("\n1 * 2**67:");
    #10 assign a = 32'h3F800000; assign b = 32'h61000000;

    #10 $display("\n1 * 2**66:");
    #10 assign a = 32'h3F800000; assign b = 32'h60800000;

    #10 $display("\n1 * 2**65:");
    #10 assign a = 32'h3F800000; assign b = 32'h60000000;

    #10 $display("\n1 * 2**64:");
    #10 assign a = 32'h3F800000; assign b = 32'h5F800000;

    #10 $display("\n1 * 2**63:");
    #10 assign a = 32'h3F800000; assign b = 32'h5F000000;

    #10 $display("\n1 * 2**62:");
    #10 assign a = 32'h3F800000; assign b = 32'h5E800000;

    #10 $display("\n1 * 2**61:");
    #10 assign a = 32'h3F800000; assign b = 32'h5E000000;

    #10 $display("\n1 * 2**60:");
    #10 assign a = 32'h3F800000; assign b = 32'h5D800000;

    #10 $display("\n1 * 2**59:");
    #10 assign a = 32'h3F800000; assign b = 32'h5D000000;

    #10 $display("\n1 * 2**58:");
    #10 assign a = 32'h3F800000; assign b = 32'h5C800000;

    #10 $display("\n1 * 2**57:");
    #10 assign a = 32'h3F800000; assign b = 32'h5C000000;

    #10 $display("\n1 * 2**56:");
    #10 assign a = 32'h3F800000; assign b = 32'h5B800000;

    #10 $display("\n1 * 2**55:");
    #10 assign a = 32'h3F800000; assign b = 32'h5B000000;

    #10 $display("\n1 * 2**54:");
    #10 assign a = 32'h3F800000; assign b = 32'h5A800000;

    #10 $display("\n1 * 2**53:");
    #10 assign a = 32'h3F800000; assign b = 32'h5A000000;

    #10 $display("\n1 * 2**52:");
    #10 assign a = 32'h3F800000; assign b = 32'h59800000;

    #10 $display("\n1 * 2**51:");
    #10 assign a = 32'h3F800000; assign b = 32'h59000000;

    #10 $display("\n1 * 2**50:");
    #10 assign a = 32'h3F800000; assign b = 32'h58800000;

    #10 $display("\n1 * 2**49:");
    #10 assign a = 32'h3F800000; assign b = 32'h58000000;

    #10 $display("\n1 * 2**48:");
    #10 assign a = 32'h3F800000; assign b = 32'h57800000;

    #10 $display("\n1 * 2**47:");
    #10 assign a = 32'h3F800000; assign b = 32'h57000000;

    #10 $display("\n1 * 2**46:");
    #10 assign a = 32'h3F800000; assign b = 32'h56800000;

    #10 $display("\n1 * 2**45:");
    #10 assign a = 32'h3F800000; assign b = 32'h56000000;

    #10 $display("\n1 * 2**44:");
    #10 assign a = 32'h3F800000; assign b = 32'h55800000;

    #10 $display("\n1 * 2**43:");
    #10 assign a = 32'h3F800000; assign b = 32'h55000000;

    #10 $display("\n1 * 2**42:");
    #10 assign a = 32'h3F800000; assign b = 32'h54800000;

    #10 $display("\n1 * 2**41:");
    #10 assign a = 32'h3F800000; assign b = 32'h54000000;

    #10 $display("\n1 * 2**40:");
    #10 assign a = 32'h3F800000; assign b = 32'h53800000;

    #10 $display("\n1 * 2**39:");
    #10 assign a = 32'h3F800000; assign b = 32'h53000000;

    #10 $display("\n1 * 2**38:");
    #10 assign a = 32'h3F800000; assign b = 32'h52800000;

    #10 $display("\n1 * 2**37:");
    #10 assign a = 32'h3F800000; assign b = 32'h52000000;

    #10 $display("\n1 * 2**36:");
    #10 assign a = 32'h3F800000; assign b = 32'h51800000;

    #10 $display("\n1 * 2**35:");
    #10 assign a = 32'h3F800000; assign b = 32'h51000000;

    #10 $display("\n1 * 2**34:");
    #10 assign a = 32'h3F800000; assign b = 32'h50800000;

    #10 $display("\n1 * 2**33:");
    #10 assign a = 32'h3F800000; assign b = 32'h50000000;

    #10 $display("\n1 * 2**32:");
    #10 assign a = 32'h3F800000; assign b = 32'h4F800000;

    #10 $display("\n1 * 2**31:");
    #10 assign a = 32'h3F800000; assign b = 32'h4F000000;

    #10 $display("\n1 * 2**30:");
    #10 assign a = 32'h3F800000; assign b = 32'h4E800000;

    #10 $display("\n1 * 2**29:");
    #10 assign a = 32'h3F800000; assign b = 32'h4E000000;

    #10 $display("\n1 * 2**28:");
    #10 assign a = 32'h3F800000; assign b = 32'h4D800000;

    #10 $display("\n1 * 2**27:");
    #10 assign a = 32'h3F800000; assign b = 32'h4D000000;

    #10 $display("\n1 * 2**26:");
    #10 assign a = 32'h3F800000; assign b = 32'h4C800000;

    #10 $display("\n1 * 2**25:");
    #10 assign a = 32'h3F800000; assign b = 32'h4C000000;

    #10 $display("\n1 * 2**24:");
    #10 assign a = 32'h3F800000; assign b = 32'h4B800000;

    #10 $display("\n1 * 2**23:");
    #10 assign a = 32'h3F800000; assign b = 32'h4B000000;

    #10 $display("\n1 * 2**22:");
    #10 assign a = 32'h3F800000; assign b = 32'h4A800000;

    #10 $display("\n1 * 2**21:");
    #10 assign a = 32'h3F800000; assign b = 32'h4A000000;

    #10 $display("\n1 * 2**20:");
    #10 assign a = 32'h3F800000; assign b = 32'h49800000;

    #10 $display("\n1 * 2**19:");
    #10 assign a = 32'h3F800000; assign b = 32'h49000000;

    #10 $display("\n1 * 2**18:");
    #10 assign a = 32'h3F800000; assign b = 32'h48800000;

    #10 $display("\n1 * 2**17:");
    #10 assign a = 32'h3F800000; assign b = 32'h48000000;

    #10 $display("\n1 * 2**16:");
    #10 assign a = 32'h3F800000; assign b = 32'h47800000;

    #10 $display("\n1 * 2**15:");
    #10 assign a = 32'h3F800000; assign b = 32'h47000000;

    #10 $display("\n1 * 2**14:");
    #10 assign a = 32'h3F800000; assign b = 32'h46800000;

    #10 $display("\n1 * 2**13:");
    #10 assign a = 32'h3F800000; assign b = 32'h46000000;

    #10 $display("\n1 * 2**12:");
    #10 assign a = 32'h3F800000; assign b = 32'h45800000;

    #10 $display("\n1 * 2**11:");
    #10 assign a = 32'h3F800000; assign b = 32'h45000000;

    #10 $display("\n1 * 2**10:");
    #10 assign a = 32'h3F800000; assign b = 32'h44800000;

    #10 $display("\n1 * 2**9:");
    #10 assign a = 32'h3F800000; assign b = 32'h44000000;

    #10 $display("\n1 * 2**8:");
    #10 assign a = 32'h3F800000; assign b = 32'h43800000;

    #10 $display("\n1 * 2**7:");
    #10 assign a = 32'h3F800000; assign b = 32'h43000000;

    #10 $display("\n1 * 2**6:");
    #10 assign a = 32'h3F800000; assign b = 32'h42800000;

    #10 $display("\n1 * 2**5:");
    #10 assign a = 32'h3F800000; assign b = 32'h42000000;

    #10 $display("\n1 * 2**4:");
    #10 assign a = 32'h3F800000; assign b = 32'h41800000;

    #10 $display("\n1 * 2**3:");
    #10 assign a = 32'h3F800000; assign b = 32'h41000000;

    #10 $display("\n1 * 2**2:");
    #10 assign a = 32'h3F800000; assign b = 32'h40800000;

    #10 $display("\n1 * 2**1:");
    #10 assign a = 32'h3F800000; assign b = 32'h40000000;

    #10 $display("\n1 * 2**0:");
    #10 assign a = 32'h3F800000; assign b = 32'h3F800000;

    #10 $display("\n1 * 2**-1:");
    #10 assign a = 32'h3F800000; assign b = 32'h3F000000;

    #10 $display("\n1 * 2**-2:");
    #10 assign a = 32'h3F800000; assign b = 32'h3E800000;

    #10 $display("\n1 * 2**-3:");
    #10 assign a = 32'h3F800000; assign b = 32'h3E000000;

    #10 $display("\n1 * 2**-4:");
    #10 assign a = 32'h3F800000; assign b = 32'h3D800000;

    #10 $display("\n1 * 2**-5:");
    #10 assign a = 32'h3F800000; assign b = 32'h3D000000;

    #10 $display("\n1 * 2**-6:");
    #10 assign a = 32'h3F800000; assign b = 32'h3C800000;

    #10 $display("\n1 * 2**-7:");
    #10 assign a = 32'h3F800000; assign b = 32'h3C000000;

    #10 $display("\n1 * 2**-8:");
    #10 assign a = 32'h3F800000; assign b = 32'h3B800000;

    #10 $display("\n1 * 2**-9:");
    #10 assign a = 32'h3F800000; assign b = 32'h3B000000;

    #10 $display("\n1 * 2**-10:");
    #10 assign a = 32'h3F800000; assign b = 32'h3A800000;

    #10 $display("\n1 * 2**-11:");
    #10 assign a = 32'h3F800000; assign b = 32'h3A000000;

    #10 $display("\n1 * 2**-12:");
    #10 assign a = 32'h3F800000; assign b = 32'h39800000;

    #10 $display("\n1 * 2**-13:");
    #10 assign a = 32'h3F800000; assign b = 32'h39000000;

    #10 $display("\n1 * 2**-14:");
    #10 assign a = 32'h3F800000; assign b = 32'h38800000;

    #10 $display("\n1 * 2**-15:");
    #10 assign a = 32'h3F800000; assign b = 32'h38000000;

    #10 $display("\n1 * 2**-16:");
    #10 assign a = 32'h3F800000; assign b = 32'h37800000;

    #10 $display("\n1 * 2**-17:");
    #10 assign a = 32'h3F800000; assign b = 32'h37000000;

    #10 $display("\n1 * 2**-18:");
    #10 assign a = 32'h3F800000; assign b = 32'h36800000;

    #10 $display("\n1 * 2**-19:");
    #10 assign a = 32'h3F800000; assign b = 32'h36000000;

    #10 $display("\n1 * 2**-20:");
    #10 assign a = 32'h3F800000; assign b = 32'h35800000;

    #10 $display("\n1 * 2**-21:");
    #10 assign a = 32'h3F800000; assign b = 32'h35000000;

    #10 $display("\n1 * 2**-22:");
    #10 assign a = 32'h3F800000; assign b = 32'h34800000;

    #10 $display("\n1 * 2**-23:");
    #10 assign a = 32'h3F800000; assign b = 32'h34000000;

    #10 $display("\n1 * 2**-24:");
    #10 assign a = 32'h3F800000; assign b = 32'h33800000;

    #10 $display("\n1 * 2**-25:");
    #10 assign a = 32'h3F800000; assign b = 32'h33000000;

    #10 $display("\n1 * 2**-26:");
    #10 assign a = 32'h3F800000; assign b = 32'h32800000;

    #10 $display("\n1 * 2**-27:");
    #10 assign a = 32'h3F800000; assign b = 32'h32000000;

    #10 $display("\n1 * 2**-28:");
    #10 assign a = 32'h3F800000; assign b = 32'h31800000;

    #10 $display("\n1 * 2**-29:");
    #10 assign a = 32'h3F800000; assign b = 32'h31000000;

    #10 $display("\n1 * 2**-30:");
    #10 assign a = 32'h3F800000; assign b = 32'h30800000;

    #10 $display("\n1 * 2**-31:");
    #10 assign a = 32'h3F800000; assign b = 32'h30000000;

    #10 $display("\n1 * 2**-32:");
    #10 assign a = 32'h3F800000; assign b = 32'h2F800000;

    #10 $display("\n1 * 2**-33:");
    #10 assign a = 32'h3F800000; assign b = 32'h2F000000;

    #10 $display("\n1 * 2**-34:");
    #10 assign a = 32'h3F800000; assign b = 32'h2E800000;

    #10 $display("\n1 * 2**-35:");
    #10 assign a = 32'h3F800000; assign b = 32'h2E000000;

    #10 $display("\n1 * 2**-36:");
    #10 assign a = 32'h3F800000; assign b = 32'h2D800000;

    #10 $display("\n1 * 2**-37:");
    #10 assign a = 32'h3F800000; assign b = 32'h2D000000;

    #10 $display("\n1 * 2**-38:");
    #10 assign a = 32'h3F800000; assign b = 32'h2C800000;

    #10 $display("\n1 * 2**-39:");
    #10 assign a = 32'h3F800000; assign b = 32'h2C000000;

    #10 $display("\n1 * 2**-40:");
    #10 assign a = 32'h3F800000; assign b = 32'h2B800000;

    #10 $display("\n1 * 2**-41:");
    #10 assign a = 32'h3F800000; assign b = 32'h2B000000;

    #10 $display("\n1 * 2**-42:");
    #10 assign a = 32'h3F800000; assign b = 32'h2A800000;

    #10 $display("\n1 * 2**-43:");
    #10 assign a = 32'h3F800000; assign b = 32'h2A000000;

    #10 $display("\n1 * 2**-44:");
    #10 assign a = 32'h3F800000; assign b = 32'h29800000;

    #10 $display("\n1 * 2**-45:");
    #10 assign a = 32'h3F800000; assign b = 32'h29000000;

    #10 $display("\n1 * 2**-46:");
    #10 assign a = 32'h3F800000; assign b = 32'h28800000;

    #10 $display("\n1 * 2**-47:");
    #10 assign a = 32'h3F800000; assign b = 32'h28000000;

    #10 $display("\n1 * 2**-48:");
    #10 assign a = 32'h3F800000; assign b = 32'h27800000;

    #10 $display("\n1 * 2**-49:");
    #10 assign a = 32'h3F800000; assign b = 32'h27000000;

    #10 $display("\n1 * 2**-50:");
    #10 assign a = 32'h3F800000; assign b = 32'h26800000;

    #10 $display("\n1 * 2**-51:");
    #10 assign a = 32'h3F800000; assign b = 32'h26000000;

    #10 $display("\n1 * 2**-52:");
    #10 assign a = 32'h3F800000; assign b = 32'h25800000;

    #10 $display("\n1 * 2**-53:");
    #10 assign a = 32'h3F800000; assign b = 32'h25000000;

    #10 $display("\n1 * 2**-54:");
    #10 assign a = 32'h3F800000; assign b = 32'h24800000;

    #10 $display("\n1 * 2**-55:");
    #10 assign a = 32'h3F800000; assign b = 32'h24000000;

    #10 $display("\n1 * 2**-56:");
    #10 assign a = 32'h3F800000; assign b = 32'h23800000;

    #10 $display("\n1 * 2**-57:");
    #10 assign a = 32'h3F800000; assign b = 32'h23000000;

    #10 $display("\n1 * 2**-58:");
    #10 assign a = 32'h3F800000; assign b = 32'h22800000;

    #10 $display("\n1 * 2**-59:");
    #10 assign a = 32'h3F800000; assign b = 32'h22000000;

    #10 $display("\n1 * 2**-60:");
    #10 assign a = 32'h3F800000; assign b = 32'h21800000;

    #10 $display("\n1 * 2**-61:");
    #10 assign a = 32'h3F800000; assign b = 32'h21000000;

    #10 $display("\n1 * 2**-62:");
    #10 assign a = 32'h3F800000; assign b = 32'h20800000;

    #10 $display("\n1 * 2**-63:");
    #10 assign a = 32'h3F800000; assign b = 32'h20000000;

    #10 $display("\n1 * 2**-64:");
    #10 assign a = 32'h3F800000; assign b = 32'h1F800000;

    #10 $display("\n1 * 2**-65:");
    #10 assign a = 32'h3F800000; assign b = 32'h1F000000;

    #10 $display("\n1 * 2**-66:");
    #10 assign a = 32'h3F800000; assign b = 32'h1E800000;

    #10 $display("\n1 * 2**-67:");
    #10 assign a = 32'h3F800000; assign b = 32'h1E000000;

    #10 $display("\n1 * 2**-68:");
    #10 assign a = 32'h3F800000; assign b = 32'h1D800000;

    #10 $display("\n1 * 2**-69:");
    #10 assign a = 32'h3F800000; assign b = 32'h1D000000;

    #10 $display("\n1 * 2**-70:");
    #10 assign a = 32'h3F800000; assign b = 32'h1C800000;

    #10 $display("\n1 * 2**-71:");
    #10 assign a = 32'h3F800000; assign b = 32'h1C000000;

    #10 $display("\n1 * 2**-72:");
    #10 assign a = 32'h3F800000; assign b = 32'h1B800000;

    #10 $display("\n1 * 2**-73:");
    #10 assign a = 32'h3F800000; assign b = 32'h1B000000;

    #10 $display("\n1 * 2**-74:");
    #10 assign a = 32'h3F800000; assign b = 32'h1A800000;

    #10 $display("\n1 * 2**-75:");
    #10 assign a = 32'h3F800000; assign b = 32'h1A000000;

    #10 $display("\n1 * 2**-76:");
    #10 assign a = 32'h3F800000; assign b = 32'h19800000;

    #10 $display("\n1 * 2**-77:");
    #10 assign a = 32'h3F800000; assign b = 32'h19000000;

    #10 $display("\n1 * 2**-78:");
    #10 assign a = 32'h3F800000; assign b = 32'h18800000;

    #10 $display("\n1 * 2**-79:");
    #10 assign a = 32'h3F800000; assign b = 32'h18000000;

    #10 $display("\n1 * 2**-80:");
    #10 assign a = 32'h3F800000; assign b = 32'h17800000;

    #10 $display("\n1 * 2**-81:");
    #10 assign a = 32'h3F800000; assign b = 32'h17000000;

    #10 $display("\n1 * 2**-82:");
    #10 assign a = 32'h3F800000; assign b = 32'h16800000;

    #10 $display("\n1 * 2**-83:");
    #10 assign a = 32'h3F800000; assign b = 32'h16000000;

    #10 $display("\n1 * 2**-84:");
    #10 assign a = 32'h3F800000; assign b = 32'h15800000;

    #10 $display("\n1 * 2**-85:");
    #10 assign a = 32'h3F800000; assign b = 32'h15000000;

    #10 $display("\n1 * 2**-86:");
    #10 assign a = 32'h3F800000; assign b = 32'h14800000;

    #10 $display("\n1 * 2**-87:");
    #10 assign a = 32'h3F800000; assign b = 32'h14000000;

    #10 $display("\n1 * 2**-88:");
    #10 assign a = 32'h3F800000; assign b = 32'h13800000;

    #10 $display("\n1 * 2**-89:");
    #10 assign a = 32'h3F800000; assign b = 32'h13000000;

    #10 $display("\n1 * 2**-90:");
    #10 assign a = 32'h3F800000; assign b = 32'h12800000;

    #10 $display("\n1 * 2**-91:");
    #10 assign a = 32'h3F800000; assign b = 32'h12000000;

    #10 $display("\n1 * 2**-92:");
    #10 assign a = 32'h3F800000; assign b = 32'h11800000;

    #10 $display("\n1 * 2**-93:");
    #10 assign a = 32'h3F800000; assign b = 32'h11000000;

    #10 $display("\n1 * 2**-94:");
    #10 assign a = 32'h3F800000; assign b = 32'h10800000;

    #10 $display("\n1 * 2**-95:");
    #10 assign a = 32'h3F800000; assign b = 32'h10000000;

    #10 $display("\n1 * 2**-96:");
    #10 assign a = 32'h3F800000; assign b = 32'h0F800000;

    #10 $display("\n1 * 2**-97:");
    #10 assign a = 32'h3F800000; assign b = 32'h0F000000;

    #10 $display("\n1 * 2**-98:");
    #10 assign a = 32'h3F800000; assign b = 32'h0E800000;

    #10 $display("\n1 * 2**-99:");
    #10 assign a = 32'h3F800000; assign b = 32'h0E000000;

    #10 $display("\n1 * 2**-100:");
    #10 assign a = 32'h3F800000; assign b = 32'h0D800000;

    #10 $display("\n1 * 2**-101:");
    #10 assign a = 32'h3F800000; assign b = 32'h0D000000;

    #10 $display("\n1 * 2**-102:");
    #10 assign a = 32'h3F800000; assign b = 32'h0C800000;

    #10 $display("\n1 * 2**-103:");
    #10 assign a = 32'h3F800000; assign b = 32'h0C000000;

    #10 $display("\n1 * 2**-104:");
    #10 assign a = 32'h3F800000; assign b = 32'h0B800000;

    #10 $display("\n1 * 2**-105:");
    #10 assign a = 32'h3F800000; assign b = 32'h0B000000;

    #10 $display("\n1 * 2**-106:");
    #10 assign a = 32'h3F800000; assign b = 32'h0A800000;

    #10 $display("\n1 * 2**-107:");
    #10 assign a = 32'h3F800000; assign b = 32'h0A000000;

    #10 $display("\n1 * 2**-108:");
    #10 assign a = 32'h3F800000; assign b = 32'h09800000;

    #10 $display("\n1 * 2**-109:");
    #10 assign a = 32'h3F800000; assign b = 32'h09000000;

    #10 $display("\n1 * 2**-110:");
    #10 assign a = 32'h3F800000; assign b = 32'h08800000;

    #10 $display("\n1 * 2**-111:");
    #10 assign a = 32'h3F800000; assign b = 32'h08000000;

    #10 $display("\n1 * 2**-112:");
    #10 assign a = 32'h3F800000; assign b = 32'h07800000;

    #10 $display("\n1 * 2**-113:");
    #10 assign a = 32'h3F800000; assign b = 32'h07000000;

    #10 $display("\n1 * 2**-114:");
    #10 assign a = 32'h3F800000; assign b = 32'h06800000;

    #10 $display("\n1 * 2**-115:");
    #10 assign a = 32'h3F800000; assign b = 32'h06000000;

    #10 $display("\n1 * 2**-116:");
    #10 assign a = 32'h3F800000; assign b = 32'h05800000;

    #10 $display("\n1 * 2**-117:");
    #10 assign a = 32'h3F800000; assign b = 32'h05000000;

    #10 $display("\n1 * 2**-118:");
    #10 assign a = 32'h3F800000; assign b = 32'h04800000;

    #10 $display("\n1 * 2**-119:");
    #10 assign a = 32'h3F800000; assign b = 32'h04000000;

    #10 $display("\n1 * 2**-120:");
    #10 assign a = 32'h3F800000; assign b = 32'h03800000;

    #10 $display("\n1 * 2**-121:");
    #10 assign a = 32'h3F800000; assign b = 32'h03000000;

    #10 $display("\n1 * 2**-122:");
    #10 assign a = 32'h3F800000; assign b = 32'h02800000;

    #10 $display("\n1 * 2**-123:");
    #10 assign a = 32'h3F800000; assign b = 32'h02000000;

    #10 $display("\n1 * 2**-124:");
    #10 assign a = 32'h3F800000; assign b = 32'h01800000;

    #10 $display("\n1 * 2**-125:");
    #10 assign a = 32'h3F800000; assign b = 32'h01000000;

    #10 $display("\n1 * 2**-126:");
    #10 assign a = 32'h3F800000; assign b = 32'h00800000;

    #10 $display("\n1 * 2**-127:");
    #10 assign a = 32'h3F800000; assign b = 32'h00400000;

    #10 $display("\n1 * 2**-128:");
    #10 assign a = 32'h3F800000; assign b = 32'h00200000;

    #10 $display("\n1 * 2**-129:");
    #10 assign a = 32'h3F800000; assign b = 32'h00100000;

    #10 $display("\n1 * 2**-130:");
    #10 assign a = 32'h3F800000; assign b = 32'h00080000;

    #10 $display("\n1 * 2**-131:");
    #10 assign a = 32'h3F800000; assign b = 32'h00040000;

    #10 $display("\n1 * 2**-132:");
    #10 assign a = 32'h3F800000; assign b = 32'h00020000;

    #10 $display("\n1 * 2**-133:");
    #10 assign a = 32'h3F800000; assign b = 32'h00010000;

    #10 $display("\n1 * 2**-134:");
    #10 assign a = 32'h3F800000; assign b = 32'h00008000;

    #10 $display("\n1 * 2**-135:");
    #10 assign a = 32'h3F800000; assign b = 32'h00004000;

    #10 $display("\n1 * 2**-136:");
    #10 assign a = 32'h3F800000; assign b = 32'h00002000;

    #10 $display("\n1 * 2**-137:");
    #10 assign a = 32'h3F800000; assign b = 32'h00001000;

    #10 $display("\n1 * 2**-138:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000800;

    #10 $display("\n1 * 2**-139:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000400;

    #10 $display("\n1 * 2**-140:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000200;

    #10 $display("\n1 * 2**-141:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000100;

    #10 $display("\n1 * 2**-142:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000080;

    #10 $display("\n1 * 2**-143:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000040;

    #10 $display("\n1 * 2**-144:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000020;

    #10 $display("\n1 * 2**-145:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000010;

    #10 $display("\n1 * 2**-146:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000008;

    #10 $display("\n1 * 2**-147:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000004;

    #10 $display("\n1 * 2**-148:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000002;

    #10 $display("\n1 * 2**-149:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000001;

    #10 $display("\n2**127 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7F000000;

    #10 $display("\n2**126 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7E800000;

    #10 $display("\n2**125 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7E000000;

    #10 $display("\n2**124 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7D800000;

    #10 $display("\n2**123 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7D000000;

    #10 $display("\n2**122 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7C800000;

    #10 $display("\n2**121 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7C000000;

    #10 $display("\n2**120 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7B800000;

    #10 $display("\n2**119 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7B000000;

    #10 $display("\n2**118 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7A800000;

    #10 $display("\n2**117 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7A000000;

    #10 $display("\n2**116 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h79800000;

    #10 $display("\n2**115 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h79000000;

    #10 $display("\n2**114 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h78800000;

    #10 $display("\n2**113 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h78000000;

    #10 $display("\n2**112 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h77800000;

    #10 $display("\n2**111 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h77000000;

    #10 $display("\n2**110 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h76800000;

    #10 $display("\n2**109 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h76000000;

    #10 $display("\n2**108 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h75800000;

    #10 $display("\n2**107 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h75000000;

    #10 $display("\n2**106 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h74800000;

    #10 $display("\n2**105 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h74000000;

    #10 $display("\n2**104 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h73800000;

    #10 $display("\n2**103 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h73000000;

    #10 $display("\n2**102 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h72800000;

    #10 $display("\n2**101 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h72000000;

    #10 $display("\n2**100 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h71800000;

    #10 $display("\n2**99 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h71000000;

    #10 $display("\n2**98 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h70800000;

    #10 $display("\n2**97 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h70000000;

    #10 $display("\n2**96 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6F800000;

    #10 $display("\n2**95 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6F000000;

    #10 $display("\n2**94 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6E800000;

    #10 $display("\n2**93 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6E000000;

    #10 $display("\n2**92 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6D800000;

    #10 $display("\n2**91 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6D000000;

    #10 $display("\n2**90 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6C800000;

    #10 $display("\n2**89 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6C000000;

    #10 $display("\n2**88 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6B800000;

    #10 $display("\n2**87 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6B000000;

    #10 $display("\n2**86 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6A800000;

    #10 $display("\n2**85 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6A000000;

    #10 $display("\n2**84 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h69800000;

    #10 $display("\n2**83 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h69000000;

    #10 $display("\n2**82 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h68800000;

    #10 $display("\n2**81 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h68000000;

    #10 $display("\n2**80 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h67800000;

    #10 $display("\n2**79 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h67000000;

    #10 $display("\n2**78 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h66800000;

    #10 $display("\n2**77 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h66000000;

    #10 $display("\n2**76 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h65800000;

    #10 $display("\n2**75 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h65000000;

    #10 $display("\n2**74 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h64800000;

    #10 $display("\n2**73 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h64000000;

    #10 $display("\n2**72 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h63800000;

    #10 $display("\n2**71 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h63000000;

    #10 $display("\n2**70 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h62800000;

    #10 $display("\n2**69 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h62000000;

    #10 $display("\n2**68 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h61800000;

    #10 $display("\n2**67 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h61000000;

    #10 $display("\n2**66 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h60800000;

    #10 $display("\n2**65 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h60000000;

    #10 $display("\n2**64 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5F800000;

    #10 $display("\n2**63 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5F000000;

    #10 $display("\n2**62 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5E800000;

    #10 $display("\n2**61 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5E000000;

    #10 $display("\n2**60 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5D800000;

    #10 $display("\n2**59 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5D000000;

    #10 $display("\n2**58 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5C800000;

    #10 $display("\n2**57 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5C000000;

    #10 $display("\n2**56 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5B800000;

    #10 $display("\n2**55 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5B000000;

    #10 $display("\n2**54 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5A800000;

    #10 $display("\n2**53 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5A000000;

    #10 $display("\n2**52 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h59800000;

    #10 $display("\n2**51 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h59000000;

    #10 $display("\n2**50 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h58800000;

    #10 $display("\n2**49 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h58000000;

    #10 $display("\n2**48 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h57800000;

    #10 $display("\n2**47 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h57000000;

    #10 $display("\n2**46 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h56800000;

    #10 $display("\n2**45 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h56000000;

    #10 $display("\n2**44 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h55800000;

    #10 $display("\n2**43 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h55000000;

    #10 $display("\n2**42 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h54800000;

    #10 $display("\n2**41 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h54000000;

    #10 $display("\n2**40 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h53800000;

    #10 $display("\n2**39 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h53000000;

    #10 $display("\n2**38 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h52800000;

    #10 $display("\n2**37 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h52000000;

    #10 $display("\n2**36 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h51800000;

    #10 $display("\n2**35 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h51000000;

    #10 $display("\n2**34 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h50800000;

    #10 $display("\n2**33 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h50000000;

    #10 $display("\n2**32 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4F800000;

    #10 $display("\n2**31 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4F000000;

    #10 $display("\n2**30 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4E800000;

    #10 $display("\n2**29 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4E000000;

    #10 $display("\n2**28 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4D800000;

    #10 $display("\n2**27 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4D000000;

    #10 $display("\n2**26 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4C800000;

    #10 $display("\n2**25 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4C000000;

    #10 $display("\n2**24 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4B800000;

    #10 $display("\n2**23 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4B000000;

    #10 $display("\n2**22 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4A800000;

    #10 $display("\n2**21 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4A000000;

    #10 $display("\n2**20 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h49800000;

    #10 $display("\n2**19 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h49000000;

    #10 $display("\n2**18 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h48800000;

    #10 $display("\n2**17 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h48000000;

    #10 $display("\n2**16 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h47800000;

    #10 $display("\n2**15 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h47000000;

    #10 $display("\n2**14 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h46800000;

    #10 $display("\n2**13 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h46000000;

    #10 $display("\n2**12 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h45800000;

    #10 $display("\n2**11 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h45000000;

    #10 $display("\n2**10 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h44800000;

    #10 $display("\n2**9 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h44000000;

    #10 $display("\n2**8 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h43800000;

    #10 $display("\n2**7 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h43000000;

    #10 $display("\n2**6 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h42800000;

    #10 $display("\n2**5 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h42000000;

    #10 $display("\n2**4 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h41800000;

    #10 $display("\n2**3 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h41000000;

    #10 $display("\n2**2 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h40800000;

    #10 $display("\n2**1 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h40000000;

    #10 $display("\n2**0 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3F800000;

    #10 $display("\n2**-1 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3F000000;

    #10 $display("\n2**-2 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3E800000;

    #10 $display("\n2**-3 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3E000000;

    #10 $display("\n2**-4 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3D800000;

    #10 $display("\n2**-5 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3D000000;

    #10 $display("\n2**-6 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3C800000;

    #10 $display("\n2**-7 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3C000000;

    #10 $display("\n2**-8 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3B800000;

    #10 $display("\n2**-9 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3B000000;

    #10 $display("\n2**-10 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3A800000;

    #10 $display("\n2**-11 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3A000000;

    #10 $display("\n2**-12 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h39800000;

    #10 $display("\n2**-13 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h39000000;

    #10 $display("\n2**-14 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h38800000;

    #10 $display("\n2**-15 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h38000000;

    #10 $display("\n2**-16 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h37800000;

    #10 $display("\n2**-17 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h37000000;

    #10 $display("\n2**-18 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h36800000;

    #10 $display("\n2**-19 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h36000000;

    #10 $display("\n2**-20 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h35800000;

    #10 $display("\n2**-21 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h35000000;

    #10 $display("\n2**-22 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h34800000;

    #10 $display("\n2**-23 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h34000000;

    #10 $display("\n2**-24 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h33800000;

    #10 $display("\n2**-25 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h33000000;

    #10 $display("\n2**-26 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h32800000;

    #10 $display("\n2**-27 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h32000000;

    #10 $display("\n2**-28 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h31800000;

    #10 $display("\n2**-29 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h31000000;

    #10 $display("\n2**-30 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h30800000;

    #10 $display("\n2**-31 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h30000000;

    #10 $display("\n2**-32 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2F800000;

    #10 $display("\n2**-33 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2F000000;

    #10 $display("\n2**-34 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2E800000;

    #10 $display("\n2**-35 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2E000000;

    #10 $display("\n2**-36 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2D800000;

    #10 $display("\n2**-37 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2D000000;

    #10 $display("\n2**-38 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2C800000;

    #10 $display("\n2**-39 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2C000000;

    #10 $display("\n2**-40 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2B800000;

    #10 $display("\n2**-41 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2B000000;

    #10 $display("\n2**-42 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2A800000;

    #10 $display("\n2**-43 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2A000000;

    #10 $display("\n2**-44 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h29800000;

    #10 $display("\n2**-45 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h29000000;

    #10 $display("\n2**-46 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h28800000;

    #10 $display("\n2**-47 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h28000000;

    #10 $display("\n2**-48 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h27800000;

    #10 $display("\n2**-49 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h27000000;

    #10 $display("\n2**-50 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h26800000;

    #10 $display("\n2**-51 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h26000000;

    #10 $display("\n2**-52 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h25800000;

    #10 $display("\n2**-53 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h25000000;

    #10 $display("\n2**-54 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h24800000;

    #10 $display("\n2**-55 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h24000000;

    #10 $display("\n2**-56 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h23800000;

    #10 $display("\n2**-57 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h23000000;

    #10 $display("\n2**-58 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h22800000;

    #10 $display("\n2**-59 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h22000000;

    #10 $display("\n2**-60 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h21800000;

    #10 $display("\n2**-61 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h21000000;

    #10 $display("\n2**-62 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h20800000;

    #10 $display("\n2**-63 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h20000000;

    #10 $display("\n2**-64 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1F800000;

    #10 $display("\n2**-65 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1F000000;

    #10 $display("\n2**-66 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1E800000;

    #10 $display("\n2**-67 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1E000000;

    #10 $display("\n2**-68 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1D800000;

    #10 $display("\n2**-69 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1D000000;

    #10 $display("\n2**-70 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1C800000;

    #10 $display("\n2**-71 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1C000000;

    #10 $display("\n2**-72 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1B800000;

    #10 $display("\n2**-73 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1B000000;

    #10 $display("\n2**-74 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1A800000;

    #10 $display("\n2**-75 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1A000000;

    #10 $display("\n2**-76 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h19800000;

    #10 $display("\n2**-77 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h19000000;

    #10 $display("\n2**-78 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h18800000;

    #10 $display("\n2**-79 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h18000000;

    #10 $display("\n2**-80 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h17800000;

    #10 $display("\n2**-81 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h17000000;

    #10 $display("\n2**-82 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h16800000;

    #10 $display("\n2**-83 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h16000000;

    #10 $display("\n2**-84 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h15800000;

    #10 $display("\n2**-85 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h15000000;

    #10 $display("\n2**-86 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h14800000;

    #10 $display("\n2**-87 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h14000000;

    #10 $display("\n2**-88 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h13800000;

    #10 $display("\n2**-89 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h13000000;

    #10 $display("\n2**-90 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h12800000;

    #10 $display("\n2**-91 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h12000000;

    #10 $display("\n2**-92 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h11800000;

    #10 $display("\n2**-93 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h11000000;

    #10 $display("\n2**-94 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h10800000;

    #10 $display("\n2**-95 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h10000000;

    #10 $display("\n2**-96 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0F800000;

    #10 $display("\n2**-97 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0F000000;

    #10 $display("\n2**-98 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0E800000;

    #10 $display("\n2**-99 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0E000000;

    #10 $display("\n2**-100 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0D800000;

    #10 $display("\n2**-101 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0D000000;

    #10 $display("\n2**-102 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0C800000;

    #10 $display("\n2**-103 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0C000000;

    #10 $display("\n2**-104 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0B800000;

    #10 $display("\n2**-105 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0B000000;

    #10 $display("\n2**-106 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0A800000;

    #10 $display("\n2**-107 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0A000000;

    #10 $display("\n2**-108 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h09800000;

    #10 $display("\n2**-109 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h09000000;

    #10 $display("\n2**-110 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h08800000;

    #10 $display("\n2**-111 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h08000000;

    #10 $display("\n2**-112 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h07800000;

    #10 $display("\n2**-113 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h07000000;

    #10 $display("\n2**-114 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h06800000;

    #10 $display("\n2**-115 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h06000000;

    #10 $display("\n2**-116 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h05800000;

    #10 $display("\n2**-117 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h05000000;

    #10 $display("\n2**-118 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h04800000;

    #10 $display("\n2**-119 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h04000000;

    #10 $display("\n2**-120 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h03800000;

    #10 $display("\n2**-121 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h03000000;

    #10 $display("\n2**-122 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h02800000;

    #10 $display("\n2**-123 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h02000000;

    #10 $display("\n2**-124 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h01800000;

    #10 $display("\n2**-125 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h01000000;

    #10 $display("\n2**-126 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00800000;

    #10 $display("\n2**-127 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00400000;

    #10 $display("\n2**-128 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00200000;

    #10 $display("\n2**-129 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00100000;

    #10 $display("\n2**-130 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00080000;

    #10 $display("\n2**-131 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00040000;

    #10 $display("\n2**-132 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00020000;

    #10 $display("\n2**-133 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00010000;

    #10 $display("\n2**-134 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00008000;

    #10 $display("\n2**-135 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00004000;

    #10 $display("\n2**-136 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00002000;

    #10 $display("\n2**-137 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00001000;

    #10 $display("\n2**-138 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000800;

    #10 $display("\n2**-139 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000400;

    #10 $display("\n2**-140 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000200;

    #10 $display("\n2**-141 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000100;

    #10 $display("\n2**-142 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000080;

    #10 $display("\n2**-143 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000040;

    #10 $display("\n2**-144 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000020;

    #10 $display("\n2**-145 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000010;

    #10 $display("\n2**-146 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000008;

    #10 $display("\n2**-147 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000004;

    #10 $display("\n2**-148 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000002;

    #10 $display("\n2**-149 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000001;

    #10 $display("\n2**0 * 2**127:");
    #10 assign a = 32'h3F800000; assign b = 32'h7F000000;
    #10 assign a = 32'h3FFFFFFF; assign b = 32'h7F7FFFFF;

    #10 $display("\n2**1 * 2**126:");
    #10 assign a = 32'h40000000; assign b = 32'h7E800000;
    #10 assign a = 32'h407FFFFF; assign b = 32'h7EFFFFFF;

    #10 $display("\n2**2 * 2**125:");
    #10 assign a = 32'h40800000; assign b = 32'h7E000000;
    #10 assign a = 32'h40FFFFFF; assign b = 32'h7E7FFFFF;

    #10 $display("\n2**3 * 2**124:");
    #10 assign a = 32'h41000000; assign b = 32'h7D800000;
    #10 assign a = 32'h417FFFFF; assign b = 32'h7DFFFFFF;

    #10 $display("\n2**4 * 2**123:");
    #10 assign a = 32'h41800000; assign b = 32'h7D000000;
    #10 assign a = 32'h41FFFFFF; assign b = 32'h7D7FFFFF;

    #10 $display("\n2**5 * 2**122:");
    #10 assign a = 32'h42000000; assign b = 32'h7C800000;
    #10 assign a = 32'h427FFFFF; assign b = 32'h7CFFFFFF;

    #10 $display("\n2**6 * 2**121:");
    #10 assign a = 32'h42800000; assign b = 32'h7C000000;
    #10 assign a = 32'h42FFFFFF; assign b = 32'h7C7FFFFF;

    #10 $display("\n2**7 * 2**120:");
    #10 assign a = 32'h43000000; assign b = 32'h7B800000;
    #10 assign a = 32'h437FFFFF; assign b = 32'h7BFFFFFF;

    #10 $display("\n2**8 * 2**119:");
    #10 assign a = 32'h43800000; assign b = 32'h7B000000;
    #10 assign a = 32'h43FFFFFF; assign b = 32'h7B7FFFFF;

    #10 $display("\n2**9 * 2**118:");
    #10 assign a = 32'h44000000; assign b = 32'h7A800000;
    #10 assign a = 32'h447FFFFF; assign b = 32'h7AFFFFFF;

    #10 $display("\n2**10 * 2**117:");
    #10 assign a = 32'h44800000; assign b = 32'h7A000000;
    #10 assign a = 32'h44FFFFFF; assign b = 32'h7A7FFFFF;

    #10 $display("\n2**11 * 2**116:");
    #10 assign a = 32'h45000000; assign b = 32'h79800000;
    #10 assign a = 32'h457FFFFF; assign b = 32'h79FFFFFF;

    #10 $display("\n2**12 * 2**115:");
    #10 assign a = 32'h45800000; assign b = 32'h79000000;
    #10 assign a = 32'h45FFFFFF; assign b = 32'h797FFFFF;

    #10 $display("\n2**13 * 2**114:");
    #10 assign a = 32'h46000000; assign b = 32'h78800000;
    #10 assign a = 32'h467FFFFF; assign b = 32'h78FFFFFF;

    #10 $display("\n2**14 * 2**113:");
    #10 assign a = 32'h46800000; assign b = 32'h78000000;
    #10 assign a = 32'h46FFFFFF; assign b = 32'h787FFFFF;

    #10 $display("\n2**15 * 2**112:");
    #10 assign a = 32'h47000000; assign b = 32'h77800000;
    #10 assign a = 32'h477FFFFF; assign b = 32'h77FFFFFF;

    #10 $display("\n2**16 * 2**111:");
    #10 assign a = 32'h47800000; assign b = 32'h77000000;
    #10 assign a = 32'h47FFFFFF; assign b = 32'h777FFFFF;

    #10 $display("\n2**17 * 2**110:");
    #10 assign a = 32'h48000000; assign b = 32'h76800000;
    #10 assign a = 32'h487FFFFF; assign b = 32'h76FFFFFF;

    #10 $display("\n2**18 * 2**109:");
    #10 assign a = 32'h48800000; assign b = 32'h76000000;
    #10 assign a = 32'h48FFFFFF; assign b = 32'h767FFFFF;

    #10 $display("\n2**19 * 2**108:");
    #10 assign a = 32'h49000000; assign b = 32'h75800000;
    #10 assign a = 32'h497FFFFF; assign b = 32'h75FFFFFF;

    #10 $display("\n2**20 * 2**107:");
    #10 assign a = 32'h49800000; assign b = 32'h75000000;
    #10 assign a = 32'h49FFFFFF; assign b = 32'h757FFFFF;

    #10 $display("\n2**21 * 2**106:");
    #10 assign a = 32'h4A000000; assign b = 32'h74800000;
    #10 assign a = 32'h4A7FFFFF; assign b = 32'h74FFFFFF;

    #10 $display("\n2**22 * 2**105:");
    #10 assign a = 32'h4A800000; assign b = 32'h74000000;
    #10 assign a = 32'h4AFFFFFF; assign b = 32'h747FFFFF;

    #10 $display("\n2**23 * 2**104:");
    #10 assign a = 32'h4B000000; assign b = 32'h73800000;
    #10 assign a = 32'h4B7FFFFF; assign b = 32'h73FFFFFF;

    #10 $display("\n2**24 * 2**103:");
    #10 assign a = 32'h4B800000; assign b = 32'h73000000;
    #10 assign a = 32'h4BFFFFFF; assign b = 32'h737FFFFF;

    #10 $display("\n2**25 * 2**102:");
    #10 assign a = 32'h4C000000; assign b = 32'h72800000;
    #10 assign a = 32'h4C7FFFFF; assign b = 32'h72FFFFFF;

    #10 $display("\n2**26 * 2**101:");
    #10 assign a = 32'h4C800000; assign b = 32'h72000000;
    #10 assign a = 32'h4CFFFFFF; assign b = 32'h727FFFFF;

    #10 $display("\n2**27 * 2**100:");
    #10 assign a = 32'h4D000000; assign b = 32'h71800000;
    #10 assign a = 32'h4D7FFFFF; assign b = 32'h71FFFFFF;

    #10 $display("\n2**28 * 2**99:");
    #10 assign a = 32'h4D800000; assign b = 32'h71000000;
    #10 assign a = 32'h4DFFFFFF; assign b = 32'h717FFFFF;

    #10 $display("\n2**29 * 2**98:");
    #10 assign a = 32'h4E000000; assign b = 32'h70800000;
    #10 assign a = 32'h4E7FFFFF; assign b = 32'h70FFFFFF;

    #10 $display("\n2**30 * 2**97:");
    #10 assign a = 32'h4E800000; assign b = 32'h70000000;
    #10 assign a = 32'h4EFFFFFF; assign b = 32'h707FFFFF;

    #10 $display("\n2**31 * 2**96:");
    #10 assign a = 32'h4F000000; assign b = 32'h6F800000;
    #10 assign a = 32'h4F7FFFFF; assign b = 32'h6FFFFFFF;

    #10 $display("\n2**32 * 2**95:");
    #10 assign a = 32'h4F800000; assign b = 32'h6F000000;
    #10 assign a = 32'h4FFFFFFF; assign b = 32'h6F7FFFFF;

    #10 $display("\n2**33 * 2**94:");
    #10 assign a = 32'h50000000; assign b = 32'h6E800000;
    #10 assign a = 32'h507FFFFF; assign b = 32'h6EFFFFFF;

    #10 $display("\n2**34 * 2**93:");
    #10 assign a = 32'h50800000; assign b = 32'h6E000000;
    #10 assign a = 32'h50FFFFFF; assign b = 32'h6E7FFFFF;

    #10 $display("\n2**35 * 2**92:");
    #10 assign a = 32'h51000000; assign b = 32'h6D800000;
    #10 assign a = 32'h517FFFFF; assign b = 32'h6DFFFFFF;

    #10 $display("\n2**36 * 2**91:");
    #10 assign a = 32'h51800000; assign b = 32'h6D000000;
    #10 assign a = 32'h51FFFFFF; assign b = 32'h6D7FFFFF;

    #10 $display("\n2**37 * 2**90:");
    #10 assign a = 32'h52000000; assign b = 32'h6C800000;
    #10 assign a = 32'h527FFFFF; assign b = 32'h6CFFFFFF;

    #10 $display("\n2**38 * 2**89:");
    #10 assign a = 32'h52800000; assign b = 32'h6C000000;
    #10 assign a = 32'h52FFFFFF; assign b = 32'h6C7FFFFF;

    #10 $display("\n2**39 * 2**88:");
    #10 assign a = 32'h53000000; assign b = 32'h6B800000;
    #10 assign a = 32'h537FFFFF; assign b = 32'h6BFFFFFF;

    #10 $display("\n2**40 * 2**87:");
    #10 assign a = 32'h53800000; assign b = 32'h6B000000;
    #10 assign a = 32'h53FFFFFF; assign b = 32'h6B7FFFFF;

    #10 $display("\n2**41 * 2**86:");
    #10 assign a = 32'h54000000; assign b = 32'h6A800000;
    #10 assign a = 32'h547FFFFF; assign b = 32'h6AFFFFFF;

    #10 $display("\n2**42 * 2**85:");
    #10 assign a = 32'h54800000; assign b = 32'h6A000000;
    #10 assign a = 32'h54FFFFFF; assign b = 32'h6A7FFFFF;

    #10 $display("\n2**43 * 2**84:");
    #10 assign a = 32'h55000000; assign b = 32'h69800000;
    #10 assign a = 32'h557FFFFF; assign b = 32'h69FFFFFF;

    #10 $display("\n2**44 * 2**83:");
    #10 assign a = 32'h55800000; assign b = 32'h69000000;
    #10 assign a = 32'h55FFFFFF; assign b = 32'h697FFFFF;

    #10 $display("\n2**45 * 2**82:");
    #10 assign a = 32'h56000000; assign b = 32'h68800000;
    #10 assign a = 32'h567FFFFF; assign b = 32'h68FFFFFF;

    #10 $display("\n2**46 * 2**81:");
    #10 assign a = 32'h56800000; assign b = 32'h68000000;
    #10 assign a = 32'h56FFFFFF; assign b = 32'h687FFFFF;

    #10 $display("\n2**47 * 2**80:");
    #10 assign a = 32'h57000000; assign b = 32'h67800000;
    #10 assign a = 32'h577FFFFF; assign b = 32'h67FFFFFF;

    #10 $display("\n2**48 * 2**79:");
    #10 assign a = 32'h57800000; assign b = 32'h67000000;
    #10 assign a = 32'h57FFFFFF; assign b = 32'h677FFFFF;

    #10 $display("\n2**49 * 2**78:");
    #10 assign a = 32'h58000000; assign b = 32'h66800000;
    #10 assign a = 32'h587FFFFF; assign b = 32'h66FFFFFF;

    #10 $display("\n2**50 * 2**77:");
    #10 assign a = 32'h58800000; assign b = 32'h66000000;
    #10 assign a = 32'h58FFFFFF; assign b = 32'h667FFFFF;

    #10 $display("\n2**51 * 2**76:");
    #10 assign a = 32'h59000000; assign b = 32'h65800000;
    #10 assign a = 32'h597FFFFF; assign b = 32'h65FFFFFF;

    #10 $display("\n2**52 * 2**75:");
    #10 assign a = 32'h59800000; assign b = 32'h65000000;
    #10 assign a = 32'h59FFFFFF; assign b = 32'h657FFFFF;

    #10 $display("\n2**53 * 2**74:");
    #10 assign a = 32'h5A000000; assign b = 32'h64800000;
    #10 assign a = 32'h5A7FFFFF; assign b = 32'h64FFFFFF;

    #10 $display("\n2**54 * 2**73:");
    #10 assign a = 32'h5A800000; assign b = 32'h64000000;
    #10 assign a = 32'h5AFFFFFF; assign b = 32'h647FFFFF;

    #10 $display("\n2**55 * 2**72:");
    #10 assign a = 32'h5B000000; assign b = 32'h63800000;
    #10 assign a = 32'h5B7FFFFF; assign b = 32'h63FFFFFF;

    #10 $display("\n2**56 * 2**71:");
    #10 assign a = 32'h5B800000; assign b = 32'h63000000;
    #10 assign a = 32'h5BFFFFFF; assign b = 32'h637FFFFF;

    #10 $display("\n2**57 * 2**70:");
    #10 assign a = 32'h5C000000; assign b = 32'h62800000;
    #10 assign a = 32'h5C7FFFFF; assign b = 32'h62FFFFFF;

    #10 $display("\n2**58 * 2**69:");
    #10 assign a = 32'h5C800000; assign b = 32'h62000000;
    #10 assign a = 32'h5CFFFFFF; assign b = 32'h627FFFFF;

    #10 $display("\n2**59 * 2**68:");
    #10 assign a = 32'h5D000000; assign b = 32'h61800000;
    #10 assign a = 32'h5D7FFFFF; assign b = 32'h61FFFFFF;

    #10 $display("\n2**60 * 2**67:");
    #10 assign a = 32'h5D800000; assign b = 32'h61000000;
    #10 assign a = 32'h5DFFFFFF; assign b = 32'h617FFFFF;

    #10 $display("\n2**61 * 2**66:");
    #10 assign a = 32'h5E000000; assign b = 32'h60800000;
    #10 assign a = 32'h5E7FFFFF; assign b = 32'h60FFFFFF;

    #10 $display("\n2**62 * 2**65:");
    #10 assign a = 32'h5E800000; assign b = 32'h60000000;
    #10 assign a = 32'h5EFFFFFF; assign b = 32'h607FFFFF;

    #10 $display("\n2**63 * 2**64:");
    #10 assign a = 32'h5F000000; assign b = 32'h5F800000;
    #10 assign a = 32'h5F7FFFFF; assign b = 32'h5FFFFFFF;

    #10 $display("\n2**64 * 2**63:");
    #10 assign a = 32'h5F800000; assign b = 32'h5F000000;
    #10 assign a = 32'h5FFFFFFF; assign b = 32'h5F7FFFFF;

    #10 $display("\n2**65 * 2**62:");
    #10 assign a = 32'h60000000; assign b = 32'h5E800000;
    #10 assign a = 32'h607FFFFF; assign b = 32'h5EFFFFFF;

    #10 $display("\n2**66 * 2**61:");
    #10 assign a = 32'h60800000; assign b = 32'h5E000000;
    #10 assign a = 32'h60FFFFFF; assign b = 32'h5E7FFFFF;

    #10 $display("\n2**67 * 2**60:");
    #10 assign a = 32'h61000000; assign b = 32'h5D800000;
    #10 assign a = 32'h617FFFFF; assign b = 32'h5DFFFFFF;

    #10 $display("\n2**68 * 2**59:");
    #10 assign a = 32'h61800000; assign b = 32'h5D000000;
    #10 assign a = 32'h61FFFFFF; assign b = 32'h5D7FFFFF;

    #10 $display("\n2**69 * 2**58:");
    #10 assign a = 32'h62000000; assign b = 32'h5C800000;
    #10 assign a = 32'h627FFFFF; assign b = 32'h5CFFFFFF;

    #10 $display("\n2**70 * 2**57:");
    #10 assign a = 32'h62800000; assign b = 32'h5C000000;
    #10 assign a = 32'h62FFFFFF; assign b = 32'h5C7FFFFF;

    #10 $display("\n2**71 * 2**56:");
    #10 assign a = 32'h63000000; assign b = 32'h5B800000;
    #10 assign a = 32'h637FFFFF; assign b = 32'h5BFFFFFF;

    #10 $display("\n2**72 * 2**55:");
    #10 assign a = 32'h63800000; assign b = 32'h5B000000;
    #10 assign a = 32'h63FFFFFF; assign b = 32'h5B7FFFFF;

    #10 $display("\n2**73 * 2**54:");
    #10 assign a = 32'h64000000; assign b = 32'h5A800000;
    #10 assign a = 32'h647FFFFF; assign b = 32'h5AFFFFFF;

    #10 $display("\n2**74 * 2**53:");
    #10 assign a = 32'h64800000; assign b = 32'h5A000000;
    #10 assign a = 32'h64FFFFFF; assign b = 32'h5A7FFFFF;

    #10 $display("\n2**75 * 2**52:");
    #10 assign a = 32'h65000000; assign b = 32'h59800000;
    #10 assign a = 32'h657FFFFF; assign b = 32'h59FFFFFF;

    #10 $display("\n2**76 * 2**51:");
    #10 assign a = 32'h65800000; assign b = 32'h59000000;
    #10 assign a = 32'h65FFFFFF; assign b = 32'h597FFFFF;

    #10 $display("\n2**77 * 2**50:");
    #10 assign a = 32'h66000000; assign b = 32'h58800000;
    #10 assign a = 32'h667FFFFF; assign b = 32'h58FFFFFF;

    #10 $display("\n2**78 * 2**49:");
    #10 assign a = 32'h66800000; assign b = 32'h58000000;
    #10 assign a = 32'h66FFFFFF; assign b = 32'h587FFFFF;

    #10 $display("\n2**79 * 2**48:");
    #10 assign a = 32'h67000000; assign b = 32'h57800000;
    #10 assign a = 32'h677FFFFF; assign b = 32'h57FFFFFF;

    #10 $display("\n2**80 * 2**47:");
    #10 assign a = 32'h67800000; assign b = 32'h57000000;
    #10 assign a = 32'h67FFFFFF; assign b = 32'h577FFFFF;

    #10 $display("\n2**81 * 2**46:");
    #10 assign a = 32'h68000000; assign b = 32'h56800000;
    #10 assign a = 32'h687FFFFF; assign b = 32'h56FFFFFF;

    #10 $display("\n2**82 * 2**45:");
    #10 assign a = 32'h68800000; assign b = 32'h56000000;
    #10 assign a = 32'h68FFFFFF; assign b = 32'h567FFFFF;

    #10 $display("\n2**83 * 2**44:");
    #10 assign a = 32'h69000000; assign b = 32'h55800000;
    #10 assign a = 32'h697FFFFF; assign b = 32'h55FFFFFF;

    #10 $display("\n2**84 * 2**43:");
    #10 assign a = 32'h69800000; assign b = 32'h55000000;
    #10 assign a = 32'h69FFFFFF; assign b = 32'h557FFFFF;

    #10 $display("\n2**85 * 2**42:");
    #10 assign a = 32'h6A000000; assign b = 32'h54800000;
    #10 assign a = 32'h6A7FFFFF; assign b = 32'h54FFFFFF;

    #10 $display("\n2**86 * 2**41:");
    #10 assign a = 32'h6A800000; assign b = 32'h54000000;
    #10 assign a = 32'h6AFFFFFF; assign b = 32'h547FFFFF;

    #10 $display("\n2**87 * 2**40:");
    #10 assign a = 32'h6B000000; assign b = 32'h53800000;
    #10 assign a = 32'h6B7FFFFF; assign b = 32'h53FFFFFF;

    #10 $display("\n2**88 * 2**39:");
    #10 assign a = 32'h6B800000; assign b = 32'h53000000;
    #10 assign a = 32'h6BFFFFFF; assign b = 32'h537FFFFF;

    #10 $display("\n2**89 * 2**38:");
    #10 assign a = 32'h6C000000; assign b = 32'h52800000;
    #10 assign a = 32'h6C7FFFFF; assign b = 32'h52FFFFFF;

    #10 $display("\n2**90 * 2**37:");
    #10 assign a = 32'h6C800000; assign b = 32'h52000000;
    #10 assign a = 32'h6CFFFFFF; assign b = 32'h527FFFFF;

    #10 $display("\n2**91 * 2**36:");
    #10 assign a = 32'h6D000000; assign b = 32'h51800000;
    #10 assign a = 32'h6D7FFFFF; assign b = 32'h51FFFFFF;

    #10 $display("\n2**92 * 2**35:");
    #10 assign a = 32'h6D800000; assign b = 32'h51000000;
    #10 assign a = 32'h6DFFFFFF; assign b = 32'h517FFFFF;

    #10 $display("\n2**93 * 2**34:");
    #10 assign a = 32'h6E000000; assign b = 32'h50800000;
    #10 assign a = 32'h6E7FFFFF; assign b = 32'h50FFFFFF;

    #10 $display("\n2**94 * 2**33:");
    #10 assign a = 32'h6E800000; assign b = 32'h50000000;
    #10 assign a = 32'h6EFFFFFF; assign b = 32'h507FFFFF;

    #10 $display("\n2**95 * 2**32:");
    #10 assign a = 32'h6F000000; assign b = 32'h4F800000;
    #10 assign a = 32'h6F7FFFFF; assign b = 32'h4FFFFFFF;

    #10 $display("\n2**96 * 2**31:");
    #10 assign a = 32'h6F800000; assign b = 32'h4F000000;
    #10 assign a = 32'h6FFFFFFF; assign b = 32'h4F7FFFFF;

    #10 $display("\n2**97 * 2**30:");
    #10 assign a = 32'h70000000; assign b = 32'h4E800000;
    #10 assign a = 32'h707FFFFF; assign b = 32'h4EFFFFFF;

    #10 $display("\n2**98 * 2**29:");
    #10 assign a = 32'h70800000; assign b = 32'h4E000000;
    #10 assign a = 32'h70FFFFFF; assign b = 32'h4E7FFFFF;

    #10 $display("\n2**99 * 2**28:");
    #10 assign a = 32'h71000000; assign b = 32'h4D800000;
    #10 assign a = 32'h717FFFFF; assign b = 32'h4DFFFFFF;

    #10 $display("\n2**100 * 2**27:");
    #10 assign a = 32'h71800000; assign b = 32'h4D000000;
    #10 assign a = 32'h71FFFFFF; assign b = 32'h4D7FFFFF;

    #10 $display("\n2**101 * 2**26:");
    #10 assign a = 32'h72000000; assign b = 32'h4C800000;
    #10 assign a = 32'h727FFFFF; assign b = 32'h4CFFFFFF;

    #10 $display("\n2**102 * 2**25:");
    #10 assign a = 32'h72800000; assign b = 32'h4C000000;
    #10 assign a = 32'h72FFFFFF; assign b = 32'h4C7FFFFF;

    #10 $display("\n2**103 * 2**24:");
    #10 assign a = 32'h73000000; assign b = 32'h4B800000;
    #10 assign a = 32'h737FFFFF; assign b = 32'h4BFFFFFF;

    #10 $display("\n2**104 * 2**23:");
    #10 assign a = 32'h73800000; assign b = 32'h4B000000;
    #10 assign a = 32'h73FFFFFF; assign b = 32'h4B7FFFFF;

    #10 $display("\n2**105 * 2**22:");
    #10 assign a = 32'h74000000; assign b = 32'h4A800000;
    #10 assign a = 32'h747FFFFF; assign b = 32'h4AFFFFFF;

    #10 $display("\n2**106 * 2**21:");
    #10 assign a = 32'h74800000; assign b = 32'h4A000000;
    #10 assign a = 32'h74FFFFFF; assign b = 32'h4A7FFFFF;

    #10 $display("\n2**107 * 2**20:");
    #10 assign a = 32'h75000000; assign b = 32'h49800000;
    #10 assign a = 32'h757FFFFF; assign b = 32'h49FFFFFF;

    #10 $display("\n2**108 * 2**19:");
    #10 assign a = 32'h75800000; assign b = 32'h49000000;
    #10 assign a = 32'h75FFFFFF; assign b = 32'h497FFFFF;

    #10 $display("\n2**109 * 2**18:");
    #10 assign a = 32'h76000000; assign b = 32'h48800000;
    #10 assign a = 32'h767FFFFF; assign b = 32'h48FFFFFF;

    #10 $display("\n2**110 * 2**17:");
    #10 assign a = 32'h76800000; assign b = 32'h48000000;
    #10 assign a = 32'h76FFFFFF; assign b = 32'h487FFFFF;

    #10 $display("\n2**111 * 2**16:");
    #10 assign a = 32'h77000000; assign b = 32'h47800000;
    #10 assign a = 32'h777FFFFF; assign b = 32'h47FFFFFF;

    #10 $display("\n2**112 * 2**15:");
    #10 assign a = 32'h77800000; assign b = 32'h47000000;
    #10 assign a = 32'h77FFFFFF; assign b = 32'h477FFFFF;

    #10 $display("\n2**113 * 2**14:");
    #10 assign a = 32'h78000000; assign b = 32'h46800000;
    #10 assign a = 32'h787FFFFF; assign b = 32'h46FFFFFF;

    #10 $display("\n2**114 * 2**13:");
    #10 assign a = 32'h78800000; assign b = 32'h46000000;
    #10 assign a = 32'h78FFFFFF; assign b = 32'h467FFFFF;

    #10 $display("\n2**115 * 2**12:");
    #10 assign a = 32'h79000000; assign b = 32'h45800000;
    #10 assign a = 32'h797FFFFF; assign b = 32'h45FFFFFF;

    #10 $display("\n2**116 * 2**11:");
    #10 assign a = 32'h79800000; assign b = 32'h45000000;
    #10 assign a = 32'h79FFFFFF; assign b = 32'h457FFFFF;

    #10 $display("\n2**117 * 2**10:");
    #10 assign a = 32'h7A000000; assign b = 32'h44800000;
    #10 assign a = 32'h7A7FFFFF; assign b = 32'h44FFFFFF;

    #10 $display("\n2**118 * 2**9:");
    #10 assign a = 32'h7A800000; assign b = 32'h44000000;
    #10 assign a = 32'h7AFFFFFF; assign b = 32'h447FFFFF;

    #10 $display("\n2**119 * 2**8:");
    #10 assign a = 32'h7B000000; assign b = 32'h43800000;
    #10 assign a = 32'h7B7FFFFF; assign b = 32'h43FFFFFF;

    #10 $display("\n2**120 * 2**7:");
    #10 assign a = 32'h7B800000; assign b = 32'h43000000;
    #10 assign a = 32'h7BFFFFFF; assign b = 32'h437FFFFF;

    #10 $display("\n2**121 * 2**6:");
    #10 assign a = 32'h7C000000; assign b = 32'h42800000;
    #10 assign a = 32'h7C7FFFFF; assign b = 32'h42FFFFFF;

    #10 $display("\n2**122 * 2**5:");
    #10 assign a = 32'h7C800000; assign b = 32'h42000000;
    #10 assign a = 32'h7CFFFFFF; assign b = 32'h427FFFFF;

    #10 $display("\n2**123 * 2**4:");
    #10 assign a = 32'h7D000000; assign b = 32'h41800000;
    #10 assign a = 32'h7D7FFFFF; assign b = 32'h41FFFFFF;

    #10 $display("\n2**124 * 2**3:");
    #10 assign a = 32'h7D800000; assign b = 32'h41000000;
    #10 assign a = 32'h7DFFFFFF; assign b = 32'h417FFFFF;

    #10 $display("\n2**125 * 2**2:");
    #10 assign a = 32'h7E000000; assign b = 32'h40800000;
    #10 assign a = 32'h7E7FFFFF; assign b = 32'h40FFFFFF;

    #10 $display("\n2**126 * 2**1:");
    #10 assign a = 32'h7E800000; assign b = 32'h40000000;
    #10 assign a = 32'h7EFFFFFF; assign b = 32'h407FFFFF;

    #10 $display("\n2**127 * 2**0:");
    #10 assign a = 32'h7F000000; assign b = 32'h3F800000;
    #10 assign a = 32'h7F7FFFFF; assign b = 32'h3FFFFFFF;

    #10 $display("\n2**-149 * 2**22:");
    #10 assign a = 32'h00000001; assign b = 32'h4A800000;
    #10 assign a = 32'h00000001; assign b = 32'h4AFFFFFF;

    #10 $display("\n2**-148 * 2**21:");
    #10 assign a = 32'h00000002; assign b = 32'h4A000000;
    #10 assign a = 32'h00000003; assign b = 32'h4A7FFFFF;

    #10 $display("\n2**-147 * 2**20:");
    #10 assign a = 32'h00000004; assign b = 32'h49800000;
    #10 assign a = 32'h00000007; assign b = 32'h49FFFFFF;

    #10 $display("\n2**-146 * 2**19:");
    #10 assign a = 32'h00000008; assign b = 32'h49000000;
    #10 assign a = 32'h0000000F; assign b = 32'h497FFFFF;

    #10 $display("\n2**-145 * 2**18:");
    #10 assign a = 32'h00000010; assign b = 32'h48800000;
    #10 assign a = 32'h0000001F; assign b = 32'h48FFFFFF;

    #10 $display("\n2**-144 * 2**17:");
    #10 assign a = 32'h00000020; assign b = 32'h48000000;
    #10 assign a = 32'h0000003F; assign b = 32'h487FFFFF;

    #10 $display("\n2**-143 * 2**16:");
    #10 assign a = 32'h00000040; assign b = 32'h47800000;
    #10 assign a = 32'h0000007F; assign b = 32'h47FFFFFF;

    #10 $display("\n2**-142 * 2**15:");
    #10 assign a = 32'h00000080; assign b = 32'h47000000;
    #10 assign a = 32'h000000FF; assign b = 32'h477FFFFF;

    #10 $display("\n2**-141 * 2**14:");
    #10 assign a = 32'h00000100; assign b = 32'h46800000;
    #10 assign a = 32'h000001FF; assign b = 32'h46FFFFFF;

    #10 $display("\n2**-140 * 2**13:");
    #10 assign a = 32'h00000200; assign b = 32'h46000000;
    #10 assign a = 32'h000003FF; assign b = 32'h467FFFFF;

    #10 $display("\n2**-139 * 2**12:");
    #10 assign a = 32'h00000400; assign b = 32'h45800000;
    #10 assign a = 32'h000007FF; assign b = 32'h45FFFFFF;

    #10 $display("\n2**-138 * 2**11:");
    #10 assign a = 32'h00000800; assign b = 32'h45000000;
    #10 assign a = 32'h00000FFF; assign b = 32'h457FFFFF;

    #10 $display("\n2**-137 * 2**10:");
    #10 assign a = 32'h00001000; assign b = 32'h44800000;
    #10 assign a = 32'h00001FFF; assign b = 32'h44FFFFFF;

    #10 $display("\n2**-136 * 2**9:");
    #10 assign a = 32'h00002000; assign b = 32'h44000000;
    #10 assign a = 32'h00003FFF; assign b = 32'h447FFFFF;

    #10 $display("\n2**-135 * 2**8:");
    #10 assign a = 32'h00004000; assign b = 32'h43800000;
    #10 assign a = 32'h00007FFF; assign b = 32'h43FFFFFF;

    #10 $display("\n2**-134 * 2**7:");
    #10 assign a = 32'h00008000; assign b = 32'h43000000;
    #10 assign a = 32'h0000FFFF; assign b = 32'h437FFFFF;

    #10 $display("\n2**-133 * 2**6:");
    #10 assign a = 32'h00010000; assign b = 32'h42800000;
    #10 assign a = 32'h0001FFFF; assign b = 32'h42FFFFFF;

    #10 $display("\n2**-132 * 2**5:");
    #10 assign a = 32'h00020000; assign b = 32'h42000000;
    #10 assign a = 32'h0003FFFF; assign b = 32'h427FFFFF;

    #10 $display("\n2**-131 * 2**4:");
    #10 assign a = 32'h00040000; assign b = 32'h41800000;
    #10 assign a = 32'h0007FFFF; assign b = 32'h41FFFFFF;

    #10 $display("\n2**-130 * 2**3:");
    #10 assign a = 32'h00080000; assign b = 32'h41000000;
    #10 assign a = 32'h000FFFFF; assign b = 32'h417FFFFF;

    #10 $display("\n2**-129 * 2**2:");
    #10 assign a = 32'h00100000; assign b = 32'h40800000;
    #10 assign a = 32'h001FFFFF; assign b = 32'h40FFFFFF;

    #10 $display("\n2**-128 * 2**1:");
    #10 assign a = 32'h00200000; assign b = 32'h40000000;
    #10 assign a = 32'h003FFFFF; assign b = 32'h407FFFFF;

    #10 $display("\n2**-127 * 2**0:");
    #10 assign a = 32'h00400000; assign b = 32'h3F800000;
    #10 assign a = 32'h007FFFFF; assign b = 32'h3FFFFFFF;

    #10 $display("\n2**-126 * 2**-1:");
    #10 assign a = 32'h00800000; assign b = 32'h3F000000;
    #10 assign a = 32'h00FFFFFF; assign b = 32'h3F7FFFFF;

    #10 $display("\n2**-125 * 2**-2:");
    #10 assign a = 32'h01000000; assign b = 32'h3E800000;
    #10 assign a = 32'h017FFFFF; assign b = 32'h3EFFFFFF;

    #10 $display("\n2**-124 * 2**-3:");
    #10 assign a = 32'h01800000; assign b = 32'h3E000000;
    #10 assign a = 32'h01FFFFFF; assign b = 32'h3E7FFFFF;

    #10 $display("\n2**-123 * 2**-4:");
    #10 assign a = 32'h02000000; assign b = 32'h3D800000;
    #10 assign a = 32'h027FFFFF; assign b = 32'h3DFFFFFF;

    #10 $display("\n2**-122 * 2**-5:");
    #10 assign a = 32'h02800000; assign b = 32'h3D000000;
    #10 assign a = 32'h02FFFFFF; assign b = 32'h3D7FFFFF;

    #10 $display("\n2**-121 * 2**-6:");
    #10 assign a = 32'h03000000; assign b = 32'h3C800000;
    #10 assign a = 32'h037FFFFF; assign b = 32'h3CFFFFFF;

    #10 $display("\n2**-120 * 2**-7:");
    #10 assign a = 32'h03800000; assign b = 32'h3C000000;
    #10 assign a = 32'h03FFFFFF; assign b = 32'h3C7FFFFF;

    #10 $display("\n2**-119 * 2**-8:");
    #10 assign a = 32'h04000000; assign b = 32'h3B800000;
    #10 assign a = 32'h047FFFFF; assign b = 32'h3BFFFFFF;

    #10 $display("\n2**-118 * 2**-9:");
    #10 assign a = 32'h04800000; assign b = 32'h3B000000;
    #10 assign a = 32'h04FFFFFF; assign b = 32'h3B7FFFFF;

    #10 $display("\n2**-117 * 2**-10:");
    #10 assign a = 32'h05000000; assign b = 32'h3A800000;
    #10 assign a = 32'h057FFFFF; assign b = 32'h3AFFFFFF;

    #10 $display("\n2**-116 * 2**-11:");
    #10 assign a = 32'h05800000; assign b = 32'h3A000000;
    #10 assign a = 32'h05FFFFFF; assign b = 32'h3A7FFFFF;

    #10 $display("\n2**-115 * 2**-12:");
    #10 assign a = 32'h06000000; assign b = 32'h39800000;
    #10 assign a = 32'h067FFFFF; assign b = 32'h39FFFFFF;

    #10 $display("\n2**-114 * 2**-13:");
    #10 assign a = 32'h06800000; assign b = 32'h39000000;
    #10 assign a = 32'h06FFFFFF; assign b = 32'h397FFFFF;

    #10 $display("\n2**-113 * 2**-14:");
    #10 assign a = 32'h07000000; assign b = 32'h38800000;
    #10 assign a = 32'h077FFFFF; assign b = 32'h38FFFFFF;

    #10 $display("\n2**-112 * 2**-15:");
    #10 assign a = 32'h07800000; assign b = 32'h38000000;
    #10 assign a = 32'h07FFFFFF; assign b = 32'h387FFFFF;

    #10 $display("\n2**-111 * 2**-16:");
    #10 assign a = 32'h08000000; assign b = 32'h37800000;
    #10 assign a = 32'h087FFFFF; assign b = 32'h37FFFFFF;

    #10 $display("\n2**-110 * 2**-17:");
    #10 assign a = 32'h08800000; assign b = 32'h37000000;
    #10 assign a = 32'h08FFFFFF; assign b = 32'h377FFFFF;

    #10 $display("\n2**-109 * 2**-18:");
    #10 assign a = 32'h09000000; assign b = 32'h36800000;
    #10 assign a = 32'h097FFFFF; assign b = 32'h36FFFFFF;

    #10 $display("\n2**-108 * 2**-19:");
    #10 assign a = 32'h09800000; assign b = 32'h36000000;
    #10 assign a = 32'h09FFFFFF; assign b = 32'h367FFFFF;

    #10 $display("\n2**-107 * 2**-20:");
    #10 assign a = 32'h0A000000; assign b = 32'h35800000;
    #10 assign a = 32'h0A7FFFFF; assign b = 32'h35FFFFFF;

    #10 $display("\n2**-106 * 2**-21:");
    #10 assign a = 32'h0A800000; assign b = 32'h35000000;
    #10 assign a = 32'h0AFFFFFF; assign b = 32'h357FFFFF;

    #10 $display("\n2**-105 * 2**-22:");
    #10 assign a = 32'h0B000000; assign b = 32'h34800000;
    #10 assign a = 32'h0B7FFFFF; assign b = 32'h34FFFFFF;

    #10 $display("\n2**-104 * 2**-23:");
    #10 assign a = 32'h0B800000; assign b = 32'h34000000;
    #10 assign a = 32'h0BFFFFFF; assign b = 32'h347FFFFF;

    #10 $display("\n2**-103 * 2**-24:");
    #10 assign a = 32'h0C000000; assign b = 32'h33800000;
    #10 assign a = 32'h0C7FFFFF; assign b = 32'h33FFFFFF;

    #10 $display("\n2**-102 * 2**-25:");
    #10 assign a = 32'h0C800000; assign b = 32'h33000000;
    #10 assign a = 32'h0CFFFFFF; assign b = 32'h337FFFFF;

    #10 $display("\n2**-101 * 2**-26:");
    #10 assign a = 32'h0D000000; assign b = 32'h32800000;
    #10 assign a = 32'h0D7FFFFF; assign b = 32'h32FFFFFF;

    #10 $display("\n2**-100 * 2**-27:");
    #10 assign a = 32'h0D800000; assign b = 32'h32000000;
    #10 assign a = 32'h0DFFFFFF; assign b = 32'h327FFFFF;

    #10 $display("\n2**-99 * 2**-28:");
    #10 assign a = 32'h0E000000; assign b = 32'h31800000;
    #10 assign a = 32'h0E7FFFFF; assign b = 32'h31FFFFFF;

    #10 $display("\n2**-98 * 2**-29:");
    #10 assign a = 32'h0E800000; assign b = 32'h31000000;
    #10 assign a = 32'h0EFFFFFF; assign b = 32'h317FFFFF;

    #10 $display("\n2**-97 * 2**-30:");
    #10 assign a = 32'h0F000000; assign b = 32'h30800000;
    #10 assign a = 32'h0F7FFFFF; assign b = 32'h30FFFFFF;

    #10 $display("\n2**-96 * 2**-31:");
    #10 assign a = 32'h0F800000; assign b = 32'h30000000;
    #10 assign a = 32'h0FFFFFFF; assign b = 32'h307FFFFF;

    #10 $display("\n2**-95 * 2**-32:");
    #10 assign a = 32'h10000000; assign b = 32'h2F800000;
    #10 assign a = 32'h107FFFFF; assign b = 32'h2FFFFFFF;

    #10 $display("\n2**-94 * 2**-33:");
    #10 assign a = 32'h10800000; assign b = 32'h2F000000;
    #10 assign a = 32'h10FFFFFF; assign b = 32'h2F7FFFFF;

    #10 $display("\n2**-93 * 2**-34:");
    #10 assign a = 32'h11000000; assign b = 32'h2E800000;
    #10 assign a = 32'h117FFFFF; assign b = 32'h2EFFFFFF;

    #10 $display("\n2**-92 * 2**-35:");
    #10 assign a = 32'h11800000; assign b = 32'h2E000000;
    #10 assign a = 32'h11FFFFFF; assign b = 32'h2E7FFFFF;

    #10 $display("\n2**-91 * 2**-36:");
    #10 assign a = 32'h12000000; assign b = 32'h2D800000;
    #10 assign a = 32'h127FFFFF; assign b = 32'h2DFFFFFF;

    #10 $display("\n2**-90 * 2**-37:");
    #10 assign a = 32'h12800000; assign b = 32'h2D000000;
    #10 assign a = 32'h12FFFFFF; assign b = 32'h2D7FFFFF;

    #10 $display("\n2**-89 * 2**-38:");
    #10 assign a = 32'h13000000; assign b = 32'h2C800000;
    #10 assign a = 32'h137FFFFF; assign b = 32'h2CFFFFFF;

    #10 $display("\n2**-88 * 2**-39:");
    #10 assign a = 32'h13800000; assign b = 32'h2C000000;
    #10 assign a = 32'h13FFFFFF; assign b = 32'h2C7FFFFF;

    #10 $display("\n2**-87 * 2**-40:");
    #10 assign a = 32'h14000000; assign b = 32'h2B800000;
    #10 assign a = 32'h147FFFFF; assign b = 32'h2BFFFFFF;

    #10 $display("\n2**-86 * 2**-41:");
    #10 assign a = 32'h14800000; assign b = 32'h2B000000;
    #10 assign a = 32'h14FFFFFF; assign b = 32'h2B7FFFFF;

    #10 $display("\n2**-85 * 2**-42:");
    #10 assign a = 32'h15000000; assign b = 32'h2A800000;
    #10 assign a = 32'h157FFFFF; assign b = 32'h2AFFFFFF;

    #10 $display("\n2**-84 * 2**-43:");
    #10 assign a = 32'h15800000; assign b = 32'h2A000000;
    #10 assign a = 32'h15FFFFFF; assign b = 32'h2A7FFFFF;

    #10 $display("\n2**-83 * 2**-44:");
    #10 assign a = 32'h16000000; assign b = 32'h29800000;
    #10 assign a = 32'h167FFFFF; assign b = 32'h29FFFFFF;

    #10 $display("\n2**-82 * 2**-45:");
    #10 assign a = 32'h16800000; assign b = 32'h29000000;
    #10 assign a = 32'h16FFFFFF; assign b = 32'h297FFFFF;

    #10 $display("\n2**-81 * 2**-46:");
    #10 assign a = 32'h17000000; assign b = 32'h28800000;
    #10 assign a = 32'h177FFFFF; assign b = 32'h28FFFFFF;

    #10 $display("\n2**-80 * 2**-47:");
    #10 assign a = 32'h17800000; assign b = 32'h28000000;
    #10 assign a = 32'h17FFFFFF; assign b = 32'h287FFFFF;

    #10 $display("\n2**-79 * 2**-48:");
    #10 assign a = 32'h18000000; assign b = 32'h27800000;
    #10 assign a = 32'h187FFFFF; assign b = 32'h27FFFFFF;

    #10 $display("\n2**-78 * 2**-49:");
    #10 assign a = 32'h18800000; assign b = 32'h27000000;
    #10 assign a = 32'h18FFFFFF; assign b = 32'h277FFFFF;

    #10 $display("\n2**-77 * 2**-50:");
    #10 assign a = 32'h19000000; assign b = 32'h26800000;
    #10 assign a = 32'h197FFFFF; assign b = 32'h26FFFFFF;

    #10 $display("\n2**-76 * 2**-51:");
    #10 assign a = 32'h19800000; assign b = 32'h26000000;
    #10 assign a = 32'h19FFFFFF; assign b = 32'h267FFFFF;

    #10 $display("\n2**-75 * 2**-52:");
    #10 assign a = 32'h1A000000; assign b = 32'h25800000;
    #10 assign a = 32'h1A7FFFFF; assign b = 32'h25FFFFFF;

    #10 $display("\n2**-74 * 2**-53:");
    #10 assign a = 32'h1A800000; assign b = 32'h25000000;
    #10 assign a = 32'h1AFFFFFF; assign b = 32'h257FFFFF;

    #10 $display("\n2**-73 * 2**-54:");
    #10 assign a = 32'h1B000000; assign b = 32'h24800000;
    #10 assign a = 32'h1B7FFFFF; assign b = 32'h24FFFFFF;

    #10 $display("\n2**-72 * 2**-55:");
    #10 assign a = 32'h1B800000; assign b = 32'h24000000;
    #10 assign a = 32'h1BFFFFFF; assign b = 32'h247FFFFF;

    #10 $display("\n2**-71 * 2**-56:");
    #10 assign a = 32'h1C000000; assign b = 32'h23800000;
    #10 assign a = 32'h1C7FFFFF; assign b = 32'h23FFFFFF;

    #10 $display("\n2**-70 * 2**-57:");
    #10 assign a = 32'h1C800000; assign b = 32'h23000000;
    #10 assign a = 32'h1CFFFFFF; assign b = 32'h237FFFFF;

    #10 $display("\n2**-69 * 2**-58:");
    #10 assign a = 32'h1D000000; assign b = 32'h22800000;
    #10 assign a = 32'h1D7FFFFF; assign b = 32'h22FFFFFF;

    #10 $display("\n2**-68 * 2**-59:");
    #10 assign a = 32'h1D800000; assign b = 32'h22000000;
    #10 assign a = 32'h1DFFFFFF; assign b = 32'h227FFFFF;

    #10 $display("\n2**-67 * 2**-60:");
    #10 assign a = 32'h1E000000; assign b = 32'h21800000;
    #10 assign a = 32'h1E7FFFFF; assign b = 32'h21FFFFFF;

    #10 $display("\n2**-66 * 2**-61:");
    #10 assign a = 32'h1E800000; assign b = 32'h21000000;
    #10 assign a = 32'h1EFFFFFF; assign b = 32'h217FFFFF;

    #10 $display("\n2**-65 * 2**-62:");
    #10 assign a = 32'h1F000000; assign b = 32'h20800000;
    #10 assign a = 32'h1F7FFFFF; assign b = 32'h20FFFFFF;

    #10 $display("\n2**-64 * 2**-63:");
    #10 assign a = 32'h1F800000; assign b = 32'h20000000;
    #10 assign a = 32'h1FFFFFFF; assign b = 32'h207FFFFF;

    #10 $display("\n2**-63 * 2**-64:");
    #10 assign a = 32'h20000000; assign b = 32'h1F800000;
    #10 assign a = 32'h207FFFFF; assign b = 32'h1FFFFFFF;

    #10 $display("\n2**-62 * 2**-65:");
    #10 assign a = 32'h20800000; assign b = 32'h1F000000;
    #10 assign a = 32'h20FFFFFF; assign b = 32'h1F7FFFFF;

    #10 $display("\n2**-61 * 2**-66:");
    #10 assign a = 32'h21000000; assign b = 32'h1E800000;
    #10 assign a = 32'h217FFFFF; assign b = 32'h1EFFFFFF;

    #10 $display("\n2**-60 * 2**-67:");
    #10 assign a = 32'h21800000; assign b = 32'h1E000000;
    #10 assign a = 32'h21FFFFFF; assign b = 32'h1E7FFFFF;

    #10 $display("\n2**-59 * 2**-68:");
    #10 assign a = 32'h22000000; assign b = 32'h1D800000;
    #10 assign a = 32'h227FFFFF; assign b = 32'h1DFFFFFF;

    #10 $display("\n2**-58 * 2**-69:");
    #10 assign a = 32'h22800000; assign b = 32'h1D000000;
    #10 assign a = 32'h22FFFFFF; assign b = 32'h1D7FFFFF;

    #10 $display("\n2**-57 * 2**-70:");
    #10 assign a = 32'h23000000; assign b = 32'h1C800000;
    #10 assign a = 32'h237FFFFF; assign b = 32'h1CFFFFFF;

    #10 $display("\n2**-56 * 2**-71:");
    #10 assign a = 32'h23800000; assign b = 32'h1C000000;
    #10 assign a = 32'h23FFFFFF; assign b = 32'h1C7FFFFF;

    #10 $display("\n2**-55 * 2**-72:");
    #10 assign a = 32'h24000000; assign b = 32'h1B800000;
    #10 assign a = 32'h247FFFFF; assign b = 32'h1BFFFFFF;

    #10 $display("\n2**-54 * 2**-73:");
    #10 assign a = 32'h24800000; assign b = 32'h1B000000;
    #10 assign a = 32'h24FFFFFF; assign b = 32'h1B7FFFFF;

    #10 $display("\n2**-53 * 2**-74:");
    #10 assign a = 32'h25000000; assign b = 32'h1A800000;
    #10 assign a = 32'h257FFFFF; assign b = 32'h1AFFFFFF;

    #10 $display("\n2**-52 * 2**-75:");
    #10 assign a = 32'h25800000; assign b = 32'h1A000000;
    #10 assign a = 32'h25FFFFFF; assign b = 32'h1A7FFFFF;

    #10 $display("\n2**-51 * 2**-76:");
    #10 assign a = 32'h26000000; assign b = 32'h19800000;
    #10 assign a = 32'h267FFFFF; assign b = 32'h19FFFFFF;

    #10 $display("\n2**-50 * 2**-77:");
    #10 assign a = 32'h26800000; assign b = 32'h19000000;
    #10 assign a = 32'h26FFFFFF; assign b = 32'h197FFFFF;

    #10 $display("\n2**-49 * 2**-78:");
    #10 assign a = 32'h27000000; assign b = 32'h18800000;
    #10 assign a = 32'h277FFFFF; assign b = 32'h18FFFFFF;

    #10 $display("\n2**-48 * 2**-79:");
    #10 assign a = 32'h27800000; assign b = 32'h18000000;
    #10 assign a = 32'h27FFFFFF; assign b = 32'h187FFFFF;

    #10 $display("\n2**-47 * 2**-80:");
    #10 assign a = 32'h28000000; assign b = 32'h17800000;
    #10 assign a = 32'h287FFFFF; assign b = 32'h17FFFFFF;

    #10 $display("\n2**-46 * 2**-81:");
    #10 assign a = 32'h28800000; assign b = 32'h17000000;
    #10 assign a = 32'h28FFFFFF; assign b = 32'h177FFFFF;

    #10 $display("\n2**-45 * 2**-82:");
    #10 assign a = 32'h29000000; assign b = 32'h16800000;
    #10 assign a = 32'h297FFFFF; assign b = 32'h16FFFFFF;

    #10 $display("\n2**-44 * 2**-83:");
    #10 assign a = 32'h29800000; assign b = 32'h16000000;
    #10 assign a = 32'h29FFFFFF; assign b = 32'h167FFFFF;

    #10 $display("\n2**-43 * 2**-84:");
    #10 assign a = 32'h2A000000; assign b = 32'h15800000;
    #10 assign a = 32'h2A7FFFFF; assign b = 32'h15FFFFFF;

    #10 $display("\n2**-42 * 2**-85:");
    #10 assign a = 32'h2A800000; assign b = 32'h15000000;
    #10 assign a = 32'h2AFFFFFF; assign b = 32'h157FFFFF;

    #10 $display("\n2**-41 * 2**-86:");
    #10 assign a = 32'h2B000000; assign b = 32'h14800000;
    #10 assign a = 32'h2B7FFFFF; assign b = 32'h14FFFFFF;

    #10 $display("\n2**-40 * 2**-87:");
    #10 assign a = 32'h2B800000; assign b = 32'h14000000;
    #10 assign a = 32'h2BFFFFFF; assign b = 32'h147FFFFF;

    #10 $display("\n2**-39 * 2**-88:");
    #10 assign a = 32'h2C000000; assign b = 32'h13800000;
    #10 assign a = 32'h2C7FFFFF; assign b = 32'h13FFFFFF;

    #10 $display("\n2**-38 * 2**-89:");
    #10 assign a = 32'h2C800000; assign b = 32'h13000000;
    #10 assign a = 32'h2CFFFFFF; assign b = 32'h137FFFFF;

    #10 $display("\n2**-37 * 2**-90:");
    #10 assign a = 32'h2D000000; assign b = 32'h12800000;
    #10 assign a = 32'h2D7FFFFF; assign b = 32'h12FFFFFF;

    #10 $display("\n2**-36 * 2**-91:");
    #10 assign a = 32'h2D800000; assign b = 32'h12000000;
    #10 assign a = 32'h2DFFFFFF; assign b = 32'h127FFFFF;

    #10 $display("\n2**-35 * 2**-92:");
    #10 assign a = 32'h2E000000; assign b = 32'h11800000;
    #10 assign a = 32'h2E7FFFFF; assign b = 32'h11FFFFFF;

    #10 $display("\n2**-34 * 2**-93:");
    #10 assign a = 32'h2E800000; assign b = 32'h11000000;
    #10 assign a = 32'h2EFFFFFF; assign b = 32'h117FFFFF;

    #10 $display("\n2**-33 * 2**-94:");
    #10 assign a = 32'h2F000000; assign b = 32'h10800000;
    #10 assign a = 32'h2F7FFFFF; assign b = 32'h10FFFFFF;

    #10 $display("\n2**-32 * 2**-95:");
    #10 assign a = 32'h2F800000; assign b = 32'h10000000;
    #10 assign a = 32'h2FFFFFFF; assign b = 32'h107FFFFF;

    #10 $display("\n2**-31 * 2**-96:");
    #10 assign a = 32'h30000000; assign b = 32'h0F800000;
    #10 assign a = 32'h307FFFFF; assign b = 32'h0FFFFFFF;

    #10 $display("\n2**-30 * 2**-97:");
    #10 assign a = 32'h30800000; assign b = 32'h0F000000;
    #10 assign a = 32'h30FFFFFF; assign b = 32'h0F7FFFFF;

    #10 $display("\n2**-29 * 2**-98:");
    #10 assign a = 32'h31000000; assign b = 32'h0E800000;
    #10 assign a = 32'h317FFFFF; assign b = 32'h0EFFFFFF;

    #10 $display("\n2**-28 * 2**-99:");
    #10 assign a = 32'h31800000; assign b = 32'h0E000000;
    #10 assign a = 32'h31FFFFFF; assign b = 32'h0E7FFFFF;

    #10 $display("\n2**-27 * 2**-100:");
    #10 assign a = 32'h32000000; assign b = 32'h0D800000;
    #10 assign a = 32'h327FFFFF; assign b = 32'h0DFFFFFF;

    #10 $display("\n2**-26 * 2**-101:");
    #10 assign a = 32'h32800000; assign b = 32'h0D000000;
    #10 assign a = 32'h32FFFFFF; assign b = 32'h0D7FFFFF;

    #10 $display("\n2**-25 * 2**-102:");
    #10 assign a = 32'h33000000; assign b = 32'h0C800000;
    #10 assign a = 32'h337FFFFF; assign b = 32'h0CFFFFFF;

    #10 $display("\n2**-24 * 2**-103:");
    #10 assign a = 32'h33800000; assign b = 32'h0C000000;
    #10 assign a = 32'h33FFFFFF; assign b = 32'h0C7FFFFF;

    #10 $display("\n2**-23 * 2**-104:");
    #10 assign a = 32'h34000000; assign b = 32'h0B800000;
    #10 assign a = 32'h347FFFFF; assign b = 32'h0BFFFFFF;

    #10 $display("\n2**-22 * 2**-105:");
    #10 assign a = 32'h34800000; assign b = 32'h0B000000;
    #10 assign a = 32'h34FFFFFF; assign b = 32'h0B7FFFFF;

    #10 $display("\n2**-21 * 2**-106:");
    #10 assign a = 32'h35000000; assign b = 32'h0A800000;
    #10 assign a = 32'h357FFFFF; assign b = 32'h0AFFFFFF;

    #10 $display("\n2**-20 * 2**-107:");
    #10 assign a = 32'h35800000; assign b = 32'h0A000000;
    #10 assign a = 32'h35FFFFFF; assign b = 32'h0A7FFFFF;

    #10 $display("\n2**-19 * 2**-108:");
    #10 assign a = 32'h36000000; assign b = 32'h09800000;
    #10 assign a = 32'h367FFFFF; assign b = 32'h09FFFFFF;

    #10 $display("\n2**-18 * 2**-109:");
    #10 assign a = 32'h36800000; assign b = 32'h09000000;
    #10 assign a = 32'h36FFFFFF; assign b = 32'h097FFFFF;

    #10 $display("\n2**-17 * 2**-110:");
    #10 assign a = 32'h37000000; assign b = 32'h08800000;
    #10 assign a = 32'h377FFFFF; assign b = 32'h08FFFFFF;

    #10 $display("\n2**-16 * 2**-111:");
    #10 assign a = 32'h37800000; assign b = 32'h08000000;
    #10 assign a = 32'h37FFFFFF; assign b = 32'h087FFFFF;

    #10 $display("\n2**-15 * 2**-112:");
    #10 assign a = 32'h38000000; assign b = 32'h07800000;
    #10 assign a = 32'h387FFFFF; assign b = 32'h07FFFFFF;

    #10 $display("\n2**-14 * 2**-113:");
    #10 assign a = 32'h38800000; assign b = 32'h07000000;
    #10 assign a = 32'h38FFFFFF; assign b = 32'h077FFFFF;

    #10 $display("\n2**-13 * 2**-114:");
    #10 assign a = 32'h39000000; assign b = 32'h06800000;
    #10 assign a = 32'h397FFFFF; assign b = 32'h06FFFFFF;

    #10 $display("\n2**-12 * 2**-115:");
    #10 assign a = 32'h39800000; assign b = 32'h06000000;
    #10 assign a = 32'h39FFFFFF; assign b = 32'h067FFFFF;

    #10 $display("\n2**-11 * 2**-116:");
    #10 assign a = 32'h3A000000; assign b = 32'h05800000;
    #10 assign a = 32'h3A7FFFFF; assign b = 32'h05FFFFFF;

    #10 $display("\n2**-10 * 2**-117:");
    #10 assign a = 32'h3A800000; assign b = 32'h05000000;
    #10 assign a = 32'h3AFFFFFF; assign b = 32'h057FFFFF;

    #10 $display("\n2**-9 * 2**-118:");
    #10 assign a = 32'h3B000000; assign b = 32'h04800000;
    #10 assign a = 32'h3B7FFFFF; assign b = 32'h04FFFFFF;

    #10 $display("\n2**-8 * 2**-119:");
    #10 assign a = 32'h3B800000; assign b = 32'h04000000;
    #10 assign a = 32'h3BFFFFFF; assign b = 32'h047FFFFF;

    #10 $display("\n2**-7 * 2**-120:");
    #10 assign a = 32'h3C000000; assign b = 32'h03800000;
    #10 assign a = 32'h3C7FFFFF; assign b = 32'h03FFFFFF;

    #10 $display("\n2**-6 * 2**-121:");
    #10 assign a = 32'h3C800000; assign b = 32'h03000000;
    #10 assign a = 32'h3CFFFFFF; assign b = 32'h037FFFFF;

    #10 $display("\n2**-5 * 2**-122:");
    #10 assign a = 32'h3D000000; assign b = 32'h02800000;
    #10 assign a = 32'h3D7FFFFF; assign b = 32'h02FFFFFF;

    #10 $display("\n2**-4 * 2**-123:");
    #10 assign a = 32'h3D800000; assign b = 32'h02000000;
    #10 assign a = 32'h3DFFFFFF; assign b = 32'h027FFFFF;

    #10 $display("\n2**-3 * 2**-124:");
    #10 assign a = 32'h3E000000; assign b = 32'h01800000;
    #10 assign a = 32'h3E7FFFFF; assign b = 32'h01FFFFFF;

    #10 $display("\n2**-2 * 2**-125:");
    #10 assign a = 32'h3E800000; assign b = 32'h01000000;
    #10 assign a = 32'h3EFFFFFF; assign b = 32'h017FFFFF;

    #10 $display("\n2**-1 * 2**-126:");
    #10 assign a = 32'h3F000000; assign b = 32'h00800000;
    #10 assign a = 32'h3F7FFFFF; assign b = 32'h00FFFFFF;

    #10 $display("\n2**0 * 2**-127:");
    #10 assign a = 32'h3F800000; assign b = 32'h00400000;
    #10 assign a = 32'h3FFFFFFF; assign b = 32'h007FFFFF;

    #10 $display("\n2**1 * 2**-128:");
    #10 assign a = 32'h40000000; assign b = 32'h00200000;
    #10 assign a = 32'h407FFFFF; assign b = 32'h003FFFFF;

    #10 $display("\n2**2 * 2**-129:");
    #10 assign a = 32'h40800000; assign b = 32'h00100000;
    #10 assign a = 32'h40FFFFFF; assign b = 32'h001FFFFF;

    #10 $display("\n2**3 * 2**-130:");
    #10 assign a = 32'h41000000; assign b = 32'h00080000;
    #10 assign a = 32'h417FFFFF; assign b = 32'h000FFFFF;

    #10 $display("\n2**4 * 2**-131:");
    #10 assign a = 32'h41800000; assign b = 32'h00040000;
    #10 assign a = 32'h41FFFFFF; assign b = 32'h0007FFFF;

    #10 $display("\n2**5 * 2**-132:");
    #10 assign a = 32'h42000000; assign b = 32'h00020000;
    #10 assign a = 32'h427FFFFF; assign b = 32'h0003FFFF;

    #10 $display("\n2**6 * 2**-133:");
    #10 assign a = 32'h42800000; assign b = 32'h00010000;
    #10 assign a = 32'h42FFFFFF; assign b = 32'h0001FFFF;

    #10 $display("\n2**7 * 2**-134:");
    #10 assign a = 32'h43000000; assign b = 32'h00008000;
    #10 assign a = 32'h437FFFFF; assign b = 32'h0000FFFF;

    #10 $display("\n2**8 * 2**-135:");
    #10 assign a = 32'h43800000; assign b = 32'h00004000;
    #10 assign a = 32'h43FFFFFF; assign b = 32'h00007FFF;

    #10 $display("\n2**9 * 2**-136:");
    #10 assign a = 32'h44000000; assign b = 32'h00002000;
    #10 assign a = 32'h447FFFFF; assign b = 32'h00003FFF;

    #10 $display("\n2**10 * 2**-137:");
    #10 assign a = 32'h44800000; assign b = 32'h00001000;
    #10 assign a = 32'h44FFFFFF; assign b = 32'h00001FFF;

    #10 $display("\n2**11 * 2**-138:");
    #10 assign a = 32'h45000000; assign b = 32'h00000800;
    #10 assign a = 32'h457FFFFF; assign b = 32'h00000FFF;

    #10 $display("\n2**12 * 2**-139:");
    #10 assign a = 32'h45800000; assign b = 32'h00000400;
    #10 assign a = 32'h45FFFFFF; assign b = 32'h000007FF;

    #10 $display("\n2**13 * 2**-140:");
    #10 assign a = 32'h46000000; assign b = 32'h00000200;
    #10 assign a = 32'h467FFFFF; assign b = 32'h000003FF;

    #10 $display("\n2**14 * 2**-141:");
    #10 assign a = 32'h46800000; assign b = 32'h00000100;
    #10 assign a = 32'h46FFFFFF; assign b = 32'h000001FF;

    #10 $display("\n2**15 * 2**-142:");
    #10 assign a = 32'h47000000; assign b = 32'h00000080;
    #10 assign a = 32'h477FFFFF; assign b = 32'h000000FF;

    #10 $display("\n2**16 * 2**-143:");
    #10 assign a = 32'h47800000; assign b = 32'h00000040;
    #10 assign a = 32'h47FFFFFF; assign b = 32'h0000007F;

    #10 $display("\n2**17 * 2**-144:");
    #10 assign a = 32'h48000000; assign b = 32'h00000020;
    #10 assign a = 32'h487FFFFF; assign b = 32'h0000003F;

    #10 $display("\n2**18 * 2**-145:");
    #10 assign a = 32'h48800000; assign b = 32'h00000010;
    #10 assign a = 32'h48FFFFFF; assign b = 32'h0000001F;

    #10 $display("\n2**19 * 2**-146:");
    #10 assign a = 32'h49000000; assign b = 32'h00000008;
    #10 assign a = 32'h497FFFFF; assign b = 32'h0000000F;

    #10 $display("\n2**20 * 2**-147:");
    #10 assign a = 32'h49800000; assign b = 32'h00000004;
    #10 assign a = 32'h49FFFFFF; assign b = 32'h00000007;

    #10 $display("\n2**21 * 2**-148:");
    #10 assign a = 32'h4A000000; assign b = 32'h00000002;
    #10 assign a = 32'h4A7FFFFF; assign b = 32'h00000003;

    #10 $display("\n2**22 * 2**-149:");
    #10 assign a = 32'h4A800000; assign b = 32'h00000001;
    #10 assign a = 32'h4AFFFFFF; assign b = 32'h00000001;

    #10 $display("\n2**-149 * 2**-1:");
    #10 assign a = 32'h00000001; assign b = 32'h3F000000;
    #10 assign a = 32'h00000001; assign b = 32'h3F7FFFFF;

    #10 $display("\n2**-148 * 2**-2:");
    #10 assign a = 32'h00000002; assign b = 32'h3E800000;
    #10 assign a = 32'h00000003; assign b = 32'h3EFFFFFF;

    #10 $display("\n2**-147 * 2**-3:");
    #10 assign a = 32'h00000004; assign b = 32'h3E000000;
    #10 assign a = 32'h00000007; assign b = 32'h3E7FFFFF;

    #10 $display("\n2**-146 * 2**-4:");
    #10 assign a = 32'h00000008; assign b = 32'h3D800000;
    #10 assign a = 32'h0000000F; assign b = 32'h3DFFFFFF;

    #10 $display("\n2**-145 * 2**-5:");
    #10 assign a = 32'h00000010; assign b = 32'h3D000000;
    #10 assign a = 32'h0000001F; assign b = 32'h3D7FFFFF;

    #10 $display("\n2**-144 * 2**-6:");
    #10 assign a = 32'h00000020; assign b = 32'h3C800000;
    #10 assign a = 32'h0000003F; assign b = 32'h3CFFFFFF;

    #10 $display("\n2**-143 * 2**-7:");
    #10 assign a = 32'h00000040; assign b = 32'h3C000000;
    #10 assign a = 32'h0000007F; assign b = 32'h3C7FFFFF;

    #10 $display("\n2**-142 * 2**-8:");
    #10 assign a = 32'h00000080; assign b = 32'h3B800000;
    #10 assign a = 32'h000000FF; assign b = 32'h3BFFFFFF;

    #10 $display("\n2**-141 * 2**-9:");
    #10 assign a = 32'h00000100; assign b = 32'h3B000000;
    #10 assign a = 32'h000001FF; assign b = 32'h3B7FFFFF;

    #10 $display("\n2**-140 * 2**-10:");
    #10 assign a = 32'h00000200; assign b = 32'h3A800000;
    #10 assign a = 32'h000003FF; assign b = 32'h3AFFFFFF;

    #10 $display("\n2**-139 * 2**-11:");
    #10 assign a = 32'h00000400; assign b = 32'h3A000000;
    #10 assign a = 32'h000007FF; assign b = 32'h3A7FFFFF;

    #10 $display("\n2**-138 * 2**-12:");
    #10 assign a = 32'h00000800; assign b = 32'h39800000;
    #10 assign a = 32'h00000FFF; assign b = 32'h39FFFFFF;

    #10 $display("\n2**-137 * 2**-13:");
    #10 assign a = 32'h00001000; assign b = 32'h39000000;
    #10 assign a = 32'h00001FFF; assign b = 32'h397FFFFF;

    #10 $display("\n2**-136 * 2**-14:");
    #10 assign a = 32'h00002000; assign b = 32'h38800000;
    #10 assign a = 32'h00003FFF; assign b = 32'h38FFFFFF;

    #10 $display("\n2**-135 * 2**-15:");
    #10 assign a = 32'h00004000; assign b = 32'h38000000;
    #10 assign a = 32'h00007FFF; assign b = 32'h387FFFFF;

    #10 $display("\n2**-134 * 2**-16:");
    #10 assign a = 32'h00008000; assign b = 32'h37800000;
    #10 assign a = 32'h0000FFFF; assign b = 32'h37FFFFFF;

    #10 $display("\n2**-133 * 2**-17:");
    #10 assign a = 32'h00010000; assign b = 32'h37000000;
    #10 assign a = 32'h0001FFFF; assign b = 32'h377FFFFF;

    #10 $display("\n2**-132 * 2**-18:");
    #10 assign a = 32'h00020000; assign b = 32'h36800000;
    #10 assign a = 32'h0003FFFF; assign b = 32'h36FFFFFF;

    #10 $display("\n2**-131 * 2**-19:");
    #10 assign a = 32'h00040000; assign b = 32'h36000000;
    #10 assign a = 32'h0007FFFF; assign b = 32'h367FFFFF;

    #10 $display("\n2**-130 * 2**-20:");
    #10 assign a = 32'h00080000; assign b = 32'h35800000;
    #10 assign a = 32'h000FFFFF; assign b = 32'h35FFFFFF;

    #10 $display("\n2**-129 * 2**-21:");
    #10 assign a = 32'h00100000; assign b = 32'h35000000;
    #10 assign a = 32'h001FFFFF; assign b = 32'h357FFFFF;

    #10 $display("\n2**-128 * 2**-22:");
    #10 assign a = 32'h00200000; assign b = 32'h34800000;
    #10 assign a = 32'h003FFFFF; assign b = 32'h34FFFFFF;

    #10 $display("\n2**-127 * 2**-23:");
    #10 assign a = 32'h00400000; assign b = 32'h34000000;
    #10 assign a = 32'h007FFFFF; assign b = 32'h347FFFFF;

    #10 $display("\n2**-126 * 2**-24:");
    #10 assign a = 32'h00800000; assign b = 32'h33800000;
    #10 assign a = 32'h00FFFFFF; assign b = 32'h33FFFFFF;

    #10 $display("\n2**-125 * 2**-25:");
    #10 assign a = 32'h01000000; assign b = 32'h33000000;
    #10 assign a = 32'h017FFFFF; assign b = 32'h337FFFFF;

    #10 $display("\n2**-124 * 2**-26:");
    #10 assign a = 32'h01800000; assign b = 32'h32800000;
    #10 assign a = 32'h01FFFFFF; assign b = 32'h32FFFFFF;

    #10 $display("\n2**-123 * 2**-27:");
    #10 assign a = 32'h02000000; assign b = 32'h32000000;
    #10 assign a = 32'h027FFFFF; assign b = 32'h327FFFFF;

    #10 $display("\n2**-122 * 2**-28:");
    #10 assign a = 32'h02800000; assign b = 32'h31800000;
    #10 assign a = 32'h02FFFFFF; assign b = 32'h31FFFFFF;

    #10 $display("\n2**-121 * 2**-29:");
    #10 assign a = 32'h03000000; assign b = 32'h31000000;
    #10 assign a = 32'h037FFFFF; assign b = 32'h317FFFFF;

    #10 $display("\n2**-120 * 2**-30:");
    #10 assign a = 32'h03800000; assign b = 32'h30800000;
    #10 assign a = 32'h03FFFFFF; assign b = 32'h30FFFFFF;

    #10 $display("\n2**-119 * 2**-31:");
    #10 assign a = 32'h04000000; assign b = 32'h30000000;
    #10 assign a = 32'h047FFFFF; assign b = 32'h307FFFFF;

    #10 $display("\n2**-118 * 2**-32:");
    #10 assign a = 32'h04800000; assign b = 32'h2F800000;
    #10 assign a = 32'h04FFFFFF; assign b = 32'h2FFFFFFF;

    #10 $display("\n2**-117 * 2**-33:");
    #10 assign a = 32'h05000000; assign b = 32'h2F000000;
    #10 assign a = 32'h057FFFFF; assign b = 32'h2F7FFFFF;

    #10 $display("\n2**-116 * 2**-34:");
    #10 assign a = 32'h05800000; assign b = 32'h2E800000;
    #10 assign a = 32'h05FFFFFF; assign b = 32'h2EFFFFFF;

    #10 $display("\n2**-115 * 2**-35:");
    #10 assign a = 32'h06000000; assign b = 32'h2E000000;
    #10 assign a = 32'h067FFFFF; assign b = 32'h2E7FFFFF;

    #10 $display("\n2**-114 * 2**-36:");
    #10 assign a = 32'h06800000; assign b = 32'h2D800000;
    #10 assign a = 32'h06FFFFFF; assign b = 32'h2DFFFFFF;

    #10 $display("\n2**-113 * 2**-37:");
    #10 assign a = 32'h07000000; assign b = 32'h2D000000;
    #10 assign a = 32'h077FFFFF; assign b = 32'h2D7FFFFF;

    #10 $display("\n2**-112 * 2**-38:");
    #10 assign a = 32'h07800000; assign b = 32'h2C800000;
    #10 assign a = 32'h07FFFFFF; assign b = 32'h2CFFFFFF;

    #10 $display("\n2**-111 * 2**-39:");
    #10 assign a = 32'h08000000; assign b = 32'h2C000000;
    #10 assign a = 32'h087FFFFF; assign b = 32'h2C7FFFFF;

    #10 $display("\n2**-110 * 2**-40:");
    #10 assign a = 32'h08800000; assign b = 32'h2B800000;
    #10 assign a = 32'h08FFFFFF; assign b = 32'h2BFFFFFF;

    #10 $display("\n2**-109 * 2**-41:");
    #10 assign a = 32'h09000000; assign b = 32'h2B000000;
    #10 assign a = 32'h097FFFFF; assign b = 32'h2B7FFFFF;

    #10 $display("\n2**-108 * 2**-42:");
    #10 assign a = 32'h09800000; assign b = 32'h2A800000;
    #10 assign a = 32'h09FFFFFF; assign b = 32'h2AFFFFFF;

    #10 $display("\n2**-107 * 2**-43:");
    #10 assign a = 32'h0A000000; assign b = 32'h2A000000;
    #10 assign a = 32'h0A7FFFFF; assign b = 32'h2A7FFFFF;

    #10 $display("\n2**-106 * 2**-44:");
    #10 assign a = 32'h0A800000; assign b = 32'h29800000;
    #10 assign a = 32'h0AFFFFFF; assign b = 32'h29FFFFFF;

    #10 $display("\n2**-105 * 2**-45:");
    #10 assign a = 32'h0B000000; assign b = 32'h29000000;
    #10 assign a = 32'h0B7FFFFF; assign b = 32'h297FFFFF;

    #10 $display("\n2**-104 * 2**-46:");
    #10 assign a = 32'h0B800000; assign b = 32'h28800000;
    #10 assign a = 32'h0BFFFFFF; assign b = 32'h28FFFFFF;

    #10 $display("\n2**-103 * 2**-47:");
    #10 assign a = 32'h0C000000; assign b = 32'h28000000;
    #10 assign a = 32'h0C7FFFFF; assign b = 32'h287FFFFF;

    #10 $display("\n2**-102 * 2**-48:");
    #10 assign a = 32'h0C800000; assign b = 32'h27800000;
    #10 assign a = 32'h0CFFFFFF; assign b = 32'h27FFFFFF;

    #10 $display("\n2**-101 * 2**-49:");
    #10 assign a = 32'h0D000000; assign b = 32'h27000000;
    #10 assign a = 32'h0D7FFFFF; assign b = 32'h277FFFFF;

    #10 $display("\n2**-100 * 2**-50:");
    #10 assign a = 32'h0D800000; assign b = 32'h26800000;
    #10 assign a = 32'h0DFFFFFF; assign b = 32'h26FFFFFF;

    #10 $display("\n2**-99 * 2**-51:");
    #10 assign a = 32'h0E000000; assign b = 32'h26000000;
    #10 assign a = 32'h0E7FFFFF; assign b = 32'h267FFFFF;

    #10 $display("\n2**-98 * 2**-52:");
    #10 assign a = 32'h0E800000; assign b = 32'h25800000;
    #10 assign a = 32'h0EFFFFFF; assign b = 32'h25FFFFFF;

    #10 $display("\n2**-97 * 2**-53:");
    #10 assign a = 32'h0F000000; assign b = 32'h25000000;
    #10 assign a = 32'h0F7FFFFF; assign b = 32'h257FFFFF;

    #10 $display("\n2**-96 * 2**-54:");
    #10 assign a = 32'h0F800000; assign b = 32'h24800000;
    #10 assign a = 32'h0FFFFFFF; assign b = 32'h24FFFFFF;

    #10 $display("\n2**-95 * 2**-55:");
    #10 assign a = 32'h10000000; assign b = 32'h24000000;
    #10 assign a = 32'h107FFFFF; assign b = 32'h247FFFFF;

    #10 $display("\n2**-94 * 2**-56:");
    #10 assign a = 32'h10800000; assign b = 32'h23800000;
    #10 assign a = 32'h10FFFFFF; assign b = 32'h23FFFFFF;

    #10 $display("\n2**-93 * 2**-57:");
    #10 assign a = 32'h11000000; assign b = 32'h23000000;
    #10 assign a = 32'h117FFFFF; assign b = 32'h237FFFFF;

    #10 $display("\n2**-92 * 2**-58:");
    #10 assign a = 32'h11800000; assign b = 32'h22800000;
    #10 assign a = 32'h11FFFFFF; assign b = 32'h22FFFFFF;

    #10 $display("\n2**-91 * 2**-59:");
    #10 assign a = 32'h12000000; assign b = 32'h22000000;
    #10 assign a = 32'h127FFFFF; assign b = 32'h227FFFFF;

    #10 $display("\n2**-90 * 2**-60:");
    #10 assign a = 32'h12800000; assign b = 32'h21800000;
    #10 assign a = 32'h12FFFFFF; assign b = 32'h21FFFFFF;

    #10 $display("\n2**-89 * 2**-61:");
    #10 assign a = 32'h13000000; assign b = 32'h21000000;
    #10 assign a = 32'h137FFFFF; assign b = 32'h217FFFFF;

    #10 $display("\n2**-88 * 2**-62:");
    #10 assign a = 32'h13800000; assign b = 32'h20800000;
    #10 assign a = 32'h13FFFFFF; assign b = 32'h20FFFFFF;

    #10 $display("\n2**-87 * 2**-63:");
    #10 assign a = 32'h14000000; assign b = 32'h20000000;
    #10 assign a = 32'h147FFFFF; assign b = 32'h207FFFFF;

    #10 $display("\n2**-86 * 2**-64:");
    #10 assign a = 32'h14800000; assign b = 32'h1F800000;
    #10 assign a = 32'h14FFFFFF; assign b = 32'h1FFFFFFF;

    #10 $display("\n2**-85 * 2**-65:");
    #10 assign a = 32'h15000000; assign b = 32'h1F000000;
    #10 assign a = 32'h157FFFFF; assign b = 32'h1F7FFFFF;

    #10 $display("\n2**-84 * 2**-66:");
    #10 assign a = 32'h15800000; assign b = 32'h1E800000;
    #10 assign a = 32'h15FFFFFF; assign b = 32'h1EFFFFFF;

    #10 $display("\n2**-83 * 2**-67:");
    #10 assign a = 32'h16000000; assign b = 32'h1E000000;
    #10 assign a = 32'h167FFFFF; assign b = 32'h1E7FFFFF;

    #10 $display("\n2**-82 * 2**-68:");
    #10 assign a = 32'h16800000; assign b = 32'h1D800000;
    #10 assign a = 32'h16FFFFFF; assign b = 32'h1DFFFFFF;

    #10 $display("\n2**-81 * 2**-69:");
    #10 assign a = 32'h17000000; assign b = 32'h1D000000;
    #10 assign a = 32'h177FFFFF; assign b = 32'h1D7FFFFF;

    #10 $display("\n2**-80 * 2**-70:");
    #10 assign a = 32'h17800000; assign b = 32'h1C800000;
    #10 assign a = 32'h17FFFFFF; assign b = 32'h1CFFFFFF;

    #10 $display("\n2**-79 * 2**-71:");
    #10 assign a = 32'h18000000; assign b = 32'h1C000000;
    #10 assign a = 32'h187FFFFF; assign b = 32'h1C7FFFFF;

    #10 $display("\n2**-78 * 2**-72:");
    #10 assign a = 32'h18800000; assign b = 32'h1B800000;
    #10 assign a = 32'h18FFFFFF; assign b = 32'h1BFFFFFF;

    #10 $display("\n2**-77 * 2**-73:");
    #10 assign a = 32'h19000000; assign b = 32'h1B000000;
    #10 assign a = 32'h197FFFFF; assign b = 32'h1B7FFFFF;

    #10 $display("\n2**-76 * 2**-74:");
    #10 assign a = 32'h19800000; assign b = 32'h1A800000;
    #10 assign a = 32'h19FFFFFF; assign b = 32'h1AFFFFFF;

    #10 $display("\n2**-75 * 2**-75:");
    #10 assign a = 32'h1A000000; assign b = 32'h1A000000;
    #10 assign a = 32'h1A7FFFFF; assign b = 32'h1A7FFFFF;

    #10 $display("\n2**-74 * 2**-76:");
    #10 assign a = 32'h1A800000; assign b = 32'h19800000;
    #10 assign a = 32'h1AFFFFFF; assign b = 32'h19FFFFFF;

    #10 $display("\n2**-73 * 2**-77:");
    #10 assign a = 32'h1B000000; assign b = 32'h19000000;
    #10 assign a = 32'h1B7FFFFF; assign b = 32'h197FFFFF;

    #10 $display("\n2**-72 * 2**-78:");
    #10 assign a = 32'h1B800000; assign b = 32'h18800000;
    #10 assign a = 32'h1BFFFFFF; assign b = 32'h18FFFFFF;

    #10 $display("\n2**-71 * 2**-79:");
    #10 assign a = 32'h1C000000; assign b = 32'h18000000;
    #10 assign a = 32'h1C7FFFFF; assign b = 32'h187FFFFF;

    #10 $display("\n2**-70 * 2**-80:");
    #10 assign a = 32'h1C800000; assign b = 32'h17800000;
    #10 assign a = 32'h1CFFFFFF; assign b = 32'h17FFFFFF;

    #10 $display("\n2**-69 * 2**-81:");
    #10 assign a = 32'h1D000000; assign b = 32'h17000000;
    #10 assign a = 32'h1D7FFFFF; assign b = 32'h177FFFFF;

    #10 $display("\n2**-68 * 2**-82:");
    #10 assign a = 32'h1D800000; assign b = 32'h16800000;
    #10 assign a = 32'h1DFFFFFF; assign b = 32'h16FFFFFF;

    #10 $display("\n2**-67 * 2**-83:");
    #10 assign a = 32'h1E000000; assign b = 32'h16000000;
    #10 assign a = 32'h1E7FFFFF; assign b = 32'h167FFFFF;

    #10 $display("\n2**-66 * 2**-84:");
    #10 assign a = 32'h1E800000; assign b = 32'h15800000;
    #10 assign a = 32'h1EFFFFFF; assign b = 32'h15FFFFFF;

    #10 $display("\n2**-65 * 2**-85:");
    #10 assign a = 32'h1F000000; assign b = 32'h15000000;
    #10 assign a = 32'h1F7FFFFF; assign b = 32'h157FFFFF;

    #10 $display("\n2**-64 * 2**-86:");
    #10 assign a = 32'h1F800000; assign b = 32'h14800000;
    #10 assign a = 32'h1FFFFFFF; assign b = 32'h14FFFFFF;

    #10 $display("\n2**-63 * 2**-87:");
    #10 assign a = 32'h20000000; assign b = 32'h14000000;
    #10 assign a = 32'h207FFFFF; assign b = 32'h147FFFFF;

    #10 $display("\n2**-62 * 2**-88:");
    #10 assign a = 32'h20800000; assign b = 32'h13800000;
    #10 assign a = 32'h20FFFFFF; assign b = 32'h13FFFFFF;

    #10 $display("\n2**-61 * 2**-89:");
    #10 assign a = 32'h21000000; assign b = 32'h13000000;
    #10 assign a = 32'h217FFFFF; assign b = 32'h137FFFFF;

    #10 $display("\n2**-60 * 2**-90:");
    #10 assign a = 32'h21800000; assign b = 32'h12800000;
    #10 assign a = 32'h21FFFFFF; assign b = 32'h12FFFFFF;

    #10 $display("\n2**-59 * 2**-91:");
    #10 assign a = 32'h22000000; assign b = 32'h12000000;
    #10 assign a = 32'h227FFFFF; assign b = 32'h127FFFFF;

    #10 $display("\n2**-58 * 2**-92:");
    #10 assign a = 32'h22800000; assign b = 32'h11800000;
    #10 assign a = 32'h22FFFFFF; assign b = 32'h11FFFFFF;

    #10 $display("\n2**-57 * 2**-93:");
    #10 assign a = 32'h23000000; assign b = 32'h11000000;
    #10 assign a = 32'h237FFFFF; assign b = 32'h117FFFFF;

    #10 $display("\n2**-56 * 2**-94:");
    #10 assign a = 32'h23800000; assign b = 32'h10800000;
    #10 assign a = 32'h23FFFFFF; assign b = 32'h10FFFFFF;

    #10 $display("\n2**-55 * 2**-95:");
    #10 assign a = 32'h24000000; assign b = 32'h10000000;
    #10 assign a = 32'h247FFFFF; assign b = 32'h107FFFFF;

    #10 $display("\n2**-54 * 2**-96:");
    #10 assign a = 32'h24800000; assign b = 32'h0F800000;
    #10 assign a = 32'h24FFFFFF; assign b = 32'h0FFFFFFF;

    #10 $display("\n2**-53 * 2**-97:");
    #10 assign a = 32'h25000000; assign b = 32'h0F000000;
    #10 assign a = 32'h257FFFFF; assign b = 32'h0F7FFFFF;

    #10 $display("\n2**-52 * 2**-98:");
    #10 assign a = 32'h25800000; assign b = 32'h0E800000;
    #10 assign a = 32'h25FFFFFF; assign b = 32'h0EFFFFFF;

    #10 $display("\n2**-51 * 2**-99:");
    #10 assign a = 32'h26000000; assign b = 32'h0E000000;
    #10 assign a = 32'h267FFFFF; assign b = 32'h0E7FFFFF;

    #10 $display("\n2**-50 * 2**-100:");
    #10 assign a = 32'h26800000; assign b = 32'h0D800000;
    #10 assign a = 32'h26FFFFFF; assign b = 32'h0DFFFFFF;

    #10 $display("\n2**-49 * 2**-101:");
    #10 assign a = 32'h27000000; assign b = 32'h0D000000;
    #10 assign a = 32'h277FFFFF; assign b = 32'h0D7FFFFF;

    #10 $display("\n2**-48 * 2**-102:");
    #10 assign a = 32'h27800000; assign b = 32'h0C800000;
    #10 assign a = 32'h27FFFFFF; assign b = 32'h0CFFFFFF;

    #10 $display("\n2**-47 * 2**-103:");
    #10 assign a = 32'h28000000; assign b = 32'h0C000000;
    #10 assign a = 32'h287FFFFF; assign b = 32'h0C7FFFFF;

    #10 $display("\n2**-46 * 2**-104:");
    #10 assign a = 32'h28800000; assign b = 32'h0B800000;
    #10 assign a = 32'h28FFFFFF; assign b = 32'h0BFFFFFF;

    #10 $display("\n2**-45 * 2**-105:");
    #10 assign a = 32'h29000000; assign b = 32'h0B000000;
    #10 assign a = 32'h297FFFFF; assign b = 32'h0B7FFFFF;

    #10 $display("\n2**-44 * 2**-106:");
    #10 assign a = 32'h29800000; assign b = 32'h0A800000;
    #10 assign a = 32'h29FFFFFF; assign b = 32'h0AFFFFFF;

    #10 $display("\n2**-43 * 2**-107:");
    #10 assign a = 32'h2A000000; assign b = 32'h0A000000;
    #10 assign a = 32'h2A7FFFFF; assign b = 32'h0A7FFFFF;

    #10 $display("\n2**-42 * 2**-108:");
    #10 assign a = 32'h2A800000; assign b = 32'h09800000;
    #10 assign a = 32'h2AFFFFFF; assign b = 32'h09FFFFFF;

    #10 $display("\n2**-41 * 2**-109:");
    #10 assign a = 32'h2B000000; assign b = 32'h09000000;
    #10 assign a = 32'h2B7FFFFF; assign b = 32'h097FFFFF;

    #10 $display("\n2**-40 * 2**-110:");
    #10 assign a = 32'h2B800000; assign b = 32'h08800000;
    #10 assign a = 32'h2BFFFFFF; assign b = 32'h08FFFFFF;

    #10 $display("\n2**-39 * 2**-111:");
    #10 assign a = 32'h2C000000; assign b = 32'h08000000;
    #10 assign a = 32'h2C7FFFFF; assign b = 32'h087FFFFF;

    #10 $display("\n2**-38 * 2**-112:");
    #10 assign a = 32'h2C800000; assign b = 32'h07800000;
    #10 assign a = 32'h2CFFFFFF; assign b = 32'h07FFFFFF;

    #10 $display("\n2**-37 * 2**-113:");
    #10 assign a = 32'h2D000000; assign b = 32'h07000000;
    #10 assign a = 32'h2D7FFFFF; assign b = 32'h077FFFFF;

    #10 $display("\n2**-36 * 2**-114:");
    #10 assign a = 32'h2D800000; assign b = 32'h06800000;
    #10 assign a = 32'h2DFFFFFF; assign b = 32'h06FFFFFF;

    #10 $display("\n2**-35 * 2**-115:");
    #10 assign a = 32'h2E000000; assign b = 32'h06000000;
    #10 assign a = 32'h2E7FFFFF; assign b = 32'h067FFFFF;

    #10 $display("\n2**-34 * 2**-116:");
    #10 assign a = 32'h2E800000; assign b = 32'h05800000;
    #10 assign a = 32'h2EFFFFFF; assign b = 32'h05FFFFFF;

    #10 $display("\n2**-33 * 2**-117:");
    #10 assign a = 32'h2F000000; assign b = 32'h05000000;
    #10 assign a = 32'h2F7FFFFF; assign b = 32'h057FFFFF;

    #10 $display("\n2**-32 * 2**-118:");
    #10 assign a = 32'h2F800000; assign b = 32'h04800000;
    #10 assign a = 32'h2FFFFFFF; assign b = 32'h04FFFFFF;

    #10 $display("\n2**-31 * 2**-119:");
    #10 assign a = 32'h30000000; assign b = 32'h04000000;
    #10 assign a = 32'h307FFFFF; assign b = 32'h047FFFFF;

    #10 $display("\n2**-30 * 2**-120:");
    #10 assign a = 32'h30800000; assign b = 32'h03800000;
    #10 assign a = 32'h30FFFFFF; assign b = 32'h03FFFFFF;

    #10 $display("\n2**-29 * 2**-121:");
    #10 assign a = 32'h31000000; assign b = 32'h03000000;
    #10 assign a = 32'h317FFFFF; assign b = 32'h037FFFFF;

    #10 $display("\n2**-28 * 2**-122:");
    #10 assign a = 32'h31800000; assign b = 32'h02800000;
    #10 assign a = 32'h31FFFFFF; assign b = 32'h02FFFFFF;

    #10 $display("\n2**-27 * 2**-123:");
    #10 assign a = 32'h32000000; assign b = 32'h02000000;
    #10 assign a = 32'h327FFFFF; assign b = 32'h027FFFFF;

    #10 $display("\n2**-26 * 2**-124:");
    #10 assign a = 32'h32800000; assign b = 32'h01800000;
    #10 assign a = 32'h32FFFFFF; assign b = 32'h01FFFFFF;

    #10 $display("\n2**-25 * 2**-125:");
    #10 assign a = 32'h33000000; assign b = 32'h01000000;
    #10 assign a = 32'h337FFFFF; assign b = 32'h017FFFFF;

    #10 $display("\n2**-24 * 2**-126:");
    #10 assign a = 32'h33800000; assign b = 32'h00800000;
    #10 assign a = 32'h33FFFFFF; assign b = 32'h00FFFFFF;

    #10 $display("\n2**-23 * 2**-127:");
    #10 assign a = 32'h34000000; assign b = 32'h00400000;
    #10 assign a = 32'h347FFFFF; assign b = 32'h007FFFFF;

    #10 $display("\n2**-22 * 2**-128:");
    #10 assign a = 32'h34800000; assign b = 32'h00200000;
    #10 assign a = 32'h34FFFFFF; assign b = 32'h003FFFFF;

    #10 $display("\n2**-21 * 2**-129:");
    #10 assign a = 32'h35000000; assign b = 32'h00100000;
    #10 assign a = 32'h357FFFFF; assign b = 32'h001FFFFF;

    #10 $display("\n2**-20 * 2**-130:");
    #10 assign a = 32'h35800000; assign b = 32'h00080000;
    #10 assign a = 32'h35FFFFFF; assign b = 32'h000FFFFF;

    #10 $display("\n2**-19 * 2**-131:");
    #10 assign a = 32'h36000000; assign b = 32'h00040000;
    #10 assign a = 32'h367FFFFF; assign b = 32'h0007FFFF;

    #10 $display("\n2**-18 * 2**-132:");
    #10 assign a = 32'h36800000; assign b = 32'h00020000;
    #10 assign a = 32'h36FFFFFF; assign b = 32'h0003FFFF;

    #10 $display("\n2**-17 * 2**-133:");
    #10 assign a = 32'h37000000; assign b = 32'h00010000;
    #10 assign a = 32'h377FFFFF; assign b = 32'h0001FFFF;

    #10 $display("\n2**-16 * 2**-134:");
    #10 assign a = 32'h37800000; assign b = 32'h00008000;
    #10 assign a = 32'h37FFFFFF; assign b = 32'h0000FFFF;

    #10 $display("\n2**-15 * 2**-135:");
    #10 assign a = 32'h38000000; assign b = 32'h00004000;
    #10 assign a = 32'h387FFFFF; assign b = 32'h00007FFF;

    #10 $display("\n2**-14 * 2**-136:");
    #10 assign a = 32'h38800000; assign b = 32'h00002000;
    #10 assign a = 32'h38FFFFFF; assign b = 32'h00003FFF;

    #10 $display("\n2**-13 * 2**-137:");
    #10 assign a = 32'h39000000; assign b = 32'h00001000;
    #10 assign a = 32'h397FFFFF; assign b = 32'h00001FFF;

    #10 $display("\n2**-12 * 2**-138:");
    #10 assign a = 32'h39800000; assign b = 32'h00000800;
    #10 assign a = 32'h39FFFFFF; assign b = 32'h00000FFF;

    #10 $display("\n2**-11 * 2**-139:");
    #10 assign a = 32'h3A000000; assign b = 32'h00000400;
    #10 assign a = 32'h3A7FFFFF; assign b = 32'h000007FF;

    #10 $display("\n2**-10 * 2**-140:");
    #10 assign a = 32'h3A800000; assign b = 32'h00000200;
    #10 assign a = 32'h3AFFFFFF; assign b = 32'h000003FF;

    #10 $display("\n2**-9 * 2**-141:");
    #10 assign a = 32'h3B000000; assign b = 32'h00000100;
    #10 assign a = 32'h3B7FFFFF; assign b = 32'h000001FF;

    #10 $display("\n2**-8 * 2**-142:");
    #10 assign a = 32'h3B800000; assign b = 32'h00000080;
    #10 assign a = 32'h3BFFFFFF; assign b = 32'h000000FF;

    #10 $display("\n2**-7 * 2**-143:");
    #10 assign a = 32'h3C000000; assign b = 32'h00000040;
    #10 assign a = 32'h3C7FFFFF; assign b = 32'h0000007F;

    #10 $display("\n2**-6 * 2**-144:");
    #10 assign a = 32'h3C800000; assign b = 32'h00000020;
    #10 assign a = 32'h3CFFFFFF; assign b = 32'h0000003F;

    #10 $display("\n2**-5 * 2**-145:");
    #10 assign a = 32'h3D000000; assign b = 32'h00000010;
    #10 assign a = 32'h3D7FFFFF; assign b = 32'h0000001F;

    #10 $display("\n2**-4 * 2**-146:");
    #10 assign a = 32'h3D800000; assign b = 32'h00000008;
    #10 assign a = 32'h3DFFFFFF; assign b = 32'h0000000F;

    #10 $display("\n2**-3 * 2**-147:");
    #10 assign a = 32'h3E000000; assign b = 32'h00000004;
    #10 assign a = 32'h3E7FFFFF; assign b = 32'h00000007;

    #10 $display("\n2**-2 * 2**-148:");
    #10 assign a = 32'h3E800000; assign b = 32'h00000002;
    #10 assign a = 32'h3EFFFFFF; assign b = 32'h00000003;

    #10 $display("\n2**-1 * 2**-149:");
    #10 assign a = 32'h3F000000; assign b = 32'h00000001;
    #10 assign a = 32'h3F7FFFFF; assign b = 32'h00000001;

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
