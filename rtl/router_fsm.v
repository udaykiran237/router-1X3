module router_fsm(input clk,rst,pkt_vld,parity_done,soft_rst0,soft_rst1,soft_rst2,
fifo_full,low_pkt_vld,empty0,empty1,empty2,
input [1:0]din,output busy,detect_add,ld,laf,full,write_enb_reg,rst_int_reg,lfd);



	parameter decode_address=3'b000;
	parameter load_first_data=3'b001;	
	parameter load_data=3'b010;
	parameter fifo_full_state=3'b011;
	parameter wait_till_empty=3'b100;
	parameter load_after_full=3'b101;	
	parameter load_parity=3'b110;
	parameter check_parity_error=3'b111;
	
	reg [2:0]state,nextstate;

	always@(posedge clk)
	begin
		if(!rst)
		state<=decode_address;
	        else if(soft_rst0||soft_rst1||soft_rst2)
			state<=decode_address;
		else
			state<=nextstate;
	end

	always@(*)
	begin
		case(state)

		decode_address:if((pkt_vld&&(din[1:0]==2'd0)&&empty0)||(pkt_vld&&(din[1:0]==2'd1)&&empty1)||(pkt_vld&&(din[1:0]==2'd2)&&empty2))
						nextstate=load_first_data;
					
					else if((pkt_vld&&(din[1:0]==0)&&!empty0)||(pkt_vld&&(din[1:0]==1)&&!empty1)||(pkt_vld&&(din[1:0]==2)&&!empty2))
					nextstate=wait_till_empty;
					else
						nextstate=decode_address;

			load_first_data:nextstate=load_data;

			load_data:if(!fifo_full&&!pkt_vld)
				  nextstate=load_parity;
			  	 else if(fifo_full && pkt_vld)
					 nextstate=fifo_full_state;
				 else
					 nextstate=load_data;
			fifo_full_state:if(!fifo_full)
					nextstate=load_after_full;
					else if(fifo_full)
					nextstate=fifo_full_state;

			load_after_full:
					 if(!parity_done&&low_pkt_vld)
					nextstate=load_parity;
					else if((!parity_done)&&(!low_pkt_vld))
					nextstate=load_data;
					else if(parity_done)
					nextstate=decode_address;

			load_parity:nextstate=check_parity_error;

			check_parity_error:if(!fifo_full)
					   nextstate=decode_address;
				   	   else if(fifo_full)
					   nextstate=fifo_full_state;
			wait_till_empty:if((empty0&&(din==0))||(empty1&&(din==1))||(empty2&&(din==2)))
					nextstate=load_first_data;
					else
						nextstate=wait_till_empty;
		endcase
	end

	assign detect_add=(state==decode_address)?1'b1:1'b0;
	assign ld=(state==load_data)?1'b1:1'b0;
	assign laf=(state==load_after_full)?1'b1:1'b0;
	assign full=(state==fifo_full_state)?1'b1:1'b0;
	assign lfd=(state==load_first_data)?1'b1:1'b0;
	assign write_enb_reg=(state==load_parity||state==load_data||state==load_after_full)?1'b1:1'b0;
	assign rst_int_reg=(state==check_parity_error)?1'b1:1'b0;
	assign busy=(state==load_data||state==decode_address)?1'b0:1'b1;
endmodule
