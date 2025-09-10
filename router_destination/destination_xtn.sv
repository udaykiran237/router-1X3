class dst_xtn extends uvm_sequence_item;

	`uvm_object_utils(dst_xtn)

	bit [7:0] header;
	bit [7:0] payload[];
	bit [7:0] parity;
	rand bit [5:0] no_of_cycles;

//	constraint c1{header[1:0]!=2'b11;}
//	constraint c2{header[7:2]!=0;}
//	constraint c3{payload.size==header[7:2]:}

function new(string name="dst_xtn");
	super.new(name);
endfunction

function void do_print(uvm_printer printer);
	super.do_print(printer);

	printer.print_field("header",this.header,8,UVM_DEC); 
	foreach(payload[i]) 
		begin
		printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC); 
		end
	printer.print_field("parity",this.parity,8,UVM_DEC);  
	printer.print_field("no_of_cycles",this.no_of_cycles,6,UVM_DEC);  	
endfunction

/*function void post_randomize();
	parity=header;
	foreach(payload[i])
		parity=parity^payload[i];
endfunction*/

endclass
