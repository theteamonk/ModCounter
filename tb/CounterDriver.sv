/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterDriver.sv
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
 
class count_drv;

    /*interface for driver*/
    virtual count_if.DRV drv_if;

    /*get the transaction packet from generator*/
    count_trans data2drv;

    /*mailbox between generator and driver*/
    mailbox #(count_trans) gen2drv;

    /*overriding new constructor*/
    function new(virtual count_if.DRV drv_if, 
				mailbox #(count_trans) gen2drv);
        this.drv_if   = drv_if;			/*passing interface information for Driver*/
        this.gen2drv  = gen2drv;		/*passing gen2drv mailbox information*/
    endfunction: new

    /*packet-to-pin conversion*/
    virtual task drive();
        forever 
			begin
				
				gen2drv.get(data2drv);	/*get packet from the mailbox sent by generator*/
				@(posedge drv_if.drv_cb);	/*one clock cycle delay*/

				/*convert the packets and drive the signals to the DUT*/
				drv_if.drv_cb.din     <= data2drv.din;
				drv_if.drv_cb.load    <= data2drv.load;
				drv_if.drv_cb.up_down <= data2drv.up_down;
				drv_if.drv_cb.resetn  <= data2drv.resetn;
			end
    endtask: drive

    /*start() method*/
	/*driving stimulus to DUT*/
    virtual task start();
        fork
			forever 		/*assuming we don't knnow how many number of transactions are generated*/
				drive();	
        join_none
    endtask: start

endclass: count_drv