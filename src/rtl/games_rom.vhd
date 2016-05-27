------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	games_rom
-- Date:		07.05.2016
-- Description:
-- 	ROM with preset Sudoku Games
--
-- Address Offsets: (2 Bit Difficulty + 2 Bit Game Selection + 7 Bit Game Numbers)
-- Simple Games:		0b 00 00 0000000
-- Middle Games:		0b 01 00 0000000
-- Difficult Games: 	0b 10 00 0000000
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity games_rom is
	generic(
		ROM_WIDTH	: natural := 4;	-- count of columns
		ROM_DEPTH	: natural := 972;	-- count of rows
		ADR_WIDTH	: natural := 11	-- address width
	);
	port(
		rom_adr_i	: in	std_logic_vector(ADR_WIDTH - 1 downto 0);
		rom_dat_o	: out std_logic_vector(ROM_WIDTH - 1 downto 0)
	);
end games_rom;

architecture rtl of games_rom is
	
	type game_array_t is array (natural range <>) of std_logic_vector(3 downto 0);
		
	constant middle_games : game_array_t(0 to 80) := 
		( 
			(	
				x"7",x"6",x"8",x"0",x"4",x"1",x"0",x"0",x"0",
				x"0",x"0",x"0",x"0",x"7",x"8",x"6",x"4",x"2",
				x"0",x"4",x"2",x"0",x"0",x"3",x"0",x"0",x"1",
				x"0",x"0",x"0",x"6",x"0",x"0",x"2",x"8",x"5",
				x"2",x"9",x"6",x"8",x"0",x"0",x"0",x"0",x"0",
				x"0",x"5",x"1",x"4",x"0",x"0",x"0",x"0",x"3",
				x"1",x"0",x"0",x"0",x"5",x"0",x"4",x"3",x"0",
				x"5",x"0",x"7",x"3",x"9",x"4",x"0",x"0",x"0",
				x"6",x"0",x"0",x"1",x"0",x"2",x"5",x"9",x"0"
			)
		);
	
	alias difficulty 	: std_logic_vector(1 downto 0) is rom_adr_i(ADR_WIDTH-1 downto ADR_WIDTH-2);
begin
	
	process(difficulty, rom_adr_i)
	begin
	
		rom_dat_o <= (others => '0');
		
		case difficulty is
			when "00" 	=>
				null;
			
			when "01" 	=>
				rom_dat_o <= middle_games(to_integer(unsigned(rom_adr_i(ADR_WIDTH-3 downto 0))));
			
			when "10"	=>
				null;
			
			when others =>
				null;
		end case;
		
	end process;
end rtl;