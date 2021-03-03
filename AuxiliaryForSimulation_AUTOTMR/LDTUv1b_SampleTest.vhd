-- File>>> LDTUv1b_SampleTest.vhd
--
-- Date: Mon Feb 22 13:27:23 CET 2021
-- Author: gianni
--
-- Code to count the number of errors in a 6 bits sample
--
-- Revision history:
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;  -- I/O for logic types

library std;
use std.textio.all;                             -- Basic I/O

entity LDTUv1b_SampleTeste is
	port (
		--reset 		: in std_logic;
		--clock 		: in std_logic;
		data_in 		: in std_logic_vector(5 downto 0);
		data_errors 	: out std_logic_vector(2 downto 0));

end LDTUv1b_SampleTeste;

architecture rtl of LDTUv1b_SampleTeste is

	signal err0 : std_logic_vector(1 downto 0);
	signal err1 : std_logic_vector(1 downto 0);

begin

	process (data_in(2 downto 0)) begin
		case data_in(2 downto 0) is
			when "000" => err0 <= "00";
			when "001" | "010" | "100" =>
				err0 <= "01";
			when "011" | "110" | "101" =>
				err0 <= "10";
			when "111" =>
				err0 <= "11";
			when others => err0 <= "00";
		end case;
	end process;

	process (data_in(5 downto 3)) begin
		case data_in(5 downto 3) is
			when "000" => err1 <= "00";
			when "001" | "010" | "100" =>
				err1 <= "01";
			when "011" | "110" | "101" =>
				err1 <= "10";
			when "111" =>
				err1 <= "11";
			when others => err1 <= "00";
		end case;
	end process;

	data_errors <= err0 + err1;

end rtl;

