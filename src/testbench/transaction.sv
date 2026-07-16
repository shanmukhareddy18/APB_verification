class transaction;
  logic [`ADDR_WIDTH-1:0]PADDR;
 logic PSEL;
logic PENABLE;
logic PWRITE;
logic [`DATA_WIDTH-1:0]PWDATA;
logic [(`DATA_WIDTH/8)-1:0]PSTRB;
rand logic [`DATA_WIDTH-1:0]PRDATA;
rand logic PREADY;
rand logic PSLVERR;
rand logic transfer;
rand logic write_read;
rand logic [`ADDR_WIDTH-1:0]addr_in;
rand logic [`DATA_WIDTH-1:0]wdata_in;
rand logic [(`DATA_WIDTH/8)-1:0]strb_in;
logic [`DATA_WIDTH-1:0]rdata_out;
logic transfer_done;
logic error;
int count;
static bit [`DATA_WIDTH-1:0]rdata;
static bit w_r;
static bit [`ADDR_WIDTH-1:0]addr;
static bit [`DATA_WIDTH-1:0]wdata;
static bit [(`DATA_WIDTH/8)-1:0]strb;

constraint c1{
 if(write_read==0)
  strb_in==0;
}
constraint c2{
 if(count>1)
   strb_in==strb &&
   wdata_in==wdata &&
   addr_in==addr &&
   w_r==write_read &&
   PRDATA==rdata;
}
 constraint c3 {
  if (count == 2)
    PREADY dist {0:=3, 1:=7};
  else
     PREADY == 0;
}
virtual function transaction copy();
 copy=new();
 copy.PRDATA=this.PRDATA;
 copy.PREADY=this.PREADY;
 copy.PSLVERR=this.PSLVERR;
 copy.transfer=this.transfer;
 copy.write_read=write_read;
 copy.addr_in=addr_in;
 copy.wdata_in=wdata_in;
 copy.strb_in=this.strb_in;
 copy.count=this.count;
return copy;
endfunction
function void post_randomize();
 if(transfer && count==0)
   count=1;
 else if(count==1)  begin
     strb=strb_in;
      wdata=wdata_in ;
      addr=addr_in ;
      w_r=write_read ;
     rdata=PRDATA;
     count++;  end
  else if (count==2) begin
        if (PREADY) begin
            if (transfer)
                count = 1;
            else
                count = 0;
           end
        else
           count=2;
    end
endfunction
endclass
                    
