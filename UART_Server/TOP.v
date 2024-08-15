module TOP(
			input iCLK,RST_n,
			input tx_en,
			input rx,
			output tx,
			output [7:0] LED,
			output Server_wifi_txd,
			output RST_WiFi
			);

UART_Server UART_Server_u1(
			.iCLK(iCLK),
			.RST_n(RST_n),
			.tx_en(tx_en),
			.rx(rx),
			.tx(tx),
			.LED(LED),
			.Server_wifi_txd(Server_wifi_txd),
			.RST_WiFi(RST_WiFi)
			);
			
endmodule
