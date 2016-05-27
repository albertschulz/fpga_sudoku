------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	rst_sync
-- Date:		27.04.2016
-- Description:
-- 	syncs the reset signal
------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity rst_synchronizer is
	port(
		clk	      : in  std_logic;
		rst_a			: in  std_logic;
		rst			: out std_logic
	);	
end rst_synchronizer;

architecture rtl of rst_synchronizer is

	signal rst_meta : std_logic := '0';
	
begin

	rst_meta	<= not rst_a when rising_edge(clk);
	rst      <= rst_meta  when rising_edge(clk);
	
end rtl;