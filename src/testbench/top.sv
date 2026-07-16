`include "defines.svh"
`include "interface.sv"
import apb_pkg::*;
`include "dut.sv"
module top;
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
    test tst;
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
        tst = new(vif);
        tst.run();
    end
endmodule

