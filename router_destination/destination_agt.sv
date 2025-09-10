class dst_agt extends uvm_agent;
	
	`uvm_component_utils(dst_agt)

	dst_config dst_cfg;
	dst_monitor d_monh;
	dst_driver d_drvh;
	dst_sequencer d_seqrh;

function new(string name="src_agt",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(dst_config)::get(this,"","dst_config",dst_cfg))
		`uvm_fatal(get_full_name(),"cannot get the destination config")

	d_monh=dst_monitor::type_id::create("d_monh",this);

	if(dst_cfg.is_active==UVM_ACTIVE)
	begin
		d_drvh=dst_driver::type_id::create("d_drvh",this);
		d_seqrh=dst_sequencer::type_id::create("d_seqrh",this);
	end
endfunction

function void connect_phase(uvm_phase phase);
	if(dst_cfg.is_active==UVM_ACTIVE)
	begin
		d_drvh.seq_item_port.connect(d_seqrh.seq_item_export);
	end
endfunction

endclass
