library ieee;
use ieee.std_logic_1164.all;

entity clock_divider is
    port ( clk_in : in std_logic;
           clk_out : out std_logic );
end clock_divider;

architecture divider_arch of clock_divider is
    signal count : integer range 0 to 49999 := 0;
begin
    process (clk_in)
    begin
        if rising_edge(clk_in) then
            if count = 49999 then
                count <= 0;
                clk_out <= not clk_out;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
end divider_arch;

entity washing_machine_fsm is
    port ( clk : in std_logic;
           reset : in std_logic;
           start : in std_logic;
           done : out std_logic );
end washing_machine_fsm;

architecture fsm_arch of washing_machine_fsm is
    type state_type is (idle, wash, rinse, spin, dry);
    signal state, next_state : state_type;
begin
    process(clk, reset)
    begin
        if (reset = '1') then
            state <= idle;
        elsif (clk'event and clk = '1') then
            state <= next_state;
        end if;
    end process;
    
    process(state, start)
    begin
        case state is
            when idle =>
                done <= '0';
                if (start = '1') then
                    next_state <= wash;
                else
                    next_state <= idle;
                end if;
            when wash =>
                done <= '0';
                next_state <= rinse;
            when rinse =>
                done <= '0';
                next_state <= spin;
            when spin =>
                done <= '0';
                next_state <= dry;
            when dry =>
                done <= '1';
                next_state <= idle;
            when others =>
                done <= '0';
                next_state <= idle;
        end case;
    end process;
end fsm_arch;

entity seven_segment_display is
    port ( clk : in std_logic;
           reset : in std_logic;
           start : in std_logic;
           display : out std_logic_vector(6 downto 0) );
end seven_segment_display;

architecture display_arch of seven_segment_display is
    signal count : integer range 0 to 999 := 0;
begin
    process(clk, reset, start)
    begin
        if (reset = '1') then
            count <= 0;
        elsif (clk'event and clk = '1' and start = '1') then
            if count = 999 then
                count <= 0;
