module UART_Client(
			input iCLK,RST_n,
			input select_w,tx_en,
			input [2:0] SW,
			input rx,
			output tx,
			output Client_wifi_txd,
			output RST_WiFi
			);
			
wire receive_ok_en,receiver_OK_w;

wire [7:0] rxd;	
wire RECEIVE_END;

wire [2:0] LED_select;
			
assign Client_wifi_txd = rx;	
assign RST_WiFi = RST_n;
					
uart_tx uart_tx_u1(
					.iCLK(iCLK),
					.RST_n(RST_n),
					.select_w(select_w),
					.tx_en(tx_en),
					.LED_select(LED_select),
					.receiver_OK(receiver_OK_w),
					.tx(tx),
					.receive_ok_en(receive_ok_en)
					);
					
uart_rx uart_rx_u2(
					.iCLK(iCLK),
					.RST_n(RST_n),
					.rx(rx),
					.rxd(rxd),
					.RECEIVE_END(RECEIVE_END)
					);
					
receiver_OK receiver_OK_u1(
								.iCLK(iCLK),
								.RST_n(RST_n),
								.RECEIVE_END(RECEIVE_END),
								.receive_ok_en(receive_ok_en),
								.rxd(rxd),
								.receiver_OK(receiver_OK_w)
								);
								
Select_mode Select_mode_u1(
								.iCLK(iCLK),
								.RST_n(RST_n),
								.select_w(select_w),
								.SW(SW),
								.LED_select(LED_select)
								);

endmodule
