library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
		
		wait until rising_edge(clk) and done = '1';
		wait until rising_edge(clk);
		
		STOPPED <= true;
		wait;	-- wait for ever

	end process;

	ram : process
		variable cnt : integer := 1;
	begin
		
		wait until ram_adr_o'event;
		
		ram_dat_i <= std_logic_vector(to_unsigned(cnt, 6));
		
		if ram_adr_o = "00110011" then
			ram_dat_i <= std_logic_vector(to_unsigned(4, 6));
		end if;
		
		cnt := cnt + 1;
		
		if cnt > 9 then
			cnt := 1;
		end if;
	
	end process;
	
end sim;