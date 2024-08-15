transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/yuchi/UART/UART_Client {D:/yuchi/UART/UART_Client/TOP.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART/UART_Client {D:/yuchi/UART/UART_Client/UART_Client.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART/UART_Client {D:/yuchi/UART/UART_Client/uart_tx.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART/UART_Client {D:/yuchi/UART/UART_Client/uart_rx.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART/UART_Client {D:/yuchi/UART/UART_Client/receiver_OK.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART/UART_Client {D:/yuchi/UART/UART_Client/Select_mode.v}
vlog -vlog01compat -work work +incdir+D:/yuchi/UART/UART_Client {D:/yuchi/UART/UART_Client/AT_ROM.v}

vlog -vlog01compat -work work +incdir+D:/yuchi/UART/UART_Client {D:/yuchi/UART/UART_Client/testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
