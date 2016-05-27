LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity ps2_dat_decoder_tb is
end ps2_dat_decoder_tb;

architecture sim of ps2_dat_decoder_tb is

	signal clk : std_logic := '0';
	signal rst : std_logic := '0';

	constant PERIOD : time := 20 ns;

	signal ps2_dat_en : std_logic := '0';
	signal ps2_dat_i	: std_logic_vector(7 downto 0) := (others => '0');

begin

	clk <= not clk after PERIOD/2;

	stimuli : process
	begin 

		wait until rising_edge(clk);
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		ps2_dat_i 	<= x"6b";
		ps2_dat_en 	<= '1';

		wait until rising_edge(clk);

		ps2_dat_en <= '0';

		wait until rising_edge(clk);

		ps2_dat_en 	<= '1';
		ps2_dat_i 	<= x"5a";

		wait until rising_edge(clk);

		ps2_dat_i		<= x"6b";

		wait until rising_edge(clk);

		ps2_dat_en <= '0';

		wait until rising_edge(clk);

		ps2_dat_en <= '1';
		ps2_dat_i <= x"f0";
		
		wait until rising_edge(clk);
		ps2_dat_en <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		ps2_dat_en	<= '1';
		ps2_dat_i <= x"72";

		wait until rising_edge(clk);

		ps2_dat_en <= '0';
		
		wait until rising_edge(clk);
		
		ps2_dat_en	<= '1';
		ps2_dat_i <= x"72";

		wait until rising_edge(clk);
		
		ps2_dat_en <= '1';
		ps2_dat_i <= x"f0";
		
		wait until rising_edge(clk);
		
		ps2_dat_en <= '0';
		
		wait until rising_edge(clk);
		
		ps2_dat_en <= '1';
		ps2_dat_i <= x"e0";
		
		wait until rising_edge(clk);
		
		ps2_dat_en <= '0';

		wait until rising_edge(clk);
		
		ps2_dat_en <= '1';
		ps2_dat_i <= x"5a";
		
		wait until rising_edge(clk);
		
		ps2_dat_en <= '0';
		
		wait until rising_edge(clk);
		
		ps2_dat_en <= '1';
		ps2_dat_i <= x"e0";
		
		wait until rising_edge(clk);
		
		ps2_dat_en <= '0';
		
		wait until rising_edge(clk);
		
		ps2_dat_en <= '1';
		ps2_dat_i <= x"5a";
		
		wait until rising_edge(clk);
		
		ps2_dat_en <= '0';
		
		wait; -- forever

	end process;

	uut : entity work.ps2_dat_decoder
	port map (
		clk 			=> clk,
		rst 			=> rst,
		ps2_dat_i 	=> ps2_dat_i,
		ps2_dat_en 	=> ps2_dat_en,
		instr_o 		=> open,
		led_mde 		=> open,
		seg_dat_o 	=> open
	);

end sim;