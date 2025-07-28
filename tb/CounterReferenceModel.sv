/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterReferenceCounter.sv
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
 

class count_rm;

	count_trans rm_data;				/* to get transactions packet from Generator*/

	static bit [3:0] ref_count = 4'd0;	/* local variable for counting */

	mailbox #(count_trans) wr_mon2rm; 	/* mailbox between Write Monitor and Reference Model*/
	mailbox #(count_trans) ref2sb; 		/* mailbox between Reference Model and Scoreboard*/

	/*overriding new constructor*/
	function new (mailbox #(count_trans) wr_mon2rm,
				  mailbox #(count_trans) ref2sb);	
		this.wr_mon2rm = wr_mon2rm; 	/*passing wr_mon2rm mailbox information*/
		this.ref2sb = ref2sb; 			/*passing ref2sb mailbox information*/
	endfunction: new

	/*replicating DUT logic*/
	virtual task count_mod (count_trans counter_rm);	/*passing txn class as an argument*/
		if(!counter_rm.resetn)						/*if resetn is high (active low) it resets the counter*/
				ref_count <= 4'b0000;	
					
		else if (counter_rm.load)					/*if load is high, loads the data into the data input*/
			ref_count <= counter_rm.din;	
				
		else if (counter_rm.up_down == 0)  			/* UP Counting */
			begin
				if (ref_count == 4'd10)				/*if the count is > to 11, resets the counter*/
					ref_count <= 4'b0000;
				
				else
					ref_count <= ref_count + 1'b1;		/*else it increments*/
			end
			
		else if(counter_rm.up_down == 1)  			/* DOWN Counting */
			begin
				if (ref_count == 4'd0)	/*if the count is > 10 or < 2, count is 10*/
					ref_count <= 4'd10;
				else
					ref_count <= ref_count - 1'b1;		/*else it decrements*/
			end
			
		else
			begin
				$display("--------Reference Model--------");
				$display("Invalid count");
				$display("-------------------------------");
			end
			
	endtask: count_mod

	virtual task start();
		fork
			forever
				begin
					wr_mon2rm.get(rm_data);	
					count_mod(rm_data);		
					rm_data.count = ref_count;	
					ref2sb.put(rm_data);
				end
		join_none
	endtask: start

endclass: count_rm
