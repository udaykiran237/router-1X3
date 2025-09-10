class dst_driver extends uvm_driver#(dst_xtn);

	`uvm_component_utils(dst_driver)

	virtual router_if.D_DRV vif;
	dst_config dst_cfg;

function new(string name="dst_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(dst_config)::get(this,"","dst_config",dst_cfg))
		`uvm_fatal(get_full_name(),"cannot get the destinatiion config")
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=dst_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
	`uvm_info(get_type_name(), "This is Driver run phase in destination", UVM_LOW)
	forever	
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
	//	req.print();
		seq_item_port.item_done();
	end
endtask 

task send_to_dut(dst_xtn req);
//	`uvm_info("DST_DRIVER",$sformatf("printing from dst driver \n %s", req.sprint()),UVM_LOW) 

	while(vif.destination_drv.vld_out!==1)
     		 @(vif.destination_drv); 
//$display("2________________%0d",vif.destination_drv.valid_out);

   	repeat(req.no_of_cycles) 
    		 @(vif.destination_drv); 

   	vif.destination_drv.re<=1'b1; 
     	@(vif.destination_drv); 

	while(vif.destination_drv.vld_out!==0)
        	@(vif.destination_drv);

        @(vif.destination_drv);
        
   	vif.destination_drv.re<=1'b0; 

	req.print();
endtask

endclass
