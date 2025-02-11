module uart_rx(
					input iCLK,RST_n,
					input rxd_in,
					output reg [7:0] rxd,
					output reg RECEIVE_END
					);		
					
localparam baud_rate = 115200;
localparam div_num = 50_000_000/baud_rate;

localparam 	START		 	 = 0,		//接收起始位址
				RECEIVE_DATA = 1,		//接收資料
				STOP			 = 2;		//接收完成
					
reg [7:0] para_data;

reg rx_reg0,rx_reg1,rx_reg2,rx_reg3;
wire rxd_neg_w;

reg R_receiving;

reg [2:0] stage_rx;
reg [7:0] rx_data;
reg bps_rx_clk_en;
wire bps_rx_clk;

reg rx_done;

reg [8:0] cnt_baud;	

reg [2:0] cnt_bit;
reg start_cnt;

//消除亞穩態
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			rx_reg0 <= 1'd0;
			rx_reg1 <= 1'd0;
			rx_reg2 <= 1'd0;
			rx_reg3 <= 1'd0;
		end
	else
		begin
			rx_reg0 <= rxd_in;
			rx_reg1 <= rx_reg0;
			rx_reg2 <= rx_reg1;
			rx_reg3 <= rx_reg2;
		end
end

//產生rxd_in下緣
assign rxd_neg_w = (~rx_reg2) & rx_reg3;

//產生發送信號
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			R_receiving <= 1'd0;
		end
	else if(rx_done)
			R_receiving <= 1'd0;
	else if(rxd_neg_w)
			R_receiving <= 1'd1;
end


//
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			rx_done <= 1'd0;
			stage_rx <= START;
			rx_data <= 8'd0;
			bps_rx_clk_en <= 1'd0;
			start_cnt <= 1'd0;
			RECEIVE_END <= 1'd0;
			rxd <= 8'd0;
		end
	else if(R_receiving)
		begin
			bps_rx_clk_en <= 1'd1;						//開始計數baud
			
			if(bps_rx_clk)
				begin
					case(stage_rx)
						START: begin						//接收起始位元，不保存
							rx_data <= 8'd0;
							rx_done <= 1'd0;
							stage_rx <= RECEIVE_DATA;
							RECEIVE_END <= 1'd0;
						end
						RECEIVE_DATA: begin
							rx_done <= 1'd0;
							rx_data[cnt_bit] <= rxd_in;
							RECEIVE_END <= 1'd0;
							
							if(cnt_bit==3'd7)
								stage_rx <= STOP;
							else
								stage_rx <= stage_rx;
						end
						STOP: begin								//接收停止位，不保存
							rxd <= rx_data;
							rx_done <= 1'd1;
							stage_rx <= START;
							RECEIVE_END <= 1'd1;
						end
						
						default: stage_rx <= START;
					endcase
				end
			else
				RECEIVE_END <= 1'd0;
		end
		else
			begin
				rx_done <= 1'd0;
				stage_rx <= 4'd0;
				rx_data <= 8'd0;
				bps_rx_clk_en <= 1'd0;
				RECEIVE_END <= 1'd0;
			end
end


//baud_rate 計數
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			cnt_baud <= 9'd0;
		end
	else	if(bps_rx_clk_en)
		begin
			if(cnt_baud==div_num-1)
				cnt_baud <= 9'd0;
			else
				cnt_baud <= cnt_baud + 9'd1;
		end
	else
		cnt_baud <= 9'd0;
end

assign bps_rx_clk =(cnt_baud==(div_num-1)>>1'd1)? 1'd1 : 1'd0;

//計算已接收資料
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			cnt_bit <= 3'd0;
		end
	else if(bps_rx_clk==1'd1 && stage_rx==RECEIVE_DATA)
		begin
			if(cnt_bit==3'd7)
				cnt_bit <= 3'd0;
			else
				cnt_bit <= cnt_bit + 3'd1;
		end
	else
		cnt_bit <= cnt_bit;
end
					
endmodule
