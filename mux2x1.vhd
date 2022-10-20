library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity mux2x1 is
	port (
		in1	: in std_logic_vector(95 downto 0);
		in2	: in std_logic_vector(95 downto 0);
		sel	: in std_logic;
		
		Z : out std_logic_vector(95 downto 0));
end mux2x1;

architecture behavior of mux2x1 is
	begin
		Z <= in1 when sel = '0' else in2;
end behavior;