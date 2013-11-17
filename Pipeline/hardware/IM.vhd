--Written by Yee Tang and Hu Yang
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Component of Instruction Memory
entity IM is
port(
	addr	:	in	std_logic_vector (31 downto 0);
	instr	:	out	std_logic_vector (31 downto 0)
);
end IM;

architecture Behavioral of IM is
-- here to decode the instructions
	type instr_type is array (0 to 257) of STD_LOGIC_VECTOR (31 downto 0);
	signal ins : instr_type := (
		x"00000000",
		x"00000000",
		x"00000000",
		x"3c011001",
		x"8c280008",
		x"00000000",
		x"00000000",
		x"00000000",
		x"3c011001",
		x"8c29000c",
		x"00000000",
		x"00000000",
		x"00000000",
		x"01095022",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"010a4020",
		x"01480019",
		x"00006010",
		x"00005812",
		x"01680018",
		x"00006010",
		x"00006812",
		x"210b0004",
		x"016a6022",
		x"29750003",
		x"2975001e",
		x"018b6824",
		x"018b7025",
		x"0c100024",
		x"00000000",
		x"00000000",
		x"00000000",
		x"08100000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"0810002c",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"02f3b027",
		x"36940001",
		x"0234c02a",
		x"0291c02a",
		x"02f34026",
		x"3c090040",
		x"212900cc",
		x"0294a021",
		x"0295a023",
		x"00000000",
		x"00000000",
		x"00000000",
		x"3c011001",
		x"ac340018",
		x"00000000",
		x"00000000",
		x"00000000",
		x"3c011001",
		x"8c320018",
		x"00000000",
		x"00000000",
		x"00000000",
		x"08100000",
		others => x"00000000"
	);

	signal temp : std_logic_vector (31 downto 0);
	begin
--			instr(31 downto 24 ) <= ins(conv_integer(addr(7 downto 0)));
--			instr(23 downto 16 ) <= ins(conv_integer(addr(7 downto 0))+1);
--			instr(15 downto 8 ) <= ins(conv_integer(addr(7 downto 0))+2);
--			instr(7 downto 0 ) <= ins(conv_integer(addr(7 downto 0))+3);	
			
			temp <= "00"&addr(31 downto 2);
			instr(31 downto 0 ) <= ins(conv_integer(temp(7 downto 0)));
end Behavioral;
