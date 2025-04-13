onbreak resume
onerror resume
vsim -voptargs=+acc work.conv_core_tb

add wave sim:/conv_core_tb/u_conv_core/clk
add wave sim:/conv_core_tb/u_conv_core/reset
add wave sim:/conv_core_tb/u_conv_core/clk_enable
add wave sim:/conv_core_tb/u_conv_core/Video_in_0
add wave sim:/conv_core_tb/u_conv_core/Video_in_1
add wave sim:/conv_core_tb/u_conv_core/Video_in_2
add wave sim:/conv_core_tb/u_conv_core/ctrl_hStart
add wave sim:/conv_core_tb/u_conv_core/ctrl_hEnd
add wave sim:/conv_core_tb/u_conv_core/ctrl_vStart
add wave sim:/conv_core_tb/u_conv_core/ctrl_vEnd
add wave sim:/conv_core_tb/u_conv_core/ctrl_valid
add wave sim:/conv_core_tb/u_conv_core/ce_out
add wave sim:/conv_core_tb/u_conv_core/Video_out
add wave sim:/conv_core_tb/Video_out_ref
add wave sim:/conv_core_tb/u_conv_core/valid_out_hStart
add wave sim:/conv_core_tb/valid_out_hStart_ref
add wave sim:/conv_core_tb/u_conv_core/valid_out_hEnd
add wave sim:/conv_core_tb/valid_out_hEnd_ref
add wave sim:/conv_core_tb/u_conv_core/valid_out_vStart
add wave sim:/conv_core_tb/valid_out_vStart_ref
add wave sim:/conv_core_tb/u_conv_core/valid_out_vEnd
add wave sim:/conv_core_tb/valid_out_vEnd_ref
add wave sim:/conv_core_tb/u_conv_core/valid_out_valid
add wave sim:/conv_core_tb/valid_out_valid_ref
run -all
