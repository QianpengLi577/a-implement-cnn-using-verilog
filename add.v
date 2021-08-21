module add    //不同符号的浮点数据相加
(
	input wire MAIN_CLK,    
	input wire [31:0] a,
	input wire [31:0] b,
	
	output wire [31:0] ab
);
 
reg [7:0] pow_a;
reg [7:0] pow_b;
reg [22:0] val_a;
reg [22:0] val_b;
reg flag_a;
reg flag_b;
reg flag;

//比较指数大小提取指数差值
reg [24:0] val_max;
reg [24:0] val_min; 
reg [7:0] pow_diff;
reg [7:0] pow_ab1;
reg flag1;

//计数输出时的数值部分
reg [7:0] pow_ab2;
reg [24:0] val_ab1;
reg flag2;

//对最后的输出指数部分和数据部分进行校准
reg [8:0] pow_ab3;
reg [23:0] val_ab2;
reg flag3;


always @(* )
begin

	flag_a = a[31];   //提取符号
	flag_b= b[31];
	flag = flag_a^flag_b;
	pow_a = a[30:23];
	pow_b = b[30:23];
	val_a = a[22:0];
	val_b = b[22:0];
	if (flag ) begin 
		if(pow_a > pow_b)    
		begin
			flag1 = flag_a;  //输出符号随a
			pow_ab1 = pow_a;
			pow_diff = pow_a - pow_b;
			val_max = {2'b01,val_a};
			val_min = {2'b01,val_b};
		end
	else if(pow_a < pow_b) 
		begin
			flag1 = flag_b;  //输出符号随b
			pow_ab1 = pow_b;
			pow_diff = pow_b - pow_a;
			val_max = {2'b01,val_b};
			val_min = {2'b01,val_a};
		end
	else
		begin
			pow_ab1 = pow_a;
			pow_diff = 0;
			if(val_a > val_b)
				begin
					flag1 = flag_a;  //输出符号随a
					val_max = {2'b01,val_a};
					val_min = {2'b01,val_b};
				end
			else //if(val_a < val_b)
				begin
					flag1 = flag_b;  //输出符号随b
					val_max = {2'b01,val_b};
					val_min = {2'b01,val_a};
				end 
		end 
	end
	
	else begin
		flag1 = flag_a;
	if(pow_a > pow_b)    
		begin
			pow_ab1 = pow_a;
			pow_diff = pow_a - pow_b;
			val_max = {2'b01,val_a};
			val_min = {2'b01,val_b};
		end
	else 
		begin
			pow_ab1 = pow_b;
			pow_diff = pow_b - pow_a;
			val_max = {2'b01,val_b};
			val_min = {2'b01,val_a};
		end
	
	end
	
		flag2 = flag1;
	pow_ab2 = pow_ab1;
	if (flag) begin
	case(pow_diff)
		0: begin val_ab1 = val_max - val_min; end
		1: begin val_ab1 = val_max - {1'b0,val_min[24:1]}; end
		2: begin val_ab1 = val_max - {2'b0,val_min[24:2]}; end
		3: begin val_ab1 = val_max - {3'b0,val_min[24:3]}; end
		4: begin val_ab1 = val_max - {4'b0,val_min[24:4]}; end
		5: begin val_ab1 = val_max - {5'b0,val_min[24:5]}; end
		6: begin val_ab1 = val_max - {6'b0,val_min[24:6]}; end
		7: begin val_ab1 = val_max - {7'b0,val_min[24:7]}; end
		8: begin val_ab1 = val_max - {8'b0,val_min[24:8]}; end
		9: begin val_ab1 = val_max - {9'b0,val_min[24:9]}; end
		10: begin val_ab1 = val_max - {10'b0,val_min[24:10]}; end
		11: begin val_ab1 = val_max - {11'b0,val_min[24:11]}; end
		12: begin val_ab1 = val_max - {12'b0,val_min[24:12]}; end
		13: begin val_ab1 = val_max - {13'b0,val_min[24:13]}; end
		14: begin val_ab1 = val_max - {14'b0,val_min[24:14]}; end
//		15: begin val_ab1 <= val_max - {15'b0,val_min[24:15]}; end
//		16: begin val_ab1 <= val_max - {16'b0,val_min[24:16]}; end
//		17: begin val_ab1 <= val_max - {17'b0,val_min[24:17]}; end
//		18: begin val_ab1 <= val_max - {18'b0,val_min[24:18]}; end
//		19: begin val_ab1 <= val_max - {19'b0,val_min[24:19]}; end
//		20: begin val_ab1 <= val_max - {20'b0,val_min[24:20]}; end
//		21: begin val_ab1 <= val_max - {21'b0,val_min[24:21]}; end
//		22: begin val_ab1 <= val_max - {22'b0,val_min[24:22]}; end
//		23: begin val_ab1 <= val_max - {23'b0,val_min[24:23]}; end
		default: begin val_ab1 = val_max; end
	endcase 
	end
	else begin
	case(pow_diff)
		0: begin val_ab1 = val_max + val_min; end
		1: begin val_ab1 = val_max + {1'b0,val_min[24:1]}; end
		2: begin val_ab1 = val_max + {2'b0,val_min[24:2]}; end
		3: begin val_ab1 = val_max + {3'b0,val_min[24:3]}; end
		4: begin val_ab1 = val_max + {4'b0,val_min[24:4]}; end
		5: begin val_ab1 = val_max + {5'b0,val_min[24:5]}; end
		6: begin val_ab1 = val_max + {6'b0,val_min[24:6]}; end
		7: begin val_ab1 = val_max + {7'b0,val_min[24:7]}; end
		8: begin val_ab1 = val_max + {8'b0,val_min[24:8]}; end
		9: begin val_ab1 = val_max + {9'b0,val_min[24:9]}; end
		10: begin val_ab1 = val_max + {10'b0,val_min[24:10]}; end
		11: begin val_ab1 = val_max + {11'b0,val_min[24:11]}; end
		12: begin val_ab1 = val_max + {12'b0,val_min[24:12]}; end
		13: begin val_ab1 = val_max + {13'b0,val_min[24:13]}; end
		14: begin val_ab1 = val_max + {14'b0,val_min[24:14]}; end
//		15: begin val_ab1 <= val_max + {15'b0,val_min[24:15]}; end
//		16: begin val_ab1 <= val_max + {16'b0,val_min[24:16]}; end
//		17: begin val_ab1 <= val_max + {17'b0,val_min[24:17]}; end
//		18: begin val_ab1 <= val_max + {18'b0,val_min[24:18]}; end
//		19: begin val_ab1 <= val_max + {19'b0,val_min[24:19]}; end
//		20: begin val_ab1 <= val_max + {20'b0,val_min[24:20]}; end
//		21: begin val_ab1 <= val_max + {21'b0,val_min[24:21]}; end
//		22: begin val_ab1 <= val_max + {22'b0,val_min[24:22]}; end
//		23: begin val_ab1 <= val_max + {23'b0,val_min[24:23]}; end
		default: begin val_ab1 = val_max; end
	endcase 
	end
	
	if (flag) begin 
	flag3 = flag2;
	if(val_ab1[23] == 1)   //说明减法过程中数据没有借位
		begin
			pow_ab3 = pow_ab2;
			val_ab2 = val_ab1[23:0]; //得到最后输出的小数部分
		end
	else if(val_ab1[22] == 1)
		begin
			pow_ab3 = pow_ab2 - 1;
			val_ab2 = {val_ab1[22:0],1'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[21] == 1)
		begin
			pow_ab3 = pow_ab2 - 2;
			val_ab2 = {val_ab1[21:0],2'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[20] == 1)
		begin
			pow_ab3 = pow_ab2 - 3;
			val_ab2 = {val_ab1[20:0],3'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[19] == 1)
		begin
			pow_ab3 = pow_ab2 - 4;
			val_ab2 = {val_ab1[19:0],4'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[18] == 1)
		begin
			pow_ab3 = pow_ab2 - 5;
			val_ab2 = {val_ab1[18:0],5'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[17] == 1)
		begin
			pow_ab3 = pow_ab2 - 6;
			val_ab2 = {val_ab1[17:0],6'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[16] == 1)
		begin
			pow_ab3 = pow_ab2 - 7;
			val_ab2 = {val_ab1[16:0],7'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[15] == 1)
		begin
			pow_ab3 = pow_ab2 - 8;
			val_ab2 = {val_ab1[15:0],8'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[14] == 1)
		begin
			pow_ab3 = pow_ab2 - 9;
			val_ab2 = {val_ab1[14:0],9'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[13] == 1)
		begin
			pow_ab3 = pow_ab2 - 10;
			val_ab2 = {val_ab1[13:0],10'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[12] == 1)
		begin
			pow_ab3 = pow_ab2 - 11;
			val_ab2 = {val_ab1[12:0],11'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[11] == 1)
		begin
			pow_ab3 = pow_ab2 - 12;
			val_ab2 = {val_ab1[11:0],12'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[10] == 1)
		begin
			pow_ab3 = pow_ab2 - 13;
			val_ab2 = {val_ab1[10:0],13'b0}; //得到最后输出的小数部分			
		end		
	else
		begin
			pow_ab3 = 0;
			val_ab2 = 0;  
		end 
	end
	
	else begin
	flag3 = flag2;
	if(val_ab1[24] == 1)   //说明加法过程中数据有溢出
		begin
			pow_ab3 = pow_ab2 + 1;
			val_ab2 = val_ab1[24:1]; //得到最后输出的小数部分
		end
	else
		begin
			pow_ab3 = pow_ab2;
			val_ab2 = val_ab1[23:0]; //得到最后输出的小数部分
		end 
	end
	

end

//对输出进行打包 
assign ab = flag ?(pow_ab3[8]==1)?{32'h0}:{flag3,pow_ab3[7:0],val_ab2[22:0]} : {flag3,pow_ab3[7:0],val_ab2[22:0]};
 
endmodule 

/*
module test_add    //不同符号的浮点数据相加
(
	input wire MAIN_CLK,    
	input wire [31:0] a,
	input wire [31:0] b,
	
	output wire [31:0] ab
);
 
reg [7:0] pow_a;
reg [7:0] pow_b;
reg [22:0] val_a;
reg [22:0] val_b;
reg flag_a;
reg flag_b;
reg flag;
always @(*)
begin
	flag_a = a[31];   //提取符号
	flag_b= b[31];
	flag = flag_a^flag_b;
	pow_a = a[30:23];
	pow_b = b[30:23];
	val_a = a[22:0];
	val_b = b[22:0];
end
//比较指数大小提取指数差值
reg [24:0] val_max;
reg [24:0] val_min; 
reg [7:0] pow_diff;
reg [7:0] pow_ab1;
reg flag1;
always @(negedge MAIN_CLK )
begin
	if (flag ) begin 
		if(pow_a > pow_b)    
		begin
			flag1 <= flag_a;  //输出符号随a
			pow_ab1 <= pow_a;
			pow_diff <= pow_a - pow_b;
			val_max <= {2'b01,val_a};
			val_min <= {2'b01,val_b};
		end
	else if(pow_a < pow_b) 
		begin
			flag1 <= flag_b;  //输出符号随b
			pow_ab1 <= pow_b;
			pow_diff <= pow_b - pow_a;
			val_max <= {2'b01,val_b};
			val_min <= {2'b01,val_a};
		end
	else
		begin
			pow_ab1 <= pow_a;
			pow_diff <= 0;
			if(val_a > val_b)
				begin
					flag1 <= flag_a;  //输出符号随a
					val_max <= {2'b01,val_a};
					val_min <= {2'b01,val_b};
				end
			else //if(val_a < val_b)
				begin
					flag1 <= flag_b;  //输出符号随b
					val_max <= {2'b01,val_b};
					val_min <= {2'b01,val_a};
				end 
		end 
	end
	
	else begin
		flag1 <= flag_a;
	if(pow_a > pow_b)    
		begin
			pow_ab1 <= pow_a;
			pow_diff <= pow_a - pow_b;
			val_max <= {2'b01,val_a};
			val_min <= {2'b01,val_b};
		end
	else 
		begin
			pow_ab1 <= pow_b;
			pow_diff <= pow_b - pow_a;
			val_max <= {2'b01,val_b};
			val_min <= {2'b01,val_a};
		end
	
	end
	
end
//计数输出时的数值部分
reg [7:0] pow_ab2;
reg [24:0] val_ab1;
reg flag2;
always @(negedge MAIN_CLK )    //当输入的绝对值较大值是较小值的1万倍以上时，则直接输出较大者
begin
	flag2 <= flag1;
	pow_ab2 <= pow_ab1;
	if (flag) begin
	case(pow_diff)
		0: begin val_ab1 <= val_max - val_min; end
		1: begin val_ab1 <= val_max - {1'b0,val_min[24:1]}; end
		2: begin val_ab1 <= val_max - {2'b0,val_min[24:2]}; end
		3: begin val_ab1 <= val_max - {3'b0,val_min[24:3]}; end
		4: begin val_ab1 <= val_max - {4'b0,val_min[24:4]}; end
		5: begin val_ab1 <= val_max - {5'b0,val_min[24:5]}; end
		6: begin val_ab1 <= val_max - {6'b0,val_min[24:6]}; end
		7: begin val_ab1 <= val_max - {7'b0,val_min[24:7]}; end
		8: begin val_ab1 <= val_max - {8'b0,val_min[24:8]}; end
		9: begin val_ab1 <= val_max - {9'b0,val_min[24:9]}; end
		10: begin val_ab1 <= val_max - {10'b0,val_min[24:10]}; end
		11: begin val_ab1 <= val_max - {11'b0,val_min[24:11]}; end
		12: begin val_ab1 <= val_max - {12'b0,val_min[24:12]}; end
		13: begin val_ab1 <= val_max - {13'b0,val_min[24:13]}; end
		14: begin val_ab1 <= val_max - {14'b0,val_min[24:14]}; end
//		15: begin val_ab1 <= val_max - {15'b0,val_min[24:15]}; end
//		16: begin val_ab1 <= val_max - {16'b0,val_min[24:16]}; end
//		17: begin val_ab1 <= val_max - {17'b0,val_min[24:17]}; end
//		18: begin val_ab1 <= val_max - {18'b0,val_min[24:18]}; end
//		19: begin val_ab1 <= val_max - {19'b0,val_min[24:19]}; end
//		20: begin val_ab1 <= val_max - {20'b0,val_min[24:20]}; end
//		21: begin val_ab1 <= val_max - {21'b0,val_min[24:21]}; end
//		22: begin val_ab1 <= val_max - {22'b0,val_min[24:22]}; end
//		23: begin val_ab1 <= val_max - {23'b0,val_min[24:23]}; end
		default: begin val_ab1 <= val_max; end
	endcase 
	end
	else begin
	case(pow_diff)
		0: begin val_ab1 <= val_max + val_min; end
		1: begin val_ab1 <= val_max + {1'b0,val_min[24:1]}; end
		2: begin val_ab1 <= val_max + {2'b0,val_min[24:2]}; end
		3: begin val_ab1 <= val_max + {3'b0,val_min[24:3]}; end
		4: begin val_ab1 <= val_max + {4'b0,val_min[24:4]}; end
		5: begin val_ab1 <= val_max + {5'b0,val_min[24:5]}; end
		6: begin val_ab1 <= val_max + {6'b0,val_min[24:6]}; end
		7: begin val_ab1 <= val_max + {7'b0,val_min[24:7]}; end
		8: begin val_ab1 <= val_max + {8'b0,val_min[24:8]}; end
		9: begin val_ab1 <= val_max + {9'b0,val_min[24:9]}; end
		10: begin val_ab1 <= val_max + {10'b0,val_min[24:10]}; end
		11: begin val_ab1 <= val_max + {11'b0,val_min[24:11]}; end
		12: begin val_ab1 <= val_max + {12'b0,val_min[24:12]}; end
		13: begin val_ab1 <= val_max + {13'b0,val_min[24:13]}; end
		14: begin val_ab1 <= val_max + {14'b0,val_min[24:14]}; end
//		15: begin val_ab1 <= val_max + {15'b0,val_min[24:15]}; end
//		16: begin val_ab1 <= val_max + {16'b0,val_min[24:16]}; end
//		17: begin val_ab1 <= val_max + {17'b0,val_min[24:17]}; end
//		18: begin val_ab1 <= val_max + {18'b0,val_min[24:18]}; end
//		19: begin val_ab1 <= val_max + {19'b0,val_min[24:19]}; end
//		20: begin val_ab1 <= val_max + {20'b0,val_min[24:20]}; end
//		21: begin val_ab1 <= val_max + {21'b0,val_min[24:21]}; end
//		22: begin val_ab1 <= val_max + {22'b0,val_min[24:22]}; end
//		23: begin val_ab1 <= val_max + {23'b0,val_min[24:23]}; end
		default: begin val_ab1 <= val_max; end
	endcase 
	end
	
end 	 
//对最后的输出指数部分和数据部分进行校准
reg [8:0] pow_ab3;
reg [23:0] val_ab2;
reg flag3;
always @(negedge MAIN_CLK )
begin

	if (flag) begin 
	flag3 <= flag2;
	if(val_ab1[23] == 1)   //说明减法过程中数据没有借位
		begin
			pow_ab3 <= pow_ab2;
			val_ab2 <= val_ab1[23:0]; //得到最后输出的小数部分
		end
	else if(val_ab1[22] == 1)
		begin
			pow_ab3 <= pow_ab2 - 1;
			val_ab2 <= {val_ab1[22:0],1'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[21] == 1)
		begin
			pow_ab3 <= pow_ab2 - 2;
			val_ab2 <= {val_ab1[21:0],2'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[20] == 1)
		begin
			pow_ab3 <= pow_ab2 - 3;
			val_ab2 <= {val_ab1[20:0],3'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[19] == 1)
		begin
			pow_ab3 <= pow_ab2 - 4;
			val_ab2 <= {val_ab1[19:0],4'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[18] == 1)
		begin
			pow_ab3 <= pow_ab2 - 5;
			val_ab2 <= {val_ab1[18:0],5'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[17] == 1)
		begin
			pow_ab3 <= pow_ab2 - 6;
			val_ab2 <= {val_ab1[17:0],6'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[16] == 1)
		begin
			pow_ab3 <= pow_ab2 - 7;
			val_ab2 <= {val_ab1[16:0],7'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[15] == 1)
		begin
			pow_ab3 <= pow_ab2 - 8;
			val_ab2 <= {val_ab1[15:0],8'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[14] == 1)
		begin
			pow_ab3 <= pow_ab2 - 9;
			val_ab2 <= {val_ab1[14:0],9'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[13] == 1)
		begin
			pow_ab3 <= pow_ab2 - 10;
			val_ab2 <= {val_ab1[13:0],10'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[12] == 1)
		begin
			pow_ab3 <= pow_ab2 - 11;
			val_ab2 <= {val_ab1[12:0],11'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[11] == 1)
		begin
			pow_ab3 <= pow_ab2 - 12;
			val_ab2 <= {val_ab1[11:0],12'b0}; //得到最后输出的小数部分			
		end
	else if(val_ab1[10] == 1)
		begin
			pow_ab3 <= pow_ab2 - 13;
			val_ab2 <= {val_ab1[10:0],13'b0}; //得到最后输出的小数部分			
		end		
	else
		begin
			pow_ab3 <= 0;
			val_ab2 <= 0;  
		end 
	end
	
	else begin
	flag3 <= flag2;
	if(val_ab1[24] == 1)   //说明加法过程中数据有溢出
		begin
			pow_ab3 <= pow_ab2 + 1;
			val_ab2 <= val_ab1[24:1]; //得到最后输出的小数部分
		end
	else
		begin
			pow_ab3 <= pow_ab2;
			val_ab2 <= val_ab1[23:0]; //得到最后输出的小数部分
		end 
	end
end
//对输出进行打包 
assign ab = flag ?(pow_ab3[8]==1)?{32'h0}:{flag3,pow_ab3[7:0],val_ab2[22:0]} : {flag3,pow_ab3[7:0],val_ab2[22:0]};
 
endmodule 
*/