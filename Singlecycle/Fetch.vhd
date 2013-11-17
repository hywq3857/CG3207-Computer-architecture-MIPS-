
--Written by Hu Yang and Haoxuan
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY Fetch IS
PORT( SIGNAL PC_Out   	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Instruction  	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Add_Result 		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PC_plus_4_out 	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Branch  			: IN  STD_LOGIC;
  SIGNAL Branch_NE 		: IN STD_LOGIC;
  SIGNAL Zero  			: IN STD_LOGIC;
  SIGNAL Jump  			: IN STD_LOGIC;
  SIGNAL Jump_Address  	: IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Clock, Reset 	: IN STD_LOGIC;
  SIGNAL Ctrl			: IN STD_LOGIC_VECTOR(5 DOWNTO 0)	); 
END Fetch;


ARCHITECTURE behavior OF Fetch IS
 SIGNAL PC  : STD_LOGIC_VECTOR (31 DOWNTO 0) :=(x"00400000");  
 SIGNAL PC_plus_4  : STD_LOGIC_VECTOR (31 DOWNTO 0);  
 signal temp : std_logic:='1';
 SIGNAL Next_PC  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	component IM is
		port (
				addr	:	in	std_logic_vector (31 downto 0);
				instr	:	out	std_logic_vector (31 downto 0)
			);
	end component;

BEGIN
	IM_OP: IM port map(PC,Instruction);

  PC_Out   <= PC; 
  PC_plus_4_out  <= PC_plus_4;

      PC_plus_4 (31 DOWNTO 2)  <= PC (31 DOWNTO 2) + 1;
		PC_plus_4 (1 DOWNTO 0)  <= PC(1 DOWNTO 0);
     
  Next_PC <= 
  Add_result 	WHEN ((Branch = '1') AND  (Zero = '1') AND (Branch_NE = '0') ) OR ((Branch_NE = '1') AND (Zero = '1')) ELSE  
  Jump_Address WHEN ( Jump = '1' ) ELSE 
  PC_plus_4;
  
 PROCESS(Clock)
  BEGIN
   if(rising_edge(Clock))then 
		IF Reset = '1' THEN
			 PC <= X"00400000"; 
		ELSif Ctrl="00001" then
			if temp ='1' then
			 temp <='0';
		else
			 PC<= Next_PC;
		END IF;
		end if;
	end if;
 END PROCESS;
END behavior;
