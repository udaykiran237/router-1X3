class env extends uvm_env;

	`uvm_component_utils(env)

	env_config env_cfg;
	src_agt_top src_agt_toph;
	dst_agt_top dst_agt_toph;	
	scoreboard sb;

function new(string name="env",uvm_component parent);
	super.new(name,parent);	
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);	
	
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_full_name(),"cannot get the env config")

	if(env_cfg.has_src_agt)
		src_agt_toph=src_agt_top::type_id::create("src_agt_toph",this);

	if(env_cfg.has_dst_agt)
		dst_agt_toph=dst_agt_top::type_id::create("dst_agt_toph",this);
	if(env_cfg.has_scoreboard)
		sb=scoreboard::type_id::create("sb",this);
endfunction

function void connect_phase(uvm_phase phase);
	if(env_cfg.has_scoreboard)
		begin
		foreach(src_agt_toph.src_agth[i])
		begin
			src_agt_toph.src_agth[i].s_monh.ap.connect(sb.src_fifo[i].analysis_export);
		end
		foreach(dst_agt_toph.dst_agth[i])
		begin
			dst_agt_toph.dst_agth[i].d_monh.ap.connect(sb.dst_fifo[i].analysis_export);
		end
		end
endfunction

endclass
