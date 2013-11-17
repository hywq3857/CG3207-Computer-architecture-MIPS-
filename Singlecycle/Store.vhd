LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_SIGNED.ALL;

 --Written by Yee Tang and Hu Yang
ENTITY Store IS
PORT( Read_Data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
 Address  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
 Write_Data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
 MemRead  : IN STD_LOGIC;
 MemWrite : IN STD_LOGIC;
 Clock : in std_logic);
END Store;

ARCHITECTURE behavior OF Store IS
	
	signal temp_addr : std_logic_vector(31 downto 0);
	type DM_type is array (0 to 100) of STD_LOGIC_VECTOR (31 downto 0);
	signal  RAM : DM_type := (
	
	x"00000000", x"00000001", x"00000002", x"00000003", x"00000004", x"00000005",

	others => x"0000000f"
);
	begin
		
		temp_addr <= "00"&address(31 downto 2);
--	
	process (MemRead,MemWrite, Address, Write_data,Clock)
	begin
		if (address(31 downto 16) = x"1001") then
			if MemRead = '1' then
				Read_Data(31 downto 0 ) <= RAM(conv_integer(temp_addr(7 downto 0)));		
			end if;
			if(rising_edge(Clock))then 
				if MemWrite = '1' then
					RAM(conv_integer(temp_addr(7 downto 0))) <= Write_Data(31 downto 0 );	
				end if;	
			end if;
		end if;
	end process;
END behavior;
