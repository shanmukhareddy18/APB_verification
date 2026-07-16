class generator;
 transaction blueprint;
 mailbox #(transaction)mbx_gd;
 function new(mailbox #(transaction) mbx_gd);
 blueprint =new();
 this.mbx_gd=mbx_gd;
 endfunction
task start();
for(int i=1;i<=`TRANS;i++)
begin
      blueprint.randomize();
           $display("GEN:clockedge=%d, count=%0d transfer=%0b PREADY=%0b addr_in=%0h wdata_in=%0h write_read=%0h PRDATA=%0h PSLVERR=%d strb_in=%b",
                i,blueprint.count,
                blueprint.transfer,
                blueprint.PREADY,
                blueprint.addr_in,
                blueprint.wdata_in,
                blueprint.write_read,
                blueprint.PRDATA,
                blueprint.PSLVERR,
                blueprint.strb_in);
     mbx_gd.put(blueprint.copy());
end
endtask
endclass
