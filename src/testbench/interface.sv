`include "defines.svh"
interface inf(input clk,reset);
  logic [`ADDR_WIDTH-1:0]PADDR;
  logic PSEL;
logic PENABLE;
logic PWRITE;
logic [`DATA_WIDTH-1:0]PWDATA;
logic [(`DATA_WIDTH/8)-1:0]PSTRB;
logic [`DATA_WIDTH-1:0]PRDATA;
logic PREADY;
logic PSLVERR;
logic transfer;
logic write_read;
logic [`ADDR_WIDTH-1:0]addr_in;
logic [`DATA_WIDTH-1:0]wdata_in;
logic [(`DATA_WIDTH/8)-1:0]strb_in;
logic [`DATA_WIDTH-1:0]rdata_out;
logic transfer_done;
logic error;
clocking drv_cb @(posedge clk);
default input #0 output #0;
output PRDATA;
output PREADY;
output PSLVERR;
output transfer;
output write_read;
output  addr_in;
output wdata_in;
output strb_in;
endclocking
clocking ref_cb @(posedge clk);
default input #0 output #0;
 input reset;
endclocking
clocking mon_cb @(posedge clk);
default input #0 output #0;
input PADDR;
input PSEL;
input PENABLE;
input PWRITE;
input PWDATA;
input PSTRB;
input rdata_out;
input transfer_done;
input error;
endclocking
modport DRV(clocking drv_cb,input reset);
modport REF(clocking ref_cb);
modport MON(clocking mon_cb);
endinterface
