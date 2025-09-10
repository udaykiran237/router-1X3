class src_agt_top extends uvm_env;

	`uvm_component_utils(src_agt_top)

	env_config env_cfg;
	src_agt src_agth[];

function new(string name="src_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_full_name(),"cannot get the env config")

	src_agth=new[env_cfg.no_of_src_agts];
	foreach(src_agth[i])
	begin
		src_agth[i]=src_agt::type_id::create($sformatf("src_agth[%0d]",i),this);
		uvm_config_db #(source_config)::set(this,$sformatf("src_agth[%0d]*",i),"source_config",env_cfg.src_cfg[i]);
	end
endfunction

endclass
