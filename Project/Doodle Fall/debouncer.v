`timescale 1ns / 1ps

module debouncer(
	input clk,
	input button,
	output reg button_state
    );

reg [15:0] counter;
reg button_state_reg = 0;

always @ (posedge clk) begin
	if(button == 0)
	begin
		counter <= 0;
		button_state <=0;
	end
	else if (counter >= 16'hffff)
		begin
			button_state <= 1;
			counter <= 0;
		end
	else begin
		counter <= counter + 1'b1;
	end
end

endmodule
