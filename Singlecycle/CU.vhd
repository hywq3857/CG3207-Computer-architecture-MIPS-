
--Written by Hu Yang
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY CU IS
PORT( SIGNAL Opcode  : IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
 SIGNAL RegDst  : OUT STD_LOGIC;
 SIGNAL Branch  : OUT STD_LOGIC;
 SIGNAL  Branch_NE : OUT STD_LOGIC;
 SIGNAL MemRead  : OUT STD_LOGIC;
 SIGNAL MemtoReg : OUT STD_LOGIC;
 SIGNAL ALU_Op  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
 SIGNAL MemWrite : OUT STD_LOGIC;
 SIGNAL ALUSrc  : OUT STD_LOGIC;
 SIGNAL RegWrite : OUT STD_LOGIC;
 SIGNAL  Jump  : OUT STD_LOGIC;
 Signal JumpAl : out Std_logic;
 Signal JumpAlR : out Std_logic;
 SIGNAL	lui_flag	: out std_logic;
 SIGNAL	shift_flag	: out std_logic;
 SIGNAL	shift_i_flag	: out std_logic;
 signal slti_flag : out std_logic;
 signal mul_div_flag: out std_logic;
 signal BGEZ_flag : out std_logic;
 signal BGEZAL_flag : out std_logic; 
 signal ori_flag : out std_logic;
 signal instruction :  in std_logic_vector (31 downto 0);
 signal BGEZ_field : in std_logic_vector (4 downto 0);
 SiGNal Funct_field : in std_logic_vector (5 downto 0);
 SIGNAL Clock, Reset : IN  STD_LOGIC);
END CU;

ARCHITECTURE behavior OF CU IS

 SIGNAL R_format, LW, SW, BEQ, BNE, JMP, JAL, JALR, JR, SLTI, MUL, DIV, MULU, DIVU, BGEZ, BGEZAL,
			 ADDI, ORI, LUI, Shift_left, Shift_right, Shift_right_ar, shift_i : STD_LOGIC;
 SIGNAL Opcode_Out    : STD_LOGIC_VECTOR (5 DOWNTO 0);

BEGIN

	 --Decode the Instruction OPCode to determine type
	 --and set all corresponding control signals &
	 --ALUOP function signals.
	 R_format <= '1' WHEN Opcode = "000000" ELSE '0';
	 LW  <= '1' WHEN Opcode = "100011" ELSE '0';
	 SW  <= '1' WHEN Opcode = "101011" ELSE '0';
	 BEQ  <= '1' WHEN Opcode = "000100" ELSE '0';
	 BNE  <= '1' WHEN Opcode = "000101" ELSE '0';
	 JMP  <= '1' WHEN Opcode = "000010" ELSE '0';
	 ADDI  <= '1' WHEN Opcode = "001000" ELSE '0';
	 ORI  <= '1' WHEN Opcode = "001101" ELSE '0';
	 LUI  <= '1' WHEN Opcode = "001111" ELSE '0';
	 JAL  <= '1' WHEN Opcode = "000011" ELSE '0';
	 SLTI  <= '1' WHEN Opcode = "001010" ELSE '0';
	 MUL  <= '1' WHEN Opcode = "000000" and Funct_field = "011000" ELSE '0';
	 MULU  <= '1' WHEN Opcode = "000000" and Funct_field = "011001" ELSE '0';
	 DIV  <= '1' WHEN Opcode = "000000" and Funct_field = "000111" ELSE '0';
	 DIVU  <= '1' WHEN Opcode = "000000" and Funct_field = "011011" ELSE '0';
	 JR  <= '1' WHEN Opcode = "000000" and Funct_field = "001000" ELSE '0';
	 JALR  <= '1' WHEN Opcode = "000000" and Funct_field = "001001" ELSE '0';
		Shift_left  <= '1' WHEN Opcode = "000000" and (Funct_field = "000000" or Funct_field = "000100") and instruction /= x"00000000" ELSE '0';
		Shift_right  <= '1' WHEN Opcode = "000000" and (Funct_field = "000010" or Funct_field = "000110") ELSE '0';
		Shift_right_ar  <= '1' WHEN Opcode = "000000" and (Funct_field = "000011" or Funct_field = "000111") ELSE '0';
		shift_i <= '1' WHEN Opcode = "000000" and (Funct_field = "000011" or Funct_field = "000010" or Funct_field = "000000") ELSE '0';
		
		BGEZ <= '1' WHEN Opcode = "000001" and BGEZ_field = "00001" ELSE '0';
		BGEZAL <= '1' WHEN Opcode = "000001" and BGEZ_field = "10001" ELSE '0';
		
	 RegDst  <= R_format; 
	 Branch  <= BEQ or BGEZ or BGEZAL;
	 Branch_NE <= BNE;
	 Jump  <= JMP or JAL or JALR or JR;
	 JumpAL <= JAL;
	 JumpALR <= JALR;
	 MemRead  <= LW;
	 MemtoReg <= LW;
	 ALU_Op(1) <= R_format;
	 ALU_Op(0) <= BEQ OR BNE or BGEZ or BGEZAL;
	 MemWrite <= SW;
	 ALUSrc  <= LW OR SW OR ADDI or ORI or LUI or SLTI;
	 RegWrite <= R_format OR LW OR ADDI or ORI or LUI or SLTI;
	 lui_flag <= LUI;
	 slti_flag <= SLTI;
	 shift_flag <= Shift_left or shift_right or shift_right_ar;
	 shift_i_flag <= shift_i;
	 ori_flag <= ori;
	 mul_div_flag <= MUL or DIV or MULU or DIVU;
	 BGEZ_flag <= BGEZ or BGEZAL;
	 BGEZAL_flag <= BGEZAL;
END behavior;

