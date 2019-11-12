library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.ALL;

 
entity buzzer_ctrl is
port ( clk : in std_logic;
       buzz_trs     : out std_logic;
		 buzz_act 		: in std_logic_vector (8-1 downto 0)
                        );
end buzzer_ctrl;
 
architecture buzz_arch of buzzer_ctrl is
begin

process(clk)
constant freq_mult : integer := 500;
variable i : integer := 0;
variable buzz_act_int : integer:=0;

begin
buzz_act_int:=conv_integer(unsigned(buzz_act));
if rising_edge(clk) then
if i <= (freq_mult/2)*buzz_act_int then
i := i + 1;
buzz_trs <= '1';
elsif i > (freq_mult/2)*buzz_act_int and i < freq_mult*buzz_act_int then
i := i + 1;
buzz_trs <= '0';
elsif i = freq_mult*buzz_act_int then
i := 0;
end if;
end if;
end process;
end buzz_arch;