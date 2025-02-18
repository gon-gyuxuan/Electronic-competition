transcript on
if ![file isdirectory pro_pinlv_iputf_libs] {
	file mkdir pro_pinlv_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "E:/FPGA-project/2015_F/pinlv/pll_100m_sim/pll_100m.vo"
vlog "E:/FPGA-project/2015_F/pinlv/pll_500_sim/pll_500.vo"  

vlog -vlog01compat -work work +incdir+E:/FPGA-project/2015_F/pinlv {E:/FPGA-project/2015_F/pinlv/pll_500.vo}
vlib pll_500
vmap pll_500 pll_500
vlog -vlog01compat -work pll_500 +incdir+E:/FPGA-project/2015_F/pinlv/pll_500 {E:/FPGA-project/2015_F/pinlv/pll_500/pll_500_0002.v}
vlog -vlog01compat -work work +incdir+E:/FPGA-project/2015_F/pinlv {E:/FPGA-project/2015_F/pinlv/pro_pinlv.v}
vlog -vlog01compat -work work +incdir+E:/FPGA-project/2015_F/pinlv {E:/FPGA-project/2015_F/pinlv/cycle.v}
vlog -vlog01compat -work work +incdir+E:/FPGA-project/2015_F/pinlv {E:/FPGA-project/2015_F/pinlv/pinlv.v}
vlog -vlog01compat -work work +incdir+E:/FPGA-project/2015_F/pinlv {E:/FPGA-project/2015_F/pinlv/duty_cycle.v}

vlog -vlog01compat -work work +incdir+E:/FPGA-project/2015_F/pinlv {E:/FPGA-project/2015_F/pinlv/tb_cycle.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -L pll_500 -voptargs="+acc"  tb_cycle

add wave *
view structure
view signals
run -all
