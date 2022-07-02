onerror {exit -code 1}
vlib work
vlog -work work project_1.vo
vlog -work work Waveform2.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.serial_to_parallel_vlg_vec_tst -voptargs="+acc"
vcd file -direction project_1.msim.vcd
vcd add -internal serial_to_parallel_vlg_vec_tst/*
vcd add -internal serial_to_parallel_vlg_vec_tst/i1/*
run -all
quit -f
