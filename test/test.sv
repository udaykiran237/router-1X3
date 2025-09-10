class router_test extends uvm_test;
	
	`uvm_component_utils(router_test)

	int no_of_src_agts=1;
	int no_of_dst_agts=3;

	env_config env_cfg;
	env envh;
	source_config src_cfg[];
	dst_config dst_cfg[];

function new(string name="router_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	env_cfg=env_config::type_id::create("env_cfg");
	env_cfg.src_cfg=new[no_of_src_agts];
	env_cfg.dst_cfg=new[no_of_dst_agts];

	src_cfg=new[no_of_src_agts];
	foreach(src_cfg[i])
	begin
		src_cfg[i]=source_config::type_id::create($sformatf("src_cfg[%0d]",i));
		if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("s_if%0d",i),src_cfg[i].vif))
			`uvm_fatal(get_full_name(),"cannot get the source virtual interface")
	$display(src_cfg[i].vif);
		src_cfg[i].is_active=UVM_ACTIVE;
		env_cfg.src_cfg[i]=src_cfg[i];
	end

	dst_cfg=new[no_of_dst_agts];
	foreach(dst_cfg[i])
	begin
		dst_cfg[i]=dst_config::type_id::create($sformatf("dst_cfg[%0d]",i));
		if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("d_if%0d",i),dst_cfg[i].vif))
			`uvm_fatal(get_full_name(),"cannot get the destination virtual interface")

		dst_cfg[i].is_active=UVM_ACTIVE;
		env_cfg.dst_cfg[i]=dst_cfg[i];
	end

	env_cfg.no_of_src_agts=no_of_src_agts;
	env_cfg.no_of_dst_agts=no_of_dst_agts;	
	
	uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);
	envh=env::type_id::create("envh",this);

endfunction

function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology;
endfunction

endclass


////////////SMALL TEST/////////
class small_test extends router_test;
	
	`uvm_component_utils(small_test)

	small_packet sp;
	less30 ls;
	bit [1:0]addr;
function new(string name="small_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
//	addr=2'b00;
//	uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);
	phase.raise_objection(this);
	sp=small_packet::type_id::create("sp");
	ls=less30::type_id::create("ls");
	repeat(5)
	begin
	addr=$urandom%3;
	uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);
	
	fork
		sp.start(envh.src_agt_toph.src_agth[0].s_seqrh);
		ls.start(envh.dst_agt_toph.dst_agth[addr].d_seqrh);
	join
	end
	#500;
	phase.drop_objection(this);
endtask

endclass


/////////MEDIUM TEST///////////
class medium_test extends router_test;

	`uvm_component_utils(medium_test)

	medium_packet mp;
	more30 ms1;
	bit [1:0]addr;
function new(string name="medium_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
//	addr=2'b01;
//	uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);
	phase.raise_objection(this);
	mp=medium_packet::type_id::create("mp");
	ms1=more30::type_id::create("ms1");
	repeat(6)
	begin
	addr=$urandom%3;
	uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);

	fork
		mp.start(envh.src_agt_toph.src_agth[0].s_seqrh);
		ms1.start(envh.dst_agt_toph.dst_agth[addr].d_seqrh);
	join
	end
	#100;
	phase.drop_objection(this);
endtask

endclass


/////////////////LARGE TEST///////////////
class large_test extends router_test;

	`uvm_component_utils(large_test)

	large_packet lp;
	less30 ms2;
	bit [1:0]addr;
function new(string name="large_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
//	addr=2'b10;
//	uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);
	phase.raise_objection(this);
	lp=large_packet::type_id::create("lp");
	ms2=less30::type_id::create("ms2");
	repeat(10)
	begin
	addr=$urandom%3;
	uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);

	fork
		lp.start(envh.src_agt_toph.src_agth[0].s_seqrh);
		ms2.start(envh.dst_agt_toph.dst_agth[addr].d_seqrh);
	join
	end
	#100;		
	phase.drop_objection(this);
endtask

endclass
