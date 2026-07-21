`include "defines.svh"
`include "interface.sv"
`include "apb_pkg.sv"
`include "dut.sv"
module top;
import apb_pkg::*;
    bit clk;
    bit reset;
    inf vif(clk, reset);
    apb_master #(
        .ADDR_WIDTH(`ADDR_WIDTH),
        .DATA_WIDTH(`DATA_WIDTH)
    ) dut (
        .PCLK          (clk),
        .PRESETn       (reset),
        .PADDR         (vif.PADDR),
        .PSEL          (vif.PSEL),
        .PENABLE       (vif.PENABLE),
        .PWRITE        (vif.PWRITE),
        .PWDATA        (vif.PWDATA),
        .PSTRB         (vif.PSTRB),
        .PRDATA        (vif.PRDATA),
        .PREADY        (vif.PREADY),
        .PSLVERR       (vif.PSLVERR),
        .transfer      (vif.transfer),
        .write_read    (vif.write_read),
        .addr_in       (vif.addr_in),
        .wdata_in      (vif.wdata_in),
        .strb_in       (vif.strb_in),
        .rdata_out     (vif.rdata_out),
        .transfer_done (vif.transfer_done),
        .error         (vif.error)

    );
   // test1 tst1;
   // test2 tst2;
     test_regression  reg_tb=new(vif.DRV,vif.MON);
    initial
        clk = 0;
    always #5 clk = ~clk;
    initial
    begin
        reset = 0;
        repeat(3) @(posedge clk);
        reset = 1;
    end
    initial
    begin
      //  tst1 = new(vif.DRV,vif.MON);
       // tst2 = new(vif.DRV,vif.MON);
       // tst1.run();
       //	tst2.run();
     reg_tb.run();
     $finish();
    end
endmodule
