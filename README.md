# Verilog IEEE 754 Multiply

## Description

Modify hp_mul module to use Verilog parameters. Rename module to fp_mul. This makes the module useful for all of the IEEE 754 binary types (16-, 32-, 64-, & 128-bits).

Code is explained in the video series [Building an FPU in Verilog](https://www.youtube.com/watch?v=rYkVdJnVJFQ&list=PLlO9sSrh8HrwcDHAtwec1ycV-m50nfUVs).
See the video *Building an FPU in Verilog: Improving the hp_mul Module*.

This version of the code:
- Packages the six separate IEEE 754 type flags into a bit vector. Defines constants for accessing the individual flags.
- Moves the various parameters defined by IEEE 754 into the include file to ensure their definitions are consistent across the whole project.

## Manifest

|   Filename   |                        Description                        |
|--------------|-----------------------------------------------------------|
| README.md | This file. |
| ieee-754-flags.v | Include file which defines the position of each of the individual IEEE type flags within the bit vector. Also defines symbolic names for quantities defined by IEEE 754. The definitions calculate these values from NEXP and NSIG. It's because these values are calculated from NEXP and NSIG dynamically that this module is able to support all of the IEEE 754 binary types instead having a different module for each type. |
| fp_class.sv | Utility module to identify the type of the IEEE 754 value passed in, and extract the exponent & significand fields for use by other modules. |
| fp_mul.v  | Parameterized multiply circuit for the IEEE 754 binary data types. |
| fp_mul_tb.py | Python 3 script to generate testbench code for each of the IEEE 754 binary formats. |
| fp_mul_tb_16.v | Testbench for IEEE 754 16-bit binary format. |
| fp_mul_tb_32.v | Testbench for IEEE 754 32-bit binary format. |
| fp_mul_tb_64.v | Testbench for IEEE 754 64-bit binary format. |
| fp_mul_tb_128.v | Testbench for IEEE 754 128-bit binary format. |

## Copyright

:copyright: Chris Larsen, 2019-2021
