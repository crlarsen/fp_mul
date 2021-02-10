# Verilog IEEE 754 Multiply

## Description

Modify hp_mul module to use Verilog parameters. Rename module to fp_mul. This makes the module useful for all of the IEEE 754 binary types (16-, 32-, 64-, & 128-bits).

Code is explained in the video series [Building an FPU in Verilog](https://www.youtube.com/watch?v=rYkVdJnVJFQ&list=PLlO9sSrh8HrwcDHAtwec1ycV-m50nfUVs).
See the video *Building an FPU in Verilog: Improving the hp_mul Module*.

## Manifest

|   Filename   |                        Description                        |
|--------------|-----------------------------------------------------------|
| README.md | This file. |
| fp_class.sv | Utility module to identify the type of the IEEE 754 value passed in, and extract the exponent & significand fields for use by other modules. |
| fp_mul.v  | Parameterized multiply circuit for the IEEE 754 binary data types. |

## Copyright

:copyright: Chris Larsen, 2019-2020
