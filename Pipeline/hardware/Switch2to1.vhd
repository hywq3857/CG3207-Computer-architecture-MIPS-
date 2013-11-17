----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:46:54 10/26/2013 
-- Design Name: 
-- Module Name:    ALUSrc - Behavioral 
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
-- Written by Yee Tang 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Switch2to1 is
generic (N:integer);
    Port ( 
	 input 		: in  STD_LOGIC;
	 A 			: in  STD_LOGIC_VECTOR (N downto 0);
    B 			: in  STD_LOGIC_VECTOR (N downto 0);
	 output 		: out  STD_LOGIC_VECTOR (N downto 0));
end Switch2to1;

architecture Behavioral of Switch2to1 is
	begin
	process (input,A,B)		
	begin
		if input ='0' then
			output(N downto 0) <= A(N downto 0);
		else
			output(N downto 0) <= B(N downto 0);			
		end if;
	end process;

end Behavioral;