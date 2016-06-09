------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	btn_sync
-- Date:		27.04.2016
-- Description:
-- 	syncs and debounces a button signal
------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity btn_synchronizer is
	generic(
		DEB_INT		: integer := 149999
	);
	port(
		clk	      : in  std_logic;
		but_i			: in  std_logic;
		but_o			: out std_logic
	);	
end btn_synchronizer;

architecture rtl of btn_synchronizer is

	signal deb_cnt		: integer range 0 to DEB_INT := 0;
	signal pressed		: std_logic := '0';
	signal btn_meta	: std_logic := '0';
	signal btn_press	: std_logic;
	
begin
	process(clk)
	begin
		if rising_edge(clk) then
			btn_meta		<= not but_i;
			btn_press 	<= btn_meta;
			
			if(deb_cnt = DEB_INT) then
				deb_cnt 	<= 0;
				pressed 	<= '0';
			else
				if(pressed = '1') then
					if(btn_press = '1') then
						deb_cnt 	<= 0;
					else
						deb_cnt	<= deb_cnt + 1;
					end if;
				end if;
			end if;
			
			if(btn_meta = '1' and pressed = '0') then
				pressed	<= '1';
				but_o	<= '1';
			else
				but_o	<= '0';
			end if;
		end if;		
	end process;
end rtl;