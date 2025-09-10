class src_driver extends uvm_driver#(src_xtn);

	`uvm_component_utils(src_driver)

	virtual router_if.S_DRV vif;
	source_config src_cfg;

function new(string name="src_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(source_config)::get(this,"","source_config",src_cfg))
		`uvm_fatal(get_full_name(),"cannot get the source config")
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=src_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info(get_type_name(), "This is Driver run phase in source", UVM_LOW)
	@(vif.source_drv);
	vif.source_drv.rst<=1'b0;
	@(vif.source_drv);
	vif.source_drv.rst<=1'b1;
	
	forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask 

task send_to_dut(src_xtn req);

	while(vif.source_drv.busy!==0)
		@(vif.source_drv);
	vif.source_drv.pkt_vld<=1'b1;
	vif.source_drv.din<=req.header;
	@(vif.source_drv);

	for(int i=0;i<req.header[7:2];i++)
	begin
		while(vif.source_drv.busy!==0)
			@(vif.source_drv);
		vif.source_drv.din<=req.payload[i];
		@(vif.source_drv);
	end

	while(vif.source_drv.busy!==0)
		@(vif.source_drv);
	vif.source_drv.pkt_vld<=1'b0;
	vif.source_drv.din<=req.parity;
	@(vif.source_drv);
	
	req.print();
	
endtask

endclass
