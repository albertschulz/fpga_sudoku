------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	solution_checker
-- Date:		26.05.2016
-- Description:
-- 	Checks for correct solution
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity solution_checker is
port 
(
	clk		: in std_logic;
	rst		: in std_logic;
	start		: in std_logic;
	done		: out std_logic;
	correct 	: out std_logic;
	
	-- RAM Connection
	ram_adr_o	: out std_logic_vector(7 downto 0);
	ram_dat_i	: in std_logic_vector(5 downto 0)
);
end solution_checker;

architecture rtl of solution_checker is

	-- State
	type T_STATE is (IDLE, READ_RAM, CHECK, SOLVED, NOT_SOLVED);
	signal state_cur 	: T_STATE := IDLE;
	signal state_nxt	: T_STATE;
	
	-- Counters
	signal x	: unsigned(3 downto 0) := (others => '0');
	signal y	: unsigned(3 downto 0) := (others => '0');
	signal x_nxt : unsigned(3 downto 0);
	signal y_nxt : unsigned(3 downto 0);

begin

	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				state_cur 	<= IDLE;
			else
				state_cur	<= state_nxt;
				x				<= x_nxt;
				y				<= y_nxt;
			end if;
		end if;
	end process;
	
	process(state_cur, ram_dat_i, start, x , y)
		alias ram_number_i : unsigned(3 downto 0) is unsigned(ram_dat_i(3 downto 0));
	begin
	
		state_nxt 	<= state_cur;
		x_nxt			<= x;
		y_nxt			<= y;
		
		done			<= '0';
		correct		<= '0';
		ram_adr_o	<= (others => '0');
	
		case state_cur is
			
			when IDLE =>
			
				if start = '1' then
					state_nxt	<= READ_RAM;
					x_nxt <= to_unsigned(0, x_nxt'length);
					y_nxt <= to_unsigned(0, x_nxt'length);
				end if;
				
			when READ_RAM =>
			
				ram_adr_o <= std_logic_vector(y) & std_logic_vector(x);
				
				state_nxt <= CHECK;
				
			when CHECK =>
			
				state_nxt <= READ_RAM;
			
				if ram_number_i = to_unsigned(0, ram_number_i'length) then
					-- Empty Field detected
					state_nxt <= NOT_SOLVED;
				else
				
					-- Increase Counters (row, column)
					if x = to_unsigned(8, x'length) then
					
						if y = to_unsigned(8, y'length) then
							state_nxt <= SOLVED;
						else 
							x_nxt <= to_unsigned(0, x_nxt'length);
							y_nxt <= y+1;
						end if;
						
					else 
						x_nxt <= x+1;
					end if;
				
				end if;
			
			when SOLVED =>
				done 		<= '1';
				correct	<= '1';
				
				state_nxt <= IDLE;
			
			when NOT_SOLVED =>
				done		<= '1';
				correct	<= '0';
				
				state_nxt <= IDLE;
			
			when others =>
				null;
			
		end case;
	
	end process;

end rtl;