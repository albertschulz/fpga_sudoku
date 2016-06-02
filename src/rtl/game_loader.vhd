------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	game_loader
-- Date:		24.05.2016
-- Description:
--		Game Loader: Loads a Game from ROM into RAM
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_loader is
	port
	(	
		-- Input ports
		clk				: in  std_logic;
		rst				: in  std_logic;
		load				: in 	std_logic;
		load_old			: in 	std_logic;
		game_diff		: in  std_logic_vector(1 downto 0);

		-- Output ports
		done				: out std_logic;
		
		-- ROM Connection
		rom_addr_out	: out std_logic_vector(10 downto 0);
		rom_data_in		: in  std_logic_vector( 3 downto 0);
		
		-- RAM Connection
		ram_addr_out	: out std_logic_vector(7 downto 0);
		ram_data_out	: out std_logic_vector(5 downto 0);
		ram_write_en	: out std_logic
	);
end game_loader;

architecture rtl of game_loader is

	type T_STATE is (IDLE, READ_ROM, WAIT_FOR_ROM, WRITE_RAM, LOADED);
	signal state 			: T_STATE := IDLE;
	signal cnt 				: unsigned(6 downto 0) := (others => '0');
	signal x					: unsigned(3 downto 0) := (others => '0');
	signal y					: unsigned(3 downto 0) := (others => '0');
	signal rnd_num			: unsigned(1 downto 0) := (others => '0');
	signal rnd_old			: unsigned(1 downto 0);
	signal game_diff_reg	: unsigned(1 downto 0);
	signal load_old_reg	: std_logic := '0';

begin
	game_diff_reg	<= unsigned(game_diff);
	
	-- generate random number
	process (clk)
	begin
		if rising_edge(clk) then
			if(rnd_num = "11") then
				rnd_num <= "00";
			else
				rnd_num <= rnd_num + 1;
			end if;
		end if;
	end process;
	
	-- load game
	process (clk)
		variable preset 	: std_logic;
		variable selected : std_logic;
		variable tmp_rnd	: unsigned(1 downto 0);
	begin
		if rising_edge(clk) then
			preset 			:= '1';
			selected 		:= '0';
			ram_write_en	<= '0';
			done				<= '0';
		
			if rst = '1' then
				cnt 				<= to_unsigned(0, cnt'length);
				x 					<= to_unsigned(0, x'length);
				y					<= to_unsigned(0, y'length);
				state 			<= IDLE;
				load_old_reg	<= '0';
			else
				if(load_old_reg = '0' and load_old = '1') then
					load_old_reg <= '1';
				end if;
			
				if state = IDLE then
					if load = '1' then
						state		<= READ_ROM;
						cnt 		<= to_unsigned(0, cnt'length);
						x			<= to_unsigned(0, x'length);
						y			<= to_unsigned(0, y'length);
						
						if(load_old_reg = '1') then
							tmp_rnd			:= rnd_old;
							load_old_reg	<= '0';
						else
							tmp_rnd	:= rnd_num;
							rnd_old	<= rnd_num;
						end if;
					end if;
					
				elsif state = READ_ROM then
					state		<= WAIT_FOR_ROM;
					
					rom_addr_out 	<= std_logic_vector(game_diff_reg - 1) & std_logic_vector(tmp_rnd) & std_logic_vector(cnt);
					
				elsif state = WAIT_FOR_ROM then
					state		<= WRITE_RAM;

				elsif state = WRITE_RAM then
					-- Mark center as selected
					if x = to_unsigned(4, x'length) and y = to_unsigned(4, y'length) then
						selected := '1';
					end if;
					
					if rom_data_in = "0000" then
						preset 	:= '0';
					end if;
					
					ram_data_out	<= selected & preset & rom_data_in;
					ram_addr_out	<= std_logic_vector(y) & std_logic_vector(x);
					ram_write_en	<= '1';
					
					if x = to_unsigned(8, x'length) then
						x <= to_unsigned(0, x'length);
						y <= y + 1;
					else
						x <= x + 1;
					end if;
					
					cnt <= cnt + 1;
					
					if cnt > 80 then
						state 	<= LOADED;
						done		<= '1';
					else 
						state 	<= READ_ROM;
					end if;
					
				elsif state = LOADED then
					state <= IDLE;
					done <= '1';
					
				end if;
			end if;
		end if;
	end process;
end rtl;
