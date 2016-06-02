------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	rom_lbl
-- Date:		31.05.2016
-- Description:
-- 	ROM with Bit-Matrix of Labels
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_lbl is
	generic(
		ROM_WIDTH	: natural := 128;	-- count of columns
		ROM_DEPTH	: natural := 32;	-- count of rows
		ADR_WIDTH	: natural := 9		-- address width -> label(4-bit) + line(5-bit)
	);
	port(
		rom_adr_i	: in	std_logic_vector(ADR_WIDTH - 1 downto 0);
		rom_dat_o	: out std_logic_vector(ROM_WIDTH - 1 downto 0)
	);
end rom_lbl;

architecture rtl of rom_lbl is
	
	subtype rom_row_t is std_logic_vector(0 to ROM_WIDTH - 1);
	type rom_mem_t is array(0 to ROM_DEPTH - 1) of rom_row_t;
	
	constant rom_lbl_start : rom_mem_t := (
		 0 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 1 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 2 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 3 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 4 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 5 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 6 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 7 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 8 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 9 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		10 => "00000000000000000000000000000000000001111100001000000000000000000000000000100000000000000000000000000000000000000000000000000000",
		11 => "00000000000000000000000000000000000100000000010000000000000000000000000001000000000000000000000000000000000000000000000000000000",
		12 => "00000000000000000000000000000000000100000000011110000001111000000101110001111000000000000000000000000000000000000000000000000000",
		13 => "00000000000000000000000000000000000011111000010000000010000100000110000001000000000000000000000000000000000000000000000000000000",
		14 => "00000000000000000000000000000000000000000100010000000010000100000100000001000000000000000000000000000000000000000000000000000000",
		15 => "00000000000000000000000000000000000000000100010000000010000100000100000001000000000000000000000000000000000000000000000000000000",
		16 => "00000000000000000000000000000000000011111000001110000001111010000100000000111000000000000000000000000000000000000000000000000000",
		17 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		18 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		19 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		20 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		21 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		22 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		23 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		24 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		25 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		26 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		27 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		28 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		29 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		30 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		31 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
		
	constant rom_lbl_restart : rom_mem_t := (
		 0 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 1 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 2 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 3 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 4 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 5 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 6 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 7 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 8 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 9 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		10 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		11 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		12 => "00000000000000000000000000000000000000000000000101110000111000000001111000000000000000000000000000000000000000000000000000000000",
		13 => "00000000000000000000000000000000000000000000000110000001000100000100000000000000000000000000000000000000000000000000000000000000",
		14 => "00000000000000000000000000000000000000000000000100000010000010000100000000000000000000000000000000000000000000000000000000000000",
		15 => "00000000000000000000000000000000000000000000000100000011111100000011110000000000000000000000000000000000000000000000000000000000",
		16 => "00000000000000000000000000000000000000000000000100000010000000000000001000000000000000000000000000000000000000000000000000000000",
		17 => "00000000000000000000000000000000000000000000000100000001000100000000001000000000000000000000000000000000000000000000000000000000",
		18 => "00000000000000000000000000000000000000000000000100000000111000000011110000000000000000000000000000000000000000000000000000000000",
		19 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		20 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		21 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		22 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		23 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		24 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		25 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		26 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		27 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		28 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		29 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		30 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		31 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
	
	constant rom_lbl_exit : rom_mem_t := (
		 0 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 1 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 2 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 3 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 4 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 5 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 6 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 7 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 8 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 9 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		10 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		11 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		12 => "00000000000000000000000000000000000000000000000000000000111000000100000100000000000000000000000000000000000000000000000000000000",
		13 => "00000000000000000000000000000000000000000000000000000001000100000010001000000000000000000000000000000000000000000000000000000000",
		14 => "00000000000000000000000000000000000000000000000000000010000010000001010000000000000000000000000000000000000000000000000000000000",
		15 => "00000000000000000000000000000000000000000000000000000011111100000000100000000000000000000000000000000000000000000000000000000000",
		16 => "00000000000000000000000000000000000000000000000000000010000000000001010000000000000000000000000000000000000000000000000000000000",
		17 => "00000000000000000000000000000000000000000000000000000001000100000010001000000000000000000000000000000000000000000000000000000000",
		18 => "00000000000000000000000000000000000000000000000000000000111000000100000100000000000000000000000000000000000000000000000000000000",
		19 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		20 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		21 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		22 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		23 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		24 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		25 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		26 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		27 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		28 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		29 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		30 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		31 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
	
	constant rom_lbl_difficulty : rom_mem_t := (
		 0 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 1 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 2 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 3 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 4 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 5 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 6 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 7 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 8 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 9 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		10 => "00000000000000000000000000000000000000000000000000000100010000011000000000000000000000000000000000000000000000000000000000000000",
		11 => "00000000000000000000000000000000000000000000000000000100010000100000000000000000000000000000000000000000000000000000000000000000",
		12 => "00000000000000000000000000000000000000000000000000000100000001000000000000000000000000000000000000000000000000000000000000000000",
		13 => "00000000000000000000000000000000000000000000000000000100000001000000000000000000000000000000000000000000000000000000000000000000",
		14 => "00000000000000000000000000000000000000000000000001110100010001111000000000000000000000000000000000000000000000000000000000000000",
		15 => "00000000000000000000000000000000000000000000000010000100010001000000000000000000000000000000000000000000000000000000000000000000",
		16 => "00000000000000000000000000000000000000000000000100000100010001000000000000000000000000000000000000000000000000000000000000000000",
		17 => "00000000000000000000000000000000000000000000000100000100010001000000000000000000000000000000000000000000000000000000000000000000",
		18 => "00000000000000000000000000000000000000000000000100000100010001000000000000000000000000000000000000000000000000000000000000000000",
		19 => "00000000000000000000000000000000000000000000000010001000010001000000000000000000000000000000000000000000000000000000000000000000",
		20 => "00000000000000000000000000000000000000000000000001110000010001000000000000000000000000000000000000000000000000000000000000000000",
		21 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		22 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		23 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		24 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		25 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		26 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		27 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		28 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		29 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		30 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		31 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
		
	constant rom_lbl_easy : rom_mem_t := (
		 0 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 1 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 2 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 3 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 4 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 5 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 6 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 7 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 8 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 9 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		10 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		11 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		12 => "00000000000000000000000000000000000000000000000000000000111000000000000000000000000000000000000000000000000000000000000000000000",
		13 => "00000000000000000000000000000000000000000000000000000001000100000000000000000000000000000000000000000000000000000000000000000000",
		14 => "00000000000000000000000000000000000000000000000000000010000010000000000000000000000000000000000000000000000000000000000000000000",
		15 => "00000000000000000000000000000000000000000000000000000011111100000000000000000000000000000000000000000000000000000000000000000000",
		16 => "00000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000",
		17 => "00000000000000000000000000000000000000000000000000000001000100000000000000000000000000000000000000000000000000000000000000000000",
		18 => "00000000000000000000000000000000000000000000000000000000111000000000000000000000000000000000000000000000000000000000000000000000",
		19 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		20 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		21 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		22 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		23 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		24 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		25 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		26 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		27 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		28 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		29 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		30 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		31 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
		
	constant rom_lbl_medium : rom_mem_t := (
		 0 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 1 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 2 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 3 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 4 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 5 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 6 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 7 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 8 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 9 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		10 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		11 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		12 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		13 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		14 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		15 => "00000000000000000000000000000000000000000000000000000000010111000111000000000000000000000000000000000000000000000000000000000000",
		16 => "00000000000000000000000000000000000000000000000000000000011000101000100000000000000000000000000000000000000000000000000000000000",
		17 => "00000000000000000000000000000000000000000000000000000000010000010000010000000000000000000000000000000000000000000000000000000000",
		18 => "00000000000000000000000000000000000000000000000000000000010000010000010000000000000000000000000000000000000000000000000000000000",
		19 => "00000000000000000000000000000000000000000000000000000000010000010000010000000000000000000000000000000000000000000000000000000000",
		20 => "00000000000000000000000000000000000000000000000000000000010000010000010000000000000000000000000000000000000000000000000000000000",
		21 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		22 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		23 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		24 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		25 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		26 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		27 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		28 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		29 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		30 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		31 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
		
	constant rom_lbl_hard : rom_mem_t := (
		 0 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 1 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 2 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 3 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 4 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 5 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 6 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 7 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 8 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 9 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		10 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		11 => "00000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000",
		12 => "00000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000",
		13 => "00000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000",
		14 => "00000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000",
		15 => "00000000000000000000000000000000000000000000000000000000010111000000000000000000000000000000000000000000000000000000000000000000",
		16 => "00000000000000000000000000000000000000000000000000000000011000100000000000000000000000000000000000000000000000000000000000000000",
		17 => "00000000000000000000000000000000000000000000000000000000010000010000000000000000000000000000000000000000000000000000000000000000",
		18 => "00000000000000000000000000000000000000000000000000000000010000010000000000000000000000000000000000000000000000000000000000000000",
		19 => "00000000000000000000000000000000000000000000000000000000010000010000000000000000000000000000000000000000000000000000000000000000",
		20 => "00000000000000000000000000000000000000000000000000000000010000010000000000000000000000000000000000000000000000000000000000000000",
		21 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		22 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		23 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		24 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		25 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		26 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		27 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		28 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		29 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		30 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		31 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
	constant rom_lbl_sudoku : rom_mem_t := (
		 0 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 1 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 2 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 3 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 4 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 5 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 6 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 7 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 8 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		 9 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		10 => "00000000000000000000000000000000000001111100001000000000000000000000000000100000000000000000000000000000000000000000000000000000",
		11 => "00000000000000000000000000000000000100000000010000000000000000000000000001000000000000000000000000000000000000000000000000000000",
		12 => "00000000000000000000000000000000000100000000011110000001111000000101110001111000000000000000000000000000000000000000000000000000",
		13 => "00000000000000000000000000000000000011111000010000000010000100000110000001000000000000000000000000000000000000000000000000000000",
		14 => "00000000000000000000000000000000000000000100010000000010000100000100000001000000000000000000000000000000000000000000000000000000",
		15 => "00000000000000000000000000000000000000000100010000000010000100000100000001000000000000000000000000000000000000000000000000000000",
		16 => "00000000000000000000000000000000000011111000001110000001111010000100000000111000000000000000000000000000000000000000000000000000",
		17 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		18 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		19 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		20 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		21 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		22 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		23 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		24 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		25 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		26 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		27 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		28 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		29 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		30 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		31 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
		
	signal bit_dat	: std_logic_vector(0 to ROM_WIDTH - 1);
	signal lbl_adr	: std_logic_vector(3 downto 0);
	signal bit_adr	: std_logic_vector(4 downto 0);
	
begin
	
	lbl_adr <= rom_adr_i(8 downto 5);
	bit_adr <= rom_adr_i(4 downto 0);
	
	process(lbl_adr, bit_adr, bit_dat)
	begin
		case lbl_adr is
			when "0001" => bit_dat <= rom_lbl_start(to_integer(unsigned(bit_adr)));
			when "0010" => bit_dat <= rom_lbl_restart(to_integer(unsigned(bit_adr)));
			when "0011" => bit_dat <= rom_lbl_exit(to_integer(unsigned(bit_adr)));
			when "0100" => bit_dat <= rom_lbl_difficulty(to_integer(unsigned(bit_adr)));
			when "0101" => bit_dat <= rom_lbl_easy(to_integer(unsigned(bit_adr)));
			when "0110" => bit_dat <= rom_lbl_medium(to_integer(unsigned(bit_adr)));
			when "0111" => bit_dat <= rom_lbl_hard(to_integer(unsigned(bit_adr)));
			when "1000" => bit_dat <= rom_lbl_sudoku(to_integer(unsigned(bit_adr)));
			when others => bit_dat <= (others => '0');
		end case;
		
		rom_dat_o <= bit_dat;
	end process;
end rtl;