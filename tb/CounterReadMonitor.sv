/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterReadMonitor.sv
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
 
class count_rd_mon;

    /* Interface for Read Monitor */
    virtual count_if.RD_MON rd_mon_if;

    /*two transaction handles for shallow copy
    one for pin-to-packet and the other for copying
    the same in order to prevent race condition */
    count_trans data2sb;    /* Data from Read Monitor to Scoreboard */
    count_trans rd_data;    /* Read Monitor packets */

    /* Mailbox between Read Monitor and Scoreboard */
    mailbox #(count_trans) rd_mon2sb;

    /* Overriding the new constructor */
    function new(virtual count_if.RD_MON rd_mon_if,
                 mailbox #(count_trans) rd_mon2sb);
        this.rd_mon_if = rd_mon_if;       /* Passing Interface info for Read Monitor */
        this.rd_mon2sb = rd_mon2sb;       /* Passing rd_mon2sb mailbox info */
        this.rd_data = new();             /* Creating transaction object rd_data for Read Monitor */
    endfunction: new

    /* Pin-to-packet conversion */
    virtual task monitor();
        @(rd_mon_if.rd_mon_cb);                      /* Wait for clocking event */
        //wait(wr_mon_if.wr_mon_cb.resetn == 1);       /* Wait until resetn is deasserted */
        //@(wr_mon_if.wr_mon_cb);                      /* One clock cycle delay */
        begin
            rd_data.count = rd_mon_if.rd_mon_cb.count;  /* Capture output count from DUT */
            rd_data.display("Data from READ MONITOR");  /* Display packet info */
        end
    endtask: monitor

    /* start() method
       Monitoring the output from DUT
       Monitored data is put into mailbox for Scoreboard to get */
    virtual task start();
        fork
            forever begin
                monitor();                           /* Calling monitor task */
                data2sb = new rd_data;               /* Shallow copy of data */
                rd_mon2sb.put(data2sb);              /* Put into mailbox for Scoreboard */
            end
        join_none
    endtask: start

endclass: count_rd_mon
