
--Written by Yee Tang, Hu Yang and Haoxuan
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY CPU IS 
 
PORT( PC   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); 
		 Instruction_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		 Final_Data_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		 Operand1		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Operand2		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
		 Result1		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Result2		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  
		 Ctrl		: IN STD_LOGIC_VECTOR(5 DOWNTO 0);		 
		 Clock, Reset  : IN STD_LOGIC
		 );

END CPU;

ARCHITECTURE Behavioral of CPU IS 


COMPONENT Fetch
 PORT( PC_Out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  Instruction  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  Add_Result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  PC_plus_4_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); 
  Branch  : IN  STD_LOGIC;
  Branch_NE : IN STD_LOGIC;
  Zero  : IN STD_LOGIC;
  Jump  : IN STD_LOGIC;
  Jump_Address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  Clock, Reset : IN STD_LOGIC;
	Ctrl			: IN STD_LOGIC_VECTOR(5 DOWNTO 0)	 
 );
  
END COMPONENT;

COMPONENT Decode
 PORT (
  Read_Data_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  Read_Data_2  : OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
  Write_Reg    : OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
  RegWrite : IN STD_LOGIC;
  RegDst  : IN  STD_LOGIC;
  ALU_Result : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
  MemtoReg : IN STD_LOGIC;
  Read_data : IN   STD_LOGIC_VECTOR (31 DOWNTO 0);
  Instruction : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
  Lui_Extend : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  Sign_Extend : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  Jump_Instr : OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
  lo_register : out STD_LOGIC_VECTOR(31 DOWNTO 0);
  hi_register : out STD_LOGIC_VECTOR(31 DOWNTO 0);
 mul_result : in std_logic_vector (63 downto 0);
  Shift_flag : IN STD_LOGIC;
  BGEZAL_EN : in std_logic;
  JumpAL	: in std_logic;
  JumpALR : in std_logic;
  PC_Out  : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  shift_i_flag	: in std_logic;
  Operand1		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  Operand2		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);  
  Result1		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  Result2		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);     
  Clock, Reset : IN STD_LOGIC);
END COMPONENT;

COMPONENT CU IS
PORT(
  Opcode  : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
  RegDst  : OUT  STD_LOGIC;
  Branch  : OUT  STD_LOGIC;
  Branch_NE : OUT  STD_LOGIC;
  MemRead  : OUT  STD_LOGIC;
  MemtoReg : OUT  STD_LOGIC;
  ALU_Op  : OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);
  MemWrite : OUT  STD_LOGIC;
  ALUSrc  : OUT  STD_LOGIC;
  RegWrite : OUT  STD_LOGIC;
  Jump  : OUT  STD_LOGIC;
  JumpAL : out std_logic;
  JumpALR : out std_logic;
  lui_flag	: out std_logic;
  shift_flag	: out std_logic;
  shift_i_flag	: out std_logic;
  slti_flag : out std_logic;
 mul_div_flag: out std_logic;
 BGEZ_flag : out std_logic;
 BGEZAL_flag : out std_logic;
  ori_flag : out std_logic;
 instruction :  in std_logic_vector (31 downto 0);
  BGEZ_field : in std_logic_vector (4 downto 0);
  Funct_field : in std_logic_vector (5 downto 0);
  Clock, Reset : IN  STD_LOGIC);
END COMPONENT;

COMPONENT execution IS
 PORT(
  Read_Data_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
  Read_Data_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
  Sign_Extend : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
  Lui_Extend : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
  Lui_Flag	: in std_logic;
  ori_flag : in std_logic;
  shift_i_flag	: in std_logic;
  slti_flag : in std_logic;
 mul_div_flag: in std_logic;
 BGEZ_flag : in std_logic;
 BGEZAL_flag : in std_logic;
 BGEZAL_EN : out std_logic;
 Branch : in  STD_LOGIC;
 Branch_NE : in  STD_LOGIC;
  Jump_Instr : IN   STD_LOGIC_VECTOR (31 DOWNTO 0);
  Jump_Address : OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
  ALUSrc  : IN STD_LOGIC;
  Zero  : OUT STD_LOGIC;
  ALU_Result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  shift_i_field: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
  Funct_field : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
  ALU_Op  : IN STD_LOGIC_VECTOR (1 DOWNTO 0);  
  Add_Result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  lo_register : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  hi_register : in STD_LOGIC_VECTOR(31 DOWNTO 0);
 mul_result : out std_logic_vector (63 downto 0);
  PC_plus_4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
  Clock, Reset : IN STD_LOGIC);
END COMPONENT; 

COMPONENT Store IS
 PORT(
  Read_Data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  Address  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
  Write_Data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
  MemRead  : IN STD_LOGIC;
  MemWrite : IN STD_LOGIC;
  Clock : In std_logic);
END COMPONENT;

SIGNAL Add_Result : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ALU_Result : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL ALU_Op  : STD_LOGIC_VECTOR (1 DOWNTO 0);  
SIGNAL ALUSrc  : STD_LOGIC;
SIGNAL Branch  : STD_LOGIC;
SIGNAL Branch_NE : STD_LOGIC;
SIGNAL Instruction  : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Jump  : STD_LOGIC;
signal JumpAL : std_logic;
signal JumpALR : std_logic;
SIGNAL  Jump_Address : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL  Jump_Instr : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL MemRead  : STD_LOGIC;
SIGNAL MemtoReg : STD_LOGIC;
SIGNAL MemWrite : STD_LOGIC;
SIGNAL PC_Out  : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL PC_plus_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Read_data : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Read_Data_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Read_Data_2  : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL RegDst  : STD_LOGIC;
SIGNAL RegWrite : STD_LOGIC;
signal Lui_Extend :   STD_LOGIC_VECTOR (31 DOWNTO 0);
Signal Lui_Flag	:  std_logic;
SIGNAL shift_flag	: std_logic;
SIGNAL shift_i_flag	: std_logic;
signal slti_flag : std_logic;
signal mul_div_flag: std_logic;
signal BGEZ_flag : std_logic;
signal BGEZAL_flag : std_logic;
signal BGEZAL_EN : std_logic;
signal ori_flag : std_logic;
SIGNAL Sign_Extend : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Write_Reg    : STD_LOGIC_VECTOR (4 DOWNTO 0);
SIGNAL Zero  : STD_LOGIC;
signal lo_register :  STD_LOGIC_VECTOR(31 DOWNTO 0);
 signal hi_register :  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal  mul_result :  std_logic_vector (63 downto 0);

SIGNAL  NClock  : STD_LOGIC;

BEGIN

 PC   <=  PC_Out;
 Instruction_out<= Instruction;
 Final_Data_out <= Read_Data;
 
 Fetching : Fetch PORT MAP ( 
   PC_Out  => PC_Out,
   Instruction  => Instruction,
   Add_Result => Add_Result,
	PC_plus_4_out => PC_plus_4,
   Branch  => Branch,
   Branch_NE => Branch_NE,
   Zero  => Zero,
   Jump  => Jump,
   Jump_Address => Jump_Address,
   Clock  => Clock,
   Reset  => Reset,
  	 Ctrl =>Ctrl 
   );

 Decoding : Decode PORT MAP (
   Read_Data_1 => Read_Data_1,
   Read_Data_2  => Read_Data_2,
   Write_Reg    => Write_Reg,
   RegWrite => RegWrite,
   RegDst  => RegDst,
   ALU_Result => ALU_Result,
   MemtoReg => MemtoReg,
   Read_data => Read_data,
   Instruction => Instruction,
	lui_Extend => lui_Extend,
   Sign_Extend => Sign_Extend,
	shift_flag => shift_flag,
	shift_i_flag => shift_i_flag,
	BGEZAL_EN => BGEZAL_EN,
   Jump_Instr => Jump_Instr,
	JumpAl => JumpAL,
	JumpAlR => JumpALR,
	lo_register => lo_register,
   hi_register => hi_register,
   mul_result =>mul_result,
	PC_Out  => PC_Out,
   Clock  => Clock,
   Reset  => Reset,
 	 Operand1		=> Operand1,
	 Operand2		=> Operand2,
	 Result1		=> Result1,
    Result2		=> Result2 
   );

 CONTROL : CU PORT MAP (
   Opcode  => Instruction (31 DOWNTO 26),
   RegDst  => RegDst,
   Jump  => Jump,
	JumpAl => JumpAL,
	JumpAlR => JumpALR,
	lui_flag => lui_flag,
	shift_flag => shift_flag,	
	shift_i_flag => shift_i_flag,
	slti_flag => slti_flag,
	mul_div_flag => mul_div_flag,
	BGEZ_flag => BGEZ_flag,
	BGEZAL_flag => BGEZAL_flag,
	ori_flag => ori_flag,
   Branch  => Branch,
   Branch_NE => Branch_NE,
   MemRead  => MemRead,
   MemtoReg => MemtoReg,
   ALU_Op  => ALU_Op,
   MemWrite => MemWrite,
   ALUSrc  => ALUSrc,
   RegWrite => RegWrite,
	instruction => instruction,
   Clock  => Clock,
	BGEZ_field => Instruction (20 DOWNTO 16),
	Funct_field => Instruction (5 DOWNTO 0),
   Reset  => Reset );

 Executing : execution PORT MAP (
   Read_Data_1 => Read_Data_1,
   Read_Data_2 => Read_Data_2,
   lui_Extend => lui_Extend,
	lui_flag => lui_flag,
	shift_i_flag => shift_i_flag,
	slti_flag => slti_flag,
	mul_div_flag => mul_div_flag,
	BGEZ_flag => BGEZ_flag,
	BGEZAL_flag => BGEZAL_flag,
	BGEZAL_EN => BGEZAL_EN,
	Branch  => Branch,
	Branch_NE => Branch_NE,
	ori_flag => ori_flag,
	Sign_Extend => Sign_Extend,
   ALUSrc  => ALUSrc,
   Zero  => Zero,
   ALU_Result => ALU_Result,
	shift_i_field => Instruction ( 10 downto 6),
   Funct_field => Instruction (5 DOWNTO 0),
   ALU_Op  => ALU_Op,
   Add_Result => Add_Result,
   PC_plus_4 => PC_plus_4,
	lo_register => lo_register,
   hi_register => hi_register,
   mul_result =>mul_result,
   Jump_Address => Jump_Address, 
   Jump_Instr => Jump_Instr,
   Clock  => Clock,
   Reset  => Reset );

 Storing : Store PORT MAP (
   Read_Data => Read_Data,
   Address  => ALU_Result,
   Write_Data => Read_Data_2,
   MemRead  => MemRead,
   MemWrite => MemWrite,
	Clock => Clock);

END Behavioral;