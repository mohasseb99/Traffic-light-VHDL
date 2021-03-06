LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY TLC_tb is
END ENTITY;
ARCHITECTURE tb of TLC_tb IS
signal Trafficlights : std_logic_vector (9 downto 0);
signal clk,press: std_logic;
begin

DUT : ENTITY work.TrafficLightController
PORT MAP(Trafficlights=>Trafficlights,clk=>clk,press=>press);
Clock : process
begin
Clk <= '0';
wait for 10 ns;
Clk <= '1';
wait for 10 ns;
end process;
stimulis : process
begin
 report("Starting simulation");
 press <= '1';wait for 60 ns;
 press <= '0';wait for 200000000 ns;
 report("End simulation");
end process;
end architecture;