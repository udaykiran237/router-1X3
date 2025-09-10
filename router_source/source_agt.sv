class src_agt extends uvm_agent;
	
	`uvm_component_utils(src_agt)

	source_config src_cfg;
	src_monitor s_monh;
	src_driver s_drvh;
	src_sequencer s_seqrh;

function new(string name="src_agt",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(source_config)::get(this,"","source_config",src_cfg))
		`uvm_fatal(get_full_name(),"cannot get the source config")

	s_monh=src_monitor::type_id::create("s_monh",this);

	if(src_cfg.is_active==UVM_ACTIVE)
	begin
		s_drvh=src_driver::type_id::create("s_drvh",this);
		s_seqrh=src_sequencer::type_id::create("s_seqrh",this);
	end
endfunction

function void connect_phase(uvm_phase phase);
	if(src_cfg.is_active==UVM_ACTIVE)
	begin
		s_drvh.seq_item_port.connect(s_seqrh.seq_item_export);
	end
endfunction

endclass
