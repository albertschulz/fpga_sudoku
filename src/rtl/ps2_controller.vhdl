------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	ps2_controller
-- Date:		25.04.2016
-- Description:
--		Controller for the PS2-Connector
------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity ps2_controller is
	generic(
		REG_WIDTH			: integer := 8
	);
	port(
		clk	      		: in  std_logic;
		ps2_clk_i      	: in  std_logic;
		ps2_dat_i			: in	std_logic;
		ps2_dat_o			: out	std_logic_vector(7 downto 0);
		ps2_dat_en			: out	std_logic
	);
end ps2_controller;

architecture rtl of ps2_controller is
	
	signal dat_reg 	: std_logic_vector(REG_WIDTH downto 0) := (others => '1');	-- shift register
	signal bit_cnt		: unsigned(3 downto 0);													-- bit counter
	signal par_bit		: std_logic := '0';														-- parity bit
	signal clk_asy		: std_logic;
	signal clk_syn		: std_logic;
	signal dat_asy		: std_logic;
	signal dat_syn		: std_logic;

begin
	-- sync. clk and data signals
	process(clk)
	begin
		if rising_edge(clk) then
			clk_syn	<= clk_asy;
			clk_asy	<= ps2_clk_i;
			dat_syn	<= dat_asy;
			dat_asy	<= ps2_dat_i;
		end if;
	end process;
	
	-- shift data on falling edge until lsb is 0, todo: calc parity bit
	process(clk)
	begin
		if rising_edge(clk) then
			if(clk_syn = '1' and clk_asy = '0') then
				if(dat_reg(0) = '0' and par_bit = '0') then
					ps2_dat_o	<= dat_reg(8 downto 1);
					ps2_dat_en	<= '1';
					dat_reg 		<= (others => '1');
					par_bit		<= '0';
				else
					dat_reg <= dat_syn & dat_reg(REG_WIDTH downto 1);
					--par_bit <= par_bit xor dat_syn;
				end if;
			else
				ps2_dat_en	<= '0';
			end if;
		end if;
	end process;
end rtl;