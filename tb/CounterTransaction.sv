/********************************************************************************
 * Verification of 4-bit Synchronous Loadable Up-Down Counter
 *
 * Author		   : Chaitra
 *
 * File name       : CounterTransaction.sv
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
 
class count_trans;

    /*Transaction signals*/
    rand bit [3:0] din;
    rand bit load;
    rand bit up_down;
    rand bit resetn;
    bit [3:0] count;

    /*Constraints*/

    /* Constraint for din, set membership:
     As din is of logic type (4 states), we are constraining it to
     take values 1 to 15 and not 0 because
     we have resetn that pulls down the output to 0*/
    constraint C1 { din inside {[2:10]}; }

    // Constraint for load: distribution of 1s vs 0s
    constraint C2 { load dist {1 := 30, 0 := 70}; }

    // Constraint for up_down: equal probability
    constraint C3 { up_down dist {1 := 50, 0 := 50}; }

    // Constraint for resetn: equal probability
    constraint C4 { resetn dist {1 := 40, 0 := 60}; }

    /*Display method*/
    // Components can call this method to display packets
    virtual function void display(input string s);
        begin
            $display("------------------------%s------------------------", s);
            $display("UP/DOWN : %0d", up_down);
            $display("Data In : %0d", din);
            $display("Load    : %0d", load);
            $display("Count   : %0d", count);
            $display("Resetn  : %0d", resetn);
            $display("--------------------------------------------------");
        end
    endfunction: display

endclass: count_trans
