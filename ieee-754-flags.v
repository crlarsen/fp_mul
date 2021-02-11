//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Chris Larsen
//
// Create Date: 01/25/2020 08:04:53 AM
// Design Name:
// Module Name: ieee-754-flags
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Flag parameters so we can include this file and have consistent
//              definitions every time we need to access of the flags for an
//              IEEE 754 floating point value.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

parameter NORMAL = 0;
parameter SUBNORMAL = NORMAL + 1;
parameter ZERO = SUBNORMAL + 1;
parameter INFINITY = ZERO + 1;
parameter QNAN = INFINITY + 1;
parameter SNAN = QNAN + 1;
parameter LAST_FLAG = SNAN + 1;

parameter BIAS = ((1 << (NEXP - 1)) - 1); // IEEE 754, section 3.3
parameter EMAX = BIAS; // IEEE 754, section 3.3
parameter EMIN = (1 - EMAX); // IEEE 754, section 3.3
