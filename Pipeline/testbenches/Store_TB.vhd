--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:28:39 11/09/2013
-- Design Name:   
-- Module Name:   C:/Users/Yee Tang/Desktop/CG3207/1109/LAB2/project/testbenches/Store_TB.vhd
-- Project Name:  LAB2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Storing
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
 
ENTITY Store_TB IS
END Store_TB;
 
ARCHITECTURE behavior OF Store_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Storing
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         MRead_2 : IN  std_logic;
         MWrite_2 : IN  std_logic;
         MemtoReg_2 : IN  std_logic;
         RegWrite_2 : IN  std_logic;
         MRead_3 : OUT  std_logic;
         MWrite_3 : OUT  std_logic;
         MemtoReg_3 : OUT  std_logic;
         RegWrite_3 : OUT  std_logic;
         wAddr_1 : IN  std_logic_vector(4 downto 0);
         wAddr_2 : OUT  std_logic_vector(4 downto 0);
         ALU_Result_1 : IN  std_logic_vector(31 downto 0);
         Addr : IN  std_logic_vector(31 downto 0);
         wData : IN  std_logic_vector(31 downto 0);
         rData_2_3 : OUT  std_logic_vector(31 downto 0);
         ALU_Result_2 : OUT  std_logic_vector(31 downto 0);
         rData_1 : OUT  std_logic_vector(31 downto 0);
         Reg_wData : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal MRead_2 : std_logic := '0';
   signal MWrite_2 : std_logic := '0';
   signal MemtoReg_2 : std_logic := '0';
   signal RegWrite_2 : std_logic := '0';
   signal wAddr_1 : std_logic_vector(4 downto 0) := (others => '0');
   signal ALU_Result_1 : std_logic_vector(31 downto 0) := (others => '0');
   signal Addr : std_logic_vector(31 downto 0) := (others => '0');
   signal wData : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal MRead_3 : std_logic;
   signal MWrite_3 : std_logic;
   signal MemtoReg_3 : std_logic;
   signal RegWrite_3 : std_logic;
   signal wAddr_2 : std_logic_vector(4 downto 0);
   signal rData_2_3 : std_logic_vector(31 downto 0);
   signal ALU_Result_2 : std_logic_vector(31 downto 0);
   signal rData_1 : std_logic_vector(31 downto 0);
   signal Reg_wData : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Storing PORT MAP (
          clk => clk,
          reset => reset,
          MRead_2 => MRead_2,
          MWrite_2 => MWrite_2,
          MemtoReg_2 => MemtoReg_2,
          RegWrite_2 => RegWrite_2,
          MRead_3 => MRead_3,
          MWrite_3 => MWrite_3,
          MemtoReg_3 => MemtoReg_3,
          RegWrite_3 => RegWrite_3,
          wAddr_1 => wAddr_1,
          wAddr_2 => wAddr_2,
          ALU_Result_1 => ALU_Result_1,
          Addr => Addr,
          wData => wData,
          rData_2_3 => rData_2_3,
          ALU_Result_2 => ALU_Result_2,
          rData_1 => rData_1,
          Reg_wData => Reg_wData
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
         Addr 				<= x"10010004";
         wData 			<= (others => '0');
         MRead_2 			<='1';
         MWrite_2 			<='0';
         MemtoReg_2 			<='0';
         RegWrite_2 			<='0';
         ALU_Result_1 		<= (others => '0');
         wAddr_1 	<= (others => '0');
      wait for CLK_period;
         Addr 				<= x"10010008";
         wData 			<= (others => '0');
         MRead_2 			<='1';
         MWrite_2 			<='0';
         MemtoReg_2 			<='0';
         RegWrite_2 			<='0';
         ALU_Result_1 		<= (others => '0');
         wAddr_1 	<= (others => '0');
      wait for CLK_period;
         Addr 				<= x"1001000C";
         wData 			<= (others => '0');
         MRead_2 			<='1';
         MWrite_2 			<='0';
         MemtoReg_2 			<='0';
         RegWrite_2 			<='0';
         ALU_Result_1 		<= (others => '0');
         wAddr_1 	<= (others => '0');
      wait for CLK_period;
         Addr 				<= x"10010010";
         wData 			<= (others => '0');
         MRead_2 			<='1';
         MWrite_2 			<='0';
         MemtoReg_2 			<='0';
         RegWrite_2 			<='0';
         ALU_Result_1 		<= (others => '0');
         wAddr_1 	<= (others => '0');
      wait for CLK_period;		
			--Write to address
         Addr 				<= x"10010004";
         wData 			<= x"0000004F";
         MRead_2 			<= '0';
         MWrite_2 			<= '1';
         MemtoReg_2 			<= '0';
         RegWrite_2 			<= '0';
         ALU_Result_1 		<= (others => '0');
         wAddr_1 	<= (others => '0');
      wait for CLK_period;
			--Data should change
         Addr 				<= x"10010004";
         wData 			<= (others => '0');
         MRead_2 			<='1';
         MWrite_2 			<='0';
         MemtoReg_2 			<='0';
         RegWrite_2 			<='0';
         ALU_Result_1 		<= (others => '0');
         wAddr_1 	<= (others => '0');
      wait for CLK_period;	
         Addr 				<= x"10010010";
         wData 			<= (others => '0');
         MRead_2 			<='1';
         MWrite_2 			<='0';
         MemtoReg_2 			<='0';
         RegWrite_2 			<='0';
         ALU_Result_1 		<= (others => '0');
         wAddr_1	<= (others => '0');
      wait for CLK_period;		
			--Test for control switch
			--Reg_WriteData will follow ReadData;
         Addr 				<= x"10010010";
         wData 			<= (others => '0');
         MRead_2 			<='0';
         MWrite_2 			<='0';
         MemtoReg_2 			<='1';
         RegWrite_2 			<='0';
         ALU_Result_1 		<= (others => '0');
         wAddr_1	<= (others => '0');
      wait for CLK_period;			
			--Test for control switch
			--Reg_WriteData will follow ALU_Result_1;
         Addr 				<= x"10010010";
         wData 			<= (others => '0');
         MRead_2 			<='0';
         MWrite_2 			<='0';
         MemtoReg_2 			<='0';
         RegWrite_2 			<='0';
         ALU_Result_1 		<= (others => '0');
         wAddr_1 	<= (others => '0');
      wait for CLK_period;			
      -- insert stimulus here 

      wait;
   end process;

END;