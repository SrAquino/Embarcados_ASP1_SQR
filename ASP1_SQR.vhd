library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ASP1_SQR is
	port (
		x 	: in std_logic_vector(31 downto 0);
		
		mux_select : in std_logic;
		
		enb_rd : in std_logic;
		enb_s : in std_logic;
		
		clock : in std_logic;
		reset : in std_logic;
		
		t_out : out std_logic;
		
		r_out : out std_logic_vector(31 downto 0));
end ASP1_SQR;

architecture behavior of ASP1_SQR is

component mux2x1 is port (
		in1	: in std_logic_vector(95 downto 0);
		in2	: in std_logic_vector(95 downto 0);
		sel	: in std_logic;
		
		Z : out std_logic_vector(95 downto 0));
end component;

signal 	ini_rds : std_logic_vector(95 downto 0);
signal 	fim_rds : std_logic_vector(95 downto 0);

signal 	saida_mux 	: std_logic_vector(95 downto 0);

signal r	:  std_logic_vector(31 downto 0):="00000000000000000000000000000001";
signal d	:  std_logic_vector(31 downto 0):="00000000000000000000000000000010";
signal s	:  std_logic_vector(31 downto 0):="00000000000000000000000000000100";
		
signal 	r_sig	: std_logic_vector(31 downto 0);
signal	d_sig	: std_logic_vector(31 downto 0);
signal	s_sig	: std_logic_vector(31 downto 0);
signal 	t	: std_logic_vector(31 downto 0);

signal reg_r : std_logic_vector(31 downto 0);
signal reg_d : std_logic_vector(31 downto 0);
signal reg_s : std_logic_vector(31 downto 0);
	
begin
	ini_rds <= r & d & s;
	
	mux: mux2x1 port map(
		in1	=> ini_rds,
		in2	=> fim_rds,
		sel	=> mux_select,
		
		Z => saida_mux);
	
		process(clock, reset)
		begin
			if(reset = '1') then
				reg_r <= (others => '0');
				reg_d <= (others => '0');
				reg_s <= (others => '0');
			
			elsif(clock = '1' and clock'event) then
				if(enb_rd = '1') then
					reg_r <= saida_mux(95 downto 64);
					reg_d <= saida_mux(63 downto 32);
				end if;
				
				if(enb_s = '1') then
					reg_s <= saida_mux(31 downto 0);
				end if;
			end if;
			
			if ( t(31 downto 31) = "1") then
				t_out <= '1';
			else
				t_out <= '0';
			end if;
			
		end process;
		
	r_sig <= reg_r + 1;
	d_sig <= reg_d + 3;
	s_sig <= reg_s + d_sig;
	
	t <= x - s_sig;
	
	r_out <= r_sig;
	
	fim_rds <= r_sig & d_sig & s_sig;
	
end behavior;
				
	
	