library ieee;
use ieee.std_logic_1164.all;

entity washing_machine is
    port ( clk : in std_logic;
           reset : in std_logic;
           start : in std_logic;
           cycle_complete : in std_logic;
           display : out std_logic_vector(6 downto 0) );
end washing_machine;

architecture machine_arch of washing_machine is
    type states is (idle, wash, rinse, spin, complete);
    signal current_state, next_state : states;
    signal count : integer range 0 to 999 := 0;
begin
    process(clk, reset)
    begin
        if (reset = '1') then
            current_state <= idle;
        elsif (clk'event and clk = '1') then
            current_state <= next_state;
        end if;
    end process;
    
    process(current_state, start, cycle_complete, count)
    begin
        case current_state is
            when idle =>
                if (start = '1') then
                    next_state <= wash;
                else
                    next_state <= idle;
                end if;
            when wash =>
                if (cycle_complete = '1') then
                    next_state <= rinse;
                else
                    next_state <= wash;
                end if;
            when rinse =>
                if (cycle_complete = '1') then
                    next_state <= spin;
                else
                    next_state <= rinse;
                end if;
            when spin =>
                if (cycle_complete = '1') then
                    next_state <= complete;
                else
                    next_state <= spin;
                end if;
            when complete =>
                next_state <= idle;
                count <= count + 1;
            when others =>
                next_state <= idle;
        end case;
    end process;
    
    display <= "1000000" when count = 0 else
              "1111001" when count = 1 else
              "0100100" when count = 2 else
              "0110000" when count = 3 else
              "0011001" when count = 4 else
              "0010010" when count = 5 else
              "0000010" when count = 6 else
              "1111000" when count = 7 else
              "0000000" when count = 8 else
              "0010000";
end machine_arch;
