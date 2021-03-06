library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenseg is
port (
      clk : in std_logic;
		sev : in std_logic_vector(3 downto 0);
      disp : out std_logic_vector (6 downto 0)
    );
end sevenseg;

architecture Display of sevenseg is
BEGIN
PROCESS(clk)
BEGIN
	disp(0)<= NOT((NOT sev(2) AND NOT sev(0)) OR (sev(3) AND NOT sev(0)) OR (NOT sev(3) AND sev(1)) OR (sev(2) AND sev(1)) OR (NOT sev(3) AND sev(2) AND sev(0)) OR (sev(3) AND NOT sev(2) AND NOT sev(1)));
	disp(1)<= NOT((NOT sev(3) AND NOT sev(2)) OR (NOT sev(2) AND NOT sev(0)) OR (NOT sev(3) AND NOT sev(1) AND NOT sev(0)) OR (NOT sev(3) AND sev(1) AND sev(0)) OR (sev(3) AND NOT sev(1) AND sev(0)));
	disp(2)<= NOT((NOT sev(3) AND sev(2)) OR (NOT sev(1) AND sev(0)) OR (NOT sev(2) AND sev(0)) OR (NOT sev(2) AND NOT sev(1)) OR (sev(3) AND NOT sev(2)));
	disp(3)<= NOT((NOT sev(2) AND NOT sev(1) AND NOT sev(0)) OR (sev(2) AND sev(1) AND NOT sev(0)) OR (sev(2) AND NOT sev(1) AND sev(0)) OR (sev(2) AND sev(3) AND NOT sev(0)) OR (NOT sev(3) AND NOT sev(2) AND sev(1)) OR (sev(3) AND NOT sev(2) AND sev(0)));
	disp(4)<= NOT((NOT sev(2) AND NOT sev(0)) OR (sev(3) AND sev(1)) OR (sev(3) AND sev(2)) OR (sev(1) AND NOT sev(0)));
	disp(5)<= NOT((NOT sev(1) AND NOT sev(0)) OR (sev(3) AND NOT sev(2)) OR (sev(2) AND NOT sev(0)) OR (sev(3) AND sev(2) AND sev(1)) OR (NOT sev(3) AND sev(2) AND NOT sev(1)));
	disp(6)<= NOT((NOT sev(2) AND sev(1)) OR (sev(3) AND sev(1)) OR (sev(3) AND sev(0)) OR (sev(3) AND NOT sev(2) AND NOT sev(0)) OR (NOT sev(3) AND sev(2) AND NOT sev(0)) OR (sev(2) AND NOT sev(1) AND sev(0)));
END PROCESS;
END;