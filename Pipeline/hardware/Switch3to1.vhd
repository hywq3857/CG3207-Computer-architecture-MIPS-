----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:26:05 10/26/2013 
-- Design Name: 
-- Module Name:    Switch3to1 - Behavioral 
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

entity Switch3to1 is
generic (N:integer);
    Port ( input : in  STD_LOGIC_VECTOR (1 downto 0);
           A : in  STD_LOGIC_VECTOR (N downto 0);
           B : in  STD_LOGIC_VECTOR (N downto 0);
           C : in  STD_LOGIC_VECTOR (N downto 0);
           output : out  STD_LOGIC_VECTOR (N downto 0));
end Switch3to1;

architecture Behavioral of Switch3to1 is
	begin
	process (input,A,B,C)		
	begin
		if input ="00" then
			output(31 downto 0) <= A(N downto 0);
		elsif(input ="01") then
			output(31 downto 0) <= B(N downto 0);		
		elsif(input ="10") then
			output(31 downto 0) <= C(N downto 0);		
		else
			output(31 downto 0) <=  (others=>'1');
		end if;
	end process;

end Behavioral;

