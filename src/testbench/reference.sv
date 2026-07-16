`include "defines.svh"

class reference_model;

    transaction ref_trans;
    transaction exp_trans;

    mailbox #(transaction) mbx_dr;
    mailbox #(transaction) mbx_rs;

    function new(mailbox #(transaction) mbx_dr,
                 mailbox #(transaction) mbx_rs);

        this.mbx_dr = mbx_dr;
        this.mbx_rs = mbx_rs;

    endfunction
    task start();
        for(int i=1;i<=`TRANS;i++)
        begin
            mbx_dr.get(ref_trans);
            exp_trans = new();
            case(ref_trans.count)
                0:
                begin
                exp_trans.PADDR  = 0;
                   exp_trans.PWRITE = 0;
                   exp_trans.PWDATA = 0;
                    exp_trans.PSTRB  = 0;
                    exp_trans.rdata_out =0;
                    exp_trans.PSEL    = 0;
                    exp_trans.PENABLE = 0;
                end

                1:
                begin
                    exp_trans.PSEL    = 1;
                    exp_trans.PENABLE = 0;
                   exp_trans.PADDR  = ref_trans.addr_in;
                   exp_trans.PWRITE = ref_trans.write_read;
                if(ref_trans.write_read)
                    begin
                       exp_trans.PWDATA = ref_trans.wdata_in;
                       exp_trans.PSTRB  = ref_trans.strb_in;
                 end
                else
                  begin
                      exp_trans.PWDATA = 0;
                      exp_trans.PSTRB  = 0;
                  end

                 end

                2:
                begin
                    exp_trans.PSEL    = 1;
                    exp_trans.PENABLE = 1;
                    exp_trans.PADDR  = ref_trans.addr_in;
                   exp_trans.PWRITE = ref_trans.write_read;
                if(ref_trans.write_read)
                    begin
                       exp_trans.PWDATA = ref_trans.wdata_in;
                       exp_trans.PSTRB  = ref_trans.strb_in;
                 end
                else
                  begin
                      exp_trans.PWDATA = 0;
                      exp_trans.PSTRB  = 0;
                  end
                    if(!ref_trans.write_read && ref_trans.PREADY)
                      exp_trans.rdata_out = ref_trans.PRDATA;
                    else
                     exp_trans.rdata_out =0;
                    end
            endcase
           exp_trans.transfer_done = ref_trans.PREADY && (ref_trans.count==2);
            exp_trans.error         = ref_trans.PREADY &&
                                      ref_trans.PSLVERR && (ref_trans.count==2);


                mbx_rs.put(exp_trans);

                $display("\n========================================");
                $display("REFERENCE MODEL");
                $display("count=%d", ref_trans.count);
                $display("PADDR         = %0h",exp_trans.PADDR);
                $display("PSEL          = %0b",exp_trans.PSEL);
                $display("PENABLE       = %0b",exp_trans.PENABLE);
                $display("PWRITE        = %0b",exp_trans.PWRITE);
                $display("PWDATA        = %0h",exp_trans.PWDATA);
                $display("PSTRB         = %0h",exp_trans.PSTRB);
                $display("rdata_out     = %0h",exp_trans.rdata_out);
                $display("transfer_done = %0b",exp_trans.transfer_done);
                $display("error         = %0b",exp_trans.error);
        end
    endtask
endclass


