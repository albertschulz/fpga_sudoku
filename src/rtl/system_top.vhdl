------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	system_top
-- Date:		22.04.2016
-- Description:
-- 	System-Top
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system_top is
	port(
		clk	      	: in  std_logic;
		rst_a				: in  std_logic;
		
		ps2_clk			: in	std_logic;
		ps2_dat			: in	std_logic;
		
		sw_dat			: in  std_logic_vector(6 downto 0);
		
		vga_red_d		: out std_logic_vector(3 downto 0);
		vga_gre_d		: out std_logic_vector(3 downto 0);
		vga_blu_d		: out std_logic_vector(3 downto 0);
		vga_h_syn_d		: out std_logic;
		vga_v_syn_d		: out std_logic;
		
		seg_hex0_d		: out std_logic_vector(6 downto 0);
		seg_hex1_d  	: out std_logic_vector(6 downto 0);
		seg_hex2_d  	: out std_logic_vector(6 downto 0);
		seg_hex3_d  	: out std_logic_vector(6 downto 0);
		
		led_mde_o		: out std_logic;
		led_solved		: out std_logic
	);	
end system_top;

architecture rtl of system_top is
  
	-- from: Reset-Synchronizer
	signal rst     				: std_logic := '0';
	
	-- from: PS2-Controller
	signal sig_ps2_dat_o			: std_logic_vector(7 downto 0);
	signal sig_ps2_dat_en		: std_logic := '0';
	
	-- from: Switches-Controller
	signal sig_sw_dat_en			: std_logic;
	signal sig_sw_dat_o			: std_logic_vector(6 downto 0);
	
	-- from: VGA-Controller
	signal sig_vga_pos_x			: integer := 0;
	signal sig_vga_pos_y			: integer := 0;
	
	-- from: CCU
	signal sig_seg_dat_o			: std_logic_vector(27 downto 0);
	signal sig_vga_dat_o			: std_logic_vector( 2 downto 0);
	signal sig_img_rom_adr_i	: std_logic_vector( 8 downto 0);
	signal sig_tmr_rom_adr_i	: std_logic_vector( 8 downto 0);
	signal sig_lbl_rom_adr_i	: std_logic_vector( 8 downto 0);
	signal sig_game_rom_adr_i	: std_logic_vector(15 downto 0);
	signal sig_ram_adr_r1			: std_logic_vector( 7 downto 0);
	signal sig_ram_adr_r2			: std_logic_vector( 7 downto 0);
	signal sig_lbl_h_rom_adr_i	: std_logic_vector( 9 downto 0);
	signal sig_ram_dat_i			: std_logic_vector( 5 downto 0);
	signal sig_ram_adr_w			: std_logic_vector( 7 downto 0);
	signal sig_ram_we					: std_logic := '0';
	
	-- from: Numbers ROM
	signal sig_img_rom_dat_i	: std_logic_vector(31 downto 0);
	
	-- from: Timer ROM
	signal sig_tmr_rom_dat_i	: std_logic_vector(23 downto 0);
	
	-- from: Label ROM
	signal sig_lbl_rom_dat_i	: std_logic_vector(127 downto 0);
	
	-- from: Headerlabel ROM
	signal sig_lbl_h_rom_dat_i	: std_logic_vector(255 downto 0);
	
	-- from: Games ROM
	signal sig_game_rom_dat_i	: std_logic_vector(7 downto 0);
	
	-- from: RAM
	signal sig_ram_dat_to_ccu1	: std_logic_vector(5 downto 0);
	signal sig_ram_dat_to_ccu2	: std_logic_vector(5 downto 0);
	
begin
	-- Reset-Synchronizer
	rst_syn : entity work.rst_synchronizer
		port map(
			clk				=> clk,
			rst_a				=> rst_a,
			rst				=> rst
		);
	
	-- PS2-Controller
	ps2_ctr : entity work.ps2_controller
		port map(
			clk				=> clk,
			ps2_clk_i		=> ps2_clk,
			ps2_dat_i		=> ps2_dat,
			ps2_dat_o		=> sig_ps2_dat_o,
			ps2_dat_en		=> sig_ps2_dat_en
		);
		
	-- Switches-Controller
	sw_ctr : entity work.switches_controller
		port map(
			clk				=> clk,
			sw_dat_i			=> sw_dat,
			sw_dat_en		=> sig_sw_dat_en,
			sw_dat_o			=> sig_sw_dat_o
		);
		
	-- VGA-Controller
	vga_ctr : entity work.vga_controller
		port map(
			clk				=> clk,
			rst				=> rst,
			vga_dat_i		=> sig_vga_dat_o,
			vga_pos_x		=> sig_vga_pos_x,
			vga_pos_y		=> sig_vga_pos_y,
			vga_red_o		=> vga_red_d,
			vga_gre_o 		=> vga_gre_d,
			vga_blu_o  		=> vga_blu_d,
			vga_h_syn 		=> vga_h_syn_d,
			vga_v_syn 		=> vga_v_syn_d
		);	
	
	-- Seg-Controller
	seg_ctr : entity work.seg_controller
		port map(
			clk				=> clk,
			rst				=> rst,
			seg_dat_i		=> sig_seg_dat_o,
			seg_hex0_o 		=>	seg_hex0_d,
			seg_hex1_o		=>	seg_hex1_d,
			seg_hex2_o		=>	seg_hex2_d,
			seg_hex3_o		=>	seg_hex3_d
		);
		
	-- CCU-Top
	ccu_top : entity work.ccu_top
		port map(
			clk					=> clk,
			rst					=> rst,
			ps2_dat_en			=> sig_ps2_dat_en,
			ps2_dat_i			=> sig_ps2_dat_o,
			sw_dat_en			=> sig_sw_dat_en,
			sw_dat_i				=> sig_sw_dat_o,
			vga_pos_x			=> sig_vga_pos_x,
			vga_pos_y			=> sig_vga_pos_y,
			led_mde_o			=> led_mde_o,
			seg_dat_o			=> sig_seg_dat_o,
			vga_dat_o			=> sig_vga_dat_o,
			img_rom_dat_i		=> sig_img_rom_dat_i,
			img_rom_adr_o		=> sig_img_rom_adr_i,
			tmr_rom_dat_i		=> sig_tmr_rom_dat_i,
			tmr_rom_adr_o		=> sig_tmr_rom_adr_i,
			lbl_rom_dat_i		=> sig_lbl_rom_dat_i,
			lbl_rom_adr_o		=> sig_lbl_rom_adr_i,
			lbl_h_rom_dat_i	=> sig_lbl_h_rom_dat_i,
			lbl_h_rom_adr_o	=> sig_lbl_h_rom_adr_i,
			game_rom_dat_i		=> sig_game_rom_dat_i,
			game_rom_adr_o		=> sig_game_rom_adr_i,
			ram_dat_i1			=> sig_ram_dat_to_ccu1,
			ram_dat_i2			=> sig_ram_dat_to_ccu2,
			ram_dat_o			=> sig_ram_dat_i,
			ram_adr_r1			=> sig_ram_adr_r1,
			ram_adr_r2			=> sig_ram_adr_r2,
			ram_adr_w			=> sig_ram_adr_w,
			ram_we				=> sig_ram_we,
			led_solved			=> led_solved
		);
		
	-- RAM-Game
	ram_game : entity work.ram_game
		port map(
			clk				=> clk,
			ram_adr_r1		=> sig_ram_adr_r1,
			ram_adr_r2		=> sig_ram_adr_r2,
			ram_adr_w		=> sig_ram_adr_w,
			ram_dat_i		=> sig_ram_dat_i,
			ram_we			=> sig_ram_we,
			ram_dat_o1		=> sig_ram_dat_to_ccu1,
			ram_dat_o2		=> sig_ram_dat_to_ccu2
		);
		
	-- ROM-Numbers
	rom_num : entity work.rom_mem
		port map(
			rom_adr_i		=> sig_img_rom_adr_i,
			rom_dat_o		=> sig_img_rom_dat_i
		);
	
	-- ROM-Timer
	rom_tmr : entity work.rom_tmr
		port map(
			rom_adr_i		=> sig_tmr_rom_adr_i,
			rom_dat_o		=> sig_tmr_rom_dat_i
		);
		
	-- ROM-Labels
	rom_lbl : entity work.rom_lbl
		port map(
			rom_adr_i		=> sig_lbl_rom_adr_i,
			rom_dat_o		=> sig_lbl_rom_dat_i
		);
	
	-- ROM-Header-Labels
	rom_lbl_head : entity work.rom_lbl_header
		port map(
			rom_adr_i		=> sig_lbl_h_rom_adr_i,
			rom_dat_o		=> sig_lbl_h_rom_dat_i
		);
	
	-- ROM-Games
	rom_games : entity work.rom
		port map (
			clock				=> clk,
			address_a		=> sig_game_rom_adr_i,
			address_b		=> x"0000",
			q_a 				=> sig_game_rom_dat_i,
			q_b				=> open
		);
	
end rtl; 
