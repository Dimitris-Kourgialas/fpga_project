library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_counter is
    port(
        clock : in  std_logic;
        rst   : in  std_logic;
        inc   : in  std_logic;
        count : out std_logic_vector(2 downto 0)
    );
end state_counter;

architecture rtl of state_counter is
    signal cnt : unsigned(2 downto 0);
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if rst = '1' then
                cnt <= (others => '0');
            elsif inc = '1' then
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    count <= std_logic_vector(cnt);
end rtl;
