/********************************************************************************
 * RTL design of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 * 
 * File name       : Counter.v
 *
 * Description     : An ACTIVE low loadable binary truncated up-down counter,
 *                   keeps counting from 2 to 10. The incrementing or
 *                   decrementing is decided based on the control signal
 *                   'up_down' each by one clock cycle.
 *
 * Scope of Work   : To design a Synchronous binary Up-Down Counter and then
 *                   develop an SV testbench to verify all the functionalities
 *                   of the design
 *
 * up_down = 0 --> up counting from count 2
 * up_down = 1 --> down counting from count 10
 *******************************************************************************/

module counter(
    input clock,
    input [3:0] din,
    input load,
    input up_down,
    input resetn,
    output reg [3:0] count
);

always @(posedge clock)
	begin
		if (!resetn)
			count <= 4'b0000;
		else if (load)
			count <= din;
		else if (up_down == 0)  /* UP Counting */
			begin
				if (count > 4'd10)
				count <= 4'b0000;
			else
				count <= count + 1'b1;
			end
		else  					/* DOWN Counting */
			begin
				if ((count > 4'd10) || (count < 4'd2))
				count <= 4'd10;
			else
				count <= count - 1'b1;
			end
	end

endmodule