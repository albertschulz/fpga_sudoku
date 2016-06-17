------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	pxl_buffer
-- Date:		09.05.2016
-- Description:
-- 	Buffers the pixels of one line
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pxl_buffer is
	port(
		clk					: in	std_logic;
		
		tme_dat_i			: in	std_logic_vector(14 downto 0);
		
		game_state			: in	std_logic;
		game_menu			: in	std_logic;
		game_won				: in  std_logic_vector(1 downto 0);
		game_diff			: in  std_logic_vector(1 downto 0);
		game_btn_act		: in  std_logic_vector(3 downto 0);
		
		vga_pos_x			: in  integer range 0 to 640;
		vga_pos_y			: in  integer range 0 to 480;
		vga_dat_o			: out	std_logic_vector(  2 downto 0);
		
		rom_img_dat_i		: in	std_logic_vector( 31 downto 0);
		rom_img_adr_o		: out std_logic_vector(  8 downto 0);
		rom_tmr_dat_i		: in	std_logic_vector( 23 downto 0);
		rom_tmr_adr_o		: out std_logic_vector(  8 downto 0);
		rom_lbl_dat_i		: in	std_logic_vector(127 downto 0);
		rom_lbl_adr_o		: out std_logic_vector(  8 downto 0);
		rom_lbl_h_dat_i	: in	std_logic_vector(255 downto 0);
		rom_lbl_h_adr_o	: out std_logic_vector(  9 downto 0);
		
		ram_dat_i			: in	std_logic_vector(  5 downto 0);
		ram_adr_r			: out	std_logic_vector(  7 downto 0)
	);	
end pxl_buffer;

architecture rtl of pxl_buffer is
	
	constant PXL_DSP_H	: integer := 640;
	constant PXL_DSP_V	: integer := 480;
	constant PXL_FLD_SZE	: integer := 316;
	constant PXL_OFF_FRM	: integer := 82;
	constant PXL_OFF_LAL	: integer := 4;
	constant PXL_OFF_SML	: integer := 2;
	constant PXL_SEP_X	: integer := 480;
	constant PXL_SEP_WDT	: integer := 4;
	
	type lbl_t is array(0 to 63) of std_logic_vector(0 to 127);
	constant lbl_legend : lbl_t := (
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
		10 => "00111000000000001110000000000000000000000000000000000000011000011110000000000000000000000000000000000000000000000000000000000000",
		11 => "00110000011110000110000000000000000000000001111110000000011000000110000000000000000000000000011000000000000000000000000000000000",
		12 => "00110000010010000110000000000000000000000000000110000000011000000110000000000000000000000000011000000000000000000000000000000000",
		13 => "00110000110011000110000000000000000000000000001100001110011111000110000000000001111000111101111110011111100111100111110000000000",
		14 => "00110000110011000110000000000000000000000000001100010011011001100110000000000011000100100110011000000001100100110110011000000000",
		15 => "00110000110111000110000000000000000000000000011000000011011001100110000000000011100001100110011000000011001100110110011000000000",
		16 => "00110000110011000110000000000000000000000000110000011111011001100110000000000001111001111110011000000110001111110110011000000000",
		17 => "00110000110011000110000000000000000000000000110000110011011001100110000000000000001101100000011000001100001100000110011000000000",
		18 => "00110000010010000110000000000000000000000001100000110011011001100110000000000010001100110010011000011000000110010110011000000000",
		19 => "00110000011110000110000000000000000000000001111110011111011001100011100000000001111000011100001110011111100011100110011000000000",
		20 => "00111000000000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		21 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		22 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		23 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		24 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		25 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		26 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		27 => "00111000000000000000011110000011100000000000000000000000011000011110000000000111100000000000000000000000001100000000000000000000",
		28 => "00110000111100000000000110000001100000000001111110000000011000000110000000000001100000100100000000000000001100000000000000000000",
		29 => "00110000110110000000000110000001100000000000000110000000011000000110000000000001100000000000000000000000001100000000000000000000",
		30 => "00110000110011001111000110000001100000000000001100001110011111000110000000000001100000111100011110000111001111100011110011111000",
		31 => "00110000110011001001100110000001100000000000001100010011011001100110000000000001100000100100110001001100101100110010011011001100",
		32 => "00110000110011011001100110000001100000000000011000000011011001100110000000000001100001100110111000011000001100110110011011001100",
		33 => "00110000110011011111100110000001100000000000110000011111011001100110000000000001100001100110011110011000001100110111111011001100",
		34 => "00110000110011011000000110000001100000000000110000110011011001100110000000000001100001100110000011011000001100110110000011001100",
		35 => "00110000110110001100100110000001100000000001100000110011011001100110000000000001100001100100100011001100101100110011001011001100",
		36 => "00110000111100000111000011100001100000000001111110011111011001100011100000000000111000111100011110000111001100110001110011001100",
		37 => "00111000000000000000000000000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		38 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		39 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		40 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		41 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		42 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		43 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		44 => "00111000000000000000000000000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		45 => "00110000110011000000000000000001100000000001000110000000000000000100100000000000000000000000000000000000000000000000000000000000",
		46 => "00110000111011000000000000000001100000000001100110000000000000000000000000000000000000000000000000000000000000000000000000000000",
		47 => "00110000111011011001101111110001100000000001111110011110011111001100110000000000000000000000000000000000000000000000000000000000",
		48 => "00110000111011011001101101010001100000000001111110010011011001101100110000000000000000000000000000000000000000000000000000000000",
		49 => "00110000111111011001101101010001100000000001111110110011011001101100110000000000000000000000000000000000000000000000000000000000",
		50 => "00110000110111011001101101010001100000000001100110111111011001101100110000000000000000000000000000000000000000000000000000000000",
		51 => "00110000110111011001101101010001100000000001100110110000011001101100110000000000000000000000000000000000000000000000000000000000",
		52 => "00110000110111011001101101010001100000000001100110011001011001101100110000000000000000000000000000000000000000000000000000000000",
		53 => "00110000110011001111101101010001100000000001100110001110011001100111110000000000000000000000000000000000000000000000000000000000",
		54 => "00111000000000000000000000000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		55 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		56 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		57 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		58 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		59 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		60 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		61 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		62 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		63 => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
	
	type buf_lne_t is array(0 to 315) of std_logic_vector(2 downto 0);
	signal buf_lne_cur	: buf_lne_t := (others => (others => '0'));
	signal buf_lne_nxt	: buf_lne_t := (others => (others => '0'));
	
	type buf_lbl_header_t is array(0 to 255) of std_logic_vector(2 downto 0);
	signal buf_lbl_top_cur	: buf_lbl_header_t := (others => (others => '0'));
	signal buf_lbl_top_nxt	: buf_lbl_header_t := (others => (others => '0'));
	
	type buf_lbl_tmr_t is array(0 to 119) of std_logic_vector(2 downto 0);
	signal buf_lbl_tmr_cur	: buf_lbl_tmr_t := (others => (others => '0'));
	signal buf_lbl_tmr_nxt	: buf_lbl_tmr_t := (others => (others => '0'));
	
	type buf_lbl_t is array(0 to 127) of std_logic_vector(2 downto 0);
	signal buf_lbl_cur		: buf_lbl_t := (others => (others => '0'));
	signal buf_lbl_nxt		: buf_lbl_t := (others => (others => '0'));
	signal buf_lbl_leg_cur	: buf_lbl_t := (others => (others => '0'));
	signal buf_lbl_leg_nxt	: buf_lbl_t := (others => (others => '0'));
	
	signal pos_x_cur		: integer range 0 to PXL_DSP_H := 0;
	signal pos_y_cur		: integer range 0 to PXL_DSP_V := 0;
	signal pos_y_nxt		: integer range 0 to PXL_DSP_V := 0;
	signal pos_y_off		: integer range 0 to PXL_DSP_V := 0;
	signal pos_y_tmr		: integer range 0 to PXL_DSP_V := 0;
	
	signal cnt_x			: unsigned(3 downto 0) := (others => '0');
	signal cnt_y			: unsigned(3 downto 0) := (others => '0');
	
	signal buf_start		: std_logic_vector(1 downto 0) := (others => '0');
	signal buf_cmt			: std_logic := '0';
	
	signal buf_lbl_key	: std_logic_vector(3 downto 0) := (others => '0');
	signal buf_tsk_cnt	: unsigned(1 downto 0) := (others => '0');
	
	signal buf_instr		: std_logic := '0';
	signal buf_tsk1_cnt	: unsigned(1 downto 0) := (others => '0');
	signal buf_tsk2_cnt	: unsigned(2 downto 0) := (others => '0');
	
begin
	-- commit buffered lines
	process(clk)
	begin
		if rising_edge(clk) then
			if(pos_x_cur = PXL_DSP_H and buf_cmt = '0') then	-- commit new buffer lines
				buf_lne_cur			<= buf_lne_nxt;
				buf_lbl_cur			<= buf_lbl_nxt;
				buf_lbl_top_cur	<= buf_lbl_top_nxt;
				buf_lbl_tmr_cur	<= buf_lbl_tmr_nxt;
				buf_lbl_leg_cur	<= buf_lbl_leg_nxt;
				buf_cmt				<= '1';
			end if;
			
			if(pos_x_cur = 0 and pos_y_cur < PXL_DSP_V) then	-- ready for new commit
				buf_cmt	<= '0';
			end if;
		end if;
	end process;

	-- buffer new game field line
	process(clk)
		variable tmp_rom 		: std_logic_vector(31 downto 0);
		variable tmp_ram 		: std_logic_vector(5 downto 0);
		variable pos_x_off 	: integer := 0;
	begin
		if rising_edge(clk) then
			if(buf_start = "01") then									-- horizontal lines
				for i in 0 to PXL_FLD_SZE - 1 loop
					buf_lne_nxt(i) <= "001";
				end loop;
				
			elsif(buf_start = "10") then								-- vertical lines & numbers
				if(cnt_x = "0000") then
					for i in 0 to PXL_OFF_LAL - 1 loop				-- large vertical lines
						buf_lne_nxt(i      ) <= "001";
						buf_lne_nxt(i + 104) <= "001";
						buf_lne_nxt(i + 208) <= "001";
						buf_lne_nxt(i + 312) <= "001";
						
						if(i < PXL_OFF_SML) then						-- small vertical lines
							buf_lne_nxt(i +  36) <= "001";
							buf_lne_nxt(i +  70) <= "001";
							buf_lne_nxt(i + 140) <= "001";
							buf_lne_nxt(i + 174) <= "001";
							buf_lne_nxt(i + 244) <= "001";
							buf_lne_nxt(i + 278) <= "001";
						end if;
					end loop;
					
					ram_adr_r <= std_logic_vector(cnt_y - 1) & std_logic_vector(cnt_x);
				
				else
					if(game_state = '1') then
						if(cnt_x = "0001") then
							tmp_ram			:= ram_dat_i;
							rom_img_adr_o	<= tmp_ram(3 downto 0) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_off), 5));
							ram_adr_r		<= std_logic_vector(cnt_y - 1) & std_logic_vector(cnt_x);
							
						elsif(cnt_x = "1001") then
							-- take data from ROM
							tmp_rom := rom_img_dat_i;
							
							-- check if menu is active to hide cursor in the game field
							if(game_menu = '1') then
								tmp_ram := '0' & tmp_ram(4 downto 0);
							end if;
							
							-- fill buffer line
							for i in 0 to 31 loop
								buf_lne_nxt(i + 246) <= tmp_ram(5 downto 4) & tmp_rom(31 - i);
							end loop;
							
							-- take data from RAM
							tmp_ram := ram_dat_i;
							
							-- calc new addresses
							rom_img_adr_o <= tmp_ram(3 downto 0) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_off), 5));
							
						
						elsif(cnt_x = "1010") then
							-- take data from ROM
							tmp_rom := rom_img_dat_i;
							
							-- check if menu is active to hide cursor in the game field
							if(game_menu = '1') then
								tmp_ram := '0' & tmp_ram(4 downto 0);
							end if;
							
							-- fill buffer line
							for i in 0 to 31 loop
								buf_lne_nxt(i + 280) <= tmp_ram(5 downto 4) & tmp_rom(31 - i);
							end loop;
							
						else
							-- take data from ROM
							tmp_rom := rom_img_dat_i;
							
							-- calc offset
							case (to_integer(cnt_x) - 2) is
								when 0 to 2 => pos_x_off := ((to_integer(cnt_x - 2) * 34) + 4);
								when 3 to 5 => pos_x_off := ((to_integer(cnt_x - 2) * 34) + 6);
								when 6 		=> pos_x_off := 212;
								when others => pos_x_off := 0;
							end case;
							
							-- check if menu is active to hide cursor in the game field
							if(game_menu = '1') then
								tmp_ram := '0' & tmp_ram(4 downto 0);
							end if;
							
							-- fill buffer line
							for i in 0 to 31 loop
								buf_lne_nxt(i + pos_x_off) <= tmp_ram(5 downto 4) & tmp_rom(31 - i);
							end loop;
							
							-- take data from RAM
							tmp_ram		:= ram_dat_i;
							
							-- calc new addresses
							rom_img_adr_o	<= tmp_ram(3 downto 0) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_off), 5));
							ram_adr_r	<= std_logic_vector(cnt_y - 1) & std_logic_vector(cnt_x);
							
						end if;
					end if;
				end if;
				
				if(cnt_x = "1010") then
					cnt_x	<= "0000";
				else
					cnt_x	<= cnt_x + 1;
				end if;
				
			else
				buf_lne_nxt <= (others => "000");
			end if;
			
		end if;
	end process;
	
	-- buffer new label line
	process(clk)
		variable tmp_rom : std_logic_vector(127 downto 0);
		variable tmp_pre : std_logic_vector(  1 downto 0);
	begin
		if rising_edge(clk) then
			if(game_state = '0') then
				if(buf_lbl_key = "0001" or buf_lbl_key = "0100" or buf_lbl_key = "0101" or buf_lbl_key = "0110" or buf_lbl_key = "0111") then
					if(buf_tsk_cnt = "00") then
						rom_lbl_adr_o <= buf_lbl_key & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_off), 5));
						
					elsif(buf_tsk_cnt = "01") then
						tmp_rom := rom_lbl_dat_i;
						
						-- calc prefix
						if(game_btn_act = buf_lbl_key) then
							tmp_pre := "10";
						else
							tmp_pre := "00";
						end if;
						
						-- fill buffer line
						for i in 0 to 127 loop
							buf_lbl_nxt(i) <= tmp_pre & tmp_rom(127 - i);
						end loop;
								
					end if;
					
					if(buf_tsk_cnt = "01") then
						buf_tsk_cnt	<= "00";
					else
						buf_tsk_cnt	<= buf_tsk_cnt + 1;
					end if;
					
				else
					buf_lbl_nxt <= (others => "000");
				end if;
			else
				if(buf_lbl_key = "0010" or buf_lbl_key = "0011") then
					if(buf_tsk_cnt = "00") then
						rom_lbl_adr_o <= buf_lbl_key & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_off), 5));
						
					elsif(buf_tsk_cnt = "01") then
						tmp_rom := rom_lbl_dat_i;
						
						-- calc prefix
						if(game_btn_act = buf_lbl_key) then
							tmp_pre := "10";
						else
							tmp_pre := "00";
						end if;
						
						-- fill buffer line
						for i in 0 to 127 loop
							buf_lbl_nxt(i) <= tmp_pre & tmp_rom(127 - i);
						end loop;
								
					end if;
					
					if(buf_tsk_cnt = "01") then
						buf_tsk_cnt	<= "00";
					else
						buf_tsk_cnt	<= buf_tsk_cnt + 1;
					end if;
					
				else
					buf_lbl_nxt <= (others => "000");
				end if;
			end if;
		end if;
	end process;
	
	-- buffer new header label line
	process(clk)
		variable rom_adr_pre	: std_logic_vector(3 downto 0);
	begin
		if rising_edge(clk) then
			if(buf_tsk1_cnt = "00") then
				if(buf_instr = '0') then
					rom_adr_pre := "0001";
				else
					if(game_state = '0') then
						rom_adr_pre := "0010";
					else
						if(game_won = "11") then
							rom_adr_pre := "0011";	-- won
						elsif(game_won = "10") then
							rom_adr_pre := "0100";	-- lost
						else
							rom_adr_pre := "0000";
						end if;
					end if;
				end if;
				
				rom_lbl_h_adr_o <= rom_adr_pre & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_off), 6));
				
			elsif(buf_tsk1_cnt = "01") then
				for i in 0 to 255 loop
					buf_lbl_top_nxt(i) <= "00" & rom_lbl_h_dat_i(255 - i);
				end loop;
			end if;
			
			if(buf_tsk1_cnt = "01") then
				buf_tsk1_cnt	<= "00";
			else
				buf_tsk1_cnt	<= buf_tsk1_cnt + 1;
			end if;
		end if;
	end process;
	
	-- buffer timer line
	process(clk)
	begin
		if rising_edge(clk) then
			if(game_state = '1' and pos_y_tmr /= 0) then
				if(buf_tsk2_cnt = "000") then
					rom_tmr_adr_o <= tme_dat_i(14 downto 11) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_tmr), 5));
				elsif(buf_tsk2_cnt = "001") then
					for i in 0 to 23 loop
						buf_lbl_tmr_nxt(i) <= "00" & rom_tmr_dat_i(23 - i);
					end loop;
					
					rom_tmr_adr_o <= tme_dat_i(10 downto 7) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_tmr), 5));
				
				elsif(buf_tsk2_cnt = "010") then
					for i in 0 to 23 loop
						buf_lbl_tmr_nxt(i + 24) <= "00" & rom_tmr_dat_i(23 - i);
					end loop;
				
					rom_tmr_adr_o <= "1010" & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_tmr), 5));
				
				elsif(buf_tsk2_cnt = "011") then
					for i in 0 to 23 loop
						buf_lbl_tmr_nxt(i + 48) <= "00" & rom_tmr_dat_i(23 - i);
					end loop;
					
					rom_tmr_adr_o <= '0' & tme_dat_i(6 downto 4) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_tmr), 5));
					
				elsif(buf_tsk2_cnt = "100") then
					for i in 0 to 23 loop
						buf_lbl_tmr_nxt(i + 72) <= "00" & rom_tmr_dat_i(23 - i);
					end loop;
		
					rom_tmr_adr_o <= tme_dat_i(3 downto 0) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_tmr), 5));
				
				elsif(buf_tsk2_cnt = "101") then
					for i in 0 to 23 loop
						buf_lbl_tmr_nxt(i + 96) <= "00" & rom_tmr_dat_i(23 - i);
					end loop;
				end if;
				
				if(buf_tsk2_cnt = "101") then
					buf_tsk2_cnt	<= "000";
				else
					buf_tsk2_cnt	<= buf_tsk2_cnt + 1;
				end if;
			else
				buf_lbl_tmr_nxt <= (others => "000");
			end if;
		end if;
	end process;
	
	-- buffer new legend label line
	process(clk)
	begin
		if rising_edge(clk) then
			if(game_state = '1' and pos_y_off = 9) then
				for i in 0 to 127 loop
					buf_lbl_leg_nxt(i) <= "00" & lbl_legend(pos_y_nxt - pos_y_off)(i);
				end loop;
			else
				buf_lbl_leg_nxt <= (others => "000");
			end if;
		end if;
	end process;
	
	-- calc y-position of field, y-offset and select buffering method
	process(pos_y_nxt, game_diff)
	begin
		cnt_y 		<= "0000";
		buf_lbl_key	<= "0000";
		buf_start	<= "00";
		buf_instr	<= '0';
		pos_y_off	<= 0;
		pos_y_tmr 	<= 0;
		
		if(pos_y_nxt > 8 and pos_y_nxt < 73) then
			buf_instr	<= '0';
			pos_y_off	<= 9;
		elsif(pos_y_nxt > 406 and pos_y_nxt < 471) then
			buf_instr	<= '1';
			pos_y_off	<= 407;
			if((pos_y_nxt > 422) and (pos_y_nxt < 455)) then
				pos_y_tmr <= 423;
			end if;
		elsif((pos_y_nxt >  81 and pos_y_nxt <  86) or (pos_y_nxt > 117 and pos_y_nxt < 120) or (pos_y_nxt > 151 and pos_y_nxt < 154) or 
			(pos_y_nxt > 185 and pos_y_nxt < 190) or (pos_y_nxt > 221 and pos_y_nxt < 224) or (pos_y_nxt > 255 and pos_y_nxt < 258) or
			(pos_y_nxt > 289 and pos_y_nxt < 294) or (pos_y_nxt > 325 and pos_y_nxt < 328) or (pos_y_nxt > 359 and pos_y_nxt < 362) or 
			(pos_y_nxt > 393 and pos_y_nxt < 398)
		) then
			buf_start	<= "01";
		elsif(pos_y_nxt > 85 and pos_y_nxt < 118) then
			cnt_y 		<= "0001";
			buf_start	<= "10";
			pos_y_off	<= 86;
		elsif(pos_y_nxt > 119 and pos_y_nxt < 152) then
			cnt_y 		<= "0010";
			buf_lbl_key	<= "0001";	-- Start
			buf_start	<= "10";
			pos_y_off	<= 120;
		elsif(pos_y_nxt > 153 and pos_y_nxt < 186) then
			cnt_y 		<= "0011";
			buf_start	<= "10";
			pos_y_off	<= 154;
		elsif(pos_y_nxt > 189 and pos_y_nxt < 222) then
			cnt_y 		<= "0100";
			buf_lbl_key	<= "0100";	-- Difficulty
			buf_start	<= "10";
			pos_y_off	<= 190;
		elsif(pos_y_nxt > 223 and pos_y_nxt < 256) then
			cnt_y 		<= "0101";
			buf_start	<= "10";
			pos_y_off	<= 224;
			
			case game_diff is
				when "01" 	=> buf_lbl_key	<= "0101";	-- easy
				when "10" 	=> buf_lbl_key	<= "0110";	-- medium
				when "11" 	=> buf_lbl_key	<= "0111";	-- hard
				when others => buf_lbl_key	<= "0000";
			end case;
		elsif(pos_y_nxt > 257 and pos_y_nxt < 290) then
			cnt_y 		<= "0110";
			buf_lbl_key	<= "0010";	-- Restart
			buf_start	<= "10";
			pos_y_off	<= 258;
		elsif(pos_y_nxt > 293 and pos_y_nxt < 326) then
			cnt_y 		<= "0111";
			buf_start	<= "10";
			pos_y_off	<= 294;
		elsif(pos_y_nxt > 327 and pos_y_nxt < 360) then
			cnt_y 		<= "1000";
			buf_lbl_key	<= "0011";	-- Exit
			buf_start	<= "10";
			pos_y_off	<= 328;
		elsif(pos_y_nxt > 361 and pos_y_nxt < 394) then
			cnt_y 		<= "1001";
			buf_start	<= "10";
			pos_y_off	<= 362;
		end if;
	end process;
	
	-- 
	process(vga_pos_x, vga_pos_y, buf_lne_cur, buf_lbl_cur, buf_lbl_top_cur, buf_lbl_tmr_cur)
	begin
		-- calc y-position of next display line
		if(vga_pos_y < PXL_DSP_V - 1) then
			pos_y_nxt <= vga_pos_y + 1;
		elsif(vga_pos_y = PXL_DSP_V - 1) then
			pos_y_nxt <= 0;
		else	
			pos_y_nxt <= vga_pos_y;
		end if;
		
		-- commit current display coordinates
		pos_x_cur	<= vga_pos_x;
		pos_y_cur	<= vga_pos_y;
		
		-- output pixel-data to vga-controller
		if(vga_pos_x < PXL_DSP_H and vga_pos_y < PXL_DSP_V) then
			if((vga_pos_x > PXL_SEP_X - 1) and (vga_pos_x < PXL_SEP_X + PXL_SEP_WDT)) then								-- vertical separation line
				vga_dat_o <= "001";
			elsif(((vga_pos_x > 483) and (vga_pos_x < 640)) and ((vga_pos_y > 81) and (vga_pos_y < 86))) then		-- upper short horizontal separation line
				vga_dat_o <= "001";
			elsif(((vga_pos_x > 483) and (vga_pos_x < 640)) and ((vga_pos_y > 393) and (vga_pos_y < 398))) then	-- lower short horizontal separation line
				vga_dat_o <= "001";
			else
				if(((vga_pos_x > 81) and (vga_pos_x < 398)) and ((vga_pos_y > 81) and (vga_pos_y < 398))) then			-- sudoku field
					vga_dat_o <= buf_lne_cur(vga_pos_x - 82);
				elsif(((vga_pos_x > 497) and (vga_pos_x < 626)) and ((vga_pos_y > 81) and (vga_pos_y < 398))) then 	-- righthand menu
					vga_dat_o <= buf_lbl_cur(vga_pos_x - 498);
				elsif(((vga_pos_x > 111) and (vga_pos_x < 368)) and ((vga_pos_y > 8) and (vga_pos_y < 73))) then 		-- sudoku label
					vga_dat_o <= buf_lbl_top_cur(vga_pos_x - 112);	
				elsif(((vga_pos_x > 111) and (vga_pos_x < 368)) and ((vga_pos_y > 406) and (vga_pos_y < 471))) then	-- credits label
					vga_dat_o <= buf_lbl_top_cur(vga_pos_x - 112);
				elsif(((vga_pos_x > 501) and (vga_pos_x < 622)) and ((vga_pos_y > 422) and (vga_pos_y < 455))) then	-- timer label
					vga_dat_o <= buf_lbl_tmr_cur(vga_pos_x - 502);
				elsif(((vga_pos_x > 497) and (vga_pos_x < 626)) and ((vga_pos_y > 8) and (vga_pos_y < 73))) then 		-- legend label
					vga_dat_o <= buf_lbl_leg_cur(vga_pos_x - 498);
				else
					vga_dat_o <= "000";
				end if;
			end if;
		else
			vga_dat_o <= "000";
		end if;
	end process;
end rtl;