/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterWriteMonitor.sv
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
 
class count_wr_mon;

    /* Interface for Write Monitor*/
    virtual count_if.WR_MON wr_mon_if;

    /*two transaction handles for shallow copy
    one for pin-to-packet and the other for copying
    the same in order to prevent race condition*/
    count_trans data2rm;        /*data from Write Monitor to Reference Model*/
    count_trans wr_data;        /*Write Monitor packets*/

    /*mailbox between Write Monitor and Reference Model*/
    mailbox #(count_trans) wr_mon2rm;

    /*overriding the new constructor*/
    function new(virtual count_if.WR_MON wr_mon_if,
                 mailbox #(count_trans) wr_mon2rm);
        this.wr_mon_if = wr_mon_if;          /*Passing Interface info for Write Monitor*/
        this.wr_mon2rm = wr_mon2rm;          /*Passing wr_mon2rm mailbox info*/
        this.wr_data = new();                /*Creating transaction object wr_data*/
    endfunction: new

    /*pin-to-packet conversion*/
    virtual task monitor();
        @(wr_mon_if.wr_mon_cb);              	/*one clock cycle delay*/
        begin
            wr_data.din     = wr_mon_if.wr_mon_cb.din;      
            wr_data.load    = wr_mon_if.wr_mon_cb.load;     
            wr_data.up_down = wr_mon_if.wr_mon_cb.up_down;  
            wr_data.resetn  = wr_mon_if.wr_mon_cb.resetn;   

            wr_data.display("Data from WRITE MONITOR");     /*Calling display method*/
        end
    endtask: monitor

    /* start() method*/
    /* monitoring the stimulus driven to DUT by Driver*/
    /* monitoring data is put into mailbox for Reference Model to get*/
    virtual task start();
        fork
            forever 
				begin
					monitor();                             /*calling monitor task*/
					data2rm = new wr_data;                 /*shallow copy*/
					wr_mon2rm.put(data2rm);                /*transaction packet(data2rm) obtained from Interface while 
															Driver sending stimulus to DUT is put into the mailbox
															for Reference Model to get*/
				end
        join_none
    endtask: start

endclass: count_wr_mon
