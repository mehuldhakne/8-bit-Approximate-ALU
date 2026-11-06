ARCA Basys 3 hardware wrapper

Top module: basys3_arca_top
Constraint: arca_8bit_alu_basys3.xdc

Add these RTL sources from the supplied ARCA ZIP:
alu_pkg.sv
alu_primitives.sv
alu_slices.sv
arca_8bit_alu.sv
plus basys3_arca_top.sv from this bundle.
Add arca_8bit_alu_basys3.xdc as a constraints file and ensure it is enabled.
Set basys3_arca_top as top. Target part: xc7a35tcpg236-1 (XC7A35T-1CPG236C).

Mapping:
SW0-SW7 = A; SW8-SW15 = B; LD0-LD15 mirror switches.
Center=ADD, Up=SUB, Left=NOT, Right=XOR, Down=NAND.
When no button is pressed, display shows 00. The result is displayed as two hexadecimal digits.
Button priority: Center > Up > Left > Right > Down.

Then run Synthesis, Implementation, Generate Bitstream. In Hardware Manager use Open Target > Auto Connect > Program Device and select the generated basys3_arca_top.bit under <project>.runs/impl_1/.
