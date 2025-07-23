/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterPackage.sv
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
 
package count_pkg;

	int no_of_transactions = 1;

	`include "CounterTransaction.sv"
	`include "CounterGenerator.sv"
	`include "CounterDriver.sv"
	`include "CounterWriteMonitor.sv"
	`include "CounterReadMonitor.sv"
	`include "CounterReferenceModel.sv"
	`include "CounterScoreboard.sv"
	`include "CounterEnvironment.sv"
	`include "CounterTest.sv"

endpackage: count_pkg