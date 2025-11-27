library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mseqlib.all;

entity mseq is
    port(
        ir           : in  std_logic_vector(3 downto 0);
        clock, reset : in  std_logic;
        z            : in  std_logic;
        code         : out std_logic_vector(35 downto 0);
        mOPs         : out std_logic_vector(26 downto 0)
    );
end mseq;

architecture arc of mseq is

    signal pc_addr    : std_logic_vector(5 downto 0);
    signal next_addr  : std_logic_vector(5 downto 0);
    signal seq_addr   : std_logic_vector(5 downto 0);
    signal field_addr : std_logic_vector(5 downto 0);
    signal ir_addr    : std_logic_vector(5 downto 0);

    signal code_int   : std_logic_vector(35 downto 0);

    signal SEL        : std_logic_vector(2 downto 0);
    signal S1,S0      : std_logic;

begin

    
    U_PC : regnbit
        generic map (n => 6)
        port map (
            din  => next_addr,
            clk  => clock,
            rst  => reset,
            ld   => '1',
            inc  => '0',
            dout => pc_addr
        );

  
    U_ROM : mseq_rom
        port map (
            address => pc_addr,
            clock   => clock,
            q       => code_int
        );

    
    code       <= code_int;
    mOPs       <= code_int(35 downto 9);
    SEL        <= code_int(8 downto 6);
    field_addr <= code_int(5 downto 0);

    
    seq_addr   <= pc_addr + 1;

   
    with ir select
        ir_addr <=
            "000100" when "0001",  
            "000000" when others;

    S1 <= SEL(2);
    S0 <= SEL(1) xor (SEL(0) and z);

    
    U_MUX_NEXT : mux4
        generic map (n => 6)
        port map (
            d0  => seq_addr,
            d1  => field_addr,
            d2  => ir_addr,
            d3  => (others => '0'),
            sel => S1 & S0,
            y   => next_addr
        );

end arc;
