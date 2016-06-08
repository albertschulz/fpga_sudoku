------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	ccu_top
-- Date:		26.04.2016
-- Description:
-- 	Central Controlling Unit
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.const_package.all;

entity ccu_top is
	port(
		clk	      		: in  std_logic;
		rst					: in  std_logic;
		
		-- PS2-Input-Ports
		ps2_dat_en			: in	std_logic;
		ps2_dat_i			: in	std_logic_vector(7 downto 0);
		
		-- Switches-Input-Ports
		sw_dat_en			: in	std_logic;
		sw_dat_i				: in	std_logic_vector(6 downto 0);
		
		-- VGA-Position-Input-Ports
		vga_pos_x			: in  integer range 0 to 640;
		vga_pos_y			: in  integer range 0 to 480;
		
		-- Controller-Ouput-Ports
		led_mde_o			: out std_logic;
		seg_dat_o			: out std_logic_vector(27 downto 0);
		vga_dat_o			: out std_logic_vector( 2 downto 0);
		led_solved			: out std_logic;
		
		-- ROM-Ports
		img_rom_dat_i		: in	std_logic_vector(31 downto 0);
		img_rom_adr_o		: out std_logic_vector( 8 downto 0);
		
		tmr_rom_dat_i		: in	std_logic_vector(23 downto 0);
		tmr_rom_adr_o		: out std_logic_vector( 8 downto 0);
		
		lbl_rom_dat_i		: in	std_logic_vector(127 downto 0);
		lbl_rom_adr_o		: out std_logic_vector(  8 downto 0);
		
		
		game_rom_dat_i		: in 	std_logic_vector( 7 downto 0);
		game_rom_adr_o		: out std_logic_vector(15 downto 0);
		
		lbl_h_rom_dat_i	: in	std_logic_vector(255 downto 0);
		lbl_h_rom_adr_o	: out std_logic_vector(  9 downto 0);
		
		-- RAM-Ports
		ram_dat_i1			: in	std_logic_vector(5 downto 0);
		ram_dat_i2			: in	std_logic_vector(5 downto 0);
		ram_adr_r1			: out	std_logic_vector(7 downto 0);
		ram_adr_r2			: out	std_logic_vector(7 downto 0);
		ram_adr_w			: out	std_logic_vector(7 downto 0);
		ram_dat_o			: out	std_logic_vector(5 downto 0);
		ram_we				: out	std_logic		
	);	
end ccu_top;

architecture rtl of ccu_top is

	-- from: PS2-Dat-Decoder
	signal sig_instr_i		: CCU_CMD_TYPE;
	
	-- from: Game Loader
	signal game_loaded		: std_logic;
	signal gl_ram_adr_w		: std_logic_vector(7 downto 0);
	signal gl_ram_dat_o		: std_logic_vector(5 downto 0);
	signal gl_ram_we			: std_logic;
	
	-- from: Game Controller
	signal load_game			: std_logic;
	signal load_old_game		: std_logic;
	signal gc_ram_adr_w		: std_logic_vector(7 downto 0);
	signal gc_ram_dat_o		: std_logic_vector(5 downto 0);
	signal gc_ram_we			: std_logic;
	signal sig_game_state	: std_logic;
	signal sig_game_menu		: std_logic;
	signal sig_game_won		: std_logic_vector(1 downto 0);
	signal sig_game_diff		: std_logic_vector(1 downto 0);
	signal sig_game_btn_act	: std_logic_vector(3 downto 0);
	signal sig_tmr_rst		: std_logic;
	signal sig_tmr_en			: std_logic;
	
	-- from: CLK-Timer
	signal sig_tme_out		: std_logic_vector(14 downto 0);
  
begin
	-- PS2-Dat-Decoder
	ps2_dat_dec : entity work.ps2_dat_decoder
		port map(
			clk 				=> clk,
			rst 				=> rst,
			ps2_dat_i 		=> ps2_dat_i,
			ps2_dat_en		=> ps2_dat_en,
			led_mde			=> led_mde_o,
			instr_o			=> sig_instr_i,
			seg_dat_o 		=> seg_dat_o
		);
		
	-- Pixel-Buffer
	pxl_buf : entity work.pxl_buffer
		port map(
			clk 					=> clk,
			tme_dat_i			=> sig_tme_out,
			game_state			=> sig_game_state,
			game_menu			=> sig_game_menu,
			game_won				=> sig_game_won,
			game_diff			=> sig_game_diff,
			game_btn_act		=> sig_game_btn_act,
			vga_pos_x			=> vga_pos_x,
			vga_pos_y			=> vga_pos_y,
			vga_dat_o			=> vga_dat_o,
			rom_img_dat_i		=> img_rom_dat_i,
			rom_img_adr_o		=> img_rom_adr_o,
			rom_tmr_dat_i		=> tmr_rom_dat_i,
			rom_tmr_adr_o		=> tmr_rom_adr_o,
			rom_lbl_dat_i		=> lbl_rom_dat_i,
			rom_lbl_adr_o		=> lbl_rom_adr_o,
			rom_lbl_h_dat_i	=> lbl_h_rom_dat_i,
			rom_lbl_h_adr_o	=> lbl_h_rom_adr_o,
			ram_dat_i			=> ram_dat_i2,
			ram_adr_r			=> ram_adr_r2
		);
		
	-- Game-Controller
	gme_ctr : entity work.game_controller
		port map(
			clk 				=> clk,
			rst 				=> rst,
			instr_i			=> sig_instr_i,
			ram_dat_i		=> ram_dat_i1,
			ram_adr_r		=> ram_adr_r1,
			ram_adr_w		=> gc_ram_adr_w,
			ram_dat_o		=> gc_ram_dat_o,
			ram_we			=> gc_ram_we,
			load_game		=> load_game,
			load_old_game	=> load_old_game,
			game_loaded		=> game_loaded,
			game_solved		=> led_solved,
			game_state		=> sig_game_state,
			game_menu		=> sig_game_menu,
			game_won			=> sig_game_won,
			game_diff		=> sig_game_diff,
			game_btn_act	=> sig_game_btn_act,
			tmr_rst			=> sig_tmr_rst,
			tmr_en			=> sig_tmr_en
		);
		
	-- Game Loader
	game_loader : entity work.game_loader
		port map (
			clk 				=> clk,
			rst 				=> rst,
			load				=> load_game,
			load_old			=> load_old_game,
			game_diff		=> sig_game_diff,
			rom_data_in 	=> game_rom_dat_i(3 downto 0),
			rom_addr_out	=> game_rom_adr_o,
			done			 	=> game_loaded,
			ram_addr_out 	=> gl_ram_adr_w,
			ram_data_out 	=> gl_ram_dat_o,
			ram_write_en 	=> gl_ram_we,
			sw_dat_en		=> sw_dat_en,
			sw_dat_i			=> sw_dat_i
		);
		
	--CLK-Timer
	tmr_clk : entity work.tmr_clk
		port map (
			clk 				=> clk,
			rst 				=> rst,
			tmr_rst			=> sig_tmr_rst,
			tmr_en			=> sig_tmr_en,
			tme_out 			=> sig_tme_out
		);
		
	-- MUX for RAM Write Port
	-- 
	-- Allow Game Loader to access RAM when loading game is in progress
	ram_adr_w	<= gl_ram_adr_w 	when load_game = '1' else gc_ram_adr_w;
	ram_dat_o	<= gl_ram_dat_o 	when load_game = '1' else gc_ram_dat_o;
	ram_we 		<= gl_ram_we 		when load_game = '1' else gc_ram_we;
		
end rtl;
