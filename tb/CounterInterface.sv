/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterInterface.sv
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
 
interface count_if (input bit clock);

    /*Interface signals*/
    bit [3:0] din;
    bit [3:0] count;
    bit load;
    bit up_down;
    bit resetn;

    /*Driver clocking block*/
    clocking drv_cb @(posedge clock);
        default input #1 output #1;
        output din;
        output load;
        output up_down;
        output resetn;
    endclocking: drv_cb

    /*Write monitor clocking block*/
    clocking wr_mon_cb @(posedge clock);
        default input #1 output #1;
        input din;
        input load;
        input up_down;
        input resetn;
    endclocking: wr_mon_cb

    /*Read monitor clocking block*/
    clocking rd_mon_cb @(posedge clock);
        default input #1 output #1;
        input count;
    endclocking: rd_mon_cb

    /*Driver modport*/
    modport DRV (clocking drv_cb);

    /*Write Monitor modport*/
    modport WR_MON (clocking wr_mon_cb);

    /*Read Monitor modport*/
    modport RD_MON (clocking rd_mon_cb);

endinterface: count_if
