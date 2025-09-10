module router_sync(input detect_add,we_reg,clock,resetn,read0,read1,read2,empty0,empty1,empty2,fifo0,fifo1,fifo2,input [1:0]din,output vld0,vld1,vld2,output reg fifo_full,soft_rst0,soft_rst1,soft_rst2,output reg[2:0]we);


reg [1:0]temp;
reg [4:0]count0,count1,count2;

	always@(posedge clock)
	begin
		if(!resetn)
			temp<=0;
		else if(detect_add)
			temp<=din;
		else
			temp<=temp;

	end

	always@(*)
	begin
		if(we_reg)
		begin
			case(temp)
				2'b00:we=3'b001;
				2'b01:we=3'b010;
				2'b10:we=3'b100;
				2'b11:we=3'b000;
			endcase
		end

		else
			we=3'b000;
	end


	always@(*)
	begin
		case(temp)
			2'b00:fifo_full=fifo0;
			2'b01:fifo_full=fifo1;
			2'b10:fifo_full=fifo2;
			2'b11:fifo_full=0;
		endcase
	end

	assign vld0=~empty0;
	assign vld1=~empty1;
	assign vld2=~empty2;

	
	always@(posedge clock)
		begin
		
			if(!resetn)begin
				count0<=5'd0;
				soft_rst0<=1'd0;end
				
			else if(!vld0)begin
			   count0<=5'd0;
				soft_rst0<=1'd0;end	
				
		   else if(read0)begin
				count0<=5'd0;
				soft_rst0<=1'd0;end
				
			else if(count0==5'd29)begin
				count0<=5'd0;
				soft_rst0<=1'd1;end
			
			else if(count0!=5'd29)begin
				count0<=count0+1'b1;
				soft_rst0<=1'd0;end
		
			
		end
	always@(posedge clock)begin
			if(!resetn)begin
				count1<=5'd0;
				soft_rst1<=1'd0;end
				
			else if(!vld1)begin
		   	count1<=5'd0;
				soft_rst1<=1'd0;end
				
		  else if(read1)begin
				count1<=5'd0;
				soft_rst1<=1'd0; end	
				
		  else if(count1==5'd29)begin
				count1<=5'd0;
				soft_rst1<=1'd1;end 
			
		  else if(count1!=5'd29)begin
				count1<=count1+1'b1;
				soft_rst1<=1'd0;end
			
		end

	always@(posedge clock)begin
		
		if(!resetn)begin
				count2<=5'd0;
				soft_rst2<=1'd0;end
				
		else if(!vld2)begin
			count2<=5'd0;
				soft_rst2<=1'd0;end
				
		else if(read2)begin
				count2<=5'd0;
				soft_rst2<=1'd0;end
				
		else if(count2==5'd29)begin
				count2<=5'd0;
				soft_rst2<=1'd1;end
			
		else if(count2!=5'd29)begin
				count2<=count2+1'b1;
				soft_rst2<=1'd0;end

		        
				 
	end
	endmodule
