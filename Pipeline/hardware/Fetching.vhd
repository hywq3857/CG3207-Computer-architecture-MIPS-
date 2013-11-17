----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:49:15 11/09/2013 
-- Design Name: 
-- Module Name:    Fetching - Behavioral 
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
--Import from Single Cycle written by Hu Yang and Haoxuan
--Pipeline written by Yee Tang 
--Pipeline debug by Yee Tang and Hu Yang
LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Fetching IS
	PORT( 
	CLK				: IN 	STD_LOGIC;
	RESET  			: IN 	STD_LOGIC; 
	Stall   			: IN 	STD_LOGIC;	
	Branch   		: IN  STD_LOGIC;
	Branch_NE  		: IN  STD_LOGIC;
	BGEZ_1 			: IN 	STD_LOGIC;
	BGEZAL_1 		: IN 	STD_LOGIC; 	
	Jump_1			: IN 	STD_LOGIC;
	IFFlush   		: IN  STD_LOGIC;
	IFFlush_2  		: IN 	STD_LOGIC;	
	IF_Branch  		: OUT STD_LOGIC;
	IF_BranchNE  	: OUT STD_LOGIC;	
	IFFlush_1  		: OUT STD_LOGIC;
	IFFlush_3  		: OUT STD_LOGIC; 
	BGEZAL_EN		: OUT STD_LOGIC;	
	Ctrl				: IN 	STD_LOGIC_VECTOR (5 DOWNTO 0);		
	rData_1  		: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
	rData_2   		: IN 	STD_LOGIC_VECTOR (31 DOWNTO 0);
	SE  				: IN 	STD_LOGIC_VECTOR (31 DOWNTO 0);	
	PC_plus_4		: IN 	STD_LOGIC_VECTOR (31 DOWNTO 0);	
	Jump_Addr_1 	: IN 	STD_LOGIC_VECTOR (31 DOWNTO 0);	
	PC_Out   		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	Instr_1  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	PC_plus_4_1		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	NXT_PC   		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_rData1  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_rData2  		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_SE  			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_PCPlus4  	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_AddResult  	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	IF_Zero   		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)	
	);
END Fetching;
ARCHITECTURE behavioral OF Fetching IS
	SIGNAL local_PC   			: STD_LOGIC_VECTOR (31 DOWNTO 0):=(x"00400000");  
	SIGNAL local_PCplus4   		: STD_LOGIC_VECTOR (31 DOWNTO 0):=(x"00400004");     
	SIGNAL local_PCnext   		: STD_LOGIC_VECTOR (31 DOWNTO 0):=(x"00400004");  
	SIGNAL local_Instr  			: STD_LOGIC_VECTOR (31 DOWNTO 0):=(x"00000000");  
	SIGNAL local_Zero   			: STD_LOGIC_VECTOR (31 DOWNTO 0):=(x"00000000");  
	SIGNAL local_Addresult  	: STD_LOGIC_VECTOR (31 DOWNTO 0):=(x"00000000");  
	SIGNAL local_SE  				: STD_LOGIC_VECTOR (31 DOWNTO 0):=(x"00000000");  
	SIGNAL Local_temp   			: STD_LOGIC :='1';
	SIGNAL LOCAL_BGEZAL_EN 		: STD_LOGIC;	
	SIGNAL local_Homerun  		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	component IM is
		port (
				addr	:	in	std_logic_vector (31 downto 0);
				instr	:	out	std_logic_vector (31 downto 0)
			);
	end component;
BEGIN


	
	IM_OP: IM port map(local_PC,local_Instr);
	
   NXT_PC<= local_PCnext;
	local_PCplus4 (31 DOWNTO 2)  <= local_PC (31 DOWNTO 2) + 1;
	local_PCplus4 (1 DOWNTO 0)  <= local_PC (1 DOWNTO 0) ;
	local_Zero 			<= rData_1 (31 DOWNTO 0) XOR rData_2 (31 DOWNTO 0);

	-- Local sign to shift by 2 bits
	local_SE(31 DOWNTO 2) <= SE (29 DOWNTO 0);
	local_SE (1 DOWNTO 0)  <= "00";
	LOCAL_BGEZAL_EN <='1' when (BGEZAL_1 = '1' and rData_1(31) = '0')
						else '0';
						

	local_Addresult 	<= PC_plus_4 (31 DOWNTO 0) + local_SE (31 DOWNTO 0);
	
 

	
	local_Homerun <= local_Addresult WHEN ( IFFlush_2 = '1' AND ( Branch_NE = '1') )  	
	OR(BGEZ_1 = '1' AND rData_1(31) = '0')
	OR (BGEZ_1 = '0' AND IFFlush_2 = '1'  and Branch ='1' AND rData_1 = rData_2)
	OR (Branch_NE = '1' AND rData_1 /= rData_2)
	
	ELSE  local_PCplus4 (31 DOWNTO 0); 	
	local_PCnext <= Jump_Addr_1 WHEN (JUMP_1 ='1')
	ELSE local_Homerun;

	IF_rData1 	<= rData_1; 
	IF_rData2 	<= rData_2;
	IF_SE 	<= SE;
	IF_Branch 		<= Branch;
	IF_BranchNE 	<= Branch_NE;
	IF_PCPlus4 		<= PC_plus_4;
	IF_AddResult 	<= local_Addresult;
	IF_Zero  		<= local_Zero;
	IFFlush_1 		<= IFFlush;
	BGEZAL_EN		<= LOCAL_BGEZAL_EN;

	Instr_1<= "00000000000000000000000000000000" 
	WHEN (Reset = '1')  
	OR ( IFFlush_2 = '1' AND ( local_Zero = X"00000000" ) 
	AND ( Branch = '1') ) OR ( IFFlush_2 = '1' 
	AND ( local_Zero /= X"00000000" ) AND ( Branch_NE = '1') ) 
	ELSE local_Instr;
	
	PROCESS (CLK)
	BEGIN
	IF(rising_edge(CLK)) then
		IF Reset = '1' THEN
		local_PC    	<= X"00400000"; 
		IFFlush_3  		<= '0';
		PC_plus_4_1		<= X"00400000"; 
		
		ELSif Ctrl="00001" then
			if Local_temp ='1' then
			 Local_temp <='0';
			 else
				IF (Stall = '1')  THEN  
				ELSE
			
				PC_Out   					<= local_PC; 		
				local_PC (31 DOWNTO 0) 	<= local_PCnext (31 DOWNTO 0);
				PC_plus_4_1 				<= local_PCplus4 (31 DOWNTO 0);

					IF ( IFFlush_2 = '1' AND ( local_Zero = X"00000000" )  
					AND ( Branch = '1') ) OR
						( IFFlush_2 = '1' AND ( local_Zero /= X"00000000" )  
					AND ( Branch_NE = '1') ) THEN
						IFFlush_3 <= '1';
					ELSE 
						IFFlush_3 <= '0';
					END IF;
				END IF;
				END IF;
		END IF;
	END IF;	
	END PROCESS;
END behavioral;
