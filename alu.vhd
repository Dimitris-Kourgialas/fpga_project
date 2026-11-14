library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.alulib.all;

entity alu is
generic (n : integer := 8);
port  ( ac      : in std_logic_vector(n-1 downto 0);
        db      : in std_logic_vector(n-1 downto 0);
        alus    : in std_logic_vector(7 downto 1);
        dout    : out std_logic_vector(n-1 downto 0));
end alu ;

architecture arch of alu is
  constant zero : std_logic_vector(n-1 downto 0) := (others => '0');
  signal db_n                     : std_logic_vector(n-1 downto 0);  -- BUS'
  signal mux_a, mux_b             : std_logic_vector(n-1 downto 0);  -- είσοδοι αθροιστή
  signal arith_out, logic_out     : std_logic_vector(n-1 downto 0);
  signal and_r, or_r, xor_r, not_r: std_logic_vector(n-1 downto 0);
  signal sel_b, sel_l             : std_logic_vector(1 downto 0);
  signal cout_unused              : std_logic;
begin
  ---------------- Arithmetic Unit ----------------
  db_n  <= not db;

  -- MUX 2-σε-1: ALUS1 = 0 -> "00000000", 1 -> AC
  mux_ac : mux2 generic map (n) port map (d0 => zero, d1 => ac, s => alus(1), y => mux_a);

  -- MUX 3-σε-1 (4-σε-1): S1 = ALUS2, S0 = ALUS3 -> 0:"0", 1:BUS, 2:BUS'
  sel_b <= alus(2) & alus(3);
  mux_bus : mux4 generic map (n) port map (d0 => zero, d1 => db, d2 => db_n, d3 => zero,
                                           s => sel_b, y => mux_b);

  -- Παράλληλος αθροιστής, Cin = ALUS4
  add : adder8bit port map (a => mux_a, b => mux_b, cin => alus(4),
                            s => arith_out, cout => cout_unused);

  ---------------- Logic Unit ----------------
  and_r <= ac and db;
  or_r  <= ac or  db;
  xor_r <= ac xor db;
  not_r <= not ac;

  -- MUX 4-σε-1: S1 = ALUS5, S0 = ALUS6 -> 0:AND, 1:OR, 2:XOR, 3:NOT
  sel_l <= alus(5) & alus(6);
  mux_logic : mux4 generic map (n) port map (d0 => and_r, d1 => or_r, d2 => xor_r, d3 => not_r,
                                             s => sel_l, y => logic_out);

  ---------------- Έξοδος ----------------
  -- MUX 2-σε-1: ALUS7 = 0 -> Arithmetic, 1 -> Logic
  mux_out : mux2 generic map (n) port map (d0 => arith_out, d1 => logic_out, s => alus(7), y => dout);
end arch;