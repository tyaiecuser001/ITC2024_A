module Select_mode(
						input iCLK,RST_n,
						input select_w,
						input [2:0] SW,
						output reg [2:0] LED_select
						);
					
						
always@(posedge iCLK or negedge RST_n)
begin
	if(!RST_n)
		begin
			LED_select <= 4'd0;
		end
	else
		begin
			if(!select_w)
				LED_select <= SW;
			else
				LED_select <= LED_select;
		end	
end		
						
endmodule
