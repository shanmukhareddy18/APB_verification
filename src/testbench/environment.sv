`include "defines.svh"
class environment;
    generator        gen;
    driver           drv;
    monitor          mon;
    reference_model  refm;
    scoreboard       sb;
    mailbox #(transaction) mbx_gd;
    mailbox #(transaction) mbx_dr;
    mailbox #(transaction) mbx_rs;
    mailbox #(transaction) mbx_ms;
    virtual inf vif;
    function new(virtual inf vif);
        this.vif = vif;
        mbx_gd = new();
        mbx_dr = new();
        mbx_rs = new();
        mbx_ms = new();
        gen  = new(mbx_gd);
        drv  = new(mbx_gd, mbx_dr, vif);
        refm = new(mbx_dr, mbx_rs);
        mon  = new(mbx_ms, vif);
        sb   = new(mbx_rs, mbx_ms);
    endfunction
    task start();
        fork
            gen.start();
            drv.start();
            refm.start();
            mon.start();
            sb.start();
        join_any
        @(posedge vif.clk);
        $display("\n======================================");
        $display("       SIMULATION COMPLETED");
        $display("======================================");
    endtask
endclass
