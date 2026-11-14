library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
  generic (n : integer := 8);
  port ( d0, d1, d2, d3 : in  std_logic_vector(n-1 downto 0);
         s              : in  std_logic_vector(1 downto 0);
         y              : out std_logic_vector(n-1 downto 0) );
end mux4;

architecture arc of mux4 is
begin
  with s select
    y <= d0 when "00",
         d1 when "01",
         d2 when "10",
         d3 when others;
end arc;