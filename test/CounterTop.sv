/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterTop.sv
 *
 * Description     : An ACTIVE low loadable binary truncated up-down counter,
 *                   keeps counting from 2 to 10. The incrementing or
 *                   decrementing is decided based on the control signal
 *                   'up_down' each by one clock cycle.
 *
 * Scope of Work   : To design a Synchronous binary Up-Down Counter and then
 *                   develop an SV testbench to verify all the functionalities
 *                   of the design
 *******************************************************************************/
 
import count_pkg::*;

module count_top();

	reg clock;

	count_if DUV_IF(clock);

	counter DUV (.clock(clock),
			   .din(DUV_IF.din),
			   .load(DUV_IF.load),
			   .up_down(DUV_IF.up_down),
			   .resetn(DUV_IF.resetn),
			   .count(DUV_IF.count));

	initial
		begin
		clock = 1'b0;
		forever #10 clock = ~clock;
	end

	initial
		begin
			if($test$plusargs("TestCase1"))
				begin
				  count_test test_h;
				  test_h = new(DUV_IF, DUV_IF, DUV_IF);
				  no_of_transactions = 10;
				  test_h.build();
				  test_h.run();
				  $finish;
				end
	end

endmodule