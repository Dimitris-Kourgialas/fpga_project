library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_decoder is
    port(
        Din  : in  std_logic_vector(2 downto 0);
        Dout : out std_logic_vector(7 downto 0)
    );
end state_decoder;

architecture rtl of state_decoder is
begin
    process(Din)
    begin
        Dout <= (others => '0');
        Dout(to_integer(unsigned(Din))) <= '1';
    end process;
end rtl;
