
--Written by Yee Tang, Hu Yang and Haoxuan
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL; 
 USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Decode IS
 PORT ( 
  Read_Data_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  Read_Data_2  : OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
  Write_Reg    : OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
  RegWrite : IN STD_LOGIC;
  RegDst  :  IN  STD_LOGIC;
  ALU_Result : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
  MemtoReg : IN STD_LOGIC;
  Read_data : IN   STD_LOGIC_VECTOR (31 DOWNTO 0);
  Instruction : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
  Lui_Extend : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  Sign_Extend : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
  Jump_Instr :    OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
  Shift_flag : IN STD_LOGIC;
  JumpAL	: in std_logic;
  JumpALR	: in std_logic;
  PC_out   	: in STD_LOGIC_VECTOR(31 DOWNTO 0);
  lo_register : out STD_LOGIC_VECTOR(31 DOWNTO 0);
  hi_register : out STD_LOGIC_VECTOR(31 DOWNTO 0);
 mul_result : in std_logic_vector (63 downto 0);
  shift_i_flag : in std_logic;
  BGEZAL_EN : in std_logic;
  Clock, Reset : IN STD_LOGIC;
  Operand1		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  Operand2		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
  Result1		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  Result2		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)      
 );
  
END Decode;
ARCHITECTURE behavior OF Decode IS

TYPE register_file IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL register_array  : register_file := (
	others => x"00000000"
);
 SIGNAL read_register_address1 : STD_LOGIC_VECTOR (4 DOWNTO 0);
 SIGNAL read_register_address2 : STD_LOGIC_VECTOR (4 DOWNTO 0);
 SIGNAL write_register_address : STD_LOGIC_VECTOR (4 DOWNTO 0);
 SIGNAL write_register_address0: STD_LOGIC_VECTOR (4 DOWNTO 0);
 SIGNAL write_register_address1: STD_LOGIC_VECTOR (4 DOWNTO 0);
 SIGNAL write_data  : STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL instruction_15_0 : STD_LOGIC_VECTOR (15 DOWNTO 0);
 SIGNAL instruction_25_0 : STD_LOGIC_VECTOR (25 DOWNTO 0);
 signal JAL_data	: std_logic_vector(31 downto 0);
 signal lo : std_logic_vector(31 downto 0);
 signal hi : std_logic_vector(31 downto 0);
 signal PC_out_plus_4: std_logic_vector(31 DOWNTO 0);

BEGIN

 read_register_address1  <= Instruction (25 DOWNTO 21) when shift_flag = '0'
							else Instruction (20 DOWNTO 16);
							
 read_register_address2  <= Instruction (20 DOWNTO 16) when shift_flag = '0'
							else Instruction (25 DOWNTO 21);
							
 write_register_address0 <= Instruction (20 DOWNTO 16);
 write_register_address1 <= Instruction (15 DOWNTO 11);
 instruction_15_0    <= Instruction (15 DOWNTO 0);
 instruction_25_0   <= Instruction (25 DOWNTO 0);

 Read_Data_1 <= register_array(CONV_INTEGER(read_register_address1 (4 DOWNTO 0)));
 Read_Data_2 <= register_array(CONV_INTEGER(read_register_address2 (4 DOWNTO 0)));

 write_register_address <= write_register_address1 WHEN (RegDst = '1')
        ELSE write_register_address0;

 write_data <= ALU_result (31 DOWNTO 0) WHEN (MemtoReg = '0')
         ELSE Read_data;

 
	 lo_register <= mul_result(31 DOWNTO 0);
	 hi_register <= mul_result(63 DOWNTO 32);
 
 
 
	Sign_Extend(15 downto 0) <= instruction_15_0 (15 DOWNTO 0);
	Sign_Extend(31 downto 16) <= (others => instruction_15_0(15));
	
	lui_Extend(31 downto 16) <= instruction_15_0 (15 DOWNTO 0);
	lui_Extend(15 downto 0) <= (others => '0');
	
	Jump_Instr(27 downto 2) <= instruction_25_0 (25 DOWNTO 0);
	Jump_Instr(31 downto 28)<= (others => '0');
	Jump_Instr(1 downto 0)<= (others => '0');

	JAL_data(29 downto 4) <= instruction_25_0 (25 DOWNTO 0);
	JAL_data(31 downto 30)<= (others => '0');
	JAL_data(3 downto 0)  <= (others => '0');

 Write_Reg  <= write_register_address;
 
	PC_out_plus_4 (31 DOWNTO 2)  <= PC_out (31 DOWNTO 2) + 1;
	PC_out_plus_4 (1 DOWNTO 0)  <= PC_out (1 DOWNTO 0);
 
 PROCESS(RegWrite,Clock, JumpAL, BGEZAL_EN)
 BEGIN
	if(rising_edge(Clock))then 
	  IF (RegWrite = '1') AND (write_register_address /= 0) THEN
		register_array(CONV_INTEGER(write_register_address (4 DOWNTO 0)))  <= write_data;
	  END IF; 
	  --used for jalr only
	  IF (JumpALR = '1') AND (write_register_address /= 0) THEN
		register_array(CONV_INTEGER(write_register_address (4 DOWNTO 0)))  <= PC_out_plus_4;
	  END IF; 
	  --used for jal only
	  IF (JumpAL = '1') or ( BGEZAL_EN ='1') THEN
		register_array(31)  <= PC_out_plus_4;
	  END IF; 
   Result1		<= register_array(18);
   Result2		<= register_array(19);
  
 	register_array(16) <= Operand1;
 	register_array(17) <= Operand1;		  
  end if;
 END PROCESS;
END behavior;


------------------------------------------------------------------
