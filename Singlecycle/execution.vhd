
--Written by Hu Yang
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_unSIGNED.ALL;

ENTITY execution IS
PORT( 
 Read_Data_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
 Read_Data_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
 Sign_Extend : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
 Lui_Extend : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
 Lui_Flag	: in std_logic;
 shift_i_flag	: in std_logic;
 slti_flag : in std_logic;
 mul_div_flag: in std_logic;
 BGEZ_flag : in std_logic;
 BGEZAL_flag : in std_logic; 
 ori_flag : in std_logic;
 ALUSrc  : IN STD_LOGIC;
 Zero  : OUT STD_LOGIC;
 ALU_Result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
 mul_result : out std_logic_vector (63 downto 0);
 lo_register : in STD_LOGIC_VECTOR(31 DOWNTO 0);
 hi_register : in STD_LOGIC_VECTOR(31 DOWNTO 0);
 Funct_field : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
 shift_i_field: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
 ALU_Op  : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
 Add_Result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
 PC_plus_4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
 BGEZAL_EN : out std_logic;
 Branch : in std_logic;
 Branch_NE : in std_logic;
 Jump_Instr : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
 Jump_Address : OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
 Clock, Reset : IN STD_LOGIC);
END execution;

ARCHITECTURE behavior of execution IS
 
 SIGNAL A_input, B_input : STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL ALU_output  : STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL Branch_Add  :  STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL Jump_Add  : STD_LOGIC_VECTOR (31 DOWNTO 0);
 SIGNAL ALU_Control  : STD_LOGIC_VECTOR (5 DOWNTO 0);
 signal sign_shift2 : STD_LOGIC_VECTOR (31 downto 0);
 signal shift_i_extend : STD_LOGIC_VECTOR (31 downto 0);
 signal high_result : STD_LOGIC_VECTOR (31 downto 0);
 signal low_result : STD_LOGIC_VECTOR (31 downto 0);

 
BEGIN
 
		shift_i_extend (4 downto 0) <= shift_i_field(4 downto 0);
		shift_i_extend (31 downto 5) <= "000000000000000000000000000";

		A_input <= 	Read_Data_1 ;

		B_input <= 	shift_i_extend  when shift_i_flag = '1' else	
						Lui_Extend	when Lui_Flag = '1' else
						Sign_Extend when ALUSrc = '1' else
						
						Read_Data_2;
 
 ALU_Control<= Funct_field when ALU_Op(1) = '1' 
				else "111111" when ALU_Op(0) = '1'
				else "101010" when slti_flag = '1'
				else "100101" when ori_flag ='1'
				else "100000";

 Zero <= '1' WHEN ( ALU_output (31 DOWNTO 0) = "00000000") ELSE '0';
 
 ALU_Result(31 DOWNTO 0) <= 
		(x"0000000" & b"000" & ALU_output (31)) WHEN ALU_Control = "101010" or  ALU_Control = "101011"     
		ELSE ALU_output (31 DOWNTO 0);
 
 Sign_shift2(31 DOWNTO 2) <= sign_extend(29 DOWNTO 0);
 Sign_shift2(1 DOWNTO 0) <= "00";
 
 BGEZAL_EN <='1' when (BGEZAL_flag = '1' and A_input(31) = '0')
						else '0';
 
 Branch_Add <= PC_plus_4 (31 DOWNTO 0) + Sign_shift2 (31 DOWNTO 0) 
					when (BGEZ_flag = '1' and A_input(31) = '0')
						or (BGEZ_flag = '0' and Branch ='1' AND A_input = B_input)
						or (Branch_NE = '1' and A_input /= B_input)
					else PC_plus_4 (31 DOWNTO 0);
 Add_Result <= Branch_Add (31 DOWNTO 0);

 Jump_Add <= Jump_Instr (31 DOWNTO 0);
 Jump_Address <= A_input when ALU_Control = "001000" or ALU_Control = "001001" else Jump_Add;
 

 PROCESS (ALU_Control, A_input, B_input)
	variable v : STD_LOGIC_VECTOR(31 downto 0); 
	variable A_signed, B_signed   : signed(31 downto 0);
   variable A_unsigned, B_unsigned : unsigned(31 downto 0);
  BEGIN 
  
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
	WHEN "010000" => ALU_output <= hi_register;
	
	--Function: MFLO
	WHEN "010010" => ALU_output <= lo_register;
	
	--Function: MULT
	WHEN "011000" => 
						mul_result <= std_logic_vector(CONV_SIGNED(A_signed * B_signed, 64));

	--Function: MULTU
	WHEN "011001" => mul_result <= std_logic_vector(CONV_UNSIGNED(A_unsigned * B_unsigned, 64));
	--Function: DIV
	WHEN "011010" => ALU_output <= A_input - B_input;
	--Function: DIVU
	WHEN "011011" => ALU_output <= A_input - B_input;
	--Function: ADDU
	WHEN "100001" => ALU_output <= A_input + B_input;

	--Function: SUBU
	WHEN "100011" => ALU_output <= A_input - B_input;

	--Function: SLL 
	WHEN "000000" | "000100" => 
	
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
END behavior;