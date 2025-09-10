interface router_if(input bit clk); 
logic rst;
logic pkt_vld;
logic err;
logic busy;
logic vld_out;
logic re;
logic [7:0] din;
logic [7:0] d_out;   

clocking source_drv@(posedge clk);
default input #1 output #1; 
output rst, pkt_vld,din; 
input busy,err;  
endclocking 

clocking source_mon@(posedge clk);
default input #1 output #1; 
input rst,pkt_vld,din;
input busy,err; 
endclocking 

clocking destination_drv@(posedge clk);
default input #1 output #1;
output re;
input vld_out;
endclocking 

clocking destination_mon@(posedge clk);
default input #1 output #1;
input d_out; 
input re;
input vld_out;
endclocking

modport S_DRV(clocking source_drv);
modport S_MON(clocking source_mon);
modport D_DRV(clocking destination_drv);
modport D_MON(clocking destination_mon);

endinterface
