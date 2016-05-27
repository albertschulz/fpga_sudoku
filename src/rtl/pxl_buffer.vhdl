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
		clk			: in	std_logic;
		vga_pos_x	: in  integer range 0 to 640;
		vga_pos_y	: in  integer range 0 to 480;
		vga_dat_o	: out	std_logic_vector(2 downto 0);
		rom_dat_i	: in	std_logic_vector(31 downto 0);
		rom_adr_o	: out std_logic_vector(8 downto 0);
		ram_dat_i	: in	std_logic_vector(5 downto 0);
		ram_adr_r	: out	std_logic_vector(7 downto 0)
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
	
	type buf_lne_t is array(0 to 315) of std_logic_vector(2 downto 0);
	signal buf_lne_cur	: buf_lne_t := (others => (others => '0'));
	signal buf_lne_nxt	: buf_lne_t := (others => (others => '0'));
	
	signal pos_x_cur		: integer range 0 to PXL_DSP_H := 0;
	signal pos_y_cur		: integer range 0 to PXL_DSP_V := 0;
	signal pos_y_nxt		: integer range 0 to PXL_DSP_V := 0;
	signal pos_y_off		: integer range 0 to PXL_DSP_V := 0;
	
	signal cnt_x			: unsigned(3 downto 0) := (others => '0');
	signal cnt_y			: unsigned(3 downto 0) := (others => '0');
	
	signal buf_start		: std_logic_vector(1 downto 0) := (others => '0');
	signal buf_cmt			: std_logic := '0';
	
begin	
	-- buffer new line
	process(clk)
		variable tmp_rom 		: std_logic_vector(31 downto 0);
		variable tmp_ram 		: std_logic_vector(5 downto 0);
		variable pos_x_off 	: integer := 0;
	begin
		if rising_edge(clk) then
					
			if(pos_x_cur = PXL_DSP_H and buf_cmt = '0') then	-- commit new buffer line
				buf_lne_cur	<= buf_lne_nxt;
				buf_cmt		<= '1';
			end if;
			
			if(pos_x_cur = 0 and pos_y_cur < PXL_DSP_V) then	-- ready for new commit
				buf_cmt	<= '0';
			end if;
		
			if(buf_start = "01") then			-- horizontal lines
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
					
				elsif(cnt_x = "0001") then
					tmp_ram		:= ram_dat_i;
					rom_adr_o	<= tmp_ram(3 downto 0) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_off), 5));
					ram_adr_r	<= std_logic_vector(cnt_y - 1) & std_logic_vector(cnt_x);
					
				elsif(cnt_x = "1001") then
					-- take data from ROM
					tmp_rom := rom_dat_i;
					
					-- fill buffer line
					for i in 0 to 31 loop
						buf_lne_nxt(i + 246) <= tmp_ram(5 downto 4) & tmp_rom(31 - i);
					end loop;
					
					-- take data from RAM
					tmp_ram := ram_dat_i;
					
					-- calc new addresses
					rom_adr_o <= tmp_ram(3 downto 0) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_off), 5));
					
				
				elsif(cnt_x = "1010") then
					-- take data from ROM
					tmp_rom := rom_dat_i;
					
					-- fill buffer line
					for i in 0 to 31 loop
						buf_lne_nxt(i + 280) <= tmp_ram(5 downto 4) & tmp_rom(31 - i);
					end loop;
					
				else
					-- take data from ROM
					tmp_rom := rom_dat_i;
					
					-- calc offset
					case (to_integer(cnt_x) - 2) is
						when 0 to 2 => pos_x_off := ((to_integer(cnt_x - 2) * 34) + 4);
						when 3 to 5 => pos_x_off := ((to_integer(cnt_x - 2) * 34) + 6);
						when 6 		=> pos_x_off := ((to_integer(cnt_x - 2) * 34) + 8);
						when others => pos_x_off := 0;
					end case;
					
					-- fill buffer line
					for i in 0 to 31 loop
						buf_lne_nxt(i + pos_x_off) <= tmp_ram(5 downto 4) & tmp_rom(31 - i);
					end loop;
					
					-- take data from RAM
					tmp_ram		:= ram_dat_i;
					
					-- calc new addresses
					rom_adr_o	<= tmp_ram(3 downto 0) & std_logic_vector(to_unsigned((pos_y_nxt - pos_y_off), 5));
					ram_adr_r	<= std_logic_vector(cnt_y - 1) & std_logic_vector(cnt_x);
					
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
	
	-- calc y-position of field, y-offset and select buffering method
	process(pos_y_nxt)
	begin
		cnt_y 		<= "0000";
		buf_start	<= "00";
		pos_y_off	<= 0;
		
		if((pos_y_nxt >  81 and pos_y_nxt <  86) or (pos_y_nxt > 117 and pos_y_nxt < 120) or (pos_y_nxt > 151 and pos_y_nxt < 154) or 
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
			buf_start	<= "10";
			pos_y_off	<= 120;
		elsif(pos_y_nxt > 153 and pos_y_nxt < 186) then
			cnt_y 		<= "0011";
			buf_start	<= "10";
			pos_y_off	<= 154;
		elsif(pos_y_nxt > 189 and pos_y_nxt < 222) then
			cnt_y 		<= "0100";
			buf_start	<= "10";
			pos_y_off	<= 190;
		elsif(pos_y_nxt > 223 and pos_y_nxt < 256) then
			cnt_y 		<= "0101";
			buf_start	<= "10";
			pos_y_off	<= 224;
		elsif(pos_y_nxt > 257 and pos_y_nxt < 290) then
			cnt_y 		<= "0110";
			buf_start	<= "10";
			pos_y_off	<= 258;
		elsif(pos_y_nxt > 293 and pos_y_nxt < 326) then
			cnt_y 		<= "0111";
			buf_start	<= "10";
			pos_y_off	<= 294;
		elsif(pos_y_nxt > 327 and pos_y_nxt < 360) then
			cnt_y 		<= "1000";
			buf_start	<= "10";
			pos_y_off	<= 328;
		elsif(pos_y_nxt > 361 and pos_y_nxt < 394) then
			cnt_y 		<= "1001";
			buf_start	<= "10";
			pos_y_off	<= 362;
		end if;
	end process;
	
	-- 
	process(vga_pos_x, vga_pos_y, buf_lne_cur)
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
		
		-- note: this is the same as an assignment outside of this process
		pos_x_cur	<= vga_pos_x;
		pos_y_cur	<= vga_pos_y;
		
		-- output pixel-data to vga-controller
		if(vga_pos_x < PXL_DSP_H and vga_pos_y < PXL_DSP_V) then
			if((vga_pos_x > PXL_SEP_X - 1) and (vga_pos_x < PXL_SEP_X + PXL_SEP_WDT)) then	-- separation line
				vga_dat_o <= "001";
			else
				if(((vga_pos_x > PXL_OFF_FRM - 1) and (vga_pos_x < PXL_OFF_FRM + PXL_FLD_SZE)) and ((vga_pos_y > PXL_OFF_FRM - 1) and (vga_pos_y < PXL_OFF_FRM + PXL_FLD_SZE))) then	-- sudoku field
					vga_dat_o <= buf_lne_cur(vga_pos_x - PXL_OFF_FRM);
				else
					vga_dat_o <= "000";
				end if;
			end if;
		else
			vga_dat_o <= "000";
		end if;
	end process;
end rtl;