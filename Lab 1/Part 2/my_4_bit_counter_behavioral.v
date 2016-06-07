module my_4_bit_counter_behavioral(clk, rst,a);

input clk, rst;
output reg [3:0] a;

always @ (posedge clk)
begin
	if (rst)
		a <= 4'b0000;
	else
		a <= a + 1'b1;
end

endmodule
