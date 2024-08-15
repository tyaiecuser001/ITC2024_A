module AT_SERVER_ROM
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output [(DATA_WIDTH-1):0] q
);

reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];

initial
begin
	$readmemh("./ROM_AT_SERVER.txt", rom);
end

assign q = rom[addr];

endmodule