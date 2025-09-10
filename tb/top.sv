module top;

	import uvm_pkg::*;
	import router_pkg::*;

	bit clk;
	always #5 clk=~clk;

	router_if s_if0(clk);
	router_if d_if0(clk);
	router_if d_if1(clk);
	router_if d_if2(clk);

 	router_top DUV(.clk(clk),
                 .pkt_vld(s_if0.pkt_vld),
                 .busy(s_if0.busy),
                 .err(s_if0.err),
                 .din(s_if0.din), 
                 .rst(s_if0.rst),
                 .vld_out_0(d_if0.vld_out),
                 .vld_out_1(d_if1.vld_out),
                 .vld_out_2(d_if2.vld_out),
                 .re_0(d_if0.re),
                 .re_1(d_if1.re),
                 .re_2(d_if2.re),
                 .d_out0(d_if0.d_out),
                 .d_out1(d_if1.d_out),
                 .d_out2(d_if2.d_out));
	initial
	begin
	`ifdef VCS
	$fsdbDumpvars(0,top);
	`endif

		uvm_config_db #(virtual router_if)::set(null,"*","s_if0",s_if0);
		uvm_config_db #(virtual router_if)::set(null,"*","d_if0",d_if0);
		uvm_config_db #(virtual router_if)::set(null,"*","d_if1",d_if1);
		uvm_config_db #(virtual router_if)::set(null,"*","d_if2",d_if2);

	
	run_test();
	end


property stable_data;
	@(posedge clk) s_if0.busy |=> $stable(s_if0.din);
endproperty

property busy_check;
	@(posedge clk) $rose(s_if0.pkt_vld) |-> s_if0.busy; //->
endproperty

property valid_signal;
	@(posedge clk) $rose(s_if0.pkt_vld) |-> ##3(d_if0.vld_out | d_if1.vld_out | d_if2.vld_out);
endproperty

property rd_enb1;
	@(posedge clk) d_if0.vld_out |-> ##[1:29] d_if0.re;
endproperty

property rd_enb2;
	@(posedge clk) d_if1.vld_out |-> ##[1:29] d_if1.re;
endproperty

property rd_enb3;
	@(posedge clk) d_if2.vld_out |-> ##[1:29] d_if2.re;
endproperty

property rd_enb1_low;
	@(posedge clk) !(d_if0.vld_out) |=> $fell(d_if0.re);
endproperty

property rd_enb2_low;
	@(posedge clk) !(d_if1.vld_out) |=> $fell(d_if1.re);
endproperty

property rd_enb3_low;
	@(posedge clk) !(d_if2.vld_out) |=> $fell(d_if2.re);
endproperty

A1: assert property (stable_data)
	$display("stable_data success");
	else
		$display("stable_data failed");

A2: assert property (busy_check)
	$display("busy_check success");
	else
		$display("busy_check failed");

A3: assert property (valid_signal)
	$display("valid_signal success");
	else
		$display("valid_signal failed");

A4: assert property (rd_enb1)
	$display("rd_enb1 success");
	else
		$display("rd_enb1 failed");

A5: assert property (rd_enb2)
	$display("rd_enb2 success");
	else
		$display("rd_enb2 failed");

A6: assert property (rd_enb3)
	$display("rd_enb3 success");
	else
		$display("rd_enb3 failed");

/*A7: assert property (rd_enb1_low)
	$display("rd_enb1_low success");
	else
		$display("rd_enb1_low failed");

A8: assert property (rd_enb2_low)
	$display("rd_enb2_low success");
	else
		$display("rd_enb2_low failed");

A9: assert property (rd_enb3_low)
	$display("rd_enb3_low success");
	else
		$display("rd_enb3_low failed");*/

C1: cover property (stable_data)
	$display("C1:stable_data success");

C2: cover property (busy_check)
	$display("C2:busy_check success");

C3: cover property (valid_signal)
	$display("C3:valid_signal success");

C4: cover property (rd_enb1)
	$display("C4:rd_enb1 success");

C5: cover property (rd_enb2)
	$display("C5:rd_enb2 success");

C6: cover property (rd_enb3)
	$display("C6:rd_enb3 success");

/*C7: cover property (rd_enb1_low)
	$display("C7:rd_enb1_low success");

C8: cover property (rd_enb2_low)
	$display("C8:rd_enb2_low success");

C9: cover property (rd_enb3_low)
	$display("C9:rd_enb3_low success");*/

endmodule
