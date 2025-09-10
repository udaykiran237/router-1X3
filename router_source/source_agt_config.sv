class source_config extends uvm_object;
	`uvm_object_utils(source_config)
	
	virtual router_if vif;
	uvm_active_passive_enum is_active;

	function new(string name="source_config");
		super.new(name);
	endfunction
endclass
