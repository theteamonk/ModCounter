/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterTest.sv
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
 
class count_test;

	virtual count_if.DRV 	drv_if; 	/*Interface for Driver*/
	virtual count_if.WR_MON wr_mon_if; 	/*Interface for Write Monitor*/
	virtual count_if.RD_MON rd_mon_if; 	/*Interface for Read Monitor*/
	
	count_env env_h; 		/*Environment instance handle*/

	/*overriding new constructor*/
	function new(virtual count_if.DRV drv_if,
				virtual count_if.WR_MON wr_mon_if,
				virtual count_if.RD_MON rd_mon_if);
	this.drv_if = drv_if; 				/*passing Interface information for Driver*/
	this.wr_mon_if = wr_mon_if; 		/*passing Interface information for Write Monitor*/
	this.rd_mon_if = rd_mon_if; 		/*passing Interface information for Read Monitor*/
	
	env_h = new(drv_if, wr_mon_if, rd_mon_if);
	endfunction: new

	/*build() method*/
	/*build() method of Environment class is called*/
	virtual task build();
		env_h.build();
	endtask: build

	/*run() method*/
	/*run() method of Environment class is called*/
	virtual task run();
		env_h.run();
	endtask: run

endclass: count_test