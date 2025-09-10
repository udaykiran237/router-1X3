class scoreboard extends  uvm_scoreboard;

	`uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo #(src_xtn) src_fifo[];
	uvm_tlm_analysis_fifo #(dst_xtn) dst_fifo[];
	src_xtn src;
	dst_xtn dst;
	env_config env_cfg;

covergroup src_cg;
	ADDR:coverpoint src.header[1:0]{bins addr={2'b00};}
				//	bins addr=2'b01,
				//	bins addr=2'b10;}
	PAYLOAD:coverpoint src.header[7:2]{bins small_size={[0:14]};
					bins medium_size={[14:41]};
					bins large_size={[41:63]};}
	ERROR:coverpoint src.error{bins no_error={0};}
			//	bins error={1};}
	CROSS:cross ADDR,PAYLOAD,ERROR;
endgroup

covergroup dst_cg;
	ADDR:coverpoint dst.header[1:0]{bins addr={2'b00};
					bins addr1={2'b01};
					bins addr2={2'b10};}
	PAYLOAD:coverpoint dst.header[7:2]{bins small_size={[0:14]};
					bins medium_size={[14:41]};
					bins large_size={[41:63]};}
//	ERROR:coverpoint src.error{bins no_error={0},
//				bins error={1};}
	CROSS:cross ADDR,PAYLOAD;
endgroup
	
function new(string name="scoreboard",uvm_component parent);
	super.new(name,parent);
	src_cg=new();
	dst_cg = new();

endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"cannot get the env config object in scoreboard")

	src_fifo=new[env_cfg.no_of_src_agts];
	dst_fifo=new[env_cfg.no_of_dst_agts];
	
	foreach(src_fifo[i])
		src_fifo[i]=new($sformatf("src_fifo[%0d]",i),this);
	foreach(dst_fifo[i])
		dst_fifo[i]=new($sformatf("dst_fifo[%0d]",i),this);

endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever
	begin
		fork
		begin
			src_fifo[0].get(src);
			src.print();
			src_cg.sample();
		end
		begin
			fork
			begin
				dst_fifo[0].get(dst);
				dst.print();
				dst_cg.sample();
			end
			begin
				dst_fifo[1].get(dst);
				dst.print();
				dst_cg.sample();
			end
			begin
				dst_fifo[2].get(dst);
				dst.print();
				dst_cg.sample();
			end
			join_any
		disable fork;
		end
		join
	compare(src,dst);
	end
endtask

task compare(src_xtn src,dst_xtn dst);
	if(src.header==dst.header)
		$display("header success");
	else
		$display("header failed");

	if(src.payload==dst.payload)
		$display("payload sucess");
	else
		$display("payload failed");

	if(src.parity==dst.parity)
		$display("parity success");
	else
		$display("parity failed");
endtask

endclass
