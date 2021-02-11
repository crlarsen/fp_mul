`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright: 2019, Chris Larsen
// Engineer: Chris Larsen
//
// Create Date: 12/14/2019 04:04:02 AM
// Design Name:
// Module Name: fp_class
// Project Name: Verilog FPU
// Target Devices:
// Tool Versions:
// Description: Identify type of floating point input f, extract & return f's
//              exponent, and significand. For Normal numbers the significand
//              will have the implied '1' bit added. For Subnormal numbers the
//              significand will shifted left until its most significant '1' bit
//              is in the position of the implied '1' for Normal numbers. For both
//              Normals & Subnormals the exponent returned will have had the bias
//              subtracted out so that the exponent value which is returned will
//              be signed.
//
//              This version differs from hp_class by being parameterized so that
//              it can be used with any of the IEEE 754 binary formats or even
//              to create non-standard exponent/significand instances as needed
//              for application specific purposes.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module fp_class(f, fExp, fSig, fFlags);
    parameter NEXP = 5;
    parameter NSIG = 10;
    parameter CLOG2_NSIG = $clog2(NSIG+1);
    input [NEXP+NSIG:0] f;
    output signed [NEXP+1:0] fExp;
    reg signed [NEXP+1:0] fExp;
    output [NSIG:0] fSig;
    reg [NSIG:0] fSig;
    `include "ieee-754-flags.v"
    output [LAST_FLAG-1:0] fFlags;

    wire expOnes, expZeroes, sigZeroes;

    assign expOnes   =  &f[NEXP+NSIG-1:NSIG];
    assign expZeroes = ~|f[NEXP+NSIG-1:NSIG];
    assign sigZeroes = ~|f[NSIG-1:0];

    assign fFlags[SNAN]      =  expOnes   & ~sigZeroes & ~f[NSIG-1];
    assign fFlags[QNAN]      =  expOnes                &  f[NSIG-1];
    assign fFlags[INFINITY]  =  expOnes   &  sigZeroes;
    assign fFlags[ZERO]      =  expZeroes &  sigZeroes;
    assign fFlags[SUBNORMAL] =  expZeroes & ~sigZeroes;
    assign fFlags[NORMAL]    = ~expOnes   & ~expZeroes;

    reg [NSIG:0] mask = ~0;
    reg [CLOG2_NSIG-1:0] sa;

    integer i;

    always @(*)
      begin
        // Use actual exponent/significand values for sNaNs, qNaNs,
        // infinities, and zeroes.
        fExp = f[NEXP+NSIG-1:NSIG];
        fSig = f[NSIG-1:0];

        sa = 0;

        if (fFlags[NORMAL])
          {fExp, fSig} = {f[NEXP+NSIG-1:NSIG] - BIAS, 1'b1, f[NSIG-1:0]};
        else if (fFlags[SUBNORMAL])
          begin
            // Shift the most significant bit into the position
            // of the Normal's implied 1. Keep track of how many
            // places were needed to shift the most significant
            // set bit so we can adjust the exponent when we're
            // done.
            for (i = (1 << (CLOG2_NSIG - 1)); i > 0; i = i >> 1)
              begin
                if ((fSig & (mask << (NSIG + 1 - i))) == 0)
                  begin
                    fSig = fSig << i;
                    sa = sa | i;
                  end
              end

            fExp = EMIN - sa;
          end
      end

endmodule
