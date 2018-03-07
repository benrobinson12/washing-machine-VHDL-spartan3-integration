library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sig_gen is
   Port (clk : in STD_LOGIC;
     reset_n : in STD_LOGIC;
     clk_out : out STD_LOGIC);
end entity sig_gen;

architecture Behavioral of sig_gen is
signal clk_sig : std_logic;
begin
process(reset_n,clk)
    variable   count   : integer;
    begin
    if (reset_n='0') then
        clk_sig<='0';
        count:=0;
        elsif rising_edge(clk) then
        if (count=24999999) then

                clk_sig<=NOT(clk_sig);
                count:=0;
               else
                count:=count+1;
        end if;
     end if;
end process;

clk_out <= clk_sig;


end Behavioral;