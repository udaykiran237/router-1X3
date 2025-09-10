class src_sequence extends uvm_sequence#(src_xtn);

	`uvm_object_utils(src_sequence)

function new(string name="src_sequence");
	super.new(name);
endfunction
endclass


///SMALL PACKET////
class small_packet extends src_sequence;

	`uvm_object_utils(small_packet);
	
	bit [1:0]addr;

function new(string name="small_packet");
	super.new(name);
endfunction

task body;
//repeat(2)
begin
	req=src_xtn::type_id::create("req");
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_full_name(),"Getting is failed") 
	start_item(req); 
	assert(req.randomize() with {header[7:2]<14; header[1:0]==addr;});
	finish_item(req);
end
endtask

endclass


///MEDIUM PACKET////
class medium_packet extends src_sequence;

	`uvm_object_utils(medium_packet);

	bit [1:0] addr;

function new(string name="medium_packet");
	super.new(name);
endfunction

task body;
//repeat(2)
begin
	req=src_xtn::type_id::create("req");
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_full_name(),"Getting is failed") 
	start_item(req); 
	assert(req.randomize() with {header[7:2]==14; header[1:0]==addr;});
	finish_item(req);
end
endtask

endclass


////////LARGE PACKET///
class large_packet extends src_sequence;

	`uvm_object_utils(large_packet);

	bit [1:0]addr;

function new(string name="large_packet");
	super.new(name);
endfunction

task body;
//repeat(2)
begin
	req=src_xtn::type_id::create("req");
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_full_name(),"Getting is failed") 
	start_item(req); 
	assert(req.randomize() with {header[7:2]>14; header[1:0]==addr;});
	finish_item(req);
end
endtask

endclass
