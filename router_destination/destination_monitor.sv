class dst_monitor extends uvm_monitor;

	`uvm_component_utils(dst_monitor)

	uvm_analysis_port #(dst_xtn) ap;
	virtual router_if.D_MON vif;
	dst_config dst_cfg;

function new(string name="dst_monitor",uvm_component parent);
	super.new(name,parent);
	ap=new("ap",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(dst_config)::get(this,"","dst_config",dst_cfg))
		`uvm_fatal(get_full_name(),"cannot get the source config to source monitor")
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=dst_cfg.vif;
endfunction
task run_phase(uvm_phase phase); 
 	`uvm_info(get_type_name(),"THIS IS MONITOR IN RUN IN DESTINATION",UVM_LOW)
	forever
		collect_data();   
endtask

task collect_data();
	dst_xtn xtn;
	xtn=dst_xtn::type_id::create("xtn");

	while(vif.destination_mon.re!==1)
		@(vif.destination_mon);
	@(vif.destination_mon);

	xtn.header=vif.destination_mon.d_out;
	@(vif.destination_mon);

	xtn.payload=new[xtn.header[7:2]];

	foreach(xtn.payload[i])
	begin
		xtn.payload[i]=vif.destination_mon.d_out;
		@(vif.destination_mon);
	end

	xtn.parity=vif.destination_mon.d_out;

        while(vif.destination_mon.re!==0) 
		@(vif.destination_mon);

	ap.write(xtn);
	xtn.print();
endtask

endclass
