library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.std_logic_arith.all;

entity washer_controller is  
   Port ( --inputs
			 clk : in std_logic;    
			 clr : in std_logic;
			 start_wash : in std_logic;
			 double_wash : in std_logic; 
			 door_open : in std_logic; 
			 --outputs
			 segment : out std_logic_vector (6 downto 0);
			 led : out std_logic_vector (6 downto 0));
end washer_controller;
--ARCHITECTURE  
architecture Behavioral of washer_controller is  
--STATES
type state_type is (S0,S1,S2,S3,S4,S5,S6);
signal state: state_type;
--signals and constants
signal count: integer range 0 to 7;
constant SEC5: std_logic_vector (3 downto 0) := "0101";
constant SEC1: std_logic_vector (3 downto 0) := "0011";

--state process

begin

next_state_process: process(clk,clr)

begin

--synchronous process
	if clr = '1' then
		state <= S0;
		count <= 0;
	elsif clk'event and clk = '1' then
	
	case state is
	
		when S0 =>
			if door_open = '1' then
				if start_wash = '0' or double_wash = '0' then
					state <= S0;
			end if;
			elsif door_open = '0' then
			if start_wash = '1' or double_wash = '1'  then
			state <= S1;
			end if;
			end if;
			
		when S1 =>
			if count < SEC1 then
				state <= S1;
				count <= count + 1;
			else
				state <= S2;
				count <=0;
			end if;
			
		when S2 =>
			if count < SEC5 then
				state <= S2;
				count <= count + 1;
			else
				state <= S3;
				count <= 0;
			end if;
			
		when S3 =>
			if start_wash = '1' then
				if double_wash = '0' then
					state <= S4;
			end if;
			elsif start_wash = '0' then
			if double_wash = '1' then
			state <= S5;
			end if;
			end if;
			
		when S4 =>
			if count < SEC5 then
				state <= S4;
				count <= count + 1;
			else
				state <= S0;
				count <= 0;
			end if;
			
		when S5 =>
			if count < SEC1 then
				state <= S5;
				count <= count + 1;
			else
				state <= S6;
				count <= 0;
			end if;
		
		when S6 =>
			if count < SEC1 then
				state <= S6;
				count <= count + 1;
			else
				state <= S4;
				count <= 0;
			end if;
			
	end case;
   end if;
end process;
	
--output process
output_process: process(state)
begin
	case state is
		when S0 => led(0) <='1';
		when S1 => led(1) <='1';
		when S2 => led(2) <='1';
		when S3 => led(3) <='1';
		when S4 => led(4) <='1';
		when S5 => led(5) <='1';
		when S6 => led(6) <='1';
	end case;
end process;

segment_process: process(count)
begin
		  if	  (count=0) then segment <= "1000000";
        elsif (count=1) then segment <= "1111001";
        elsif (count=2) then segment <= "0100100";
        elsif (count=3) then segment <= "0110000";
        elsif (count=4) then segment <= "0011001";
        elsif (count=5) then segment <= "0010010";
        elsif (count=6) then segment <= "0000010";
        elsif (count=7) then segment <= "1111000";
       end if;
end process;
end Behavioral;  