library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SQR_FSM is
	port (
		x 	: in std_logic_vector(31 downto 0):="1001";
		
		r_out : out std_logic_vector(31 downto 0));
end SQR_FSM;

architecture behavior of SQR_FSM is

component ASP1_SQR is port (
		x 	: in std_logic_vector(31 downto 0);
		
		mux_select : in std_logic;
		
		enb_rd : in std_logic;
		enb_s : in std_logic;
		
		clock : in std_logic;
		reset : in std_logic;
		
		t_out : out std_logic;
		
		r_out : out std_logic_vector(31 downto 0));
end component;

signal clock : std_logic;
signal reset : std_logic;

signal estado_atual 	: std_logic_vector(1 downto 0):="00";
signal prox_estado 	: std_logic:='0'; 

signal mux_select : std_logic:='0';
		
signal enb_rd : std_logic:='0';
signal enb_s : std_logic:='0';

signal t : std_logic:='0';

	
begin
	
	sqr: ASP1_SQR port map(
		x 	=> x,
		
		mux_select => mux_select,
		
		enb_rd => enb_rd,
		enb_s => enb_s,
		
		clock => clock,
		reset => reset,
		
		t_out => t,
		
		r_out  => r_out);
	
		process(clock, reset)
		begin
			if(reset = '1') then
				enb_rd <= '0';
				enb_s <= '0';
				estado_atual <= "00";
			
			elsif(clock = '1' and clock'event) then
			
				if(estado_atual = "00") then
					mux_select <= '0';
					enb_rd <= '1';
					enb_s <= '1';
					estado_atual <= "01";
					
				elsif(estado_atual = "01") then
					mux_select <= '1';
					enb_rd <= '1';
					enb_s <= '0';
					estado_atual <= "10";
					
				elsif(estado_atual = "10") then
					mux_select <= '1';
					enb_rd <= '0';
					enb_s <= '1';
					
						if(t = '1') then
							estado_atual <= "00";
						elsif(t = '0') then
							estado_atual <= "01";
						end if;
				end if;
			end if;
			
			wait for 10 ns;
				clock <= not clock;
				
		end process;
		
		
			
		
	
end behavior;