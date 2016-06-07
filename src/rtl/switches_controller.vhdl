------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	switches_controller
-- Date:		25.04.2016
-- Description:
--		Controller for the Switches
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity switches_controller is
	port(
		clk			: in  std_logic;
		sw_dat_i		: in  std_logic_vector(6 downto 0);
		sw_dat_en	: out std_logic;
		sw_dat_o		: out	std_logic_vector(6 downto 0)
	);
end switches_controller;

architecture rtl of switches_controller is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if(sw_dat_i = "0000000") then
				sw_dat_en 	<= '0';				
			else
				sw_dat_en 	<= '1';
			end if;
		end if;
	end process;
	
	sw_dat_o <= sw_dat_i;
end rtl;