library ieee;
use ieee.std_logic_1164.all;


entity game_loader_tb is
end game_loader_tb;

architecture sim of game_loader_tb is

	signal clk 				: std_logic := '1';
	signal rst 				: std_logic := '1';
	
	signal done				: std_logic;
	signal rom_addr_out 	: std_logic_vector(10 downto 0);
	signal rom_data_in 	: std_logic_vector(3 downto 0);
	signal ram_addr_out	: std_logic_vector(7 downto 0);
	signal ram_data_out	: std_logic_vector(5 downto 0);
	signal ram_write_en	: std_logic;
	
	signal STOPPED 	: boolean := false;

begin
	
	uut : entity work.game_loader
	port map (
		clk 				=> clk,
		rst 				=> rst,
		done				=> done,
		rom_addr_out	=> rom_addr_out,
		rom_data_in		=> rom_data_in,
		ram_addr_out	=> ram_addr_out,
		ram_data_out	=> ram_data_out,
		ram_write_en	=> ram_write_en
	);
	
	-- clock generation
  clk <= not clk after 5 ns when not STOPPED;

	stimuli : process
	begin
		wait until rising_edge(clk);
		rst <= '0';
		
		rom_data_in  <= x"1";
		
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