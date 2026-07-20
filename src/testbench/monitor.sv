`include "defines.svh"

class monitor;
    transaction mon_trans;
    mailbox #(transaction) mbx_ms;
    virtual inf.MON vif;
    function new(mailbox #(transaction) mbx_ms,
                 virtual inf.MON vif);
        this.mbx_ms = mbx_ms;
        this.vif    = vif;
    endfunction
    bit done;
    task start();
        repeat(2) @(vif.mon_cb);
        for(int i=1;i<=`TRANS;i++)
        begin
            @(vif.mon_cb);
                mon_trans = new();
                mon_trans.PADDR         = vif.mon_cb.PADDR;
                mon_trans.PSEL          = vif.mon_cb.PSEL;
                mon_trans.PENABLE       = vif.mon_cb.PENABLE;
                mon_trans.PWRITE        = vif.mon_cb.PWRITE;
                mon_trans.PWDATA        = vif.mon_cb.PWDATA;
                mon_trans.PSTRB         = vif.mon_cb.PSTRB;
                mon_trans.rdata_out     = vif.mon_cb.rdata_out;
                mon_trans.transfer_done = vif.mon_cb.transfer_done;
                mon_trans.error         = vif.mon_cb.error;
                mbx_ms.put(mon_trans);
                $display("\n========================================");
                $display("MONITOR");
                $display("PADDR         = %0h",mon_trans.PADDR);
                $display("PSEL          = %0b",mon_trans.PSEL);
                $display("PENABLE       = %0b",mon_trans.PENABLE);
                $display("PWRITE        = %0b",mon_trans.PWRITE);
                $display("PWDATA        = %0h",mon_trans.PWDATA);
                $display("PSTRB         = %0h",mon_trans.PSTRB);
                $display("rdata_out     = %0h",mon_trans.rdata_out);
                $display("transfer_done = %0b",mon_trans.transfer_done);
                $display("error         = %0b",mon_trans.error);
            end
    endtask

endclass

