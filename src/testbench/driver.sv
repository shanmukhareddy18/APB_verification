`include "defines.svh"
class driver;
    transaction drv_trans;
    mailbox #(transaction) mbx_gd;
    mailbox #(transaction) mbx_dr;
    virtual inf.DRV vif;
    covergroup drv_cg;
        TRANSFER : coverpoint drv_trans.transfer;
        WRITE    : coverpoint drv_trans.write_read;
        ADDRESS  : coverpoint drv_trans.addr_in;
        DATA     : coverpoint drv_trans.wdata_in;
        STRB     : coverpoint drv_trans.strb_in;
        READY    : coverpoint drv_trans.PREADY;
        ERROR    : coverpoint drv_trans.PSLVERR;

        WRXRDY : cross WRITE, READY;
    endgroup
    function new(mailbox #(transaction) mbx_gd,
                 mailbox #(transaction) mbx_dr,
                 virtual inf.DRV vif);
        this.mbx_gd = mbx_gd;
        this.mbx_dr = mbx_dr;
        this.vif    = vif;
        drv_cg = new();
    endfunction
    task start();
        $display("[%0t] DRIVER START", $time);
        repeat(2) @(vif.drv_cb);
        for(int i=1;i<=`TRANS;i++)
        begin
            if(!vif.reset)
            begin
                drv_trans=new();
                vif.drv_cb.transfer   <= 0;
                vif.drv_cb.write_read <= 0;
                vif.drv_cb.addr_in    <= 0;
                vif.drv_cb.wdata_in   <= 0;
                vif.drv_cb.strb_in    <= 0;
                vif.drv_cb.PREADY     <= 0;
                vif.drv_cb.PRDATA     <= 0;
                vif.drv_cb.PSLVERR    <= 0;
                drv_trans.transfer   = 0;
                drv_trans.write_read = 0;
                drv_trans.addr_in    = 0;
                drv_trans.wdata_in   = 0;
                drv_trans.strb_in    = 0;
                drv_trans.PREADY     = 0;
                drv_trans.PRDATA     = 0;
                drv_trans.PSLVERR   = 0;
                      $display("transfer    = %0b", drv_trans.transfer);
                $display("write_read  = %0b", drv_trans.write_read);
                $display("addr_in     = %0h", drv_trans.addr_in);
                $display("wdata_in    = %0h", drv_trans.wdata_in);
                $display("strb_in     = %0h", drv_trans.strb_in);
                $display("PREADY      = %0b", drv_trans.PREADY);
                $display("PRDATA      = %0h", drv_trans.PRDATA);
                $display("PSLVERR     = %0b", drv_trans.PSLVERR);
                $display("count=%d", drv_trans.count);
            end
            else
            begin

            mbx_gd.get(drv_trans);
                vif.drv_cb.transfer   <= drv_trans.transfer;
                vif.drv_cb.write_read <= drv_trans.write_read;
                vif.drv_cb.addr_in    <= drv_trans.addr_in;
                vif.drv_cb.wdata_in   <= drv_trans.wdata_in;
                vif.drv_cb.strb_in    <= drv_trans.strb_in;
                vif.drv_cb.PREADY     <= drv_trans.PREADY;
                vif.drv_cb.PRDATA     <= drv_trans.PRDATA;
                vif.drv_cb.PSLVERR    <= drv_trans.PSLVERR;
                drv_cg.sample();
                $display("DRIVER : CLOCK EDGE = %0d", i);
                $display("----------------------------------------");
                $display("COUNT       = %0d", drv_trans.count);
                $display("transfer    = %0b", drv_trans.transfer);
                $display("write_read  = %0b", drv_trans.write_read);
                $display("addr_in     = %0h", drv_trans.addr_in);
                $display("wdata_in    = %0h", drv_trans.wdata_in);
                $display("strb_in     = %0h", drv_trans.strb_in);
                $display("PREADY      = %0b", drv_trans.PREADY);
                $display("PRDATA      = %0h", drv_trans.PRDATA);
               $display("PSLVERR     = %0b", drv_trans.PSLVERR);
                $display("Driver Coverage = %0.2f%%",
                         drv_cg.get_coverage());
            end
         @(vif.drv_cb);

         mbx_dr.put(drv_trans.copy());
        end
    endtask
endclass

