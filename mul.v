//**
//Author:                   Luk.wj
//Create:                  2020.11.19
//Revise:                  2020.11.24
//Fuction:   Two-stage assembly line floating point multiplier with single precision
//功能：              2级流水线的单精度浮点乘法器(IEEE Standard)
//**
module mul(flout_a,flout_b,clk,en,rst,round_cfg,flout_c,overflow); 
 input[31:0] flout_a;           // 输入的被乘数
 input[31:0] flout_b;           // 输入的乘数
 input clk;                     // 时钟信号
 input en;                      // 使能信号
 input rst;                     // 复位信号
 input round_cfg;               // 决定舍入的方法，0采用chopping，1采用就近舍入 
 output[31:0] flout_c;          // 输出运算结果
 output[1:0] overflow;          // 输出溢出标志
 reg[31:0] flout_c;
 reg[1:0] overflow;
 wire s1,s2;                     // 输入数符号
 wire[7:0] exp1,exp2;            // 输入阶码
 wire[23:0] man1,man2;           // 输入尾数，多一位，把默认的‘1’加上
 reg n;                         // 左归阶码
 reg[9:0] temp1,temp2,temp3;    // 多两位，用于阶码的双符号表示，判断溢出
 reg[47:0] mul_out_p;           // 第二级逻辑运算尾数部分

 //-------‘s'为符号，'e'为阶码，'m’为尾数------------//
 //第一级逻辑输出
 reg       one_s_out;
 reg[9:0]  one_e_out;
 reg[47:0] one_m_out;
 
 //第一级流水寄存
 reg       one_s_reg; 
 reg[9:0]  one_e_reg; 
 reg[47:0] one_m_reg;
 

 //第二级逻辑输出
 reg[1:0]  two_f_out; //溢出
 reg[7:0]  two_e_out; 
 reg[22:0] two_m_out; 

 //第二级流水寄存
 reg       two_s_reg;
 reg[1:0]  two_f_reg; //溢出
 reg[7:0]  two_e_reg;
 reg[22:0] two_m_reg;

/*---------------提取flout_a 的符号,阶码,尾数---------------------*/

 
       assign s1   = flout_a[31];
       assign exp1 = flout_a[30:23];
      assign  man1 = {1'b1,flout_a[22:0]};
	assign s2   = flout_b[31];
       assign exp2 = flout_b[30:23];
      assign man2 = {1'b1,flout_b[22:0]};

 


/*--------------------第一级逻辑运算---------------------------------*/
//符号位
always@(*)  one_s_out = s1^s2;  //输入符号异或

//尾数相乘
always@(*) 
 begin
  if(man1 == 24'b10000000000_0000000000000)
	  one_m_out = 48'b0;
	else if(man2 == 24'b10000000000_0000000000000)
	  one_m_out = 48'b0;
	else
	  one_m_out = man1*man2; //48位
end

//阶码相加,阶码是移码,移码是符号位取反的补码
always@(*) 
//把阶码的移码形式变为补码形式，并且转成双符号位格式,00为正,11为负
 begin
   if(exp1[7] == 1)
     temp1 = {2'b00,1'b0,exp1[6:0]};
   else 
	   temp1 = {2'b11,1'b1,exp1[6:0]};
   if(exp2[7] == 1)
     temp2 = {2'b00,1'b0,exp2[6:0]};
   else
	   temp2 = {2'b11,1'b1,exp2[6:0]}; 
   one_e_out[9:0] = temp1[9:0] + temp2[9:0];        //阶码以双符号补码的形式相加计算
end
/*----------------------------------------------------------------*/

//第一级流水寄存
always@(clk)
 begin
   one_s_reg <= one_s_out;
	 one_e_reg <= one_e_out;
	 one_m_reg <= one_m_out;
end

/*--------------------第二级逻辑运算---------------------------------*/
//尾数规范化及舍入处理，溢出判断
always@(*) 
 begin
   if(one_m_reg == 48'b0000000000_0000000000000)
     begin
       two_m_out =  23'b0;
       n  =  1'b0;
     end  // 处理特殊值
	 else
	   begin
		  if(one_m_reg[47] == 1)
		   begin
		     n  = 1'b1;                  //左归码为1
			   mul_out_p = one_m_reg >> 1; //右移一位
		  end
		  else
		   begin
			  n   = 1'b0;                 //左归码为0
			  mul_out_p = one_m_reg;      //不需要右移
			end
		 if(round_cfg == 1)         //0采用chopping，1采用就近舍入 
		   begin
		     if(mul_out_p[22] == 1)
			    two_m_out[22:0] = mul_out_p[45:23]+1'b1;
			   else
			    two_m_out[22:0] = mul_out_p[45:23];
		   end
		  else
		 	 two_m_out[22:0] = mul_out_p[45:23];
    end
   //双符号的定义，01为上溢，10为下溢，符号相同无溢出
   temp3 = one_e_reg[9:0] + n + 1'b1;  //加上左归阶码,因为补码与移码的转换是-128，而IEEE是-127，故加上1
	 if(temp3[9:8] == 2'b01)  
     two_f_out = 2'b01; //阶码上溢
   else if(temp3[9:8] == 2'b10)  
	  two_f_out = 2'b10; //阶码下溢
   else 
	  two_f_out = 2'b00; //无溢出
	 //输出补码转回移码
   case(temp3[7])  
     1'b1:  two_e_out = {1'b0,temp3[6:0]}; 
     1'b0:  two_e_out = {1'b1,temp3[6:0]}; 
   endcase
end
/*----------------------------------------------------------------*/

//第二级流水寄存
always@(clk) 
 begin
   if(two_m_out == 0) //特殊值处理
	  begin
	     two_s_reg <= 1'b0;
		   two_e_reg <= 8'b0;
		   two_m_reg <= 23'b0;
	     two_f_reg <= 2'b00;
	  end
   else
	  begin
       two_s_reg <= one_s_reg;
       two_f_reg <= two_f_out;
       two_e_reg <= two_e_out;
       two_m_reg <= two_m_out;
	  end
end

//输出结果
always@(*) 
 begin
	  flout_c  = {two_s_reg,two_e_reg[7:0],two_m_reg[22:0]};
	  overflow = two_f_reg;
end

endmodule

//**
//Author:                   Luk.wj
//Create:                  2020.11.19
//Revise:                  2020.11.24
//Fuction:   Two-stage assembly line floating point multiplier with single precision
//功能：              2级流水线的单精度浮点乘法器(IEEE Standard)
//**
module two_line_float_p_mul(flout_a,flout_b,clk,en,rst,round_cfg,flout_c,overflow); 
 input[31:0] flout_a;           // 输入的被乘数
 input[31:0] flout_b;           // 输入的乘数
 input clk;                     // 时钟信号
 input en;                      // 使能信号
 input rst;                     // 复位信号
 input round_cfg;               // 决定舍入的方法，0采用chopping，1采用就近舍入 
 output[31:0] flout_c;          // 输出运算结果
 output[1:0] overflow;          // 输出溢出标志
 reg[31:0] flout_c;
 reg[1:0] overflow;
 reg s1,s2;                     // 输入数符号
 reg[7:0] exp1,exp2;            // 输入阶码
 reg[23:0] man1,man2;           // 输入尾数，多一位，把默认的‘1’加上
 reg n;                         // 左归阶码
 reg[9:0] temp1,temp2,temp3;    // 多两位，用于阶码的双符号表示，判断溢出
 reg[47:0] mul_out_p;           // 第二级逻辑运算尾数部分

 //-------‘s'为符号，'e'为阶码，'m’为尾数------------//
 //第一级逻辑输出
 reg       one_s_out;
 reg[9:0]  one_e_out;
 reg[47:0] one_m_out;
 
 //第一级流水寄存
 reg       one_s_reg; 
 reg[9:0]  one_e_reg; 
 reg[47:0] one_m_reg;
 

 //第二级逻辑输出
 reg[1:0]  two_f_out; //溢出
 reg[7:0]  two_e_out; 
 reg[22:0] two_m_out; 

 //第二级流水寄存
 reg       two_s_reg;
 reg[1:0]  two_f_reg; //溢出
 reg[7:0]  two_e_reg;
 reg[22:0] two_m_reg;

/*---------------提取flout_a 的符号,阶码,尾数---------------------*/
always@(*) 
 begin
   if(!rst)
     begin       //复位，初始化
       s1   = 1'b0;
       exp1 = 8'b0000_0000;
       man1 = {1'b1,23'b0};
     end
	 else if(en) 
     begin
       s1   = flout_a[31];
       exp1 = flout_a[30:23];
       man1 = {1'b1,flout_a[22:0]};
	   end
 end
 
/*---------------提取flout_b 的符号,阶码,尾数---------------------*/
always@(*) 
 begin
   if(!rst)
     begin      //复位，初始化
       s2   = 1'b0;
       exp2 = 8'b0000_0000;
       man2 = {1'b1,23'b0};
     end
   else if(en) 
     begin
       s2   = flout_b[31];
       exp2 = flout_b[30:23];
       man2 = {1'b1,flout_b[22:0]};
     end
end

/*--------------------第一级逻辑运算---------------------------------*/
//符号位
always@(*)  one_s_out = s1^s2;  //输入符号异或

//尾数相乘
always@(*) 
 begin
  if(man1 == 24'b10000000000_0000000000000)
	  one_m_out = 48'b0;
	else if(man2 == 24'b10000000000_0000000000000)
	  one_m_out = 48'b0;
	else
	  one_m_out = man1*man2; //48位
end

//阶码相加,阶码是移码,移码是符号位取反的补码
always@(*) 
//把阶码的移码形式变为补码形式，并且转成双符号位格式,00为正,11为负
 begin
   if(exp1[7] == 1)
     temp1 = {2'b00,1'b0,exp1[6:0]};
   else 
	   temp1 = {2'b11,1'b1,exp1[6:0]};
   if(exp2[7] == 1)
     temp2 = {2'b00,1'b0,exp2[6:0]};
   else
	   temp2 = {2'b11,1'b1,exp2[6:0]}; 
   one_e_out[9:0] = temp1[9:0] + temp2[9:0];        //阶码以双符号补码的形式相加计算
end
/*----------------------------------------------------------------*/

//第一级流水寄存
always@(posedge clk)
 begin
   one_s_reg <= one_s_out;
	 one_e_reg <= one_e_out;
	 one_m_reg <= one_m_out;
end

/*--------------------第二级逻辑运算---------------------------------*/
//尾数规范化及舍入处理，溢出判断
always@(*) 
 begin
   if(one_m_reg == 48'b0000000000_0000000000000)
     begin
       two_m_out =  23'b0;
       n  =  1'b0;
     end  // 处理特殊值
	 else
	   begin
		  if(one_m_reg[47] == 1)
		   begin
		     n  = 1'b1;                  //左归码为1
			   mul_out_p = one_m_reg >> 1; //右移一位
		  end
		  else
		   begin
			  n   = 1'b0;                 //左归码为0
			  mul_out_p = one_m_reg;      //不需要右移
			end
		 if(round_cfg == 1)         //0采用chopping，1采用就近舍入 
		   begin
		     if(mul_out_p[22] == 1)
			    two_m_out[22:0] = mul_out_p[45:23]+1'b1;
			   else
			    two_m_out[22:0] = mul_out_p[45:23];
		   end
		  else
		 	 two_m_out[22:0] = mul_out_p[45:23];
    end
   //双符号的定义，01为上溢，10为下溢，符号相同无溢出
   temp3 = one_e_reg[9:0] + n + 1'b1;  //加上左归阶码,因为补码与移码的转换是-128，而IEEE是-127，故加上1
	 if(temp3[9:8] == 2'b01)  
     two_f_out = 2'b01; //阶码上溢
   else if(temp3[9:8] == 2'b10)  
	  two_f_out = 2'b10; //阶码下溢
   else 
	  two_f_out = 2'b00; //无溢出
	 //输出补码转回移码
   case(temp3[7])  
     1'b1:  two_e_out = {1'b0,temp3[6:0]}; 
     1'b0:  two_e_out = {1'b1,temp3[6:0]}; 
   endcase
end
/*----------------------------------------------------------------*/

//第二级流水寄存
always@(posedge clk) 
 begin
   if(two_m_out == 0) //特殊值处理
	  begin
	     two_s_reg <= 1'b0;
		   two_e_reg <= 8'b0;
		   two_m_reg <= 23'b0;
	     two_f_reg <= 2'b00;
	  end
   else
	  begin
       two_s_reg <= one_s_reg;
       two_f_reg <= two_f_out;
       two_e_reg <= two_e_out;
       two_m_reg <= two_m_out;
	  end
end

//输出结果
always@(*) 
 begin
	  flout_c  = {two_s_reg,two_e_reg[7:0],two_m_reg[22:0]};
	  overflow = two_f_reg;
end

endmodule

