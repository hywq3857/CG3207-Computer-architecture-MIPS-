----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:00:09 11/09/2013 
-- Design Name: 
-- Module Name:    Executing - Behavioral 
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
--Import from Single Cycle written by Hu Yang
--Pipeline written by Yee Tang 
--Pipeline debug by Yee Tang and Hu Yang
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Executing IS
 PORT(
	Clock					: IN STD_LOGIC;
	Reset  				: IN STD_LOGIC;
	ALUSrc_1  			: IN STD_LOGIC;
	Ori_1 				: IN STD_LOGIC;	
	Slti_1				: IN STD_LOGIC;
	Shift_1				: IN STD_LOGIC;
	Shifti_1				: IN STD_LOGIC;	 
	MulDiv_1				: IN STD_LOGIC; 
	Lui_1					: IN STD_LOGIC;
	MemtoReg_1  		: IN  STD_LOGIC;
	MRead_1  			: IN  STD_LOGIC;
	RegWrite_1  		: IN  STD_LOGIC;	
	MWrite_1  			: IN  STD_LOGIC;	
	EXMEM_RegWrite 	: IN  STD_LOGIC;  
	MEMWB_RegWrite 	: IN  STD_LOGIC; 
	RegDst_1  			: IN  STD_LOGIC; 	
	Zero_1   			: OUT STD_LOGIC;	
	MRead_2  			: OUT  STD_LOGIC;
	RegWrite_2  		: OUT  STD_LOGIC;
	MWrite_2  			: OUT  STD_LOGIC;
	MemtoReg_2  		: OUT  STD_LOGIC;
	MEMWBRegWrite  	: OUT  STD_LOGIC;  
	EXMEMRegWrite 	 	: OUT  STD_LOGIC; 
	ALU_Op_1  			: IN STD_LOGIC_VECTOR (1 DOWNTO 0);	
	forwardA  			: OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);
	forwardB  			: OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);		
	MEMWB_Reg_Rd 		: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 
	EXMEM_Reg_Rd 		: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 
	IDEX_Reg_Rs 		: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 
	IDEX_Reg_Rt 		: IN  STD_LOGIC_VECTOR (4 DOWNTO 0); 
	Shifti_field		: IN STD_LOGIC_VECTOR (4 DOWNTO 0); 		
	wAddr_0_1 			: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	wAddr_1_1 			: IN STD_LOGIC_VECTOR (4 DOWNTO 0); 
	wAddr_1 			: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	EXMEMReg_Rd 		: OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
	MEMWBReg_Rd 		: OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
	IDEXReg_Rs 			: OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
	IDEXReg_Rt 			: OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
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
	Jump_Addr_1 		: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0); 	
	ALU_Result_1  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_2_2  			: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);	
	Mul_result_1 		: OUT std_logic_vector (63 downto 0);	
	ALU1   				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	ALU2   				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  	MEMWBrData  		: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0); 
	EXMEMALU_Result 	: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0)

  );
END Executing;

ARCHITECTURE behavioral of Executing IS

 SIGNAL A_input			: STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL B_input			: STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL Binput 			: STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL Branch_Add  		:  STD_LOGIC_VECTOR (31 DOWNTO 0);
  
 SIGNAL ALU_output   	: STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL ALU_Control  	: STD_LOGIC_VECTOR (5 DOWNTO 0);
 
 
 --SIGNAL Shift_1			: IN STD_LOGIC;
 --SIGNAL Shifti_1			: IN STD_LOGIC;	 
 --SIGNAL MulDiv_1			: IN STD_LOGIC; 		
 --SIGNAL Mul_result_1 	: OUT std_logic_vector (63 downto 0);	
 SIGNAL Local_Jump_Add  : STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL Local_Lo_reg 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
 SIGNAL Local_Hi_reg 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
 SIGNAL Local_Shifti_extend : STD_LOGIC_VECTOR (31 downto 0);
	
 --PIPELINED SIGNALS
 SIGNAL ALU_Result   	: STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL Zero    			: STD_LOGIC;
 SIGNAL wAddr   : STD_LOGIC_VECTOR (4 DOWNTO 0);
 --FORWARDING SIGNALS
 SIGNAL Forward_A  		: STD_LOGIC_VECTOR (1 DOWNTO 0); 
 SIGNAL Forward_B  		: STD_LOGIC_VECTOR (1 DOWNTO 0);
 signal v : STD_LOGIC_VECTOR(31 downto 0);  
 
	component Switch3to1 is
	generic (N:integer);
	 Port ( input : in  STD_LOGIC_VECTOR (1 downto 0);
			  A : in  STD_LOGIC_VECTOR (N downto 0);
			  B : in  STD_LOGIC_VECTOR (N downto 0);
			  C : in  STD_LOGIC_VECTOR (N downto 0);
			  output : out  STD_LOGIC_VECTOR (N downto 0));
	end component;	
	component Switch2to1 is
	generic (N:integer);
		 Port ( 
		 input 		: in  STD_LOGIC;
		 A 			: in  STD_LOGIC_VECTOR (N downto 0);
		 B 			: in  STD_LOGIC_VECTOR (N downto 0);
		 output 		: out  STD_LOGIC_VECTOR (N downto 0));
	end component;		
BEGIN

	Local_Shifti_extend (4 downto 0) <= shifti_field(4 downto 0);
	Local_Shifti_extend (31 downto 5) <= "000000000000000000000000000";
	
	 --Jump Addr
	 Local_Jump_Add <= Jump_Instr_1 (31 DOWNTO 0);
	 Jump_Addr_1 <= A_input when ALU_Control = "001000" or ALU_Control = "001001" else Local_Jump_Add;	
	
 --FORWARDING UNIT PART II

 PROCESS (EXMEM_RegWrite, EXMEM_ALU_Result, EXMEM_Reg_Rd, MEMWB_RegWrite, 
   MEMWB_Reg_Rd, MEMWB_rData, IDEX_Reg_Rs, IDEX_Reg_Rt)
    BEGIN
 --Copy from lecture notes	 
  -- Forward A
  IF ( (MEMWB_RegWrite = '1') AND 
    (MEMWB_Reg_Rd /= "00000") AND 
   (EXMEM_Reg_Rd /= IDEX_Reg_Rs) AND 
   (MEMWB_Reg_Rd = IDEX_Reg_Rs) ) THEN 
   Forward_A <= "01";  -- HAZARD
  ELSIF ( (EXMEM_RegWrite = '1') AND 
    (EXMEM_Reg_Rd /= "00000") AND
   (EXMEM_Reg_Rd = IDEX_Reg_Rs) ) THEN
   Forward_A <= "10";  -- HAZARD
  ELSE
   Forward_A <= "00";  --NO HAZARD
  END IF;
 
  -- Forward B
  IF ( (MEMWB_RegWrite = '1') AND 
    (MEMWB_Reg_Rd /= "00000") AND 
    (EXMEM_Reg_Rd /= IDEX_Reg_Rt) AND 
    (MEMWB_Reg_Rd = IDEX_Reg_Rt) ) THEN
    Forward_B <= "01"; -- HAZARD 
  ELSIF ( (EXMEM_RegWrite = '1') AND 
   (EXMEM_Reg_Rd /= "00000") AND
   (EXMEM_Reg_Rd = IDEX_Reg_Rt) ) THEN 
   Forward_B <= "10"; -- HAZARD
  ELSE
  Forward_B <= "00"; --NO HAZARD
  END IF;
 END PROCESS;

	--Decide what to do.
	Forward_A_OP: Switch3to1 generic map(N=>31)
	port map(Forward_A,rData_1,MEMWB_rData,EXMEM_ALU_Result,A_input);
	Forward_B_OP: Switch3to1 generic map(N=>31)
	port map(Forward_B,rData_2,MEMWB_rData,EXMEM_ALU_Result,Binput);

	
	B_input <= Local_Shifti_extend  WHEN Shifti_1 = '1' ELSE	
				Lui_Extend_1				WHEN Lui_1 = '1' ELSE
				SE_1 (31 DOWNTO 0) 		WHEN (ALUSrc_1 = '1') ELSE
				Binput;	
							

 ALU_Control<= Funct_field when ALU_Op_1(1) = '1' 
				else "111111" when ALU_Op_1(0) = '1'
				else "101010" when Slti_1 = '1'
				else "100101" when Ori_1 ='1'
				else "100000";
				
 --Set ALU_Zero
 Zero <= '1' WHEN ( ALU_output (7 DOWNTO 0) = "00000000") ELSE '0';
 
 --Reg File : Write Addr
 	wAddr_OP: Switch2to1 generic map(N=>4)
	port map(RegDst_1, wAddr_0_1,wAddr_1_1,wAddr);

 --ALU Output:  Must check for SLT instr and set correct ALU_output
 ALU_Result(31 DOWNTO 0) <= (x"0000000" & b"000" & ALU_output (31)) WHEN ALU_Control = "101010" or  ALU_Control = "101011"     
ELSE ALU_output (31 DOWNTO 0);

 --Compute the ALU_output use the ALU_Control signals 
 PROCESS (ALU_Control, A_input, B_input)
	variable v : STD_LOGIC_VECTOR(31 downto 0); 
	variable A_signed, B_signed   : signed(31 downto 0);
   variable A_unsigned, B_unsigned : unsigned(31 downto 0);
  BEGIN --ALU Operation
  
	A_signed  := signed(A_input);
   B_signed  := signed(B_input);
   A_unsigned := unsigned(A_input);
   B_unsigned := unsigned(B_input);

  CASE ALU_Control IS
   --Function: A_input AND B_input
   WHEN "100100" => ALU_output <= A_input AND B_input;
   --Function: A_input OR B_input
   WHEN "100101" => ALU_output <= A_input OR B_input;
   --Function: A_input ADD B_input
   WHEN "100000" => ALU_output <= std_logic_vector(CONV_SIGNED(A_signed + B_signed, 32));
	--std_logic_vector(A_signed + B_signed);
	--Function: A_input SUB B_input
   WHEN "100010" => ALU_output <= std_logic_vector(CONV_SIGNED(A_signed - B_signed, 32));
	--std_logic_vector(A_signed - B_signed);
   --Function: NOR   not (A_input or B_input)   100111     op : 10 ---->101
   WHEN "100111" => ALU_output <= A_input NOR B_input;
	--Function: XOR   
   WHEN "100110" => ALU_output <= A_input XOR B_input;
   --Function: SLT (set less than)
   WHEN "101010" => ALU_output <= A_input - B_input;
	--Function: SLTU
	WHEN "101011" => ALU_output <= A_input - B_input;
	
	--Function: MFHI
	WHEN "010000" => ALU_output <= hi_reg_1;
	
	--Function: MFLO
	WHEN "010010" => ALU_output <= lo_reg_1;
	
	--Function: MULT
	WHEN "011000" => 
						mul_result_1 <= std_logic_vector(CONV_SIGNED(A_signed * B_signed, 64));
						--mul_result <= A_input * B_input;
						--mul_result <= mul_temp;
						--ALU_output <= std_logic_vector(mul_temp(31 downto 0));
						--lo_result <= std_logic_vector(mul_temp(31 downto 0));
						--hi_result <= std_logic_vector(mul_temp(63 downto 32));
	--Function: MULTU
	WHEN "011001" => mul_result_1 <= std_logic_vector(CONV_UNSIGNED(A_unsigned * B_unsigned, 64));
	--Function: DIV
	WHEN "011010" => ALU_output <= A_input - B_input;
	--Function: DIVU
	WHEN "011011" => ALU_output <= A_input - B_input;
	--Function: ADDU
	WHEN "100001" => ALU_output <= A_input + B_input;
	--std_logic_vector(A_unsigned + B_unsigned);
	--Function: SUBU
	WHEN "100011" => ALU_output <= A_input - B_input;
	--std_logic_vector(A_unsigned - B_unsigned);

	--Function: SLL 
	WHEN "000000" | "000100" => 
	
	--ALU_output <= std_logic_vector(shift_left(A_input, B_input));
	
	if B_input >x"001F" then 
				v(31 downto 0) := (others => '0');
			else
				v(31 downto 0) := A_input(31 downto 0);	
				if B_input(4) = '1' then
					v(31 downto 16) := v(15 downto 0);
					v(15 downto 0) := (others => '0');
				end if;
				if B_input(3) = '1' then
					v(31 downto 8) := v(23 downto 0);
					v(7 downto 0) := (others => '0');
				end if;
				if B_input(2) = '1' then
					v(31 downto 4) := v(27 downto 0);
					v(3 downto 0) := (others => '0');
				end if;
				if B_input(1) = '1' then
					v(31 downto 2) := v(29 downto 0);
					v(1 downto 0) := (others => '0');
				end if;
				if B_input(0) = '1' then
					v(31 downto 1) := v(30 downto 0);
					v(0) := '0';
				end if;
			end if;
	ALU_output <= v;
	--Function: SRA
	WHEN "000011" | "000111" => 
	
	if B_input >x"001F" then 
				v(31 downto 0) := (others => A_input(31));
			else
				v(31 downto 0) := A_input(31 downto 0);	
				if B_input(4) = '1' then
					v(15 downto 0) := v(31 downto 16);
					v(31 downto 16) := (others => v(31));
				end if;
				if B_input(3) = '1' then
					v(23 downto 0) := v(31 downto 8);
					v(31 downto 24) := (others => v(31));
				end if;
				if B_input(2) = '1' then
					v(27 downto 0) := v(31 downto 4);
					v(31 downto 28) := (others => v(31));
				end if;
				if B_input(1) = '1' then
					v(29 downto 0) := v(31 downto 2);
					v(31 downto 30) := (others => v(31));
				end if;
				if B_input(0) = '1' then
					v(30 downto 0) := v(31 downto 1);
				end if;
			end if;
			--temp (31 downto 0) <= v(31 downto 0);
			ALU_output(31 downto 0)<= v(31 downto 0);
	--Function: SRL
	WHEN "000010" | "000110" => 
		if B_input >x"001F" then 
				v(31 downto 0) := (others => '0');
			else
				v(31 downto 0) := A_input(31 downto 0);	
				if B_input(4) = '1' then
					v(15 downto 0) := v(31 downto 16);
					v(31 downto 16) := (others => '0');
				end if;
				if B_input(3) = '1' then
					v(23 downto 0) := v(31 downto 8);
					v(31 downto 24) := (others => '0');
				end if;
				if B_input(2) = '1' then
					v(27 downto 0) := v(31 downto 4);
					v(31 downto 28) := (others => '0');
				end if;
				if B_input(1) = '1' then
					v(29 downto 0) := v(31 downto 2);
					v(31 downto 30) := (others => '0');
				end if;
				if B_input(0) = '1' then
					v(30 downto 0) := v(31 downto 1);
					v(31) := '0';
				end if;
			end if;
			--temp (31 downto 0) <= v(31 downto 0);
			ALU_output(31 downto 0)<= v(31 downto 0);
	
   WHEN OTHERS => ALU_output <= x"00000000";
  END CASE;
 END PROCESS;

 PROCESS (Clock)
 BEGIN
	if(rising_edge(Clock)) then
  IF Reset = '1' THEN

	Zero_1   			<= '0';
	MRead_2  			<= '0';
	RegWrite_2  		<= '0';
	MWrite_2  			<= '0';
	MemtoReg_2  		<= '0';
	MEMWBRegWrite  		<= '0';
	EXMEMRegWrite 	 	<= '0';
	forwardA  			<= "00";
	forwardB  			<= "00";	
	wAddr_1 			<= "00000";
	EXMEMReg_Rd 		<= "00000";
	MEMWBReg_Rd 		<= "00000";
	IDEXReg_Rs 			<= "00000";
	IDEXReg_Rt 			<= "00000";
	ALU_Result_1  		<= X"00000000";
	rData_2_2  			<= X"00000000";
	ALU1   				<= X"00000000";
	ALU2   				<= X"00000000";
  	MEMWBrData  		<= X"00000000";
	EXMEMALU_Result 	<= X"00000000";
  ELSE
   Zero_1   			<= Zero;
   ALU_Result_1  		<= ALU_Result;
   wAddr_1 				<= wAddr;
   MemtoReg_2  			<= MemtoReg_1;
   rData_2_2  			<= rData_2;
   MRead_2  			<= MRead_1;
   RegWrite_2  			<= RegWrite_1;
   MWrite_2  			<= MWrite_1;
   ALU1   				<= A_input;
   ALU2   				<= B_input;
   forwardA  			<= Forward_A;
   forwardB  			<= Forward_B;
   EXMEMRegWrite  		<= EXMEM_RegWrite;
   EXMEMALU_Result 		<= EXMEM_ALU_Result;
   EXMEMReg_Rd 			<= EXMEM_Reg_Rd;
   MEMWBRegWrite  		<= MEMWB_RegWrite;
   MEMWBReg_Rd 			<= MEMWB_Reg_Rd;
   MEMWBrData  			<= MEMWB_rData;
   IDEXReg_Rs 			<= IDEX_Reg_Rs;
   IDEXReg_Rt 			<= IDEX_Reg_Rt;
  END IF;
   END IF; 
 END PROCESS;
END behavioral;


