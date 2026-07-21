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
    virtual inf.DRV drv_vif;
    virtual inf.MON mon_vif;
    function new(virtual inf.MON mon_vif,virtual inf.DRV drv_vif);
        this.drv_vif = drv_vif;
        this.mon_vif = mon_vif;
    endfunction
   task build();
        mbx_gd = new();
        mbx_dr = new();
        mbx_rs = new();
        mbx_ms = new();
        gen  = new(mbx_gd);
        drv  = new(mbx_gd, mbx_dr, drv_vif);
        refm = new(mbx_dr, mbx_rs);
        mon  = new(mbx_ms, mon_vif);
        sb   = new(mbx_rs, mbx_ms);
   endtask 
    task start();
        fork
            gen.start();
            drv.start();
            refm.start();
            mon.start();
            sb.start();
        join
    endtask
endclass
