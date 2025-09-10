class src_monitor extends uvm_monitor;

	`uvm_component_utils(src_monitor)
	
	uvm_analysis_port #(src_xtn) ap;
	virtual router_if.S_MON vif;
	source_config src_cfg;

function new(string name="src_monitor",uvm_component parent);
	super.new(name,parent);
	ap=new("ap",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(source_config)::get(this,"","source_config",src_cfg))
		`uvm_fatal(get_full_name(),"cannot get the source config to source monitor")
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=src_cfg.vif;
endfunction

task run_phase(uvm_phase phase); 
	`uvm_info(get_type_name(),"THIS IS MONITOR IN RUN IN SOURCE",UVM_LOW)
	forever
		collect_data();
endtask

task collect_data();
	src_xtn xtn;
	xtn=src_xtn::type_id::create("xtn");
	
	while(vif.source_mon.busy!==0)
		@(vif.source_mon);
	while(vif.source_mon.pkt_vld!==1)
		@(vif.source_mon);

	xtn.header=vif.source_mon.din;
	@(vif.source_mon);

	xtn.payload=new[xtn.header[7:2]];

	foreach(xtn.payload[i])
	begin
		while(vif.source_mon.busy!==0)
			@(vif.source_mon);
		xtn.payload[i]=vif.source_mon.din;
		@(vif.source_mon);
	end

	while(vif.source_mon.pkt_vld!==0)
		@(vif.source_mon);
	while(vif.source_mon.busy!==0)
		@(vif.source_mon);
	xtn.parity=vif.source_mon.din;
	@(vif.source_mon);
	@(vif.source_mon);

	xtn.error=vif.source_mon.err;
	
	ap.write(xtn);
	xtn.print();
endtask

endclass
