------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	tmr_clk
-- Date:		25.05.2016
-- Description:
-- 	generates an 1 Hz clock
------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity tmr_clk is
	port(
		clk	      : in  std_logic;
		rst	      : in  std_logic;
		tmr_rst		: in 	std_logic;
		tmr_en		: in	std_logic;
		tme_out		: out std_logic_vector(12 downto 0)
	);	
end tmr_clk;

architecture rtl of tmr_clk is

	signal cnt 			: integer range 0 to 24_999_999 := 0;
	signal min			: unsigned(6 downto 0) := (others => '0');
	signal sec			: unsigned(5 downto 0) := (others => '0');
	
	signal clk_sig_1 	: std_logic := '0';
	signal clk_sig_2 	: std_logic := '0';
	
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if(rst = '1') then
				clk_sig_1	<= '0';
				clk_sig_2	<= '0';
				cnt 			<= 0;
				min			<= (others => '0');
				sec			<= (others => '0');
			else
				if(cnt = 24_999_999) then
					clk_sig_2	<= clk_sig_1;
					clk_sig_1	<= not clk_sig_1;
					cnt 			<= 0;
				else
					cnt			<= cnt + 1;
				end if;
				
				if(tmr_rst = '1') then
					min		<= (others => '0');
					sec		<= (others => '0');
				else
					if(tmr_en = '1' and clk_sig_1 = '0' and clk_sig_2 = '1') then
						if(sec = to_unsigned(59, sec'length)) then
							sec	<= (others => '0');
							
							if(min = to_unsigned(99, min'length)) then
								min <= (others => '0');
							else
								min <= min + 1;
							end if;
						else
							sec <= sec + 1;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	tme_out <= std_logic_vector(min) & std_logic_vector(sec);
	
end rtl;