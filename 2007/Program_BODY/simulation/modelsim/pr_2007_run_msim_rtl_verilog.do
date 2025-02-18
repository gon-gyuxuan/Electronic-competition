transcript on
if ![file isdirectory pr_2007_iputf_libs] {
	file mkdir pr_2007_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "E:/2017diansai/2007/program/clk_sam_sim/clk_sam.vo"

vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/ram200_8.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/rom_12_12.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/pr_2007.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/ad.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/vga_qudong.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/vga_control.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/sample_time.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/dds.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/key.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/dengxiao_sample.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/dengxiao_2us.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/cepin.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/cefu.v}

vlog -vlog01compat -work work +incdir+E:/2017diansai/2007/program {E:/2017diansai/2007/program/tb_2007.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_2007

add wave *
view structure
view signals
run -all
