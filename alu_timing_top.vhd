library ieee;
use ieee.std_logic_1164.all;

-- Top-level ΜΟΝΟ για ανάλυση υλικού & χρονισμού
entity alu_timing_top is
  port ( clk  : in  std_logic;                      -- 50 MHz (PIN_P11)
         ac   : in  std_logic_vector(7 downto 0);   -- Virtual Pins
         db   : in  std_logic_vector(7 downto 0);   -- Virtual Pins
         alus : in  std_logic_vector(7 downto 1);   -- Virtual Pins
         dout : out std_logic_vector(7 downto 0) ); -- Virtual Pins
end alu_timing_top;

architecture arc of alu_timing_top is
  signal ac_r, db_r, dout_c : std_logic_vector(7 downto 0);
  signal alus_r             : std_logic_vector(7 downto 1);
begin
  process(clk)
  begin
    if rising_edge(clk) then
      ac_r <= ac;  db_r <= db;  alus_r <= alus;     -- καταχωρητές εισόδου
      dout <= dout_c;                               -- καταχωρητής εξόδου
    end if;
  end process;
  alu_i : entity work.alu port map (ac_r, db_r, alus_r, dout_c);
end arc;