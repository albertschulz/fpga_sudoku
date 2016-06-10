------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	ram_game
-- Date:		07.05.2016
-- Description:
-- 	RAM with current game information
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_game is
	generic(
		RAM_WIDTH	: natural := 9;
		RAM_DEPTH	: natural := 9;
		ADR_WIDTH	: natural := 8;
		ETR_WIDTH	: natural := 6
	);
	port(
		clk			: in std_logic;
		ram_adr_r1	: in	std_logic_vector(ADR_WIDTH - 1 downto 0);
		ram_adr_r2	: in	std_logic_vector(ADR_WIDTH - 1 downto 0);
		ram_adr_w	: in	std_logic_vector(ADR_WIDTH - 1 downto 0);
		ram_dat_i	: in	std_logic_vector(ETR_WIDTH - 1 downto 0);
		ram_we		: in 	std_logic;
		ram_dat_o1	: out std_logic_vector(ETR_WIDTH - 1 downto 0);
		ram_dat_o2	: out std_logic_vector(ETR_WIDTH - 1 downto 0)
	);	
end ram_game;


architecture rtl of ram_game is

	type memory_type is array(0 to 255) of std_logic_vector(5 downto 0);
	signal memory : memory_type := (others => (others => '0'));

begin
	
	-- dual async read
	process(ram_adr_r1, ram_adr_r2, ram_adr_w, ram_we, ram_dat_i, memory)
	begin
		if (ram_adr_r1 = ram_adr_w) and (ram_we = '1') then
			ram_dat_o1 <= ram_dat_i; -- data forwarding
		else
			ram_dat_o1 <= memory(to_integer(unsigned(ram_adr_r1)));
		end if;
		if (ram_adr_r2 = ram_adr_w) and (ram_we = '1') then
			ram_dat_o2 <= ram_dat_i; -- data forwarding
		else
			ram_dat_o2 <= memory(to_integer(unsigned(ram_adr_r2)));
		end if;
	end process;
	
	-- sync write
	process(clk, ram_we, ram_adr_w)
	begin
		if (rising_edge(clk)) and (ram_we = '1') then
			memory(to_integer(unsigned(ram_adr_w))) <= ram_dat_i;
		end if;
	end process;
	
end rtl;