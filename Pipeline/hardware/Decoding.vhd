----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:33:46 11/09/2013 
-- Design Name: 
-- Module Name:    Decoding - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
--Import from Single Cycle Written by Yee Tang, Hu Yang and Haoxuan
--Pipeline written by Yee Tang
--Pipeline debug by Yee Tang and Hu Yang
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Decoding IS
 PORT (
	Clock						: IN STD_LOGIC;
	Reset  					: IN STD_LOGIC; 
	RegWrite_3  			: IN STD_LOGIC;
	MemtoReg_3  			: IN STD_LOGIC;
	JumpAL_1					: IN STD_LOGIC;
	JumpALR_1				: IN STD_LOGIC;
	Shift_1					: IN STD_LOGIC;
	Shifti_1					: IN STD_LOGIC;  
	IDEX_MRead  			: IN STD_LOGIC;
	Branch_1  				: IN  STD_LOGIC;
	Branch_NE_1  			: IN  STD_LOGIC;
	BGEZAL_EN				: IN STD_LOGIC;  	
	IDEXMRead_out 			: OUT STD_LOGIC; 	
	RegWriteOut  			: OUT STD_LOGIC;
	Branch_2  				: OUT  STD_LOGIC;
	Branch_NE_2  			: OUT  STD_LOGIC;	
	wAddr_2 					: IN STD_LOGIC_VECTOR  (4 DOWNTO 0);  
	IDEX_Reg_Rt 			: IN STD_LOGIC_VECTOR  (4 DOWNTO 0); 
	IFID_Reg_Rs 			: IN STD_LOGIC_VECTOR  (4 DOWNTO 0);  
	IFID_Reg_Rt 			: IN STD_LOGIC_VECTOR  (4 DOWNTO 0); 
	IDEXReg_Rt_out 		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	IFIDReg_Rs_out 		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	IFIDReg_Rt_out 		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);	
	rData_1  				: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);	
	wData  					: IN STD_LOGIC_VECTOR  (31 DOWNTO 0); 
	ALU_Result_2  			: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);
	Instr_1  				: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);
	PC_plus_4_1    		: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);	
	Operand1					: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);
	Operand2					: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);  	 	
	Mul_result_1 			: IN STD_LOGIC_VECTOR  (63 downto 0);	
	wAddr_0_1 				: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	wAddr_1_1 				: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	wAddr_2_1 				: OUT STD_LOGIC_VECTOR (4 DOWNTO 0); 	
	wAddr_3 					: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	rData_1_1  				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_2_1   			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); 
	SE_1  					: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	RegwData  				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	Instr_2  				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	PC_plus_4_2  			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	Lui_Extend_1 			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); 
	Lo_reg_1 				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	Hi_reg_1 				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	Jump_Instr_1 			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);  
	Result1					: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	Result2					: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)    
  );
END Decoding;

ARCHITECTURE behavioral OF Decoding IS
	component Switch2to1 is
	generic (N:integer);
		 Port ( 
		 input 		: in  STD_LOGIC;
		 A 			: in  STD_LOGIC_VECTOR (N downto 0);
		 B 			: in  STD_LOGIC_VECTOR (N downto 0);
		 output 		: out  STD_LOGIC_VECTOR (N downto 0));
	end component;	

TYPE reg_file IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL reg_array  : reg_file := (
	others => x"00000000"
);
 SIGNAL Local_JumpAL					: STD_LOGIC;
 SIGNAL Local_JumpALR				: STD_LOGIC;
 SIGNAL Local_Shift					: STD_LOGIC;
 SIGNAL Local_Shifti					: STD_LOGIC;	
 SIGNAL read_reg_addr1 				: STD_LOGIC_VECTOR (4 DOWNTO 0); 
 SIGNAL read_reg_addr2 				: STD_LOGIC_VECTOR (4 DOWNTO 0);
 SIGNAL instr_15_0 					: STD_LOGIC_VECTOR (15 DOWNTO 0);
 SIGNAL instr_25_0 					: STD_LOGIC_VECTOR (25 DOWNTO 0);
 SIGNAL write_reg_addr0				: STD_LOGIC_VECTOR (4 DOWNTO 0);
 SIGNAL write_reg_addr1				: STD_LOGIC_VECTOR (4 DOWNTO 0);
 SIGNAL write_reg_addr2				: STD_LOGIC_VECTOR (4 DOWNTO 0);
 SIGNAL local_SE  					: STD_LOGIC_VECTOR (31 DOWNTO 0)		:=(x"00000000");  
 SIGNAL local_lui_extend  			: STD_LOGIC_VECTOR (31 DOWNTO 0)		:=(x"00000000");  
 SIGNAL local_rData_1  				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:=(x"00000000");  
 SIGNAL local_rData_2  				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:=(x"00000000");  
 SIGNAL local_wData    				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:=(x"00000000");  
 SIGNAL instr  						: STD_LOGIC_VECTOR (31 DOWNTO 0)		:=(x"00000000");  
 SIGNAL Local_Lo_reg 				: STD_LOGIC_VECTOR(31 DOWNTO 0);
 SIGNAL Local_Hi_reg 				: STD_LOGIC_VECTOR(31 DOWNTO 0);
 SIGNAL Local_Jump_Instr 			: STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL Local_JAL_data	 			: STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL Local_PC_out_plus_4		: std_logic_vector(31 DOWNTO 0);
 SIGNAL local_Mul_result 			: STD_LOGIC_VECTOR (63 downto 0);	
BEGIN
 read_reg_addr1  <= Instr_1 (25 DOWNTO 21) when Shift_1 = '0'
							else Instr_1 (20 DOWNTO 16);--Rs
							
 read_reg_addr2  <= Instr_1 (20 DOWNTO 16)when Shift_1 = '0'
							else Instr_1 (25 DOWNTO 21); --Rt
							
 write_reg_addr0 	<= Instr_1 (20 DOWNTO 16);
 write_reg_addr1 	<= Instr_1 (15 DOWNTO 11);
 write_reg_addr2 	<= Instr_1 (25 DOWNTO 21);
 instr_15_0   		<= Instr_1 (15 DOWNTO 0);  
 instr_25_0   		<= Instr (25 DOWNTO 0);

 --Reg File: rData_1 Output
 local_rData_1 <= reg_array(CONV_INTEGER(read_reg_addr1 (4 DOWNTO 0)));

 --Reg File: rData_2 Output
 local_rData_2 <= reg_array(CONV_INTEGER(read_reg_addr2 (4 DOWNTO 0)));

 --Sign Extend 
	local_SE(15 downto 0) 	<= instr_15_0 (15 DOWNTO 0);
	local_SE(31 downto 16) 	<= (others => instr_15_0 (15));

--Lui	
	local_lui_extend(31 downto 16) 	<= instr_15_0 (15 DOWNTO 0);
	local_lui_extend(15 downto 0) 	<= (others => '0');
	

	local_wData_OP: Switch2to1 generic map(N=>31)
	port map(MemtoReg_3, ALU_Result_2,rData_1,local_wData );
	
	Local_Lo_reg <= mul_result_1(31 DOWNTO 0);
	LOCAL_hi_reg <= mul_result_1(63 DOWNTO 32);
	 
 --Copy Instr
	instr <= Instr_1;

 --Jump Instr
	Local_Jump_Instr(27 downto 2) <= Instr_1 (25 DOWNTO 0);
	Local_Jump_Instr(31 downto 28)<= (others => '0');
	Local_Jump_Instr(1 downto 0)<= (others => '0');

	Local_JAL_data(29 downto 4) <= Instr_1 (25 DOWNTO 0);
	Local_JAL_data(31 downto 30)<= (others => '0');
	Local_JAL_data(3 downto 0)  <= (others => '0');

 PROCESS (Clock, Reset)
 BEGIN
  IF (rising_edge(Clock)) THEN
   IF ((RegWrite_3 = '1') AND (wAddr_2 /= 0)) THEN
    reg_array(CONV_INTEGER(wAddr_2 (4 DOWNTO 0)))  <= local_wData  ;
   END IF;
  --used for jalr only
  IF (JumpALR_1 = '1') AND (wAddr_2 /= 0) THEN
	reg_array(CONV_INTEGER(wAddr_2 (4 DOWNTO 0)))  <= PC_plus_4_1;
  END IF; 
  --used for jal only
  IF (JumpAL_1 = '1')or ( BGEZAL_EN ='1') THEN
	reg_array(31)  <= PC_plus_4_1;

  END IF; 	
  --Save and load from file reg 16,17,18,20
   Result1			<= reg_array(18);
   Result2			<= reg_array(20);
 	reg_array(16) 	<= Operand1;
 	reg_array(17) 	<= Operand1;	
  
  END IF;
 END PROCESS;

 PROCESS (Clock)
 BEGIN
	IF (rising_edge(Clock)) THEN
   IF Reset = '1' THEN  	
	IDEXMRead_out 			<= '0';
	RegWriteOut  			<= '0';
	Branch_2  				<= '0';
	Branch_NE_2  			<= '0';
	IDEXReg_Rt_out 		<= "00000";
	IFIDReg_Rs_out 		<= "00000";
	IFIDReg_Rt_out 		<= "00000";
	wAddr_0_1 				<= "00000";
	wAddr_1_1 				<= "00000";
	wAddr_2_1 				<= "00000";
	wAddr_3 					<= "00000";
	rData_1_1  				<= X"00000000";
	rData_2_1   			<= X"00000000";
	SE_1  					<= X"00000000";
	RegwData  				<= X"00000000";
	Instr_2  				<= X"00000000";
	PC_plus_4_2  			<= X"00400000";
	Lui_Extend_1 			<= X"00000000";
	Lo_reg_1 				<= X"00000000";
	Hi_reg_1 				<= X"00000000";
	Jump_Instr_1 			<= X"00000000";
   ELSE
    Branch_2  				<= Branch_1;
    Branch_NE_2  			<= Branch_NE_1;
    IDEXMRead_out 		<= IDEX_MRead;
    IDEXReg_Rt_out 		<= IDEX_Reg_Rt;
    IFIDReg_Rs_out 		<= IFID_Reg_Rs;
    IFIDReg_Rt_out 		<= IFID_Reg_Rt;
	 wAddr_0_1  			<= write_reg_addr0;
    wAddr_1_1  			<= write_reg_addr1;
    wAddr_2_1  			<= write_reg_addr2; 
    rData_1_1      		<= local_rData_1;
    rData_2_1      		<= local_rData_2;
    SE_1     				<= local_SE;
	 Jump_Instr_1 			<= Local_Jump_Instr;	 
    PC_plus_4_2  			<= PC_plus_4_1;	 
	 Lui_Extend_1			<= local_lui_extend;
	 Lo_reg_1 				<= Local_Lo_reg;
	 Hi_reg_1				<= Local_Hi_reg;
    RegwData  				<= local_wData ;
    Instr_2  				<= Instr_1;
    wAddr_3  				<= wAddr_2;
    RegWriteOut  			<= RegWrite_3;
   END IF;
   END IF;	
 END PROCESS;
END behavioral;