


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity keyboard_ctrl is
	port(
	clk: in std_logic;
	rst : in std_logic;
	key_clk : in std_logic;
	key_data : in std_logic;
	keyval : out std_logic_vector(7 downto 0)
	);
end keyboard_ctrl;



architecture key_arch of keyboard_ctrl is
type state_type is (start, low1, high1, getkey1, low2, high2, getkey2, breakey, low3, high3, getkey3);

signal state: state_type;
signal key_clkf, key_dataf : std_logic;
signal key_clk_filter, key_data_filter: std_logic_vector(7 downto 0);
signal shift1, shift2, shift3: std_logic_vector(10 downto 0);
signal keyval1t, keyval2t, keyval3t: std_logic_vector(7 downto 0);
signal bit_count : std_logic_vector(3 downto 0);
constant bit_count_max: std_logic_vector(3 downto 0) := "1011"; 

begin 

filter: process(clk, rst)
begin
		if rst = '1' then
				key_clk_filter <= (others => '0');
				key_data_filter <= (others => '0');
				key_clkf <= '1';
				key_dataf <= '1';
		elsif rising_edge(clk) then
				key_clk_filter(7) <= key_clk;
				key_clk_filter(6 downto 0) <= key_clk_filter(7 downto 1);
				key_data_filter(7) <= key_data;
				key_data_filter(6 downto 0) <= key_data_filter(7 downto 1);
				if key_clk_filter = x"FF" then
						key_clkf <= '1'; 
				elsif key_clk_filter = x"00" then
						key_clkf <= '0';
				end if;
				if key_data_filter = x"FF" then
						key_dataf <= '1'; 
				elsif key_data_filter = x"00" then
						key_dataf <= '0';
				end if;
		end if;
end process filter;

key_process: process(clk, rst)
begin
	if (rst= '1') then 
			state <= start;
			bit_count <= (others => '0');
			shift1 <= (others => '0');
			shift2 <= (others => '0');
			shift3 <= (others => '0');
			keyval1t <= (others => '0');
			keyval2t <= (others => '0');
			keyval3t <= (others => '0');
	elsif rising_edge(clk) then
			case state is 
					when start => 
								if key_dataf = '1' then
										state <= start;
								else
										state <= low1;
								end if;
					when low1 =>
							if bit_count < bit_count_max then
								if key_clkf = '1' then
										state <= low1;
								else 
										state <= high1;
										shift1 <= key_dataf & shift1(10 downto 1);
								end if;
							else
								state <=getkey1;
							end if;
					when high1 =>
								if key_clkf ='0' then
										state <= high1;
								else
										state <= low1;
										bit_count <= bit_count + 1;
								end if;
					when getkey1 =>
								keyval1t <= shift1(8 downto 1);
								bit_count <= (others => '0');
								state <= low2;
					when low2 =>
							if bit_count < bit_count_max then
								if key_clkf = '1' then
										state <= low2;
								else 
										state <= high2;
										shift2 <= key_dataf & shift2(10 downto 1);
								end if;
							else
								state <=getkey2;
							end if;
					when high2 =>
								if key_clkf ='0' then
										state <= high2;
								else
										state <= low2;
										bit_count <= bit_count + 1;
								end if;
					when getkey2 =>
								keyval2t <= shift2(8 downto 1);
								bit_count <= (others => '0');
								state <= breakey;
					when breakey =>
								if keyval2t = X"E0" then
										state <= low3;
								else
										if keyval1t = X"C0" then
												state <= low1;
										else 
												state <= low2;
										end if;
								end if;
					when low3 =>
							if bit_count < bit_count_max then
								if key_clkf = '1' then
										state <= low3;
								else 
										state <= high3;
										shift3 <= key_dataf & shift3(10 downto 1);
								end if;
							else
								state <=getkey3;
							end if;		
					when high3 =>
								if key_clkf ='0' then
										state <= high3;
								else
										state <= low3;
										bit_count <= bit_count + 1;
								end if;
					when getkey3 =>
								keyval3t <= shift3(8 downto 1);
								bit_count <= (others => '0');
								state <= low1;
			end case;
	end if;
end process key_process;

keyval <= keyval2t;

end key_arch;