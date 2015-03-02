transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/ALU_K.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/SEXT11.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/SEXT9.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/SEXT6.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/SEXT5.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/reg_3.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/reg_1.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/nzp_logic.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/tri_buffer_16.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/SLC3_2.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/reg_16.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/mux_4x1.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/mux_2x1.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/Mem2IO.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/ISDU.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/carry_select_adder_16.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/regfile.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/test_memory.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/processor.sv}
vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/SLC3.sv}

vlog -sv -work work +incdir+C:/Users/Sunny/Documents/GitHub/ECE385Lab6 {C:/Users/Sunny/Documents/GitHub/ECE385Lab6/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
