
--Written by Yee Tang and Hu Yang
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IM is
port(
	addr	:	in	std_logic_vector (31 downto 0);
	instr	:	out	std_logic_vector (31 downto 0)
);
end IM;

architecture Behavioral of IM is
	type instr_type is array (0 to 257) of STD_LOGIC_VECTOR (31 downto 0);
	signal ins : instr_type := (

x"3c190040",
x"23390008",
x"23390008",
x"23390008",
x"03204009",
x"01000008",
x"3c011001",
x"8c280008",
x"3c011001",
x"8c29000c",
x"1128fff5",
x"01095022",
x"05410009",
x"05510008",
x"05010002",
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
x"0c100022",
x"00000000",
x"08100000",
x"000c6880",
x"02aca804",
x"000bb043",
x"010ab807",
x"000ba042",
x"02d79806",
x"0810002a",
x"00000000",
x"02f3b027",
x"36940001",
x"0234c02a",
x"0291c02a",
x"02f34026",
x"3c090040",
x"212900c8",
x"01200008",
x"152a0002",
x"00000000",
x"00000000",
x"0294a021",
x"0295a023",
x"3c011001",
x"ac340018",
x"00000000",
x"3c011001",
x"8c320018",
x"08100000",

		others => x"00000000"
	);
	signal temp : std_logic_vector (31 downto 0);

		begin
			temp <= "00"&addr(31 downto 2);
			instr(31 downto 0 ) <= ins(conv_integer(temp(7 downto 0)));

	end Behavioral;
