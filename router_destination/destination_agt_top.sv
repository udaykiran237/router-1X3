class dst_agt_top extends uvm_env;

	`uvm_component_utils(dst_agt_top)

	env_config env_cfg;
	dst_agt dst_agth[];

function new(string name="dst_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_full_name(),"cannot get the env config")

	dst_agth=new[env_cfg.no_of_dst_agts];
	foreach(dst_agth[i])
	begin
		dst_agth[i]=dst_agt::type_id::create($sformatf("dst_agth[%0d]",i),this);
		uvm_config_db #(dst_config)::set(this,$sformatf("dst_agth[%0d]*",i),"dst_config",env_cfg.dst_cfg[i]);
	end
endfunction

endclass
