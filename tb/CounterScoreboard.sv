/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterScoreboard.sv
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

class count_sb;

	/*event DONE to indicate completion of verification*/
	event DONE;

	static int ref_data_count, 	/*to count transaction packets coming from Reference Model*/
			   rdm_data_count, 	/*to count transaction packets coming from Read Monitor*/
			   data_verified; 	/*to count the number of data verified*/

	count_trans rm_data; 		/*to get transaction packet from Reference Model*/
	count_trans rdm_data; 		/*to get transaction packet from Read Monitor*/

	mailbox #(count_trans) rdm2sb; /*mailbox between Read Monitor and Scoreboard*/
	mailbox #(count_trans) ref2sb; /*mailbox between Reference Model and Scoreboard*/

	/*overriding new constructor*/
	function new(mailbox #(count_trans) rdm2sb,
				mailbox #(count_trans) ref2sb);
		this.rdm2sb = rdm2sb; 		/*passing rdm2sb mailbox information*/
		this.ref2sb = ref2sb; 		/*passing ref2sb mailbox information*/
	endfunction: new

	/*check() method*/
	/*to compare the packets from Reference Model and packets from Read Monitor*/
	virtual task check(count_trans rm_data, rdm_data); /*packet from Read Monitor will be passed*/
		begin
			if(rm_data.count == rdm_data.count) 	/*comparing packets of Refrence Model and packets from Read Monitor*/
			  $display("Count Matches");
			else
			  $display("Count not matching");
		end
			data_verified++; 				/*counting the number of data verified*/
		begin
			if(data_verified >= no_of_transactions)	/*if data verified is more than the number of transactions generated*/
			  begin
				->DONE;		/*DONE is triggered*/
			  end
		else
		  $display("Data not compared completely");
		end
	endtask: check

	/*report() method*/
	/*this method is called in Environment*/
	/*Report from SCOREBOARD*/
	/*reports Read Monitor Data Count*/
	virtual function void report();
		$display("------------------SCOREBOARD REPORT------------------");
		$display("\n");
		$display("Number of data from Read Monitor = %d", rdm_data_count);
		$display("Number of data from Reference Model = %d", ref_data_count);
		$display("Data verified = %d", data_verified);
		$display("\n");
		$display("-----------------------------------------------------");
	endfunction: report

	virtual task start();
		fork
			forever
			  begin
				ref2sb.get(rm_data); 		/*getting transaction packet from Reference Model*/
				ref_data_count++; 			/*counting number of transaction packets from Reference Model*/
				rdm2sb.get(rdm_data); 		/*getting transaction packet from Read Monitor*/
				rdm_data_count++; 			/*counting number of transaction packets from Read Monitor*/
				check(rm_data, rdm_data); 	/*calling the check() method that compares the RM and RdM transaction packets*/
				report(); 					/*calling the report() method that reports the number of transaction packets and data verified*/
			  end
		join_none
	endtask: start

endclass: count_sb
