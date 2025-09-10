class env_config extends uvm_object;
	`uvm_object_utils(env_config)
	
	source_config src_cfg[];
	dst_config dst_cfg[];
	
	int no_of_src_agts=1;
	int no_of_dst_agts=3;

	bit has_src_agt=1;
	bit has_dst_agt=1;
	bit has_scoreboard=1;

function new(string name="env_config");
	super.new(name);
endfunction

endclass
