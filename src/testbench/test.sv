`include "defines.svh"
class test;
    environment env;
    virtual inf.DRV drv_vif;
    virtual inf.MON mon_vif;    
function new(virtual inf.DRV drv_vif,virtual inf.MON mon_vif);
        this.drv_vif = drv_vif;
	this.mon_vif=mon_vif;
    endfunction
/*    task run();
       env=new(mon_vif,drv_vif);
       env.build();
        $display("\n========================================");
        $display(" SIMULATION STARTED");
        $display("========================================");
        env.start();
    endtask */
endclass

/* class test1 extends test;
	transaction1 trans1;
  	function new(virtual inf.DRV drv_vif,virtual inf.MON mon_vif);
    		super.new(drv_vif,mon_vif);
  	endfunction
  	task run();
    		env=new(mon_vif,drv_vif);
    		env.build();
    		begin
    			trans1 = new();
    			env.gen.blueprint= trans1;
    		end
                $display("\n========================================");
              $display(" TEST=1 SIMULATION STARTED");
             $display("========================================");

    		env.start();
  	endtask
endclass

class test2 extends test;
        transaction2 trans2;
        function new(virtual inf.DRV drv_vif,virtual inf.MON mon_vif);
                super.new(drv_vif,mon_vif);
        endfunction
        task run();
                env=new(mon_vif,drv_vif);
                env.build();
                begin
                        trans2 = new();
                        env.gen.blueprint= trans2;
                end
                $display("\n========================================");
              $display(" TEST=2 SIMULATION STARTED");
             $display("========================================");

                env.start();
        endtask
endclass */

class test_regression extends test;
 transaction1 t1;
 transaction2 t2;
 transaction3 t3;
 function new(virtual inf.DRV drv_vif,virtual inf.MON mon_vif);
  super.new(drv_vif,mon_vif);
endfunction
task run();
env=new(mon_vif,drv_vif);
env.build;
begin
t1 =new();
env.gen.blueprint=t1;
end
env.start;

begin
t2 =new();
env.gen.blueprint=t2;
end
env.start;

begin
t3 =new();
env.gen.blueprint=t2;
end
env.start;

endtask
endclass
