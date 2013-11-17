----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:54:06 11/06/2013 
-- Design Name: 
-- Module Name:    datamemory - Behavioral 
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
--Import from Single Cycle written by Yee Tang and Hu Yang
--Pipeline written by Yee Tang 
--Pipeline debug by Yee Tang and Hu Yang
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_SIGNED.ALL; 

ENTITY Storing IS
 PORT(
	clk					: IN STD_LOGIC;
	reset					: IN STD_LOGIC;
	MRead_2 				: IN STD_LOGIC;
	MWrite_2  			: IN STD_LOGIC;
   MemtoReg_2  		: IN  STD_LOGIC;
	RegWrite_2  		: IN  STD_LOGIC; 
	MRead_3  			: OUT STD_LOGIC;  
	MWrite_3  			: OUT  STD_LOGIC;  
	MemtoReg_3  		: OUT  STD_LOGIC;
	RegWrite_3  		: OUT  STD_LOGIC;  
	wAddr_1 				: IN STD_LOGIC_VECTOR (4 DOWNTO 0);	
	wAddr_2 				: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);	
	ALU_Result_1  		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	Addr   				: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
	wData  				: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_2_3 			: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
	ALU_Result_2  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_1  			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	Reg_wData  			: OUT  STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END Storing;

ARCHITECTURE behavioral OF Storing IS
	--MUX
	component Switch2to1 is
	generic (N:integer);
		 Port ( 
		 input 		: in  STD_LOGIC;
		 A 			: in  STD_LOGIC_VECTOR (N downto 0);
		 B 			: in  STD_LOGIC_VECTOR (N downto 0);
		 output 		: out  STD_LOGIC_VECTOR (N downto 0));
	end component;	
 --Internal Signals
	SIGNAL Reg_wData_Switch : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL Local_rData  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal Local_addr : std_logic_vector(31 downto 0);
	type DM_type is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
	signal  RAM : DM_type := (
	
	----lab 3A final data start----
	x"00000000", x"00000001", x"00000002", x"00000003", x"00000004", x"00000005",

	others => x"0000000f"
);

BEGIN
	--Testing make sure able to get things out in TB
	--Put Addr into a signal
	--Local_addr(7 downto 0) <= Addr(7 downto 0);
	--Local_addr(7 downto 0) <= "00000100";
	Local_addr <= "00"&addr(31 downto 2);	
	--Move this to decode but use as testing
	Reg_wData_OP: Switch2to1 generic map(N=>31)
	port map(MemtoReg_2, ALU_Result_1,Local_rData,Reg_wData_Switch);

 PROCESS(MRead_2,MWrite_2, Addr, wData,CLK)
 BEGIN
 	if (addr(31 downto 16) = x"1001") then
		if MRead_2 = '1' then	
			Local_rData	<= RAM(conv_integer(Local_addr(4 downto 0)));
			--Local_rData(23 downto 16 ) 	<= RAM(conv_integer(Addr(7 downto 0))+1);
			--Local_rData(15 downto 8 )  	<= RAM(conv_integer(Addr(7 downto 0))+2);
			--Local_rData(7 downto 0 )   	<= RAM(conv_integer(Addr(7 downto 0))+3);		
		end if;
		if(rising_edge(CLK))then 
			if MWrite_2 = '1' then
				RAM(conv_integer(Local_addr(4 downto 0))) 		<=  wData(31 downto 0 );	
			--	RAM(conv_integer(Addr(7 downto 0))+1) 	<= wData(23 downto 16 );	
			--	RAM(conv_integer(Addr(7 downto 0))+2) 	<= wData(15 downto 8 );	
			--	RAM(conv_integer(Addr(7 downto 0))+3) 	<= wData(7 downto 0 );	
			end if;	
		end if;
  end if;
	if(rising_edge(CLK))then 
   IF Reset = '1' THEN
	MRead_3  			<= '0';
	MWrite_3  			<= '0';
	MemtoReg_3  		<= '0';
	RegWrite_3  		<= '0';
	wAddr_2 				<= "00000";
	rData_2_3 			<= X"00000000";
	ALU_Result_2  		<= X"00000000";
	rData_1  			<= X"00000000";
	Reg_wData  			<= X"00000000"; 
	 
   ELSE
		 MRead_3 		<= MRead_2;
		 MWrite_3  		<= MWrite_2;
		 MemtoReg_3  	<= MemtoReg_2;	
		 wAddr_2 		<= wAddr_1; 
		 rData_2_3 		<= wData;		 
		 RegWrite_3  	<= RegWrite_2;
		 ALU_Result_2  <= ALU_Result_1;
		 rData_1  		<= Local_rData;
		 Reg_wData		<= Reg_wData_Switch;
    END IF;
   END IF;
 END PROCESS;
END behavioral;
