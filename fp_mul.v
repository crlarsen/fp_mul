`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright: Chris Larsen 2019
// Engineer: Chris Larsen
//
// Create Date: 07/26/2019 07:05:10 PM
// Design Name: Parameterized Floating Point Multiplier
// Module Name: fp_mul
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

module fp_mul(a, b, p, snan, qnan, infinity, zero, subnormal, normal);
  parameter NEXP = 5;
  parameter NSIG = 10;
  parameter BIAS = (1 << (NEXP-1)) - 1;
  parameter EMAX = BIAS;
  parameter EMIN = 1 - EMAX;
  input [NEXP+NSIG:0] a, b;
  output [NEXP+NSIG:0] p;
  output snan, qnan, infinity, zero, subnormal, normal;
  reg snan, qnan, infinity, zero, subnormal, normal;

  wire aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal;
  wire bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal;

  wire signed [NEXP+1:0] aExp, bExp;
  reg signed [NEXP+1:0] pExp, t1Exp, t2Exp;
  wire [NSIG:0] aSig, bSig;
  reg [NSIG:0] pSig, tSig;

  reg [NEXP+NSIG:0] pTmp;

  wire [2*NSIG+1:0] rawSignificand;

  reg pSign;

  fp_class #(NEXP,NSIG) aClass(a, aExp, aSig, aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal);
  fp_class #(NEXP,NSIG) bClass(b, bExp, bSig, bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal);

  assign rawSignificand = aSig * bSig;

  always @(*)
  begin
    // IEEE 754-2019, section 6.3 requires that "[w]hen neither the
    // inputs nor result are NaN, the sign of a product ... is the
    // exclusive OR of the operands' signs".
    pSign = a[NEXP+NSIG] ^ b[NEXP+NSIG];
    pTmp = {pSign, {NEXP{1'b1}}, 1'b0, {NSIG-1{1'b1}}};  // Initialize p to be an sNaN.
    {snan, qnan, infinity, zero, subnormal, normal} = 6'b000000;

    if ((aSnan | bSnan) == 1'b1)
      begin
        pTmp = aSnan == 1'b1 ? a : b;
        snan = 1;
      end
    else if ((aQnan | bQnan) == 1'b1)
      begin
        pTmp = aQnan == 1'b1 ? a : b;
        qnan = 1;
      end
    else if ((aInfinity | bInfinity) == 1'b1)
      begin
        if ((aZero | bZero) == 1'b1)
          begin
            pTmp = {pSign, {NEXP{1'b1}}, 1'b1, {NSIG-1{1'b0}}}; // qNaN
            qnan = 1;
          end
        else
          begin
            pTmp = {pSign, {NEXP{1'b1}}, {NSIG{1'b0}}};
            infinity = 1;
          end
      end
    else if ((aZero | bZero) == 1'b1 ||
             (aSubnormal & bSubnormal) == 1'b1)
      begin
        pTmp = {pSign, {NEXP+NSIG{1'b0}}};
        zero = 1;
      end
    else // if (((aSubnormal | aNormal) & (bSubnormal | bNormal)) == 1'b1)
      begin
        t1Exp = aExp + bExp;

        if (rawSignificand[2*NSIG+1] == 1'b1)
          begin
            tSig = rawSignificand[2*NSIG+1:NSIG+1];
            t2Exp = t1Exp + 1;
          end
        else
          begin
            tSig = rawSignificand[2*NSIG:NSIG];
            t2Exp = t1Exp;
          end

        if (t2Exp < (EMIN - NSIG))  // Too small to even be represented as
          begin                     // a subnormal; round down to zero.
            pTmp = {pSign, {NEXP+NSIG{1'b0}}};
            zero = 1;
          end
        else if (t2Exp < EMIN) // Subnormal
          begin
            pSig = tSig >> (EMIN - t2Exp);
            // Remember that we can only store NSIG bits
            pTmp = {pSign, {NEXP{1'b0}}, pSig[NSIG-1:0]};
            subnormal = 1;
          end
        else if (t2Exp > EMAX) // Infinity
          begin
            pTmp = {pSign, {NEXP{1'b1}}, {NSIG{1'b0}}};
            infinity = 1;
          end
        else // Normal
          begin
            pExp = t2Exp + BIAS;
            pSig = tSig;
            // Remember that for Normals we always assume the most
            // significant bit is 1 so we only store the least
            // significant NSIG bits in the significand.
            pTmp = {pSign, pExp[NEXP-1:0], pSig[NSIG-1:0]};
	    normal = 1;
          end
      end //
  end

  assign p = pTmp;

endmodule
