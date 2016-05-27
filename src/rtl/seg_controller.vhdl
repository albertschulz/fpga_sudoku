------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	seg_controller
-- Date:		26.04.2016
-- Description:
--		Controller for the 7-segment display
--			--  0
--		5 |  |  1
--		 	--  6	 -> position & index of each seg.
--		4 |  |  2
--		 	--  3
------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;

entity seg_controller is
	port (
		clk	   	: in  std_logic;
		rst			: in  std_logic;
		seg_dat_i 	: in  std_logic_vector(27 downto 0);
		seg_hex0_o	: out std_logic_vector(6 downto 0);
		seg_hex1_o	: out std_logic_vector(6 downto 0);
		seg_hex2_o	: out std_logic_vector(6 downto 0);
		seg_hex3_o	: out std_logic_vector(6 downto 0)
	);
end entity seg_controller;

architecture rtl of seg_controller is
begin
	process(clk)
	begin
		if rising_edge(clk) then	-- Leds are low-active
				if(rst = '1') then
				seg_hex0_o  <= "1111111";
				seg_hex1_o  <= "1111111";
				seg_hex2_o  <= "1111111";
				seg_hex3_o  <= "1111111";
			else
				seg_hex0_o  <= not seg_dat_i(6 downto 0);
				seg_hex1_o  <= not seg_dat_i(13 downto 7);
				seg_hex2_o  <= not seg_dat_i(20 downto 14);
				seg_hex3_o  <= not seg_dat_i(27 downto 21);
			end if;
		end if;
	end process;
end architecture rtl;