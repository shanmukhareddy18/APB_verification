class transaction ;
  logic [`ADDR_WIDTH-1:0]PADDR;
 logic PSEL;
logic PENABLE;
logic PWRITE;
logic [`DATA_WIDTH-1:0]PWDATA;
logic [(`DATA_WIDTH/8)-1:0]PSTRB;
rand logic [`DATA_WIDTH-1:0]PRDATA;
 logic PREADY;
rand logic PSLVERR;
 logic transfer;
rand logic write_read;
rand logic [`ADDR_WIDTH-1:0]addr_in;
rand logic [`DATA_WIDTH-1:0]wdata_in;
rand logic [(`DATA_WIDTH/8)-1:0]strb_in;
logic [`DATA_WIDTH-1:0]rdata_out;
logic transfer_done;
logic error;
int count=0;
bit reset;
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
endclass

class transaction1 extends transaction;
 bit [`DATA_WIDTH-1:0]rdata;
 bit w_r;
 bit [`ADDR_WIDTH-1:0]addr;
 bit [`DATA_WIDTH-1:0]wdata;
 bit [(`DATA_WIDTH/8)-1:0]strb;
constraint c1{
 if(write_read==0)
  strb_in==0;
}
constraint c2{
 if(count>=1)
   strb_in==strb &&
   wdata_in==wdata &&
   addr_in==addr &&
   w_r==write_read &&
   PRDATA==rdata;
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
 if( count==0)begin
   count=1;
   PREADY=0;
   transfer=1;
      strb=strb_in;
      wdata=wdata_in ;
      addr=addr_in ;
      w_r=write_read ;
     rdata=PRDATA;

 end
 else if(count==1)  begin
     strb=strb_in;
      wdata=wdata_in ;
      addr=addr_in ;
      w_r=write_read ;
     rdata=PRDATA;
     count++;
     PREADY=0;  end
 else if (count==2) begin
    PREADY=1; transfer=0; count=0;
    end 
endfunction   
endclass

class transaction2 extends transaction;
 bit [`DATA_WIDTH-1:0]rdata;
 bit w_r;
 bit [`ADDR_WIDTH-1:0]addr;
 bit [`DATA_WIDTH-1:0]wdata;
 bit [(`DATA_WIDTH/8)-1:0]strb;
constraint c1{
 if(write_read==0)
  strb_in==0;
}
constraint c2{
 if(count>=1)
   strb_in==strb &&
   wdata_in==wdata &&
   addr_in==addr &&
   w_r==write_read &&
   PRDATA==rdata;
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
 if( count==0)begin
   count=1;
   PREADY=0;
   transfer=0;
      strb=strb_in;
      wdata=wdata_in ;
      addr=addr_in ;
      w_r=write_read ;
     rdata=PRDATA;

 end
 else if(count==1)  begin
     count++; transfer=1; PREADY=0;  end
 else if (count==2) begin
    PREADY=0; transfer=0; count=3; end
 else if(count==3)begin
  PREADY=0; transfer=0; count=4;end
 else if(count==4)begin
 PREADY=0; transfer=0; count=5; end
else if(count==5)begin
 PREADY=1; transfer=0; count=0;
 end
endfunction
endclass

class transaction3 extends transaction;
 bit [`DATA_WIDTH-1:0]rdata;
 bit w_r;
 bit [`ADDR_WIDTH-1:0]addr;
 bit [`DATA_WIDTH-1:0]wdata;
 bit [(`DATA_WIDTH/8)-1:0]strb;
constraint c1{
 if(write_read==0)
  strb_in==0;
}
constraint c2{
 if(count>=1)
   strb_in==strb &&
   wdata_in==wdata &&
   addr_in==addr &&
   w_r==write_read &&
   PRDATA==rdata;
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
 if( count==0)begin
   count=1;
   PREADY=0;
   transfer=1;
      strb=strb_in;
      wdata=wdata_in ;
      addr=addr_in ;
      w_r=write_read ;
     rdata=PRDATA;
 end
 else if(count==1)  begin
     count++;
     PREADY=1;  transfer=1;end
 else if (count==2) begin
    PREADY=1; transfer=1; count=3;
    end
else if(count==3)begin
  PREADY=1; transfer=1; count=1;end
endfunction
endclass
