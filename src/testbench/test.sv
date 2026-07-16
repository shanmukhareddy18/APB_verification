`include "defines.svh"

class test;
    environment env;
    virtual inf vif;
    function new(virtual inf vif);
        this.vif = vif;
        env = new(vif);
    endfunction
    task run();
        $display("        APB MASTER TEST STARTED");
        $display("====================================");
        env.start();
        $display("\======================================");
        $display("        APB MASTER TEST PASSED");
    endtask
endclass
