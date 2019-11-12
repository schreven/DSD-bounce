library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity buzz_ctrl is
port (

clk :				in std_logic;
buzz_trs : 		in std_logic;
);

end buzz_ctrl;

architecture soundout of buzz_ctrl is
begin

process(clock)
variable i: integer :=0;
begin
if rising_edge(clk) then
if i<= 50 000 000 then
i := i+1;
buzz_trs <= '1';
elsif i> 50 000 000 and i< 100 000 000 then
i := i+1;
buzz_trs <= '0';
elsif i= 100 000 000 then
i := 0;
end if;
end if;
end process;
end soundout;
