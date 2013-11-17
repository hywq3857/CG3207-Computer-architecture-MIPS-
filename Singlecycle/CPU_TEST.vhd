
--Written by Yee Tang
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CPU_TEST IS
END CPU_TEST;
 
ARCHITECTURE behavior OF CPU_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU
    PORT(
         PC : OUT  std_logic_vector(31 downto 0);
         Instruction_out : OUT  std_logic_vector(31 downto 0);
			Final_Data_out : OUT  std_logic_vector(31 downto 0);
					 Operand1		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Operand2		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
		 Result1		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Result2		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  
		 Ctrl		: IN STD_LOGIC_VECTOR(5 DOWNTO 0);		 
         Clock : IN  std_logic;
         Reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';
		signal Control		: STD_LOGIC_VECTOR(5 DOWNTO 0);
	signal Operand1		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal Operand2		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal Result1		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal Result2		: STD_LOGIC_VECTOR(31 DOWNTO 0);

 	--Outputs
   signal PC : std_logic_vector(31 downto 0);
   signal Instruction_out : std_logic_vector(31 downto 0);
	signal Final_Data_out :  std_logic_vector(31 downto 0);


   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU PORT MAP (
          PC => PC,
          Instruction_out => Instruction_out,
			 Final_Data_out => Final_Data_out,
			 		Ctrl			=>	Control,
		Operand1			=>	Operand1,
		Operand2			=>	Operand2,
		Result1			=>	Result1,
		Result2			=>	Result2,
          Clock => Clock,
          Reset => Reset
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;	
		Control <="000001";
      wait for Clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
