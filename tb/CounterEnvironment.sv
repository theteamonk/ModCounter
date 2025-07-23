/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterEnvironment.sv
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
 
class count_env;

	virtual count_if drv_if; 	/*Interface for Driver*/
	virtual count_if wr_mon_if; /*Interface for Write Monitor*/
	virtual count_if rd_mon_if; /*Interface for Read Monitor*/

	mailbox #(count_trans) gen2drv; 	/*mailbox between Generator and Driver*/
	mailbox #(count_trans) wr_mon2rm; 	/*mailbox between Write Monitor and Reference Model*/
	mailbox #(count_trans) rd_mon2sb; 	/*mailbox between Read Monitor and Scoreboard*/
	mailbox #(count_trans) ref2sb;		/*mailbox between Reference Model and Scoreboard*/

	count_gen 		gen_h; 				/*Generator instance handle*/
	count_drv 		drv_h; 				/*Driver instance handle*/
	count_wr_mon 	wr_mon_h; 			/*Write Monitor instance handle*/
	count_rd_mon 	rd_mon_h; 			/*Read Monitor instance handle*/
	count_rm 		rm_h; 				/*Reference Model instance handle*/
	count_sb 		sb_h; 				/*Scoreboard instance handle*/

	//overriding new constructor*/
	function new(virtual count_if.DRV drv_if,
				virtual count_if.WR_MON wr_mon_if,
				virtual count_if.RD_MON rd_mon_if);
		this.drv_if = drv_if; 		/*passing Interface information for Driver*/
		this.wr_mon_if = wr_mon_if; /*passing Interface information for Write Monitor*/
		this.rd_mon_if = rd_mon_if; /*passing Interface information for Read Monitor*/
	endfunction: new

	//build() method*/
	//object of each component is generated
	//and physical interface and mailbox arguments*/
	virtual task build();
		gen_h 		= new(gen2drv); 					/*Generator to Driver mailbox communication*/
		drv_h 		= new(drv_if, gen2drv); 			/*Interface for Driver & Generator to Driver mailbox communication*/
		wr_mon_h 	= new(wr_mon_if, wr_mon2rm); 	/*Interface for Write Monitor & Write Monitor to Reference Model mailbox communication*/
		rd_mon_h 	= new(rd_mon_if, rd_mon2sb); 	/*Interface for Read Monitor & Read Monitor to Scoreboard mailbox communication*/
		rm_h 		= new(wr_mon2rm, ref2sb); 			/*Write Monitor to Reference Model mailbox communication & Reference Model to Scoreboard mailbox communication*/
		sb_h 		= new(rd_mon2sb, ref2sb); 			/*Read Monitor to Scoreboard mailbox communication & Reference Model to Scoreboard mailbox communication*/
	endtask: build

	/*reset_duv() method*/
	/*resetn is driven here*/
	//virtual task reset_duv();
	//@(drv_if.DRV_CYC); 			/*delay of one clock cycle*/
	//drv_if.drv_cb.resetn <= 1'd0; /*resetn is high, active low*/
	//repeat(2) @(drv_if.drv_cb); //delay of two clock cycle*/
	//drv_if.DRV_cb.resetn <= 1'b1; //*resetn is low, active low*/
	//endtask: reset_duv

	//start() method*/
	//start() methods of every component is called*/
	virtual task start();
		gen_h.start(); 	/*Generator*/
		drv_h.start(); 	/*Driver*/
		wr_mon_h.start(); /*Write Monitor*/
		rd_mon_h.start(); /*Read Monitor*/
		rm_h.start(); 	/*Reference Model*/
		sb_h.start(); 	/*Scoreboard*/
	endtask: start

	/*stop() method*/
	/*waits for DONE event in SCOREBOARD to get triggered*/
	virtual task stop();
		wait(sb_h.DONE.triggered);
	endtask:

	//run() method*/
	//this method is called in Test class*/
	//all the methods in Environment is called*/
	virtual task run();
		//reset_duv(); 		/*resen task*/
		start(); 			/*start() method of all the components*/
		stop(); 			/*waits for DONE event to get triggered*/
		sb_h.report(); 		/*Scoreboard report*/
	endtask: run

endclass: count_env