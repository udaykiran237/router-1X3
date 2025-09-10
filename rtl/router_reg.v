module router_reg(input clk,rst,pkt_vld,fifo_full,rst_int_reg,detect_add,ld,laf,full,lfd,input [7:0]din,output reg parity_done,low_pkt_vld,err,output reg [7:0]dout);

reg [7:0]header;
reg [7:0]internal_parity;
reg [7:0]packet_parity;
reg [7:0]FIFO_full;

//logic for dout
always@(posedge clk)
begin
	if(!rst)
	begin
		dout<=3'd0;
		/*err<=1'b0;
		low_pkt_vld<=1'b0;
		parity_done<=1'b0;*/

	end
	else if(detect_add&pkt_vld)
		dout<=dout;
	else if((lfd)&&(din[1:0]!=3))
		dout<=header;
	else if((ld)&&(!fifo_full))
		dout<=din;
	else if((ld)&&(fifo_full))
		dout<=dout;
	else if (laf)
		dout<=FIFO_full;
		
end

always@(posedge clk)
begin
	if(!rst)
		header<=0;
	else if(detect_add&&pkt_vld&&din[1:0]!=3)
		header<=din;
end

always@(posedge clk)
begin
	if(!rst)
		internal_parity<=0;
	else if(detect_add)
		internal_parity<=0;
	else if(lfd)
		internal_parity<=internal_parity^header;
	else if (pkt_vld&&ld&&!full)
		internal_parity<=internal_parity^din;
end

always@(posedge clk)
begin
	if(!rst)
	packet_parity<=0;
	else if(detect_add)
	packet_parity<=0;
	else if(ld&&~pkt_vld)
	packet_parity<=din;
end


//low pkt vld logic
always@(posedge clk)
begin
if(!rst)
low_pkt_vld<=1'b0;
else if((ld)&&(!pkt_vld))
low_pkt_vld<=1'b1;
else if(rst_int_reg)
low_pkt_vld<=1'b0;
end

//error logic
always@(posedge clk)
begin
if(!rst)
err<=1'b0;
else if(parity_done)
begin
	if(packet_parity!=internal_parity)
   err<=1'b1;
	else 
	err<=1'b0;
end
else
err<=err;
end

//fifo_full logic

always@(posedge clk)
begin
if(!rst)
FIFO_full<=3'd0;
else if((fifo_full==1'b1)&&(ld))
FIFO_full<=din;

else
FIFO_full<=FIFO_full;
end

//parity done logic
always@(posedge clk)
begin
if(!rst)
parity_done<=3'd0;
else if(((ld)&&(!fifo_full)&&(!pkt_vld))||((laf)&&(low_pkt_vld)&&(parity_done==1'd0)))
parity_done<=3'd1;
else if(detect_add)
parity_done<=1'b0;
else
parity_done<=parity_done;
end
endmodule
