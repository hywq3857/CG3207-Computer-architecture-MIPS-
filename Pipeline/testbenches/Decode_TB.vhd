--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:24:58 11/09/2013
-- Design Name:   
-- Module Name:   C:/Users/Yee Tang/Desktop/CG3207/1109/LAB2/project/testbenches/Decode_TB.vhd
-- Project Name:  LAB2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Decoding
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
 
ENTITY Decode_TB IS
END Decode_TB;
 
ARCHITECTURE behavior OF Decode_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Decoding
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         RegWrite_3 : IN  std_logic;
         MemtoReg_3 : IN  std_logic;
         JumpAL_1 : IN  std_logic;
         JumpALR_1 : IN  std_logic;
         Shift_1 : IN  std_logic;
         Shifti_1 : IN  std_logic;
         IDEX_MRead : IN  std_logic;
         Branch_1 : IN  std_logic;
         Branch_NE_1 : IN  std_logic;
         BGEZAL_EN : IN  std_logic;
         IDEXMRead_out : OUT  std_logic;
         RegWriteOut : OUT  std_logic;
         Branch_2 : OUT  std_logic;
         Branch_NE_2 : OUT  std_logic;
         wAddr_2 : IN  std_logic_vector(4 downto 0);
         IDEX_Reg_Rt : IN  std_logic_vector(4 downto 0);
         IFID_Reg_Rs : IN  std_logic_vector(4 downto 0);
         IFID_Reg_Rt : IN  std_logic_vector(4 downto 0);
         IDEXReg_Rt_out : OUT  std_logic_vector(4 downto 0);
         IFIDReg_Rs_out : OUT  std_logic_vector(4 downto 0);
         IFIDReg_Rt_out : OUT  std_logic_vector(4 downto 0);
         rData_1 : IN  std_logic_vector(31 downto 0);
         wData : IN  std_logic_vector(31 downto 0);
         ALU_Result_2 : IN  std_logic_vector(31 downto 0);
         Instr_1 : IN  std_logic_vector(31 downto 0);
         PC_plus_4_1 : IN  std_logic_vector(31 downto 0);
         Operand1 : IN  std_logic_vector(31 downto 0);
         Operand2 : IN  std_logic_vector(31 downto 0);
         Mul_result_1 : IN  std_logic_vector(63 downto 0);
         wAddr_0_1 : OUT  std_logic_vector(4 downto 0);
         wAddr_1_1 : OUT  std_logic_vector(4 downto 0);
         wAddr_2_1 : OUT  std_logic_vector(4 downto 0);
         wAddr_3 : OUT  std_logic_vector(4 downto 0);
         rData_1_1 : OUT  std_logic_vector(31 downto 0);
         rData_2_1 : OUT  std_logic_vector(31 downto 0);
         SE_1 : OUT  std_logic_vector(31 downto 0);
         RegwData : OUT  std_logic_vector(31 downto 0);
         Instr_2 : OUT  std_logic_vector(31 downto 0);
         PC_plus_4_2 : OUT  std_logic_vector(31 downto 0);
         Lui_Extend_1 : OUT  std_logic_vector(31 downto 0);
         Lo_reg_1 : OUT  std_logic_vector(31 downto 0);
         Hi_reg_1 : OUT  std_logic_vector(31 downto 0);
         Jump_Instr_1 : OUT  std_logic_vector(31 downto 0);
         Result1 : OUT  std_logic_vector(31 downto 0);
         Result2 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';
   signal RegWrite_3 : std_logic := '0';
   signal MemtoReg_3 : std_logic := '0';
   signal JumpAL_1 : std_logic := '0';
   signal JumpALR_1 : std_logic := '0';
   signal Shift_1 : std_logic := '0';
   signal Shifti_1 : std_logic := '0';
   signal IDEX_MRead : std_logic := '0';
   signal Branch_1 : std_logic := '0';
   signal Branch_NE_1 : std_logic := '0';
   signal BGEZAL_EN : std_logic := '0';
   signal wAddr_2 : std_logic_vector(4 downto 0) := (others => '0');
   signal IDEX_Reg_Rt : std_logic_vector(4 downto 0) := (others => '0');
   signal IFID_Reg_Rs : std_logic_vector(4 downto 0) := (others => '0');
   signal IFID_Reg_Rt : std_logic_vector(4 downto 0) := (others => '0');
   signal rData_1 : std_logic_vector(31 downto 0) := (others => '0');
   signal wData : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_Result_2 : std_logic_vector(31 downto 0) := (others => '0');
   signal Instr_1 : std_logic_vector(31 downto 0) := (others => '0');
   signal PC_plus_4_1 : std_logic_vector(31 downto 0) := (others => '0');
   signal Operand1 : std_logic_vector(31 downto 0) := (others => '0');
   signal Operand2 : std_logic_vector(31 downto 0) := (others => '0');
   signal Mul_result_1 : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal IDEXMRead_out : std_logic;
   signal RegWriteOut : std_logic;
   signal Branch_2 : std_logic;
   signal Branch_NE_2 : std_logic;
   signal IDEXReg_Rt_out : std_logic_vector(4 downto 0);
   signal IFIDReg_Rs_out : std_logic_vector(4 downto 0);
   signal IFIDReg_Rt_out : std_logic_vector(4 downto 0);
   signal wAddr_0_1 : std_logic_vector(4 downto 0);
   signal wAddr_1_1 : std_logic_vector(4 downto 0);
   signal wAddr_2_1 : std_logic_vector(4 downto 0);
   signal wAddr_3 : std_logic_vector(4 downto 0);
   signal rData_1_1 : std_logic_vector(31 downto 0);
   signal rData_2_1 : std_logic_vector(31 downto 0);
   signal SE_1 : std_logic_vector(31 downto 0);
   signal RegwData : std_logic_vector(31 downto 0);
   signal Instr_2 : std_logic_vector(31 downto 0);
   signal PC_plus_4_2 : std_logic_vector(31 downto 0);
   signal Lui_Extend_1 : std_logic_vector(31 downto 0);
   signal Lo_reg_1 : std_logic_vector(31 downto 0);
   signal Hi_reg_1 : std_logic_vector(31 downto 0);
   signal Jump_Instr_1 : std_logic_vector(31 downto 0);
   signal Result1 : std_logic_vector(31 downto 0);
   signal Result2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Decoding PORT MAP (
          Clock => Clock,
          Reset => Reset,
          RegWrite_3 => RegWrite_3,
          MemtoReg_3 => MemtoReg_3,
          JumpAL_1 => JumpAL_1,
          JumpALR_1 => JumpALR_1,
          Shift_1 => Shift_1,
          Shifti_1 => Shifti_1,
          IDEX_MRead => IDEX_MRead,
          Branch_1 => Branch_1,
          Branch_NE_1 => Branch_NE_1,
          BGEZAL_EN => BGEZAL_EN,
          IDEXMRead_out => IDEXMRead_out,
          RegWriteOut => RegWriteOut,
          Branch_2 => Branch_2,
          Branch_NE_2 => Branch_NE_2,
          wAddr_2 => wAddr_2,
          IDEX_Reg_Rt => IDEX_Reg_Rt,
          IFID_Reg_Rs => IFID_Reg_Rs,
          IFID_Reg_Rt => IFID_Reg_Rt,
          IDEXReg_Rt_out => IDEXReg_Rt_out,
          IFIDReg_Rs_out => IFIDReg_Rs_out,
          IFIDReg_Rt_out => IFIDReg_Rt_out,
          rData_1 => rData_1,
          wData => wData,
          ALU_Result_2 => ALU_Result_2,
          Instr_1 => Instr_1,
          PC_plus_4_1 => PC_plus_4_1,
          Operand1 => Operand1,
          Operand2 => Operand2,
          Mul_result_1 => Mul_result_1,
          wAddr_0_1 => wAddr_0_1,
          wAddr_1_1 => wAddr_1_1,
          wAddr_2_1 => wAddr_2_1,
          wAddr_3 => wAddr_3,
          rData_1_1 => rData_1_1,
          rData_2_1 => rData_2_1,
          SE_1 => SE_1,
          RegwData => RegwData,
          Instr_2 => Instr_2,
          PC_plus_4_2 => PC_plus_4_2,
          Lui_Extend_1 => Lui_Extend_1,
          Lo_reg_1 => Lo_reg_1,
          Hi_reg_1 => Hi_reg_1,
          Jump_Instr_1 => Jump_Instr_1,
          Result1 => Result1,
          Result2 => Result2
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
      wait for 100 ns;	
			--Do a normal test run
         RegWrite_3  		<='0';
         wAddr_2 	<= (others => '0');
         rData_1 		<= x"10010000";
         MemtoReg_3 			<='0';
         ALU_Result_2  		<= (others => '0');
         wData 			<= (others => '0');
         Instr_1 		<= x"3C011010";
         PC_plus_4_1 		<= (others => '0');
         IDEX_MRead 		<='0';
         IDEX_Reg_Rt 	<= (others => '0');
         IFID_Reg_Rs 	<= (others => '0');
         IFID_Reg_Rt 	<= (others => '0');
         Branch_1 			<='0';
         Branch_NE_1			<='0';
      wait for Clock_period;
			--Make MemtoReg and RegWrite to 1 to test the store into function
         RegWrite_3  		<='1';
         wAddr_2 	<= (others => '0');
         rData_1 		<= x"10010000";
         MemtoReg_3 			<='1';
         ALU_Result_2  		<= (others => '0');
         wData 			<= (others => '0');
         Instr_1 		<= x"3C011010";
         PC_plus_4_1 		<= (others => '0');
         IDEX_MRead 		<='0';
         IDEX_Reg_Rt 	<= (others => '0');
         IFID_Reg_Rs 	<= (others => '0');
         IFID_Reg_Rt 	<= (others => '0');
         Branch_1 			<='0';
         Branch_NE_1			<='0';
      wait for Clock_period;
			--Do a normal test run to check write
         RegWrite_3  		<='0';
         wAddr_2 	<= (others => '0');
         rData_1 		<= x"10010000";
         MemtoReg_3 			<='0';
         ALU_Result_2  		<= (others => '0');
         wData 			<= (others => '0');
         Instr_1 		<= x"3C011010";
         PC_plus_4_1 		<= (others => '0');
         IDEX_MRead 		<='0';
         IDEX_Reg_Rt 	<= (others => '0');
         IFID_Reg_Rs 	<= (others => '0');
         IFID_Reg_Rt 	<= (others => '0');
         Branch_1 			<='0';
         Branch_NE_1			<='0';
      wait for Clock_period;		
			--Now test MemtoReg and RegWrite to 1 to test the store into function
         RegWrite_3  		<='1';
         wAddr_2 	<= (others => '0');
         rData_1 		<= x"00000000";
         MemtoReg_3 			<='1';
         ALU_Result_2  		<= (others => '0');
         wData 			<= (others => '0');
         Instr_1 		<= x"3C011010";
         PC_plus_4_1 		<= (others => '0');
         IDEX_MRead 		<='0';
         IDEX_Reg_Rt 	<= (others => '0');
         IFID_Reg_Rs 	<= (others => '0');
         IFID_Reg_Rt 	<= (others => '0');
         Branch_1 			<='0';
         Branch_NE_1			<='0';
      wait for Clock_period;
			--Do a normal test run to check write
         RegWrite_3  		<='0';
         wAddr_2 	<= (others => '0');
         rData_1 		<= x"10010000";
         MemtoReg_3 			<='0';
         ALU_Result_2  		<= (others => '0');
         wData 			<= (others => '0');
         Instr_1 		<= x"3C011010";
         PC_plus_4_1 		<= (others => '0');
         IDEX_MRead 		<='0';
         IDEX_Reg_Rt 	<= (others => '0');
         IFID_Reg_Rs 	<= (others => '0');
         IFID_Reg_Rt 	<= (others => '0');
         Branch_1 			<='0';
         Branch_NE_1			<='0';
      wait for Clock_period;				
      -- insert stimulus here 

      wait;
   end process;

END;

