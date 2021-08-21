//module move_row_data(clk,en,data_in,)


module get_data(clk,rst,data,data_kernel,mul_en,kernel_en);
input clk;
input rst;
input [31:0] data;
output reg [32*9 -1 :0] data_kernel;
output wire mul_en;//用于标记卷积数据是否准备好
output wire kernel_en;

wire [32*28-1:0] data_row1,data_row2,data_row3;//三行的data

reg flag1,flag2,flag3,flag4;//四个标志位 flag4表示开始行传递
reg [6:0] count1,count2,count3;//三个计数标记符
reg [9:0] count;
wire [31:0] data1,data2,data3;
reg [31:0] d1,d2;
reg finsh;

assign data1 = flag4 ? d1 : data;
assign data2 = flag4 ? d2 : data;
assign data3 = data;
assign kernel_en = (count==0 | count >726) ? 1'b0 : 1'b1;
initial begin
	flag1 = 0;
	flag2 = 0;
	flag3 = 0;
	flag4 = 0;
	count1 = 0;
	count2 = 0;
	count3 = 0;
	finsh = 0;
	count = 0;
end
move_row_data row1(clk,rst,flag1,data1,data_row1);
move_row_data row2(clk,rst,flag2,data2,data_row2);
move_row_data row3(clk,rst,flag3,data3,data_row3);

always @(posedge clk )begin

	if(count3 <28) begin
		if (count3 == 27) finsh = 1;
		if(count2 <28)begin
			if(count1 <28)begin
			   if (count1 == 0) flag1 = 1;
				count1 = count1 + 1;
			end
			else begin
				flag1 =0;
				flag2 =1;
				count2 = count2 + 1;
			end
		end
		else begin
			flag2 = 0;
			flag3 = 1;
			count3 = count3 + 1;
		end
	end
	else begin
		flag1 = 1;
		flag2 = 1;
		flag3 = 1;
		flag4 = 1;
	end
	d1 = data_row2[31:0];
	d2 = data_row3[31:0];
	data_kernel[31:0]= flag4 ? data_row1[31:0] : data_kernel[31:0];
	data_kernel[63:32]=flag4 ? data_row1[63:32] : data_kernel[63:32];
	data_kernel[95:64]=flag4 ? data_row1[95:64] : data_kernel[95:64];
	data_kernel[127:96]=flag4 ? data_row2[31:0] : data_kernel[127:96];
	data_kernel[159:128]=flag4 ? data_row2[63:32] : data_kernel[159:128];
	data_kernel[191:160]=flag4 ? data_row2[95:64] : data_kernel[191:160];
	data_kernel[223:192]=flag4 ? data_row3[31:0] : data_kernel[223:192];
	data_kernel[255:224]=flag4 ? data_row3[63:32] : data_kernel[255:224];
	data_kernel[287:256]=flag4 ? data_row3[95:64] : data_kernel[287:256];
	count = flag4 ? count + 1 : count;
end

assign mul_en = flag1 | flag2 |flag3 |flag4;
endmodule



module move_row_data(clk,rst,en,data_in,data_out);

input clk;
input en;
input rst;
input  [31:0] data_in ;
output reg [32*28-1:0] data_out ;

always @(data_in or clk or en )
begin
	if (en &(~clk)) begin
		data_out[31:0]=data_out[63:32];
		data_out[63:32]=data_out[95:64];
		data_out[95:64]=data_out[127:96];
		data_out[127:96]=data_out[159:128];
		data_out[159:128]=data_out[191:160];
		data_out[191:160]=data_out[223:192];
		data_out[223:192]=data_out[255:224];
		data_out[255:224]=data_out[287:256];
		data_out[287:256]=data_out[319:288];
		data_out[319:288]=data_out[351:320];
		data_out[351:320]=data_out[383:352];
		data_out[383:352]=data_out[415:384];
		data_out[415:384]=data_out[447:416];
		data_out[447:416]=data_out[479:448];
		data_out[479:448]=data_out[511:480];
		data_out[511:480]=data_out[543:512];
		data_out[543:512]=data_out[575:544];
		data_out[575:544]=data_out[607:576];
		data_out[607:576]=data_out[639:608];
		data_out[639:608]=data_out[671:640];
		data_out[671:640]=data_out[703:672];
		data_out[703:672]=data_out[735:704];
		data_out[735:704]=data_out[767:736];
		data_out[767:736]=data_out[799:768];
		data_out[799:768]=data_out[831:800];
		data_out[831:800]=data_out[863:832];
		data_out[863:832]=data_out[895:864];
		data_out[895:864]=data_in;
	end
	else begin
		data_out = data_out;
	end

end
endmodule
