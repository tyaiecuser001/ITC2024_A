module uart_tx(
				input iCLK,RST_n,
				input select_w,tx_en,
				input [2:0] LED_select,
				input receiver_OK,
				output reg tx,receive_ok_en
					);
					
localparam CLK = 50_000_000;
localparam baud_rate = 115200;
localparam div_num = CLK/baud_rate;

localparam 	IDLE		 = 0,		//等待
				START		 = 1,		//傳送起始位址
				SEND_DATA = 2,		//傳送資料
				STOP	 	 = 3;		//傳送完成


reg [2:0] stage_tx;
reg start_cnt;
				
wire end_baud;
reg [8:0] cnt_baud;

reg [2:0] cnt_bit;
reg [7:0] addr;
wire [7:0] tx_data;

wire ok;
assign ok = (receiver_OK || tx_data!=8'h0a);

reg [3:0] cnt_rom;			//計算傳到第幾筆指令
reg SEND_END_cmd;
reg SEND_DATA_en;
reg btn;


reg [7:0] Send_addr;
reg [7:0] Send_addr_w;
reg enable;

AT_ROM AT(
			.clk(iCLK), 
			.addr(addr),
			.q(tx_data)
			);

//
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			stage_tx <= IDLE;
			addr <= 8'd0;
			start_cnt <= 1'd0;
			enable <= 1'd0;
			Send_addr_w <= 8'd0;
		end
	else if(tx_en)
		begin
			case(stage_tx)
				IDLE: begin							//等待
					if(end_baud)
						stage_tx <= START;
					else
						stage_tx <= IDLE;
				end
				START: begin						//起始位元
					if(end_baud)
						stage_tx <= SEND_DATA;
					else
						stage_tx <= START;
				end
				SEND_DATA: begin					//傳送資料
					if(cnt_bit==3'd7 && end_baud==1'd1) begin
						stage_tx <= STOP;
						start_cnt <= 1'd0;
					end
					else begin
						stage_tx <= SEND_DATA;
						start_cnt <= 1'd1;
					end
				end
				STOP: begin							//結束位元
					if(SEND_DATA_en && end_baud==1'd1 && ok==1'd1) begin
						stage_tx <= START;
						
						if(cnt_rom==4'd6 && tx_data==8'h0a) begin
							case(LED_select)
								3'd0:
									addr <= Send_addr + 8'd14;
								3'd1:
									addr <= Send_addr + 8'd17;
								3'd2:
									addr <= Send_addr + 8'd20;
								3'd3:
									addr <= Send_addr + 8'd23;
								3'd4:
									addr <= Send_addr + 8'd26;
								3'd5:
									addr <= Send_addr + 8'd29;
								3'd6:
									addr <= Send_addr + 8'd32;
								3'd7:
									addr <= Send_addr + 8'd35;
							endcase
						end
						else if(cnt_rom==4'd5 && tx_data==8'h0a) begin
							addr <= Send_addr;
							Send_addr_w <= Send_addr;
							enable = 1'd1;
						end
						else
							addr <= addr + 8'd1;
							
					end
					else begin
						stage_tx <= STOP;
					end
				end
			endcase
		end
end


//傳送資料給Server的指令address
always@(cnt_rom,tx_data,enable,addr,Send_addr_w)
begin
	if(cnt_rom==4'd5 && tx_data==8'h0a && enable==1'd0) begin
		Send_addr = addr + 8'd1;
	end
	else begin
		Send_addr = Send_addr_w;
	end
end

//baud_rate 計數
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			cnt_baud <= 9'd0;
		end
	else
		begin
			if(cnt_baud==div_num-1) begin
				cnt_baud <= 9'd0;
			end
			else begin
				cnt_baud <= cnt_baud + 9'd1;
			end
		end
end

assign end_baud = (cnt_baud==div_num-1);

//計數已傳送資料
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			cnt_bit <= 3'd0;
		end
	else if(end_baud==1'd1 && stage_tx==SEND_DATA && start_cnt==1'd1)
		begin
			if(cnt_bit==3'd7)
				cnt_bit <= 3'd0;
			else
				cnt_bit <= cnt_bit + 3'd1;
		end
	else
		cnt_bit <= cnt_bit;
end

//傳完一筆指令
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			receive_ok_en <= 1'd0;
		end
	else
		begin
			if(stage_tx==STOP) begin
				if(tx_data==8'h0a)
					receive_ok_en <= 1'd1;
				else
					receive_ok_en <= 1'd0;
			end
			else
				receive_ok_en <= 1'd0;
		end
end


//計數傳完第幾筆指令
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			cnt_rom <= 4'd0;
		end
	else
		begin
			if(stage_tx==SEND_DATA && cnt_bit==3'd7 && end_baud==1'd1) begin
				if(tx_data==8'h0a)
					cnt_rom <= cnt_rom + 4'd1;
				else
					cnt_rom <= cnt_rom;
			end
			else if(cnt_rom==4'd7)
				cnt_rom <= 4'd5;
		end
end

//SEND_DATA_en
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			SEND_END_cmd <= 1'd0;
		end
	else
		begin
			if(cnt_rom==4'd5 || cnt_rom==4'd7)					//傳完第5筆cmd資料，接下來要傳送資料到server
				SEND_END_cmd <= 1'd1;
			else
				SEND_END_cmd <= 1'd0;
		end
end

//判斷按鈕有沒有按下
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			btn <= 1'd0;
		end
	else
		begin
			if(!select_w)
				btn <= 1'd1;
			else if(cnt_rom==4'd7)
				btn <= 1'd0;
			else
				btn <= btn;
		end
end
	
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			SEND_DATA_en <= 1'd1;
		end
	else if(btn)
		begin
			SEND_DATA_en <= 1'd1;
		end
	else if(SEND_END_cmd)
		SEND_DATA_en <= 1'd0;
	else
		SEND_DATA_en <= SEND_DATA_en;
end
	
		
//傳送tx
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			tx <= 1'd1;		//沒傳送資料為high
		end
	else
		begin
			if(stage_tx==START)							//起始訊號
				tx <= 1'd0;			
			else if(stage_tx==SEND_DATA)				//傳送tx
				tx <= tx_data[cnt_bit];
			else if(stage_tx==STOP)						//結束訊號
				tx <= 1'd1;
			else
				tx <= tx;
		end
end
endmodule
