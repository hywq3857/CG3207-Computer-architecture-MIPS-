--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:25:36 11/09/2013
-- Design Name:   
-- Module Name:   C:/Users/Yee Tang/Desktop/CG3207/1109/LAB2/project/testbenches/Fetch_TB.vhd
-- Project Name:  LAB2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Fetching
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
 --Written by Yee Tang
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Fetch_TB IS
END Fetch_TB;
 
ARCHITECTURE behavior OF Fetch_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Fetching
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         Stall : IN  std_logic;
         Branch : IN  std_logic;
         Branch_NE : IN  std_logic;
         BGEZ_1 : IN  std_logic;
         BGEZAL_1 : IN  std_logic;
         Jump_1 : IN  std_logic;
         IFFlush : IN  std_logic;
         IFFlush_2 : IN  std_logic;
         IF_Branch : OUT  std_logic;
         IF_BranchNE : OUT  std_logic;
         IFFlush_1 : OUT  std_logic;
         IFFlush_3 : OUT  std_logic;
         BGEZAL_EN : OUT  std_logic;
         Ctrl : IN  std_logic_vector(5 downto 0);
         rData_1 : IN  std_logic_vector(31 downto 0);
         rData_2 : IN  std_logic_vector(31 downto 0);
         SE : IN  std_logic_vector(31 downto 0);
         PC_plus_4 : IN  std_logic_vector(31 downto 0);
         Jump_Addr_1 : IN  std_logic_vector(31 downto 0);
         PC_Out : OUT  std_logic_vector(31 downto 0);
         Instr_1 : OUT  std_logic_vector(31 downto 0);
         PC_plus_4_1 : OUT  std_logic_vector(31 downto 0);
         NXT_PC : OUT  std_logic_vector(31 downto 0);
         IF_rData1 : OUT  std_logic_vector(31 downto 0);
         IF_rData2 : OUT  std_logic_vector(31 downto 0);
         IF_SE : OUT  std_logic_vector(31 downto 0);
         IF_PCPlus4 : OUT  std_logic_vector(31 downto 0);
         IF_AddResult : OUT  std_logic_vector(31 downto 0);
         IF_Zero : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal Stall : std_logic := '0';
   signal Branch : std_logic := '0';
   signal Branch_NE : std_logic := '0';
   signal BGEZ_1 : std_logic := '0';
   signal BGEZAL_1 : std_logic := '0';
   signal Jump_1 : std_logic := '0';
   signal IFFlush : std_logic := '0';
   signal IFFlush_2 : std_logic := '0';
   signal Ctrl : std_logic_vector(5 downto 0) := (others => '0');
   signal rData_1 : std_logic_vector(31 downto 0) := (others => '0');
   signal rData_2 : std_logic_vector(31 downto 0) := (others => '0');
   signal SE : std_logic_vector(31 downto 0) := (others => '0');
   signal PC_plus_4 : std_logic_vector(31 downto 0) := (others => '0');
   signal Jump_Addr_1 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal IF_Branch : std_logic;
   signal IF_BranchNE : std_logic;
   signal IFFlush_1 : std_logic;
   signal IFFlush_3 : std_logic;
   signal BGEZAL_EN : std_logic;
   signal PC_Out : std_logic_vector(31 downto 0);
   signal Instr_1 : std_logic_vector(31 downto 0);
   signal PC_plus_4_1 : std_logic_vector(31 downto 0);
   signal NXT_PC : std_logic_vector(31 downto 0);
   signal IF_rData1 : std_logic_vector(31 downto 0);
   signal IF_rData2 : std_logic_vector(31 downto 0);
   signal IF_SE : std_logic_vector(31 downto 0);
   signal IF_PCPlus4 : std_logic_vector(31 downto 0);
   signal IF_AddResult : std_logic_vector(31 downto 0);
   signal IF_Zero : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Fetching PORT MAP (
          CLK => CLK,
          RESET => RESET,
          Stall => Stall,
          Branch => Branch,
          Branch_NE => Branch_NE,
          BGEZ_1 => BGEZ_1,
          BGEZAL_1 => BGEZAL_1,
          Jump_1 => Jump_1,
          IFFlush => IFFlush,
          IFFlush_2 => IFFlush_2,
          IF_Branch => IF_Branch,
          IF_BranchNE => IF_BranchNE,
          IFFlush_1 => IFFlush_1,
          IFFlush_3 => IFFlush_3,
          BGEZAL_EN => BGEZAL_EN,
          Ctrl => Ctrl,
          rData_1 => rData_1,
          rData_2 => rData_2,
          SE => SE,
          PC_plus_4 => PC_plus_4,
          Jump_Addr_1 => Jump_Addr_1,
          PC_Out => PC_Out,
          Instr_1 => Instr_1,
          PC_plus_4_1 => PC_plus_4_1,
          NXT_PC => NXT_PC,
          IF_rData1 => IF_rData1,
          IF_rData2 => IF_rData2,
          IF_SE => IF_SE,
          IF_PCPlus4 => IF_PCPlus4,
          IF_AddResult => IF_AddResult,
          IF_Zero => IF_Zero
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		Stall 			<='0';
		rData_1 	<=X"00000000";
		rData_2 	<=X"00000000";
		SE 	<=X"00000000";
		Branch 			<='0';
		Branch_NE 		<='0';
		PC_plus_4 		<=NXT_PC;
		IFFlush 			<='0';
		IFFlush_1 		<='0';
		IFFlush_2 		<='0';
      wait for CLK_period;
		Stall 			<='0';
		rData_1 	<=X"00000000";
		rData_2 	<=X"00000000";
		SE 	<=X"00000000";
		Branch 			<='0';
		Branch_NE 		<='0';
		PC_plus_4 		<=NXT_PC;
		IFFlush 			<='0';
		IFFlush_1 		<='0';
		IFFlush_2 		<='0';
      -- insert stimulus here 
      wait;
   end process;

END;