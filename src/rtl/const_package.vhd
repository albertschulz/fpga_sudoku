------------------------------------------------
-- Project:	Sudoku - Game
------------------------------------------------
-- Entity:	const_package
-- Date:		29.04.2016
-- Description:
--		Package with some constants
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package const_package is
  
	-- constants	
	subtype CCU_CMD_TYPE is std_logic_vector(4 downto 0);
	constant CMD_DEL  : CCU_CMD_TYPE := "00000";
	constant CMD_1	  	: CCU_CMD_TYPE := "00001";
	constant CMD_2 	: CCU_CMD_TYPE := "00010";
	constant CMD_3  	: CCU_CMD_TYPE := "00011";
	constant CMD_4  	: CCU_CMD_TYPE := "00100";
	constant CMD_5   	: CCU_CMD_TYPE := "00101";
	constant CMD_6  	: CCU_CMD_TYPE := "00110";
	constant CMD_7  	: CCU_CMD_TYPE := "00111";
	constant CMD_8  	: CCU_CMD_TYPE := "01000";
	constant CMD_9 	: CCU_CMD_TYPE := "01001";
	constant CMD_UP	: CCU_CMD_TYPE := "01010";
	constant CMD_RGT	: CCU_CMD_TYPE := "01011";
	constant CMD_DWN	: CCU_CMD_TYPE := "01100";
	constant CMD_LFT	: CCU_CMD_TYPE := "01101";
	constant CMD_ENT	: CCU_CMD_TYPE := "01110";
	constant CMD_NOP	: CCU_CMD_TYPE := "01111";
	constant CMD_DIV	: CCU_CMD_TYPE := "10000";
	
end const_package;