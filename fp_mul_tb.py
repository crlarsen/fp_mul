# coding=utf-8
import sys

if len(sys.argv) != 3:
  sys.exit("number of arguments = " + str(len(sys.argv)))

header = """
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright: © 2019-2020, Chris Larsen
// Engineer:
//
// Create Date: 07/26/2019 07:19:00 PM
// Design Name:
// Module Name: fp_mul_tb
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


module fp_mul_tb;
"""

body = """
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
    $display("Test multiply circuit for binary%d:\\n\\n", NEXP+NSIG+1);

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
    #10 $display("\\n{qNaN, infinity, zero, subnormal, normal} * sNaN:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, 1'b0, ({NSIG-1{1'b0}} | 4'hB)};
        assign a = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    // For these tests a is always a quiet NaN.
    #10 $display("\\nqNaN * {qNaN, infinity, zero, subnormal, normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    // For these tests b is always a quiet NaN.
    #10 $display("\\n{infinity, zero, subnormal, normal} * qNaN:");
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
//              #10 $display("\\n+infinity * {+infinity, +zero, +subnormal, +normal}:");
//            else
//              #10 $display("\\n+infinity * {-infinity, -zero, -subnormal, -normal}:");
//          else
//            if (j == 0)
//              #10 $display("\\n-infinity * {+infinity, +zero, +subnormal, +normal}:");
//            else
//              #10 $display("\\n-infinity * {-infinity, -zero, -subnormal, -normal}:");
//          #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}} | (i << NEXP+NSIG);
//              assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}} | (j << NEXP+NSIG);
//          #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}} | (j << NEXP+NSIG);
//          #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)} | (j << NEXP+NSIG);
//          #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)} | (j << NEXP+NSIG);

//         // For these tests b is always Infinity.
//          if (i == 0)
//            if (j == 0)
//              #10 $display("\\n{+zero, +subnormal, +normal} * +infinity:");
//            else
//              #10 $display("\\n{+zero, +subnormal, +normal} * -infinity:");
//          else
//            if (j == 0)
//              #10 $display("\\n{-zero, -subnormal, -normal} * +infinity:");
//            else
//              #10 $display("\\n{-zero, -subnormal, -normal} * -infinity:");
//          #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}} | (j << NEXP+NSIG);
//              assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}} | (i << NEXP+NSIG);
//          #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)} | (i << NEXP+NSIG);
//          #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)} | (i << NEXP+NSIG);
//    end

    #10 $display("\\n+infinity * {+infinity, +zero, +subnormal, +normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n{+zero, +subnormal, +normal} * +infinity:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\\n+infinity * {-infinity, -zero, -subnormal, -normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n{+zero, +subnormal, +normal} * -infinity:");
    #10 assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\\n-infinity * {+infinity, +zero, +subnormal, +normal}:");
    #10 assign a = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n{-zero, -subnormal, -normal} * +infinity:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\\n-infinity * {-infinity, -zero, -subnormal, -normal}:");
    #10 assign a = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n{-zero, -subnormal, -normal} * -infinity:");
    #10 assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\\n+zero * {+zero, +subnormal, +normal}:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n{+subnormal, +normal} * +zero:");
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\\n-zero * {+zero, +subnormal, +normal}:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n{-subnormal, -normal} * +zero:");
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\\n+zero * {-zero, -subnormal, -normal}:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n{+subnormal, +normal} * -zero:");
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\\n-zero * {-zero, -subnormal, -normal}:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n{-subnormal, -normal} * -zero:");
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $display("\\n+subnormal * +subnormal:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n+subnormal * -subnormal:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n-subnormal * +subnormal:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $display("\\n-subnormal * -subnormal:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
"""

end = """

//    #10 $display("\\n20 * 20:"); // 1.0100000000 * 2**4 or 0x4D00
//    #10 assign a = 16'h4D00; assign b = 16'h4D00; // 1.1001000000 x 2**8 or 0x5E40
//
//    #10 $display("\\n400 * PI:"); // PI = 1.1001001000 * 2**1
//    #10 assign a = 16'h5E40; assign b = 16'h4248; // 1.0011101000 * 2**10 or 0x64E8

    #20 $display("\\nEnd of tests : %t", $time);
    #20 $stop;
  end

  fp_mul #(NEXP, NSIG) inst1(
  .a(a),
  .b(b),
  .p(p),
  .pFlags(flags)
  );
endmodule
"""

print(header[1:-1])

NEXP = int(sys.argv[1])
NSIG = int(sys.argv[2])

print("  parameter NEXP = " + str(NEXP) + ";")
print("  parameter NSIG = " + str(NSIG) + ";")

print(body[1:-1])

emax = (1 << (NEXP-1)) - 1;
bias = emax;
emin = 1 - emax;

stringWidth = NEXP + NSIG + 1
# oneString = '%d\'h%04X' % (stringWidth, (bias << NSIG))
hexFormat = "%d'h%0" + str((stringWidth+3)>>2) + "X"
oneString = hexFormat % (stringWidth, (bias << NSIG))
stringPrefix = str(stringWidth) + '\'h'

# One * {Normal, Subnormal}
for i in range(emax, -emax, -1):
  print('\n    #10 $display("\\n1 * 2**%d:");' % i)
  normalString = hexFormat % (stringWidth, ((i + bias) << NSIG))
  print('    #10 assign a = ' + oneString + '; assign b = ' + normalString + ';')

for i in range(0, NSIG, 1):
  print('\n    #10 $display("\\n1 * 2**%d:");' % (-emax-i))
  subnormalString = hexFormat % (stringWidth, (1 << (NSIG-1-i)))
  print('    #10 assign a = ' + oneString + '; assign b = ' + subnormalString + ';')

# {Normal, Subnormal} * One
for i in range(emax, -emax, -1):
  print('\n    #10 $display("\\n2**%d * 1:");' % i)
  normalString = hexFormat % (stringWidth, ((i + bias) << NSIG))
  print('    #10 assign b = ' + oneString + '; assign a = ' + normalString + ';')

for i in range(0, NSIG, 1):
  print('\n    #10 $display("\\n2**%d * 1:");' % (-emax-i))
  subnormalString = hexFormat % (stringWidth, (1 << (NSIG-1-i)))
  print('    #10 assign b = ' + oneString + '; assign a = ' + subnormalString + ';')

# Edge of Normal/Infinity boundary:
for i in range(0, emax+1):
    print('\n    #10 $display("\\n2**%d * 2**%d:");' % (i, emax-i))
    aString = hexFormat % (stringWidth, ((i + bias) << NSIG))
    bString = hexFormat % (stringWidth, ((emax - i + bias) << NSIG))
    print('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')
    aString = hexFormat % (stringWidth, ((i + bias) << NSIG) + ((1 << NSIG) - 1))
    bString = hexFormat % (stringWidth, ((emax - i + bias) << NSIG) + ((1 << NSIG) - 1))
    print('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')

# Edge of Subnormal/Normal boundary:

def makeNormal(exp, sig) -> int:
    return ((exp + bias) << NSIG) + (sig & ((1 << NSIG) - 1))

def makeSubnormal(exp, sig) -> int:
    shiftAmount = emin - exp
    return sig >> shiftAmount

def makeNumber(exp, sig) -> int:
    if exp < emin:
        return makeSubnormal(exp, sig)
    else:
        return makeNormal(exp, sig)

minExp = emin - NSIG
maxExp = NSIG

for i in range(minExp, maxExp):
    print('\n    #10 $display("\\n2**%d * 2**%d:");' % (i, minExp+NSIG-1-i))
    aString = hexFormat % (stringWidth, makeNumber(i, (1 << NSIG)))
    bString = hexFormat % (stringWidth, makeNumber(minExp+NSIG-1-i, (1 << NSIG)))
    print('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')
    aString = hexFormat % (stringWidth, makeNumber(i, ((2 << NSIG) - 1)))
    bString = hexFormat % (stringWidth, makeNumber(minExp+NSIG-1-i, ((2 << NSIG) - 1)))
    print('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')

maxExp = -1

for i in range(minExp, maxExp+1):
    print('\n    #10 $display("\\n2**%d * 2**%d:");' % (i, maxExp+minExp-i))
    aString = hexFormat % (stringWidth, makeNumber(i, (1 << NSIG)))
    bString = hexFormat % (stringWidth, makeNumber(maxExp+minExp-i, (1 << NSIG)))
    print('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')
    aString = hexFormat % (stringWidth, makeNumber(i, ((2 << NSIG) - 1)))
    bString = hexFormat % (stringWidth, makeNumber(maxExp+minExp-i, ((2 << NSIG) - 1)))
    print('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')

print(end[1:-1])
