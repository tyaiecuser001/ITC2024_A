module TOP(
			input iCLK,RST_n,
			input select_w,tx_en,
			input [2:0] SW,
			input rx,
			output tx,
			output Client_wifi_txd,
			output RST_WiFi
			);
			
UART_Client UART_Client_u1(
					.iCLK(iCLK),
					.RST_n(RST_n),
					.select_w(select_w),
					.tx_en(tx_en),
					.SW(SW),
					.rx(rx),
					.tx(tx),
					.Client_wifi_txd(Client_wifi_txd),
					.RST_WiFi(RST_WiFi)
					);
			
endmodule

