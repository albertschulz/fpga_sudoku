------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	tmr_clk
-- Date:		25.05.2016
-- Description:
-- 	generates an 1 Hz clock based on the sys_clk_freq
------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity tmr_clk is
	generic(
		CLK_FREQ		: integer := 50_000_000
	);
	port(
		clk	      : in  std_logic;
		rst	      : in  std_logic;
		tmr_rst		: in 	std_logic;
		tmr_en		: in	std_logic;
		tme_out		: out std_logic_vector(14 downto 0)
	);	
end tmr_clk;

architecture rtl of tmr_clk is

	signal cnt 			: integer range 0 to ((CLK_FREQ / 2) - 1) := 0;
	signal min1			: unsigned(3 downto 0) := (others => '0');
	signal min0			: unsigned(3 downto 0) := (others => '0');
	signal sec1			: unsigned(2 downto 0) := (others => '0');
	signal sec0			: unsigned(3 downto 0) := (others => '0');
	
	signal clk_sig_1 	: std_logic := '0';
	signal clk_sig_2 	: std_logic := '0';
	
	signal tme_over	: std_logic := '0';
	
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if(rst = '1') then
				clk_sig_1	<= '0';
				clk_sig_2	<= '0';
				tme_over		<= '0';
				cnt 			<= 0;
				min1			<= (others => '0');
				min0			<= (others => '0');
				sec1			<= (others => '0');
				sec0			<= (others => '0');
			else
				if(cnt = ((CLK_FREQ / 2) - 1)) then
					clk_sig_1	<= not clk_sig_1;
					cnt 			<= 0;
				else
					clk_sig_2	<= clk_sig_1;
					cnt			<= cnt + 1;
				end if;
				
				if(tmr_rst = '1') then
					clk_sig_1	<= '0';
					clk_sig_2	<= '0';
					tme_over		<= '0';
					cnt 			<= 0;
					min1			<= (others => '0');
					min0			<= (others => '0');
					sec1			<= (others => '0');
					sec0			<= (others => '0');
				else
					if(tmr_en = '1' and tme_over = '0' and clk_sig_2 = '0' and clk_sig_1 = '1') then
						if(sec0 = "1001") then
							sec0	<= (others => '0');
							if(sec1 = "101") then
								sec1	<= (others => '0');
								if(min0 = "1001") then
									min0	<= (others => '0');
									if(min1 = "1001") then
										tme_over	<= '1';
										min0		<= "1001";
										sec1		<= "101";
										sec0		<= "1001";
									else
										min1 <= min1 + 1;
									end if;
								else
									min0 <= min0 + 1;
								end if;
							else
								sec1 <= sec1 + 1;
							end if;
						else
							sec0 <= sec0 + 1;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	tme_out <= std_logic_vector(min1) & std_logic_vector(min0) & std_logic_vector(sec1) & std_logic_vector(sec0);
	
end rtl;