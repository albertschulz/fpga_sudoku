library ieee;
use ieee.std_logic_1164.all;
use work.const_package.all;


entity game_controller_tb is
end game_controller_tb;

architecture sim of game_controller_tb is

	signal clk 			: std_logic := '1';
	signal rst 			: std_logic := '1';

	signal instr_i		: std_logic_vector(3 downto 0);
	signal ram_dat_i	: std_logic_vector(5 downto 0);
	signal ram_adr_r	: std_logic_vector(7 downto 0);
	signal ram_adr_w	: std_logic_vector(7 downto 0);
	signal ram_dat_o	: std_logic_vector(5 downto 0);
	signal ram_we		: std_logic;
	
	signal STOPPED 	: boolean := false;

begin
	
	uut : entity work.game_controller
	port map (
		clk 			=> clk,
		rst 			=> rst,
		instr_i		=> instr_i,
		ram_dat_i	=> ram_dat_i,
		ram_adr_r	=> ram_adr_r,
		ram_adr_w	=> ram_adr_w,
		ram_dat_o	=> ram_dat_o,
		ram_we		=> ram_we
	);
	
	-- clock generation
  clk <= not clk after 5 ns when not STOPPED;

	stimuli : process
	begin
		wait until rising_edge(clk);
		rst <= '0';
		wait until rising_edge(clk);

		instr_i 	<= CMD_NOP;
		wait until rising_edge(clk);

		instr_i 	<= CMD_1;
		wait until rising_edge(clk);
		
		instr_i 	<= CMD_NOP;
		wait until rising_edge(clk);
		
		instr_i 	<= CMD_NOP;
		ram_dat_i 	<= "100010";
		wait until rising_edge(clk);
		ram_dat_i 	<= "000000";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		instr_i 	<= CMD_RGT;
		wait until rising_edge(clk);
		
		instr_i 	<= CMD_NOP;
		wait until rising_edge(clk);
		
		ram_dat_i 	<= "100010";
		wait until rising_edge(clk);
		
		ram_dat_i 	<= "000011";
		wait until rising_edge(clk);
		
		ram_dat_i 	<= "000000";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		
    STOPPED <= true;
    wait;	-- wait for ever

	end process;
end sim;