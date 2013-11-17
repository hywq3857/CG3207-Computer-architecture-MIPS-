--Written by Yee Tang, Hu Yang and Haoxuan
--Pipeline written by Yee Tang and Hu Yang
--Pipeline debug by Yee Tang and Hu Yang
LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY CPU IS

 PORT( 
  Clock					: IN STD_LOGIC;
  Reset  				: IN STD_LOGIC; 
  Ctrl					: IN STD_LOGIC_VECTOR (5 DOWNTO 0); 
  Operand1				: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
  Operand2				: IN STD_LOGIC_VECTOR (31 DOWNTO 0); 
  Result1				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  Result2				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);  
  PC   					: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); 
  Final_Data_out 		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
);

END CPU;

ARCHITECTURE structure of CPU IS

COMPONENT Fetching
	PORT( 
	CLK				: IN 	STD_LOGIC;
	RESET  			: IN 	STD_LOGIC; 
	Stall   			: IN 	STD_LOGIC;	
	Branch   		: IN  STD_LOGIC;
	Branch_NE  		: IN  STD_LOGIC;
	BGEZ_1 			: IN 	STD_LOGIC;
	BGEZAL_1 		: IN 	STD_LOGIC; 	
	Jump_1			: IN 	STD_LOGIC;
	IFFlush   		: IN  STD_LOGIC;
	IFFlush_2  		: IN 	STD_LOGIC;	
	IF_Branch  		: OUT STD_LOGIC;
	IF_BranchNE  	: OUT STD_LOGIC;	
	IFFlush_1  		: OUT STD_LOGIC;
	IFFlush_3  		: OUT STD_LOGIC; 
	BGEZAL_EN		: OUT STD_LOGIC;	
	Ctrl				: IN 	STD_LOGIC_VECTOR (5 DOWNTO 0);		
	rData_1  		: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_2   		: IN 	STD_LOGIC_VECTOR (31 DOWNTO 0);
	SE  				: IN 	STD_LOGIC_VECTOR (31 DOWNTO 0);	
	PC_plus_4		: IN 	STD_LOGIC_VECTOR (31 DOWNTO 0);	
	Jump_Addr_1 	: IN 	STD_LOGIC_VECTOR (31 DOWNTO 0);	
	PC_Out   		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	Instr_1  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	PC_plus_4_1		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	NXT_PC   		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_rData1  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_rData2  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_SE  			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_PCPlus4  	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_AddResult  	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_Zero   		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END COMPONENT;


COMPONENT Decoding
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
END COMPONENT;

COMPONENT Controlling IS
PORT(
 	CLK 						: IN  STD_LOGIC; 
	RESET 					: IN  STD_LOGIC; 
	IDEX_MRead  			: IN STD_LOGIC; 		
	RegDst_1  				: OUT STD_LOGIC;
	ALUSrc_1  				: OUT STD_LOGIC;
	MWrite_1  				: OUT STD_LOGIC;
	Branch_1  				: OUT STD_LOGIC;
	Branch_NE_1  			: OUT STD_LOGIC;
	Jump_1					: OUT STD_LOGIC; 
	JumpAL_1					: OUT STD_LOGIC;
	JumpALR_1				: OUT STD_LOGIC; 
	Slti_1					: OUT STD_LOGIC; 
	Shift_1					: OUT STD_LOGIC; 
	Shifti_1					: OUT STD_LOGIC; 
	MulDiv_1					: OUT STD_LOGIC; 		
	Ori_1 					: OUT STD_LOGIC;		
	BGEZ_1 					: OUT STD_LOGIC;
	BGEZAL_1 				: OUT STD_LOGIC; 
  	Lui_1						: OUT STD_LOGIC;	
	MRead_1  				: OUT STD_LOGIC;
	MemtoReg_1  			: OUT STD_LOGIC;
	RegWrite_1  			: OUT STD_LOGIC;
	IF_Flush  				: OUT STD_LOGIC;	
	Stall_out  				: OUT STD_LOGIC;	
	ALU_Op_1  				: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
	BGEZ_field 				: IN 	STD_LOGIC_VECTOR (4 downto 0);
	IDEX_Reg_Rt 			: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 
	IFID_Reg_Rs 			: IN  STD_LOGIC_VECTOR (4 DOWNTO 0);  
	IFID_Reg_Rt 			: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 	
	Opcode   				: IN 	STD_LOGIC_VECTOR (5 DOWNTO 0);
	Funct_field 			: IN  STD_LOGIC_VECTOR (5 downto 0);	
	instr 			: IN  STD_LOGIC_VECTOR (31 downto 0)


  ); 
END COMPONENT;

COMPONENT Executing IS
 PORT( 
	Clock				: IN STD_LOGIC;
	Reset  			: IN STD_LOGIC;
	ALUSrc_1  		: IN STD_LOGIC;
	Ori_1 			: IN STD_LOGIC;	
	Slti_1			: IN STD_LOGIC;
	Shift_1			: IN STD_LOGIC;
	Shifti_1			: IN STD_LOGIC;	 
	MulDiv_1			: IN STD_LOGIC; 
	Lui_1				: IN STD_LOGIC;
	MemtoReg_1  	: IN  STD_LOGIC;
	MRead_1  		: IN  STD_LOGIC;
	RegWrite_1  	: IN  STD_LOGIC;	
	MWrite_1  		: IN  STD_LOGIC;	
	EXMEM_RegWrite : IN  STD_LOGIC;  
	MEMWB_RegWrite : IN  STD_LOGIC; 
	RegDst_1  		: IN  STD_LOGIC; 	
	Zero_1   		: OUT STD_LOGIC;	
	MRead_2  		: OUT  STD_LOGIC;
	RegWrite_2  	: OUT  STD_LOGIC;
	MWrite_2  		: OUT  STD_LOGIC;
	MemtoReg_2  	: OUT  STD_LOGIC;
	MEMWBRegWrite  : OUT  STD_LOGIC;  
	EXMEMRegWrite  : OUT  STD_LOGIC; 
	ALU_Op_1  		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);	
	forwardA  		: OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);
	forwardB  		: OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);		
	MEMWB_Reg_Rd 	: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 
	EXMEM_Reg_Rd 	: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 
	IDEX_Reg_Rs 	: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 
	IDEX_Reg_Rt 	: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 
	Shifti_field	: IN STD_LOGIC_VECTOR (4 DOWNTO 0); 		
	wAddr_0_1 	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	wAddr_1_1	: IN STD_LOGIC_VECTOR (4 DOWNTO 0); 
	wAddr_1 		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	EXMEMReg_Rd 	: OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
   MEMWBReg_Rd 	: OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
	IDEXReg_Rs 		: OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
	IDEXReg_Rt 		: OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
	EXMEM_ALU_Result 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0); 
 	MEMWB_rData 		: IN  STD_LOGIC_VECTOR (31 DOWNTO 0); 
	Funct_field  		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);	
	rData_1  			: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_2  			: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	SE_1  				: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
	Lui_Extend_1 		: IN STD_LOGIC_VECTOR (31 DOWNTO 0); 	
	Lo_reg_1 			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	Hi_reg_1 			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	Jump_Instr_1 		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	PC_plus_4_2  		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);	
	Jump_Addr_1 	: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0); 	
	ALU_Result_1  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_2_2  			: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);	
	Mul_result_1 		: OUT std_logic_vector (63 downto 0);	
	ALU1   				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	ALU2   				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  	MEMWBrData  		: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0); 
	EXMEMALU_Result 	: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0)

	);
END COMPONENT;

COMPONENT Storing IS
 PORT(
	clk					: IN STD_LOGIC;
	reset					: IN STD_LOGIC;
	MRead_2 				: IN STD_LOGIC;
	MWrite_2  			: IN STD_LOGIC;
   MemtoReg_2  		: IN  STD_LOGIC;
	RegWrite_2  		: IN  STD_LOGIC; 
	MRead_3  			: OUT STD_LOGIC;  
	MWrite_3  			: OUT  STD_LOGIC;  
	MemtoReg_3  		: OUT  STD_LOGIC;
	RegWrite_3  		: OUT  STD_LOGIC;  
	wAddr_1 			: IN STD_LOGIC_VECTOR (4 DOWNTO 0);	
	wAddr_2 			: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);	
	ALU_Result_1  		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	Addr   			: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
	wData  				: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_2_3 			: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
	ALU_Result_2  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_1  			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	Reg_wData  			: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0)
);
END COMPONENT;


 
SIGNAL ALUSrc_1  			: STD_LOGIC;
SIGNAL Branch_1  			: STD_LOGIC;
SIGNAL Branch_2  			: STD_LOGIC;
SIGNAL Branch_NE_1  		: STD_LOGIC;
SIGNAL Branch_NE_2  		: STD_LOGIC;
SIGNAL BGEZ_1 				: STD_LOGIC;
SIGNAL BGEZAL_1 			: STD_LOGIC; 
SIGNAL BGEZAL_EN			: STD_LOGIC;
SIGNAL Lui_1 				: STD_LOGIC;
SIGNAL Jump_1				: STD_LOGIC;
SIGNAL JumpAL_1			: STD_LOGIC;
SIGNAL JumpALR_1			: STD_LOGIC;
SIGNAL Slti_1				: STD_LOGIC;
SIGNAL Shift_1				: STD_LOGIC;
SIGNAL Shifti_1			: STD_LOGIC;
SIGNAL MulDiv_1			: STD_LOGIC; 
SIGNAL MRead_1  		: STD_LOGIC;
SIGNAL MRead_2  		: STD_LOGIC;
SIGNAL MRead_3  		: STD_LOGIC;
SIGNAL MemtoReg_1  		: STD_LOGIC;
SIGNAL MemtoReg_2  		: STD_LOGIC;
SIGNAL MemtoReg_3  		: STD_LOGIC;
SIGNAL MWrite_1  		: STD_LOGIC;
SIGNAL MWrite_2  		: STD_LOGIC;
SIGNAL MWrite_3  		: STD_LOGIC;
SIGNAL Ori_1				: STD_LOGIC;
SIGNAL RegDst_1  			: STD_LOGIC;
SIGNAL RegWrite_1  		: STD_LOGIC;
SIGNAL RegWrite_2  		: STD_LOGIC;
SIGNAL RegWrite_3  		: STD_LOGIC;
SIGNAL RegWriteOut  		: STD_LOGIC; 
SIGNAL Zero_1   			: STD_LOGIC;
SIGNAL EXMEMRegWrite 	: STD_LOGIC;   
SIGNAL MEMWBRegWrite  	: STD_LOGIC;  
SIGNAL STALLout  			: STD_LOGIC;
SIGNAL IDEXMRead_out 	: STD_LOGIC;  
SIGNAL IF_Flush  			: STD_LOGIC;
SIGNAL IF_Flush_1  		: STD_LOGIC;
SIGNAL IF_Flush_2  		: STD_LOGIC;
SIGNAL IF_Flush_3  		: STD_LOGIC;
SIGNAL IF_Branch  		: STD_LOGIC;
SIGNAL IF_BranchNE  		: STD_LOGIC;
SIGNAL forwardA  			: STD_LOGIC_VECTOR (1 DOWNTO 0)			:= (others => '0');
SIGNAL forwardB  			: STD_LOGIC_VECTOR (1 DOWNTO 0)			:= (others => '0');
SIGNAL ALU_Op_1  			: STD_LOGIC_VECTOR (1 DOWNTO 0)			:= (others => '0');
SIGNAL BGEZ_field 		: STD_LOGIC_VECTOR (4 downto 0)		:= (others => '0');
SIGNAL wAddr_0_1 		: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL wAddr_1_1 		: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL wAddr_2_1 		: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL EXMEMReg_Rd 		: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL MEMWBReg_Rd 		: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL IDEXReg_Rs 		: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0'); 
SIGNAL IDEXReg_Rt 		: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL IDEXReg_Rt_out 	: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0'); 
SIGNAL IFIDReg_Rs_out 	: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL IFIDReg_Rt_out 	: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL wAddr_1 			: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL wAddr_2 			: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL wAddr_3 			: STD_LOGIC_VECTOR (4 DOWNTO 0)		:= (others => '0');
SIGNAL Lo_reg_1 		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL Hi_reg_1 		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL Jump_Instr_1 			: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');  
SIGNAL Jump_Addr_1		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');  
SIGNAL Add_Result_1  		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL Add_Result_2  		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL ALU_Result_1  		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL ALU_Result_2  		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL ALU1   					: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL ALU2  					: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL Lui_Extend_1  		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0'); 
SIGNAL Instr   		: STD_LOGIC_VECTOR(31 DOWNTO 0)		:= (others => '0');
SIGNAL Instr_1 		: STD_LOGIC_VECTOR(31 DOWNTO 0)		:= (others => '0');
SIGNAL Instr_2 		: STD_LOGIC_VECTOR(31 DOWNTO 0)		:= (others => '0');
SIGNAL PC_Out   				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL PC_plus_4_1  			: STD_LOGIC_VECTOR(31 DOWNTO 0)		:= (others => '0');
SIGNAL PC_plus_4_2  			: STD_LOGIC_VECTOR(31 DOWNTO 0)		:= (others => '0');
SIGNAL NXT_PC   				: STD_LOGIC_VECTOR(31 DOWNTO 0)		:= (others => '0');
SIGNAL rData_1_1 				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL rData_2_1 				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL rData_1  				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL rData_2_2 				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL rData_2_3 				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL Mul_result_1 			: STD_LOGIC_VECTOR (63 downto 0)		:= (others => '0');	
SIGNAL RegwData  				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL Reg_wData 				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL SE_1 					: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0'); 
SIGNAL EXMEMALU_Result 		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL MEMWBrData  			: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL StallInstr 	: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL IF_rData1  			: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL IF_rData2  			: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL IF_SE  					: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL IF_PCPlus4  			: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL IF_AddResult  		: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');
SIGNAL IF_Zero   				: STD_LOGIC_VECTOR (31 DOWNTO 0)		:= (others => '0');

BEGIN
	PC    				<=  PC_Out;
	StallInstr  <=  Instr WHEN STALLout = '0' ELSE Instr_2;
	Final_Data_out 	<= Reg_wData;

 FETCH : Fetching PORT MAP ( 
    CLK   			=> Clock,
    RESET   		=> Reset, 
    Stall   		=> STALLout,
    PC_Out   		=> PC_Out,
    Branch   		=> Branch_1,
    Branch_NE  	=> Branch_NE_1,
	 BGEZ_1 			=> BGEZ_1,
	 BGEZAL_1 		=> BGEZAL_1,
	 Jump_1        => Jump_1,
    IFFlush   		=> IF_Flush,
    IFFlush_1  	=> IF_Flush_1,
    IFFlush_2  	=> IF_Flush_1,
    IFFlush_3  	=> IF_Flush_3,
    IF_Branch  	=> IF_Branch,
    IF_BranchNE  	=> IF_BranchNE,
	 BGEZAL_EN 		=> BGEZAL_EN,	
	 Ctrl 			=> Ctrl,
    rData_1  		=> rData_1_1,
    rData_2   		=> rData_2_1,
    SE  				=> SE_1,
	 PC_plus_4		=> PC_plus_4_1,
	 Jump_Addr_1=> Jump_Addr_1,
    Instr_1 => Instr,
	 PC_plus_4_1	=> PC_plus_4_1,
    NXT_PC   		=> NXT_PC,
    IF_rData1  	=> IF_rData1,
    IF_rData2  	=> IF_rData2,
    IF_SE 			=> IF_SE,
    IF_PCPlus4  	=> IF_PCPlus4,
    IF_AddResult  => IF_AddResult,
    IF_Zero   		=> IF_Zero
	 );

 DECODE : Decoding PORT MAP (
	 Clock 					=> Clock,
	 Reset 					=> Reset, 
    RegWrite_3      		=> RegWrite_3,
    MemtoReg_3    			=> MemtoReg_3,
	 JumpAL_1				=> JumpAL_1,
	 JumpALR_1				=> JumpALR_1,
	 Shift_1				=> Shift_1,
	 Shifti_1				=> Shifti_1,
    IDEX_MRead  			=> MRead_1,	
    Branch_1  				=> Branch_1, 
    Branch_NE_1  			=> Branch_NE_1,
	 BGEZAL_EN				=> BGEZAL_EN,
    IDEXMRead_out 			=> IDEXMRead_out,
    RegWriteOut  			=> RegWriteOut,
    Branch_2  				=> Branch_2,
    Branch_NE_2  			=> Branch_NE_2,
    wAddr_2   				=> wAddr_2,
    IDEX_Reg_Rt 			=> wAddr_0_1,
    IFID_Reg_Rt 			=> Instr (20 DOWNTO 16),		 
    IFID_Reg_Rs 			=> Instr (25 DOWNTO 21),
    IDEXReg_Rt_out 			=> IDEXReg_Rt_out,
    IFIDReg_Rs_out 			=> IFIDReg_Rs_out,
    IFIDReg_Rt_out 			=> IFIDReg_Rt_out,
    rData_1  				=> rData_1,
    wData  					=> Reg_wData,
    ALU_Result_2    		=> ALU_Result_2,
    Instr_1    				=> StallInstr,
    PC_plus_4_1   			=> PC_plus_4_1,
	 Operand1				=> Operand1,
	 Operand2				=> Operand2,
	 Mul_result_1 			=> Mul_result_1,
    wAddr_0_1  				=> wAddr_0_1,
    wAddr_1_1  				=> wAddr_1_1,
    wAddr_2_1  				=> wAddr_2_1,	
    rData_1_1    			=> rData_1_1,
    rData_2_1     			=> rData_2_1,
    SE_1    				=> SE_1,
    RegwData    			=> RegwData, 
    Instr_2    				=> Instr_2,
    PC_plus_4_2    			=> PC_plus_4_2,
    wAddr_3  				=> wAddr_3,
	 Lo_reg_1 				=> Lo_reg_1,
	 Hi_reg_1 				=> Hi_reg_1,
	 Jump_Instr_1 			=> Jump_Instr_1,
	 Lui_Extend_1 			=> Lui_Extend_1,
	 Result1					=> Result1,
    Result2					=> Result2
	  );	 
	 
 CONTROL : Controlling PORT MAP (
    CLK   					=> Clock,
    RESET   				=> Reset, 
    IDEX_MRead  			=> MRead_1,
    RegDst_1  				=> RegDst_1,
    ALUSrc_1  				=> ALUSrc_1,
	 MWrite_1  				=> MWrite_1, 
    Branch_1  				=> Branch_1,
    Branch_NE_1  			=> Branch_NE_1,   
	 Jump_1					=> Jump_1,
	 JumpAL_1				=> JumpAL_1,
	 JumpALR_1				=> JumpALR_1,
	 Slti_1					=> Slti_1,
	 Shift_1				=> Shift_1,
	 Shifti_1				=> Shifti_1,
	 MulDiv_1				=> MulDiv_1,	 
	 Ori_1					=> Ori_1,	 
	 BGEZ_1 				=>	BGEZ_1, 	
	 BGEZAL_1				=> BGEZAL_1, 
    Stall_out  				=> STALLout,	 
	 Lui_1					=> Lui_1,
    MRead_1  				=> MRead_1,
    MemtoReg_1  			=> MemtoReg_1,
    RegWrite_1  			=> RegWrite_1,
    IF_Flush  				=> IF_Flush,	 
	 BGEZ_field 			=>	BGEZ_field,	
    IDEX_Reg_Rt 			=> wAddr_0_1,
    IFID_Reg_Rs 			=> Instr (25 DOWNTO 21),
    IFID_Reg_Rt 			=> Instr (20 DOWNTO 16),
	 Opcode   				=> Instr (31 DOWNTO 26),
	 Funct_field 			=> Instr (5 DOWNTO 0),
    ALU_Op_1  				=> ALU_Op_1,
	 instr 			=> instr
	 );
	 

 EXECUTE : Executing PORT MAP (
   Clock    			=> Clock,
   Reset    			=> Reset,  
   ALUSrc_1   			=> ALUSrc_1,	
	Ori_1					=> Ori_1,
	Slti_1				=> Slti_1,
	Shift_1				=> Shift_1,
	Shifti_1				=> Shifti_1,
	MulDiv_1				=> MulDiv_1,
	Lui_1 				=> Lui_1,
   MemtoReg_1   		=> MemtoReg_1,
   MRead_1   			=> MRead_1,
   RegWrite_1   		=> RegWrite_1,
   MWrite_1   			=> MWrite_1,
   EXMEM_RegWrite   	=> RegWrite_2,   
   EXMEMRegWrite   	=> EXMEMRegWrite,
   RegDst_1   			=> RegDst_1,
   Zero_1    			=> Zero_1,
   MRead_2   			=> MRead_2,
   RegWrite_2   		=> RegWrite_2,
   MEMWB_RegWrite   	=> RegWrite_3,    
   MWrite_2   			=> MWrite_2,
   MEMWBRegWrite   	=> MEMWBRegWrite, 
   ALU_Op_1   			=> ALU_Op_1,
   forwardA   			=> forwardA,
   forwardB   			=> forwardB,
   EXMEM_Reg_Rd 		=> wAddr_1,  
   MEMWB_Reg_Rd 		=> wAddr_2, 
   IDEX_Reg_Rs  		=> wAddr_2_1,
   IDEX_Reg_Rt  		=> wAddr_0_1,
   wAddr_0_1 			=> wAddr_0_1,
   wAddr_1_1 			=> wAddr_1_1,
   wAddr_1  			=> wAddr_1,
   MemtoReg_2   		=> MemtoReg_2,
   rData_2_2   		=> rData_2_2,	
   IDEXReg_Rs  		=> IDEXReg_Rs, 
   IDEXReg_Rt  		=> IDEXReg_Rt,
   Funct_field   		=> Instr_2 (5 DOWNTO 0),
	Shifti_field 		=> Instr_2 ( 10 downto 6),	
   rData_1   			=> rData_1_1,
   rData_2   			=> rData_2_1,
   SE_1   				=> SE_1,
	Lui_Extend_1 		=> Lui_Extend_1,
   ALU_Result_1   	=> ALU_Result_1,
	Mul_result_1 		=> Mul_result_1,
	Lo_reg_1 			=> Lo_reg_1,
	Hi_reg_1 			=> Hi_reg_1,
   PC_plus_4_2   		=> PC_plus_4_2,	
	Jump_Instr_1		=> Jump_Instr_1,
	Jump_Addr_1 		=> Jump_Addr_1,
   EXMEMReg_Rd  		=> EXMEMReg_Rd,
   MEMWBReg_Rd  		=> MEMWBReg_Rd,
   EXMEM_ALU_Result  => ALU_Result_1,  
   MEMWB_rData  		=> Reg_wData,  
   ALU1     			=> ALU1,
   ALU2     			=> ALU2,
   MEMWBrData   		=> MEMWBrData,
   EXMEMALU_Result  	=> EXMEMALU_Result	
	);

 STORE : Storing PORT MAP (
   CLK    				=> Clock,
   Reset    			=> Reset, 
   MRead_2   			=> MRead_2,
   MWrite_2  	 		=> MWrite_2,
   RegWrite_2   		=> RegWrite_2,
   MRead_3   			=> MRead_3, 
   MWrite_3   			=> MWrite_3,	
   MemtoReg_2   		=> MemtoReg_2,
   MemtoReg_3   		=> MemtoReg_3,
   RegWrite_3   		=> RegWrite_3,
   wAddr_1  			=> wAddr_1,
   wAddr_2  			=> wAddr_2,
   ALU_Result_1   	=> ALU_Result_1,
	Addr    				=> ALU_Result_1,
   wData   				=> rData_2_2,  
   rData_2_3  			=> rData_2_3,
   ALU_Result_2   	=> ALU_Result_2,	
	rData_1   			=> rData_1,
   Reg_wData   		=> Reg_wData
);

END structure;


