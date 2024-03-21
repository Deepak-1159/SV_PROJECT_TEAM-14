vlog FSM_FINAL.sv +acc
vlog Memory.sv +acc
vlog 8088if.svp
vlog interface.sv +acc
vlog top.sv +acc
vsim work.top
add wave -r *
run -all

