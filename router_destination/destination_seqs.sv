class dst_sequence extends uvm_sequence#(dst_xtn);

	`uvm_object_utils(dst_sequence)

function new(string name="dst_sequence");
	super.new(name);
endfunction
endclass


///////////LESS THAN 30 CYCLES////////
class less30 extends dst_sequence;

	`uvm_object_utils(less30)

function new(string name="less30");
	super.new(name);
endfunction

task body(); 
//repeat(3)
begin
	req=dst_xtn::type_id::create("req"); 
	start_item(req); 
	assert(req.randomize() with {no_of_cycles inside {[1:30]};}); 
	finish_item(req);  
end
endtask
endclass


//////////MORE THAN 30 CYCLES/////////////
class more30 extends dst_sequence;

	`uvm_object_utils(more30)

function new(string name="more30");
	super.new(name);
endfunction

task body();
//repeat(3)
begin 
	req=dst_xtn::type_id::create("req"); 
	start_item(req); 
	assert(req.randomize() with {no_of_cycles>30; no_of_cycles<60;}); 
	finish_item(req);  
end
endtask
endclass
