------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	vga_controller
-- Date:		25.04.2016
-- Description:
--		Controller for the VGA-Connector
-- 	
--		vga_dat_i - Data Format:
-- 	011 		dark grey
-- 	001 		black
-- 	100, 110 light grey
-- 	000, 010 white
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller is
	generic(
		-- resolution: 640 x 480 @ 60Hz 	-> pxl_clk = 25 MHz
		H_PUL			: integer   := 96;  	-- hor. sync pulse
		H_BP     	: integer   := 48;  	-- hor. back porch
		H_PXL			: integer   := 640; 	-- hor. display width
		H_FP     	: integer   := 16;  	-- hor. front porch
		H_POL    	: std_logic := '0';  -- hor. sync pulse polarity
		V_PUL			: integer   := 2;		-- ver. sync pulse
		V_BP     	: integer   := 33;   -- ver. back porch
		V_PXL 		: integer   := 480;	-- ver. display width
		V_FP     	: integer   := 10;   -- ver. front porch
		V_POL    	: std_logic := '0'	-- ver. sync pulse polarity
	);
	port(
		clk	      : in  std_logic;
		rst			: in  std_logic;
		vga_dat_i	: in	std_logic_vector(2 downto 0);
		vga_pos_x	: out	integer range 0 to H_PXL;
		vga_pos_y	: out	integer range 0 to V_PXL;
		vga_red_o	: out std_logic_vector(3 downto 0);
		vga_gre_o 	: out std_logic_vector(3 downto 0);
		vga_blu_o  	: out std_logic_vector(3 downto 0);
		vga_h_syn  	: out std_logic;
		vga_v_syn  	: out std_logic
	);
end vga_controller;

architecture rtl of vga_controller is

	constant H_SUM	: integer := H_PUL + H_BP + H_PXL + H_FP;	-- sum of pixel clocks in a row
	constant	V_SUM	: integer := V_PUL + V_BP + V_PXL + V_FP; -- sum of rows in a column
	
	signal h_pos	: integer range 0 to H_SUM := 0;				-- current hor. position
	signal v_pos	: integer range 0 to V_SUM := 0;				-- current ver. position
	signal vga_clk	: std_logic;										-- clock for the vga timing
	signal disp_en	: std_logic;										-- signal for when drawing is allowed
	
	signal bit_val : std_logic;										-- value for current bit, '1' if it is set
	signal is_fix	: std_logic;										-- '1' if the number is fixed
	signal is_act	: std_logic;										-- '1' if the current field is active

begin	
	-- VGA-Pixel-Clock-PLL
	vga_pll : entity work.vga_clock_pll
		port map(
			inclk0	=> clk,
			c0			=> vga_clk
		);

	-- VGA Controller
	process(vga_clk)
	begin
		if rising_edge(vga_clk) then
			if rst = '1' then
				vga_h_syn	<= not H_POL;
				vga_v_syn	<= not V_POL;
				disp_en		<= '0';
				h_pos 		<= 0;
				v_pos 		<= 0;
			else

				-- current position
				if(h_pos < H_SUM) then
					h_pos <= h_pos + 1;
				else
					h_pos	<= 0;
					if(v_pos < V_SUM) then
						v_pos <= v_pos + 1;
					else
						v_pos <= 0;
					end if;
				end if;
				
				-- horizontal sync signal
				if(h_pos < H_PXL + H_FP or h_pos > H_PXL + H_FP + H_PUL) then
					vga_h_syn <= not H_POL;
				else
					vga_h_syn <= H_POL;
				end if;

				-- vertical sync signal
				if(v_pos < V_PXL + V_FP or v_pos > V_PXL + V_FP + V_PUL) then
					vga_v_syn <= not V_POL;
				else
					vga_v_syn <= V_POL;
				end if;

				--set display enable
				if(h_pos < H_PXL and v_pos < V_PXL) then
					vga_pos_x	<= h_pos;
					vga_pos_y	<= v_pos;
					disp_en 		<= '1';
				else
					vga_pos_x	<= H_PXL;
					vga_pos_y	<= V_PXL;
					disp_en 		<= '0';
				end if;
				
			end if;
		end if;
	end process;
	
	-- Data to Monitor
	process(vga_clk)
	begin
		if rising_edge(vga_clk) then
			if rst = '1' then
				vga_red_o 	<= (others => '0');
				vga_gre_o	<= (others => '0');
				vga_blu_o 	<= (others => '0');
			else
				-- if display is enabled -> draw from incoming data
				if(disp_en = '1') then					-- display is enabled
					if(vga_dat_i(0) = '1') then
						if(vga_dat_i(1) = '1') then 	-- number is grey if fixed
							vga_red_o <= "0100";
							vga_gre_o <= "0100";
							vga_blu_o <= "0100";
						else									-- otherwise black
							vga_red_o <= "0000";
							vga_gre_o <= "0000";
							vga_blu_o <= "0000";
						end if;	
					else
						if(vga_dat_i(2) = '1') then 	-- background is light-grey if active
							vga_red_o <= "1100";
							vga_gre_o <= "1100";
							vga_blu_o <= "1100";
						else									-- otherwise white
							vga_red_o <= "1111";
							vga_gre_o <= "1111";
							vga_blu_o <= "1111";
						end if;
					end if;
				else											-- display is disabled
					vga_red_o <= "0000";
					vga_gre_o <= "0000";
					vga_blu_o <= "0000";
				end if;
			end if;
		end if;
	end process;
	
end rtl;