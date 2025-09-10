`define size 3
module router_top(input clk,rst,pkt_vld,
		input re_0,re_1,re_2,
		input [7:0]din,
		output [7:0]d_out0,d_out1,d_out2,
		output vld_out_0,vld_out_1,vld_out_2,
		output err,busy);

	wire [7:0]data_out;
	wire parity_done,fifo_full,low_pkt_vld,detect_add,ld,laf,full_state,write_enb_reg,rst_int_reg,lfd;
	wire [2:0]soft_rst,empty,full,we;


//---------------genvar fifo instantation
	/*genvar i;
	generate for(i=0;i<(`size);i=i+1)
		begin:block
			fifo a(.clock(clk),.resetn(rst),.we(we[i]),.soft_reset(soft_rst[i]),.re(re[i]),.lfd(lfd),.din(data_out),.empty(empty[i]),.full(full[i]),
				.d_out(d_out[i]));
		end
	endgenerate*/
	
	
//-------------fifo instantitaon
	
   	router_fifo f1(.clock(clk),.resetn(rst),.we(we[0]),.soft_reset(soft_rst[0]),.re(re_0),.lfd(lfd),.din(data_out),.empty(empty[0]),.full(full[0]),
				.d_out(d_out0));
				
	router_fifo f2(.clock(clk),.resetn(rst),.we(we[1]),.soft_reset(soft_rst[1]),.re(re_1),.lfd(lfd),.din(data_out),.empty(empty[1]),.full(full[1]),
				.d_out(d_out1));
				
	router_fifo f3(.clock(clk),.resetn(rst),.we(we[2]),.soft_reset(soft_rst[2]),.re(re_2),.lfd(lfd),.din(data_out),.empty(empty[2]),.full(full[2]),
				.d_out(d_out2));
		

//synchronizer instantaion

	router_sync b(.clock(clk),.resetn(rst),.detect_add(detect_add),.we_reg(write_enb_reg),.read0(re_0),.read1(re_1),.read2(re_2),.empty0(empty[0]),
			.empty1(empty[1]),.empty2(empty[2]),.fifo0(full[0]),.fifo1(full[1]),.fifo2(full[2]),.din(din[1:0]),.vld0(vld_out_0),.vld1(vld_out_1),
			.vld2(vld_out_2),.fifo_full(fifo_full),.soft_rst0(soft_rst[0]),.soft_rst1(soft_rst[1]),.soft_rst2(soft_rst[2]),.we(we));
	
//fsm instantation

	router_fsm c(.clk(clk),.rst(rst),.pkt_vld(pkt_vld),.parity_done(parity_done),.soft_rst0(soft_rst[0]),.soft_rst1(soft_rst[1]),.soft_rst2(soft_rst[2]),
		.fifo_full(fifo_full),.low_pkt_vld(low_pkt_vld),.empty0(empty[0]),.empty1(empty[1]),.empty2(empty[2]),.din(din[1:0]),.busy(busy),
		.detect_add(detect_add),.ld(ld),.laf(laf),.full(full_state),.write_enb_reg(write_enb_reg),.rst_int_reg(rst_int_reg),.lfd(lfd));

//register instantation

	router_reg d(.clk(clk),.rst(rst),.pkt_vld(pkt_vld),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),.detect_add(detect_add),.ld(ld),.laf(laf),
		.full(full_state),.lfd(lfd),.din(din),.parity_done(parity_done),.low_pkt_vld(low_pkt_vld),.err(err),.dout(data_out));

endmodule
