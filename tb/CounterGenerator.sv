/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterGenerator.sv
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
 
class count_gen;

    /*two transaction handles for shallow copy
    one for randomization and the other for copying
    in order to prevent race condition*/
    count_trans trans_h;
    count_trans data2send;

    /*mailbox between generator and driver*/
    mailbox #(count_trans) gen2drv;

    /*overriding new constructor*/
    function new(mailbox #(count_trans) gen2drv);
        this.gen2drv = gen2drv;     /*passing gen2drv mailbox information*/
        this.trans_h = new();       /*creating object of transaction class*/
    endfunction: new

    /* start() method*/
	/*packet generation with respect to number of transactions*/
    virtual task start();
        fork
			begin
				for (int i = 0; i < no_of_transactions; i++) 	/*no_of_transactions is declared in counter package*/
					begin
						assert(trans_h.randomize());      /*randomization of packets*/
						data2send = new trans_h;          /*shallow copy*/
						gen2drv.put(data2send);           /*randomized generated data is put into the mailbox*/
					end
			end
        join_none
    endtask: start

endclass: count_gen

