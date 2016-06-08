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
	filled 	: out std_logic;
	correct 	: out std_logic;
	
	-- RAM Connection
	ram_adr_o	: out std_logic_vector(7 downto 0);
	ram_dat_i	: in std_logic_vector(5 downto 0)
);
end solution_checker;

architecture rtl of solution_checker is

	-- functions
	
	function to_index(slv : UNSIGNED; max : NATURAL := 0) return INTEGER is
		variable res : integer;
	begin
		if (slv'length = 0) then	return 0;	end if;

		res := to_integer(slv);
		return  res;
	end function;
	
	function to_index(slv : STD_LOGIC_VECTOR; max : NATURAL := 0) return INTEGER is
	begin
		return to_index(unsigned(slv), max);
	end function;
	
	function bin2onehot(Value : std_logic_vector) return std_logic_vector is
		variable result		: std_logic_vector(2**Value'length - 1 downto 0);
	begin
		result	:= (others => '0');
		result(to_index(Value, 0)) := '1';
		return result;
	end function;
	
	function xy_to_int(x, y: integer) return integer is
		variable result : integer := -1;
	begin
		
		case y is
			when 0 to 2 =>
				case x is
					when 0 to 2 => result := 0;
					when 3 to 5 => result := 1;
					when 6 to 8 => result := 2;
					when others => null;
				end case;
				
			when 3 to 5 =>
				case x is
					when 0 to 2 => result := 3;
					when 3 to 5 => result := 4;
					when 6 to 8 => result := 5;
					when others => null;
				end case;
			
			when 6 to 8 =>
				case x is
					when 0 to 2 => result := 6;
					when 3 to 5 => result := 7;
					when 6 to 8 => result := 8;
					when others => null;
				end case;
			when others =>
				null;
		end case;
		
		return result;
		
	end function;

	-- State
	type T_STATE is (IDLE, READ_RAM, CHECK, FINAL_CHECK, SOLVED, NOT_SOLVED);
	signal state_cur 	: T_STATE := IDLE;
	signal state_nxt	: T_STATE;
	
	-- Counters
	signal x			: unsigned(3 downto 0) := (others => '0');
	signal y			: unsigned(3 downto 0) := (others => '0');
	signal x_nxt	: unsigned(3 downto 0);
	signal y_nxt 	: unsigned(3 downto 0);
	
	type T_ONEHOT_NUMBERS_VECTOR is array (0 to 8) of std_logic_vector(8 downto 0);
	
	signal row_digits				: T_ONEHOT_NUMBERS_VECTOR	:= (others => (others => '0'));
	signal row_digits_nxt		: T_ONEHOT_NUMBERS_VECTOR;
	
	signal col_digits				: T_ONEHOT_NUMBERS_VECTOR	:= (others => (others => '0'));
	signal col_digits_nxt 		: T_ONEHOT_NUMBERS_VECTOR;
	
	signal square_digits			: T_ONEHOT_NUMBERS_VECTOR	:= (others => (others => '0'));
	signal square_digits_nxt	: T_ONEHOT_NUMBERS_VECTOR;
	
	signal filled_reg				: std_logic := '0';
	signal filled_nxt				: std_logic;

begin

	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				state_cur 		<= IDLE;
				filled_reg		<= '0';
				row_digits		<= (others => (others => '0'));
				col_digits		<= (others => (others => '0'));
				square_digits	<= (others => (others => '0'));
			else
				state_cur		<= state_nxt;
				filled_reg		<= filled_nxt;
				x					<= x_nxt;
				y					<= y_nxt;
				row_digits		<= row_digits_nxt;
				col_digits		<= col_digits_nxt;
				square_digits	<= square_digits_nxt;
			end if;
		end if;
	end process;
	
	process(state_cur, ram_dat_i, start, x , y, row_digits, col_digits, square_digits, filled_reg)
		variable y_int 			: integer := to_integer(y);
		variable x_int 			: integer := to_integer(x);
		variable number_missing : boolean := false;
	begin
		state_nxt 			<= state_cur;
		filled_nxt			<= filled_reg;
		row_digits_nxt		<= row_digits;
		col_digits_nxt		<= col_digits;
		square_digits_nxt	<= square_digits;
		x_nxt					<= x;
		y_nxt					<= y;
		done					<= '0';
		correct				<= '0';
		
		ram_adr_o 			<= (others => '0');
		
		number_missing 	:= false;
	
		case state_cur is
			when IDLE =>
				
				if start = '1' then
					state_nxt			<= READ_RAM;
					filled_nxt			<= '0';
					x_nxt 				<= to_unsigned(0, x_nxt'length);
					y_nxt 				<= to_unsigned(0, x_nxt'length);
					row_digits_nxt		<= (others => (others => '0'));
					col_digits_nxt		<= (others => (others => '0'));
					square_digits_nxt	<= (others => (others => '0'));
				end if;
				
			when READ_RAM =>
				ram_adr_o <= std_logic_vector(y) & std_logic_vector(x);
				
				state_nxt <= CHECK;
				
			when CHECK =>
				state_nxt <= READ_RAM;
			
				if ram_dat_i(3 downto 0) = "0000" then
					-- Empty Field detected
					state_nxt <= NOT_SOLVED;
				else
				
					y_int := to_integer(y);
					x_int := to_integer(x);
				
					row_digits_nxt(y_int)							<= row_digits(y_int) or bin2onehot(ram_dat_i(3 downto 0))(9 downto 1);
					col_digits_nxt(x_int) 							<= row_digits(x_int) or bin2onehot(ram_dat_i(3 downto 0))(9 downto 1);
					square_digits_nxt(xy_to_int(x_int,y_int)) <= square_digits(xy_to_int(x_int,y_int)) or bin2onehot(ram_dat_i(3 downto 0))(9 downto 1);
				
					-- Increase Counters (row, column)
					if x = to_unsigned(8, x'length) then
						if y = to_unsigned(8, y'length) then
							state_nxt <= FINAL_CHECK;
						else 
							x_nxt <= to_unsigned(0, x_nxt'length);
							y_nxt <= y + 1;
						end if;
					else 
						x_nxt <= x + 1;
					end if;
				end if;
				
				ram_adr_o <= std_logic_vector(y) & std_logic_vector(x);
				
			when FINAL_CHECK =>
			
				if row_digits /= (row_digits'range => (row_digits(0)'range => '1')) then
					number_missing := true;
				elsif col_digits /= (col_digits'range => (col_digits(0)'range => '1')) then
					number_missing := true;
				elsif square_digits /= (square_digits'range => (square_digits(0)'range => '1')) then
					number_missing := true;
				end if;
				
				filled_nxt 	<= '1';
				
				if number_missing = true then
					state_nxt <= NOT_SOLVED;
				else
					state_nxt <= SOLVED;
				end if;
				
			when SOLVED =>
				done 			<= '1';
				correct		<= '1';
				
				state_nxt <= IDLE;
			
			when NOT_SOLVED =>
				done			<= '1';
				correct		<= '0';
				
				state_nxt <= IDLE;
			
			when others =>
				null;
			
		end case;
	end process;
	
	filled <= filled_reg;
	
end rtl;