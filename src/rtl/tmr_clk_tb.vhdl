library ieee;
use ieee.std_logic_1164.all;


entity tmr_clk_tb is
end tmr_clk_tb;

architecture sim of tmr_clk_tb is

	signal clk 			: std_logic := '1';
	signal rst 			: std_logic := '1';

	signal tmr_rst		: std_logic := '0';
	signal tmr_en		: std_logic := '0';
	signal tme_out		: std_logic_vector(14 downto 0);
	
	signal STOPPED 	: boolean := false;

begin
	
	uut : entity work.tmr_clk
	port map (
		clk 			=> clk,
		rst 			=> rst,
		tmr_rst		=> tmr_rst,
		tmr_en		=> tmr_en,
		tme_out		=> tme_out
	);
	
	-- clock generation
  clk <= not clk after 5 ns when not STOPPED;

	stimuli : process
	begin
		wait until rising_edge(clk);
		rst <= '0';
		wait until rising_edge(clk);

		tmr_rst 	<= '1';
		wait until rising_edge(clk);
		
		tmr_rst 	<= '0';
		tmr_en 	<= '1';
		wait until rising_edge(clk);
		
		wait for 5000 ms;
		
		STOPPED <= true;
		wait;

	end process;
end sim;