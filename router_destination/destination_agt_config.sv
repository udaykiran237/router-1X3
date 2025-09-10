class dst_config extends uvm_object;
	`uvm_object_utils(dst_config)
	
	virtual router_if vif;
	uvm_active_passive_enum is_active;

	function new(string name="dst_config");
		super.new(name);
	endfunction
endclass
