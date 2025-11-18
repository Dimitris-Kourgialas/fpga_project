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

   
    signal and_res, or_res, xor_res, not_res : std_logic_vector(n-1 downto 0);
    signal logic_out : std_logic_vector(n-1 downto 0);

 
    signal a_sel, b_sel : std_logic_vector(n-1 downto 0);
    signal cin_sel      : std_logic;

    signal arith_out : std_logic_vector(n-1 downto 0);

begin



    and_res <= ac and db;
    or_res  <= ac or db;
    xor_res <= ac xor db;
    not_res <= not ac;

   
    logic_mux: mux4
        generic map (n => n)
        port map (
            d0  => and_res,
            d1  => or_res,
            d2  => xor_res,
            d3  => not_res,
            sel => alus(2 downto 1),   
            y   => logic_out
        );


    a_mux : mux2
        generic map (n => n)
        port map (
            d0 => (others => '0'),
            d1 => ac,
            sel => alus(3),
            y  => a_sel
        );

    
    b_mux : mux4
        generic map (n => n)
        port map (
            d0 => (others => '0'),
            d1 => db,
            d2 => not db,
            d3 => (others => '0'),
            sel => alus(5 downto 4),
            y  => b_sel
        );

    
    cin_sel <= alus(6);

    
    adder_inst : adder8bit
        generic map (n => n)
        port map (
            a    => a_sel,
            b    => b_sel,
            cin  => cin_sel,
            s    => arith_out,
            cout => open
        );



    result_mux : mux2
        generic map (n => n)
        port map (
            d0  => arith_out,
            d1  => logic_out,
            sel => alus(7),
            y   => dout
        );

end arch;
