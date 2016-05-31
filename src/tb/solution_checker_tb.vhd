library ieee;
use ieee.std_logic_1164.all;


entity solution_checker_tb is
end solution_checker_tb;

architecture sim of solution_checker_tb is

	signal clk 				: std_logic := '0';
	signal rst 				: std_logic := '1';

	signal start			: std_logic;
	signal done				: std_logic;
	signal correct 		: std_logic;
	
	-- RAM Connection
	signal ram_adr_o		: std_logic_vector(7 downto 0);
	signal ram_dat_i		: std_logic_vector(5 downto 0);
	
	signal STOPPED 		: boolean := false;

begin
	
	uut : entity work.solution_checker
	port map (
		clk 				=> clk,
		rst 				=> rst,
		start				=> start,
		done				=> done,
		correct			=> correct,
		ram_adr_o		=> ram_adr_o,
		ram_dat_i		=> ram_dat_i
	);
	
	-- clock generation
  clk <= not clk after 5 ns when not STOPPED;

	stimuli : process
	begin
		wait until rising_edge(clk);
		rst <= '0';
		
		start <= '1';
		ram_dat_i <= "111111";
		
		wait until rising_edge(clk);

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
				wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
				wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
				wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
				wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
				wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
				wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		STOPPED <= true;
		wait;	-- wait for ever

	end process;
end sim;