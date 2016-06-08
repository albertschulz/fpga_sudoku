------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	ps2_dat_decoder
-- Date:		28.04.2016
-- Description:
--		Decoder for PS2-Data
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.const_package.all;

entity ps2_dat_decoder is
	port(
		clk	      	: in  std_logic;
		rst	      	: in  std_logic;
		ps2_dat_en		: in	std_logic;
		ps2_dat_i		: in	std_logic_vector(7 downto 0);
		
		led_mde			: out std_logic;
		instr_o			: out std_logic_vector(4 downto 0);
		seg_dat_o		: out std_logic_vector(27 downto 0)
	);
end ps2_dat_decoder;

architecture rtl of ps2_dat_decoder is

	signal ins_code	: CCU_CMD_TYPE := CMD_NOP;
	signal seg_code	: std_logic_vector(27 downto 0) := (others => '0');
	signal rel_flg		: std_logic := '0';	-- release flag
	signal set_flg		: std_logic := '0';	-- mode flag -> '1'-set, '0'-nav
	signal mov_flg		: std_logic := '0';	-- move flag -> '1' down with 5, else with 2

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if(rst = '1') then
				rel_flg		<= '0';
				set_flg		<= '0';
				ins_code		<= CMD_NOP;
				seg_code		<= x"0000000";
			else
				if(ps2_dat_en = '1') then
					if(rel_flg = '1') then
						rel_flg <= '0';
					else
						if(set_flg = '1') then
							case ps2_dat_i is
								when x"69"	=> 				-- '1' -> 69
									seg_code <= x"0000006";
									ins_code	<= CMD_1;
									set_flg	<= '0';

								when x"72"	=> 				-- '2' -> 72
									seg_code <= x"000005B";
									ins_code	<= CMD_2;
									set_flg	<= '0';

								when x"7A"	=> 				-- '3' -> 7A
									seg_code <= x"000004F";
									ins_code	<= CMD_3;
									set_flg	<= '0';

								when x"6B"	=> 				-- '4' -> 6B
									seg_code <= x"0000066";
									ins_code	<= CMD_4;
									set_flg	<= '0';

								when x"73"	=> 				-- '5' -> 73
									seg_code <= x"000006D";
									ins_code	<= CMD_5;
									set_flg	<= '0';

								when x"74"	=> 				-- '6' -> 74
									seg_code <= x"000007D";
									ins_code	<= CMD_6;
									set_flg	<= '0';

								when x"6C"	=> 				-- '7' -> 6C
									seg_code <= x"0000007";
									ins_code	<= CMD_7;
									set_flg	<= '0';

								when x"75"	=> 				-- '8' -> 75
									seg_code <= x"000007F";
									ins_code	<= CMD_8;
									set_flg	<= '0';

								when x"7D"	=>					-- '9' -> 7D
									seg_code <= x"000006F";
									ins_code	<= CMD_9;
									set_flg	<= '0';

								when x"71"	=>					-- 'Del' -> 71
									seg_code <= x"017BCB8";
									ins_code	<= CMD_DEL;
									set_flg	<= '0';
									
								when x"77"	=>					-- 'Num' -> 77	
									seg_code <= x"01B7CF8";
									
								when x"4A"	=>					-- '/'	-> E0, 4A
									ins_code	<= CMD_DIV;
									
								when x"7C"	=>					-- '*'	-> 7C
									seg_code <= x"A912A1C";
									ins_code	<= CMD_MNU;
								
								when x"7B"	=>					-- '-'	-> 7B
									seg_code <= x"0000000";
									ins_code	<= CMD_NOP;
									
								when x"79"	=>					-- '+'	-> 79
									seg_code <= x"0000000";
									ins_code	<= CMD_NOP;
									
								when x"5A"	=>					-- 'Enter' -> E0,5A
									seg_code <= x"01E6A78";
									ins_code	<= CMD_ENT;
								
								when x"F0"	=>					-- 'Release-Sig.' -> F0
									rel_flg 	<= '1';				

								when x"E0"	=>					-- 'E0' -> E0
								
								when others	=>					-- default
									seg_code <= x"0000000";
									ins_code	<= CMD_NOP;

							end case;
						else
							case ps2_dat_i is
								when x"72"	=> 				-- '2' -> 72
									seg_code <= x"000001C";
									ins_code	<= CMD_DWN;

								when x"73"	=> 				-- '5' -> 73
									seg_code <= x"000001C";
									ins_code	<= CMD_DWN;
									
								when x"6B"	=> 				-- '4' -> 6B
									seg_code <= x"0000058";
									ins_code	<= CMD_LFT;

								when x"74"	=> 				-- '6' -> 74
									seg_code <= x"000004C";
									ins_code	<= CMD_RGT;

								when x"75"	=> 				-- '8' -> 75
									seg_code <= x"0000054";
									ins_code	<= CMD_UP;

								when x"71"	=>					-- 'Del' -> 71
									seg_code <= x"017BCB8";
									ins_code	<= CMD_DEL;
									
								when x"77"	=>					-- 'Num' -> 77	
									seg_code <= x"01B7CF8";
									set_flg	<= '1';
								
								when x"4A"	=>					-- '/'	-> E0, 4A
									ins_code	<= CMD_DIV;
								
								when x"7C"	=>					-- '*'	-> 7C
									seg_code <= x"A912A1C";
									ins_code	<= CMD_MNU;
									
								when x"5A"	=>					-- 'Enter' -> E0,5A
									seg_code <= x"01E6A78";
									ins_code	<= CMD_ENT;
									
								when x"F0"	=>					-- 'Release-Sig.' -> F0
									rel_flg 	<= '1';				

								when x"E0"	=>					-- 'E0' -> E0
																
								when others	=>					-- default
									seg_code <= x"0000000";
									ins_code	<= CMD_NOP;

							end case;
						end if;
					end if;
				else
					ins_code <= CMD_NOP;
				end if;
			end if;
			
			seg_dat_o <= seg_code;
			instr_o	 <= ins_code;
			led_mde	 <= set_flg;		
			
		end if;
	end process;	
end rtl;