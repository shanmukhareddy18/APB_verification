class reference_model;
        transaction ref_trans;
        mailbox#(transaction)mbx_dr;
        mailbox#(transaction)mbx_rs;
        typedef enum {idle,setup,access} state;
        state c_state=idle;
        bit [`DATA_WIDTH-1:0] read_d,write_d;
        bit [`ADDR_WIDTH-1:0] prev_add;
        bit prev_pwrite,tr_d,err;
        bit [(`DATA_WIDTH)/8-1:0]prev_strb;
        function new(mailbox#(transaction)mbx_dr,mailbox#(transaction)mbx_rs);
                this.mbx_dr=mbx_dr;
                this.mbx_rs=mbx_rs;
        endfunction
        task start();
                for(int i=0;i<`TRANS;i++)begin
                        mbx_dr.get(ref_trans);
                        if(ref_trans.reset==1) begin
                                if(c_state==idle) begin
                                        ref_trans.PSEL=0;
                                        ref_trans.PENABLE=0;
                                        if (tr_d==1) begin ref_trans.transfer_done=1;tr_d=0;end else begin ref_trans.transfer_done=0; end
                                        if (err==1) begin ref_trans.error=1; err=0; end else begin ref_trans.error=0; end
                                        ref_trans.rdata_out=read_d;
                                        ref_trans.PADDR=prev_add;
                                        ref_trans.PWRITE=prev_pwrite;
                                        ref_trans.PSTRB=prev_strb;
                                        ref_trans.rdata_out=read_d;
                                        ref_trans.PWDATA=write_d;
                                        if(ref_trans.transfer==1) c_state=setup;
                                end else if (c_state==setup) begin
                                        ref_trans.PSEL=1;
                                        ref_trans.PENABLE=0;
                                        if (tr_d==1) begin ref_trans.transfer_done=1;tr_d=0;end else begin ref_trans.transfer_done=0; end
                                        if (err==1) begin ref_trans.error=1; err=0; end else begin ref_trans.error=0; end
                                        ref_trans.rdata_out=read_d;
                                        ref_trans.PADDR=prev_add;
                                        ref_trans.PWRITE=prev_pwrite;
                                        ref_trans.PSTRB=prev_strb;
                                        ref_trans.rdata_out=read_d;
                                        ref_trans.PWDATA=write_d;
                                        c_state=access;
                                     end else if (c_state==access) begin
                                        ref_trans.PSEL=1;
                                        ref_trans.PENABLE=1;
                                        ref_trans.transfer_done=0;
                                        ref_trans.error=0;
                                        ref_trans.PADDR=ref_trans.addr_in;
                                        prev_add=ref_trans.addr_in;
                                        ref_trans.PWRITE=ref_trans.write_read;
                                        prev_pwrite=ref_trans.write_read;
                                        if(ref_trans.PWRITE==1) begin
                                                ref_trans.PWDATA=ref_trans.wdata_in;
                                                ref_trans.rdata_out=read_d;
                                                write_d=ref_trans.wdata_in;
                                                ref_trans.PSTRB=ref_trans.strb_in;
                                                prev_strb=ref_trans.strb_in;
                                        end else if(ref_trans.PWRITE==0) begin
                                                ref_trans.rdata_out=read_d;
                                                ref_trans.PWDATA=0;
                                                write_d=0;
                                                prev_strb=0;
                                                ref_trans.PSTRB=0;
                                                prev_strb=0;
                                        end
                                        if (ref_trans.PREADY==1) begin
                                                tr_d=1;
                                                if(ref_trans.PSLVERR==1) err=1; else err=0;
                                                if(ref_trans.transfer==1) c_state=setup;
                                                else if (ref_trans.transfer==0) c_state=idle;
                                                if(ref_trans.PWRITE==0) begin
                                                        read_d=ref_trans.PRDATA;
                                                end
                                        end
                                end
                        end else if (ref_trans.reset==0) begin
                             ref_trans.PADDR=0;
                                ref_trans.rdata_out=0;
                                ref_trans.error=0;
                                ref_trans.PSTRB=0;
                                ref_trans.PWDATA=0;
                                ref_trans.PWRITE=0;
                                ref_trans.transfer_done=0;
                                ref_trans.PENABLE=0;
                                ref_trans.PSEL=0;
                                read_d=0;
                                write_d=0;
                                prev_add=0;
                                prev_pwrite=0;
                                tr_d=0;
                                err=0;
                                prev_strb=0;
                                c_state=idle;
                        end
                        $display("REF MODEL DATA IN FROM DRIVER: test_case:%0d Reset:%0b PRDATA:%0h PREADY:%0b PSLVERR:%0b transfer:%0b write_read:%0b addr_in:%0h wdata_in:%0h strb_in:%0b",i,ref_trans.reset,ref_trans.PRDATA,ref_trans.PREADY,ref_trans.PSLVERR,ref_trans.transfer,ref_trans.write_read,ref_trans.addr_in,ref_trans.wdata_in,ref_trans.strb_in,$time);
                        $display("REF MODEL DATA OUT TO MONITOR: PADDR=%0h, PSEL=%0b, PENABLE=%0b, PWRITE=%0b, PWDATA=%0h, PSTRB=%0b, rdata_out=%0h, transfer_done=%0b, error=%0b",ref_trans.PADDR,ref_trans.PSEL,ref_trans.PENABLE,ref_trans.PWRITE,ref_trans.PWDATA,ref_trans.PSTRB,ref_trans.rdata_out,ref_trans.transfer_done,ref_trans.error,$time);
                        mbx_rs.put(ref_trans);
                end
        endtask
endclass


