module receiver_OK(
						input iCLK,RST_n,
						input RECEIVE_END,
						input receive_ok_en,
						input [7:0] rxd,
						output receiver_OK
						);

reg [2:0] state;
wire test;
reg OK;

assign receiver_OK = OK;
						
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			OK <= 1'd0;
			state <= 3'd0;
		end
	else if(RECEIVE_END)
		begin
			case(state)
				3'd0: begin
					OK <= 1'd0;
					
					if(rxd==8'h4f)				//O
						state <= 3'd1;
					else
						state <= 3'd0;
				end
				3'd1: begin
					OK <= 1'd0;
					
					if(rxd==8'h4b)				//K
						state <= 3'd2;
					else
						state <= 3'd0;
				end
				3'd2: begin
					OK <= 1'd0;
					
					if(rxd==8'h0d)
						state <= 3'd3;
					else
						state <= 3'd0;
				end
				3'd3: begin
					state <= 3'd0;
					
					if(rxd==8'h0a)
						OK <= 1'd1;
				end
			
			endcase
		end
	else if(receive_ok_en==1'd0)
		OK <= 1'd0;
		
end

endmodule
