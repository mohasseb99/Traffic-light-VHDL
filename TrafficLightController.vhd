LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY TrafficLightController IS
  PORT(
    trafficLights :OUT STD_LOGIC_VECTOR(9 DOWNTO 0);      -- we need here 10 bits (3 for 1st traffic light, 3 for 2nd TL, 2 for 1st pedestrain TL, 2 for 2nd pedestrain TL)
    clk :IN STD_LOGIC;
    press :IN STD_LOGIC
  );
END TrafficLightController;

ARCHITECTURE Behavioral of TrafficLightController IS
  TYPE state_type IS(st0_R_G_G_R, st1_R_Y_G_R, st2_R_R_R_R, st3_G_R_R_G, st4_Y_R_R_G, st5_R_R_R_R, st6_R_R_G_G);
  SIGNAL state:state_type;
  SIGNAL state1:state_type;      -- to save state of two traffic lights so if pedestrain press button we have last state
  SIGNAL count:STD_LOGIC_VECTOR(4 DOWNTO 0);     -- to count seconds for traffic lights for cars
  SIGNAL countp:STD_LOGIC_VECTOR(4 DOWNTO 0);    -- to count seconds for traffic lights of pedestrain if pedestrain pressed button
  CONSTANT sec10:STD_LOGIC_VECTOR(4 DOWNTO 0) := "01010";  
  CONSTANT sec2:STD_LOGIC_VECTOR(4 DOWNTO 0) := "00010";
  CONSTANT sec1:STD_LOGIC_VECTOR(4 DOWNTO 0) := "00001";
  BEGIN
    PROCESS(clk)
      BEGIN
        IF press = '1' THEN  --pedestrain pressed button
          state <= st6_R_R_G_G;
          if countp < sec2 then
            state <= st6_R_R_G_G; --reset to red for two traffic lights and green for two pedestrain traffic lights
            countp <= countp + 1;
          else
            countp <= "00001";
          end if;
        ELSIF Clk' event and Clk = '1' then -- check for raising edge  
          case (state1) is
            when st0_R_G_G_R =>
              if count < sec10 then
                state1 <= st0_R_G_G_R;
                state <= state1;
                count <= count + 1;
              else
                state1 <= st1_R_Y_G_R;
                state <= state1; 
                count <= "00000";
              end if;
            when st1_R_Y_G_R =>
              if count < sec2 then
                state1 <= st1_R_Y_G_R;
                state <= state1;
                count <= count + 1;
              else
                state1 <= st2_R_R_R_R;
                state <= state1; 
                count <= "00000";
              end if;
            when st2_R_R_R_R =>
              if count < sec1 then
                state1 <= st2_R_R_R_R;
                state <= state1; 
                count <= count + 1;
              else
                state1 <= st3_G_R_R_G;
                state <= state1; 
                count <= "00000";
              end if;
            when st3_G_R_R_G =>
              if count < sec10 then
                state1 <= st3_G_R_R_G; 
                state <= state1;
                count <= count + 1;
              else
                state1 <= st4_Y_R_R_G;
                state <= state1; 
                count <= "00000";
              end if;
            when st4_Y_R_R_G =>
              if count < sec2 then
                state1 <= st4_Y_R_R_G;
                state <= state1;
                count <= count + 1;
              else
                state1 <= st5_R_R_R_R;
                state <= state1; 
                count <= "00000";
              end if;
            when st5_R_R_R_R =>
              if count < sec1 then
                state1 <= st5_R_R_R_R;
                state <= state1;
                count <= count + 1;
              else
                state1 <= st0_R_G_G_R;
                state <= state1; 
                count <= "00000";
              end if;
            when st6_R_R_G_G =>
              countp <= "00000";
            END CASE;
          END IF;
        END PROCESS;
              
  OUTPUT_DECODE: process (state)
    BEGIN
      case state is
        when st0_R_G_G_R => Trafficlights <= "1000010110"; -- 1st traffic -> Red, 2nd traffic -> green, 1st peds traffic -> green, 2nd peds traffic -> red
        when st1_R_Y_G_R => Trafficlights <= "1000100110"; -- 1st traffic -> Red, 2nd traffic -> yellow, 1st peds traffic -> green, 2nd peds traffic -> red
        when st2_R_R_R_R => Trafficlights <= "1001001010"; -- 1st traffic -> Red, 2nd traffic -> red, 1st peds traffic -> red, 2nd peds traffic -> red
        when st3_G_R_R_G => Trafficlights <= "0011001001"; -- 1st traffic -> green, 2nd traffic -> red, 1st peds traffic -> red, 2nd peds traffic -> green
        when st4_Y_R_R_G => Trafficlights <= "0101001001"; -- 1st traffic -> yellow, 2nd traffic -> red, 1st peds traffic -> red, 2nd peds traffic -> green
        when st5_R_R_R_R => Trafficlights <= "1001001010"; -- 1st traffic -> Red, 2nd traffic -> red, 1st peds traffic -> red, 2nd peds traffic -> red
        when st6_R_R_G_G => Trafficlights <= "1001000101"; -- 1st traffic -> red, 2nd traffic -> red, 1st peds traffic -> green, 2nd peds traffic -> green 
      END CASE;
  END process;
END Behavioral;