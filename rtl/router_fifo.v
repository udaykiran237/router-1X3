module router_fifo(input clock,resetn,we,soft_reset,re,lfd,input [7:0]din,output empty,full,output reg [7:0]d_out);

	reg [4:0]wptr,rptr;
	reg [8:0]mem[15:0];
	reg [7:0]count;
	reg temp;
	integer i,j;

always@(posedge clock)
begin
if(!resetn)
temp<=1'b0;
else
temp<=lfd;
end

	//writing
	always@(posedge clock)
	begin
		if(!resetn)
		begin
			wptr<=0;
			for(i=0;i<16;i=i+1)
					mem[i]<=0;
		end	
				else if(soft_reset)
				begin
					for(j=0;j<16;j=j+1)
						mem[i]<=0;
				end

					else if((we)&&(!full))
					begin
						mem[wptr[3:0]]<={temp,din};
						wptr<=wptr+1;
						end
						//else
						//wptr<=0;
	end
	
	//reading	

	always@(posedge clock)
	begin
		if(!resetn)
		begin
			rptr<=0;
			d_out<=8'bz;
      end			
		else if(soft_reset)
    			d_out<=8'bz;

		else if((re)&&(~empty))
        begin
 			d_out<=mem[rptr[3:0]];
				rptr<=rptr+1;
				//if(rptr==5'd16)
			//	rptr<=0;
				end
		else if(count==0)
			d_out<=8'bz;
			//else
			//rptr<=0;
	end
							
	
	//counting
	
	always@(posedge clock)
	begin
		if(~resetn)
			count<=0;
		else if(soft_reset)
			count<=0;
		else if((re)&&(~empty))
		begin
			if(mem[rptr[3:0]][8]==1'b1)
				count<=mem[rptr[3:0]][7:2]+5'h1;
			else if(count!=7'b0)
				count<=count-7'b1;
      end
	end

	assign full=((wptr==5'd16)&&(rptr==0));
	assign empty=(wptr==rptr);
endmodule
