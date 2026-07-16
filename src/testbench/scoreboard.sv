`include "defines.svh"

class scoreboard;
    transaction exp_trans;
    transaction mon_trans;
    mailbox #(transaction) mbx_rs;
    mailbox #(transaction) mbx_ms;
    int match;
    int mismatch;
    function new(mailbox #(transaction) mbx_rs,
                 mailbox #(transaction) mbx_ms);
        this.mbx_rs = mbx_rs;
        this.mbx_ms = mbx_ms;
        match    = 0;
        mismatch = 0;
    endfunction
    task start();
        for(int i=1;i<=`TRANS;i++)
        begin
            mbx_rs.get(exp_trans);
            mbx_ms.get(mon_trans);
            $display("\n==================================================");
            $display("                 SCOREBOARD");
            $display("==================================================");
                $display("From reference");
                $display("------------------------------------");
                $display("PADDR         = %0h",exp_trans.PADDR);
                $display("PSEL          = %0b",exp_trans.PSEL);
                $display("PENABLE       = %0b",exp_trans.PENABLE);
                $display("PWRITE        = %0b",exp_trans.PWRITE);
                $display("PWDATA        = %0h",exp_trans.PWDATA);
                $display("PSTRB         = %0h",exp_trans.PSTRB);
                $display("rdata_out     = %0h",exp_trans.rdata_out);
                $display("transfer_done = %0b",exp_trans.transfer_done);
                $display("error         = %0b",exp_trans.error);

                $display("From MON");
                $display("------------------------------------");
                $display("PADDR         = %0h",mon_trans.PADDR);
                $display("PSEL          = %0b",mon_trans.PSEL);
                $display("PENABLE       = %0b",mon_trans.PENABLE);
                $display("PWRITE        = %0b",mon_trans.PWRITE);
                 $display("PWDATA        = %0h",mon_trans.PWDATA);
                $display("PSTRB         = %0h",mon_trans.PSTRB);
                $display("rdata_out     = %0h",mon_trans.rdata_out);
                $display("transfer_done = %0b",mon_trans.transfer_done);
                $display("error         = %0b",mon_trans.error);

            if((exp_trans.PADDR         === mon_trans.PADDR)         &&
               (exp_trans.PSEL          === mon_trans.PSEL)          &&
               (exp_trans.PENABLE       === mon_trans.PENABLE)       &&
               (exp_trans.PWRITE        === mon_trans.PWRITE)        &&
               (exp_trans.PWDATA        === mon_trans.PWDATA)        &&
               (exp_trans.PSTRB         === mon_trans.PSTRB)         &&
               (exp_trans.rdata_out     === mon_trans.rdata_out)     &&
               (exp_trans.transfer_done === mon_trans.transfer_done) &&
               (exp_trans.error         === mon_trans.error))
                match++;
            else
                mismatch++;
            $display("------------------------------------");
            $display("MATCHES    = %0d",match);
            $display("MISMATCHES = %0d",mismatch);
            $display("------------------------------------");
        end
    endtask
endclass
