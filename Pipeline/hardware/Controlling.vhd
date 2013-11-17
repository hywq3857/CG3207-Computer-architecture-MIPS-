--Import from Single Cycle written by Hu Yang
--Pipeline written by Yee Tang 
--Pipeline debug by Yee Tang and Hu Yang
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Controlling IS
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
END Controlling; 

ARCHITECTURE behavioral OF Controlling IS
	SIGNAL Local_RType				: STD_LOGIC; 
	SIGNAL Local_LoadWord			: STD_LOGIC; 
	SIGNAL Local_StoreWord			: STD_LOGIC; 
	SIGNAL Local_BranchEqual		: STD_LOGIC; 
	SIGNAL Local_BranchNotEqual	: STD_LOGIC; 
	signal Local_JMP					: STD_LOGIC; 
	signal Local_JAL					: STD_LOGIC;
	signal Local_JALR					: STD_LOGIC; 
	signal Local_JR					: STD_LOGIC;
	signal Local_SLTI					: STD_LOGIC; 
	signal Local_MUL					: STD_LOGIC; 
	signal Local_DIV					: STD_LOGIC; 
	signal Local_MULU					: STD_LOGIC; 
	signal Local_DIVU					: STD_LOGIC; 
	signal Local_ORI					: STD_LOGIC; 
	signal Local_LUI					: STD_LOGIC; 
	signal Local_Shift_left			: STD_LOGIC; 
	signal Local_Shift_right		: STD_LOGIC; 
	signal Local_Shift_right_ar	: STD_LOGIC; 
	signal Local_Shift_i 			: STD_LOGIC;	
	SIGNAL Local_ADDI					: STD_LOGIC;
	SIGNAL Local_BGEZ					: STD_LOGIC;
	SIGNAL Local_BGEZAL 				: STD_LOGIC;
	
	SIGNAL Opcode_Out : STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL ifflush    : STD_LOGIC;
	SIGNAL RegDst		: STD_LOGIC;  
	SIGNAL ALU_Op0		: STD_LOGIC;  
	SIGNAL ALU_Op1		: STD_LOGIC;  
	SIGNAL ALUSrc 		: STD_LOGIC;
	SIGNAL Branch		: STD_LOGIC;
	SIGNAL Branch_NE	: STD_LOGIC;
	signal Jump			: STD_LOGIC; 
	signal JumpAL		: STD_LOGIC;
	signal JumpALR		: STD_LOGIC; 
	signal Slti			: STD_LOGIC; 
	signal Shift		: STD_LOGIC; 
	signal Shifti		: STD_LOGIC; 
	signal MulDiv		: STD_LOGIC; 
	signal Lui			: STD_LOGIC; 
	SIGNAL MWrite		: STD_LOGIC; 
	SIGNAL MRead 		: STD_LOGIC;
	SIGNAL BGEZ			: STD_LOGIC;
	SIGNAL BGEZAL 		: STD_LOGIC;
	Signal Ori			: STD_LOGIC;
	SIGNAL MemtoReg	: STD_LOGIC; 
	SIGNAL RegWrite   : STD_LOGIC;
	SIGNAL stall     	: STD_LOGIC;

BEGIN

	Local_RType 				<= '1' WHEN Opcode = "000000" ELSE '0';
	Local_LoadWord  			<= '1' WHEN Opcode = "100011" ELSE '0';
	Local_StoreWord  			<= '1' WHEN Opcode = "101011" ELSE '0';
	Local_BranchEqual  		<= '1' WHEN Opcode = "000100" ELSE '0';
	Local_BranchNotEqual  	<= '1' WHEN Opcode = "000101" ELSE '0';
	Local_JMP  					<= '1' WHEN Opcode = "000010" ELSE '0';		
	Local_ADDI  				<= '1' WHEN Opcode = "001000" ELSE '0';
	Local_ORI  					<= '1' WHEN Opcode = "001101" ELSE '0';
	Local_LUI  					<= '1' WHEN Opcode = "001111" ELSE '0';
	Local_JAL  					<= '1' WHEN Opcode = "000011" ELSE '0';
	Local_SLTI  				<= '1' WHEN Opcode = "001010" ELSE '0';
	Local_MUL  <= '1' 				WHEN Opcode = "000000" and Funct_field = "011000" ELSE '0';
	Local_MULU  <= '1' 				WHEN Opcode = "000000" and Funct_field = "011001" ELSE '0';
	Local_DIV  <= '1' 				WHEN Opcode = "000000" and Funct_field = "000111" ELSE '0';
	Local_DIVU  <= '1' 				WHEN Opcode = "000000" and Funct_field = "011011" ELSE '0';
	Local_JR  <= '1' 					WHEN Opcode = "000000" and Funct_field = "001000" ELSE '0';
	Local_JALR  <= '1' 				WHEN Opcode = "000000" and Funct_field = "001001" ELSE '0';
	Local_Shift_left  <= '1' 		WHEN Opcode = "000000" and ((Funct_field = "000000" or Funct_field = "000100") and instr/= x"00000000") ELSE '0';
	Local_Shift_right  <= '1' 		WHEN Opcode = "000000" and (Funct_field = "000010" or Funct_field = "000110") ELSE '0';
	Local_Shift_right_ar  <= '1' 	WHEN Opcode = "000000" and (Funct_field = "000011" or Funct_field = "000111") ELSE '0';
	Local_shift_i <= '1' 			WHEN Opcode = "000000" and (Funct_field = "000011" or Funct_field = "000010" or Funct_field = "000000") ELSE '0';
 	Local_BGEZ <= '1' 				WHEN Opcode = "000001" and BGEZ_field = "00001" ELSE '0';
	Local_BGEZAL <= '1' 				WHEN Opcode = "000001" and BGEZ_field = "10001" ELSE '0';
 
 
	RegDst  		<= Local_RType;
	ALU_Op1  	<= Local_RType;
	ALU_Op0  	<= Local_BranchEqual OR Local_BranchNotEqual OR Local_BGEZ OR Local_BGEZAL;
	ALUSrc  		<= Local_LoadWord OR Local_StoreWord OR LOCAL_ADDI OR Local_ORI OR Local_LUI or Local_SLTI ;
	Ori 			<= Local_ORI;
	Branch  		<= Local_BranchEqual OR Local_BGEZ OR Local_BGEZAL;
	Branch_NE 	<= Local_BranchNotEqual;
	Lui 			<= Local_LUI;
	ifflush  	<= Local_BranchEqual OR Local_BGEZ OR Local_BGEZAL;
	MRead  		<= Local_LoadWord;
	MWrite 		<= Local_StoreWord;
	Jump  		<= Local_JMP or Local_JAL or Local_JALR or Local_JR;
	JumpAL 		<= Local_JAL;
	JumpALR 		<= Local_JALR;
	Slti 			<= Local_SLTI;
	Shift 		<=	Local_Shift_left or Local_Shift_right or Local_Shift_right_ar;
	Shifti		<= Local_Shift_i;
	MulDiv		<= Local_MUL or Local_DIV or Local_MULU or Local_DIVU;
	BGEZ 			<= Local_BGEZ OR Local_BGEZAL;
	BGEZAL 		<= Local_BGEZAL;
	MemtoReg 	<= Local_LoadWord;
	RegWrite 	<= Local_RType OR Local_LoadWord OR LOCAL_ADDI OR Local_LUI OR Local_ORI  or Local_SLTI ;

 PROCESS (IDEX_MRead,IDEX_Reg_Rt,IFID_Reg_Rs,IFID_Reg_Rt)
    BEGIN
--Copy Lecture note 15	 
	--Detect Hazard
	IF ( (IDEX_MRead = '1') AND 
		((IDEX_Reg_Rt = IFID_Reg_Rs) OR 
		(IDEX_Reg_Rt = IFID_Reg_Rt))) THEN 
			stall <= '1';  --Got HAZARD
	ELSE
			stall <= '0';  --No HAZARD 
	END IF;
	END PROCESS;

 PROCESS (Clk)
  BEGIN
  if(rising_edge(Clk)) then
   IF (Reset = '1' OR stall = '1') THEN
		RegDst_1  				<= '0';
		ALUSrc_1  				<= '0';
		MWrite_1  				<= '0';
		Branch_1  				<= '0';
		Branch_NE_1  			<= '0';
		Jump_1					<= '0';
		JumpAL_1					<= '0';
		JumpALR_1				<= '0';
		Slti_1					<= '0';
		Shift_1					<= '0';
		Shifti_1					<= '0';
		MulDiv_1					<= '0';
		Ori_1 					<= '0';	
		BGEZ_1 					<= '0';
		BGEZAL_1 				<= '0';
		Lui_1						<= '0';
		MRead_1  				<= '0';
		MemtoReg_1  			<= '0';
		RegWrite_1  			<= '0';
		IF_Flush  				<= '0';	
		Stall_out  				<= stall;
   ELSE 
		 Shift_1			<= Shift;
		 Shifti_1		<= Shifti;
		 MulDiv_1		<= MulDiv; 
		 Ori_1 			<=Ori;	 
		 MemtoReg_1 	<= MemtoReg;
		 RegWrite_1 	<= RegWrite;
		 MWrite_1 	<= MWrite;
		 MRead_1 		<= MRead;
		 Branch_1 		<= Branch;
		 Branch_NE_1 	<= Branch_NE;
		 Lui_1 			<= Lui;
		 Jump_1			<= Jump;
		 JumpAL_1		<= JumpAL;
		 JumpALR_1		<= JumpALR;
		 Slti_1			<= Slti;
		 BGEZ_1			<=	BGEZ;
		 BGEZAL_1 		<= BGEZAL;
		 RegDst_1 		<= RegDst;
		 ALU_Op_1(1) 	<= ALU_Op1;
		 ALU_Op_1(0) 	<= ALU_Op0;
		 ALUSrc_1 		<= ALUSrc;
		 IF_Flush 		<= ifflush;
		 Stall_out 		<= stall;
	 END IF;
   END IF;	
 END PROCESS;
END behavioral;

