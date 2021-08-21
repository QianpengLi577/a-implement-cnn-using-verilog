iverilog -o "tb.vvp" add.v cnn.v get_data.v mul.v tb.v

pause

vvp -n "tb.vvp"

pause


gtkwave tb.vcd



