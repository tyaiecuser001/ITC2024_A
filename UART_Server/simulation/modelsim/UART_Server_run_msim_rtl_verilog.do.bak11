transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/yuchi/UART_Server {D:/yuchi/UART_Server/TOP.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART_Server {D:/yuchi/UART_Server/UART_Server.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART_Server {D:/yuchi/UART_Server/uart_tx.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART_Server {D:/yuchi/UART_Server/uart_rx.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART_Server {D:/yuchi/UART_Server/receiver_OK_ser.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART_Server {D:/yuchi/UART_Server/mode_LED.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART_Server {D:/yuchi/UART_Server/AT_SERVER_ROM.v}

vlog -vlog01compat -work work +incdir+D:/yuchi/UART_Server {D:/yuchi/UART_Server/testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
