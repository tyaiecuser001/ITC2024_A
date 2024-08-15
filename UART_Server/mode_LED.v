module mode_LED(
					input iCLK,RST_n,
					input RECEIVE_END,
					input [7:0] rxd,
					input SEND_END_cmd,
					output reg [7:0] LED
					);
					
reg [7:0] rx_reg;
reg [3:0] LED_select;
reg LED_en;

reg [3:0] state_recv;

//輸出亮哪顆LED
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			LED[0] <= 1'd0;	LED[1] <= 1'd0;
			LED[2] <= 1'd0;	LED[3] <= 1'd0;
			LED[4] <= 1'd0;	LED[5] <= 1'd0;
			LED[6] <= 1'd0;	LED[7] <= 1'd0;
		end
	else
		begin
			case(LED_select)
				4'd0: begin
					LED[0] <= 1'd0;	LED[1] <= 1'd0;
					LED[2] <= 1'd0;	LED[3] <= 1'd0;
					LED[4] <= 1'd0;	LED[5] <= 1'd0;
					LED[6] <= 1'd0;	LED[7] <= 1'd0;
				end
				4'd1: begin
					LED[0] <= 1'd1;	LED[1] <= 1'd0;
					LED[2] <= 1'd0;	LED[3] <= 1'd0;
					LED[4] <= 1'd0;	LED[5] <= 1'd0;
					LED[6] <= 1'd0;	LED[7] <= 1'd0;
				end
				4'd2: begin
					LED[0] <= 1'd0;	LED[1] <= 1'd1;
					LED[2] <= 1'd0;	LED[3] <= 1'd0;
					LED[4] <= 1'd0;	LED[5] <= 1'd0;
					LED[6] <= 1'd0;	LED[7] <= 1'd0;
				end
				4'd3: begin
					LED[0] <= 1'd0;	LED[1] <= 1'd0;
					LED[2] <= 1'd1;	LED[3] <= 1'd0;
					LED[4] <= 1'd0;	LED[5] <= 1'd0;
					LED[6] <= 1'd0;	LED[7] <= 1'd0;
				end
				4'd4: begin
					LED[0] <= 1'd0;	LED[1] <= 1'd0;
					LED[2] <= 1'd0;	LED[3] <= 1'd1;
					LED[4] <= 1'd0;	LED[5] <= 1'd0;
					LED[6] <= 1'd0;	LED[7] <= 1'd0;
				end
				4'd5: begin
					LED[0] <= 1'd0;	LED[1] <= 1'd0;
					LED[2] <= 1'd0;	LED[3] <= 1'd0;
					LED[4] <= 1'd1;	LED[5] <= 1'd0;
					LED[6] <= 1'd0;	LED[7] <= 1'd0;
				end
				4'd6: begin
					LED[0] <= 1'd0;	LED[1] <= 1'd0;
					LED[2] <= 1'd0;	LED[3] <= 1'd0;
					LED[4] <= 1'd0;	LED[5] <= 1'd1;
					LED[6] <= 1'd0;	LED[7] <= 1'd0;
				end
				4'd7: begin
					LED[0] <= 1'd0;	LED[1] <= 1'd0;
					LED[2] <= 1'd0;	LED[3] <= 1'd0;
					LED[4] <= 1'd0;	LED[5] <= 1'd0;
					LED[6] <= 1'd1;	LED[7] <= 1'd0;
				end
				default: begin
					LED[0] <= 1'd0;	LED[1] <= 1'd0;
					LED[2] <= 1'd0;	LED[3] <= 1'd0;
					LED[4] <= 1'd0;	LED[5] <= 1'd0;
					LED[6] <= 1'd0;	LED[7] <= 1'd0;
				end
			endcase
		end
end

//判斷是否為0-7
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			rx_reg <= 8'd0;
			LED_select <= 4'd0;
			state_recv <= 4'd0;
		end
	else if(RECEIVE_END==1'd1 && SEND_END_cmd==1'd1)
		begin
			case(state_recv)
				4'd0: begin
					if(rxd==8'h2c)								//,
						state_recv <= 4'd1;
					else
						state_recv <= 4'd0;
				end
				4'd1: begin
					if(rxd==8'h32)								//2
						state_recv <= 4'd2;
					else
						state_recv <= 4'd0;
				end
				4'd2: begin
					if(rxd==8'h3a)								//:
						state_recv <= 4'd3;
					else
						state_recv <= 4'd0;
				end
				4'd3: begin;
					if(rxd>=8'h30 && rxd<=8'h37) begin	//0~7
						state_recv <= 4'd4;
						rx_reg <= rxd;
					end
					else begin
						state_recv <= 4'd0;
					end
				end
				4'd4: begin
					state_recv <= 4'd0;
					
					if(rxd==8'h0d)
						LED_select <= rx_reg[3:0];
					else
						LED_select <= LED_select;
				end
			endcase	
		end
end
					
endmodule
