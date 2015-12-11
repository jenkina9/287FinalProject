LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;

ENTITY ProjectV2 IS
PORT( 	Reset : in std_logic;
			Clock : in std_logic;
			w : in std_logic_vector(3 downto 0);
			hard: in std_logic;
			lvl3 : in std_logic;
			lvl2 : in std_logic;
			z : out std_logic_vector(3 downto 0);
			g : out std_logic;
			disp_0 : out std_logic_vector(6 downto 0);
			disp_1 : out std_logic_vector(6 downto 0);
			highScore_0 : out std_logic_vector(6 downto 0);
			highScore_1 : out std_logic_vector(6 downto 0);
			dif_0 : out std_logic_vector(6 downto 0);
			dif_1 : out std_logic_vector(6 downto 0);
			dif_2 : out std_logic_vector(6 downto 0);
			dif_3 : out std_logic_vector(6 downto 0)
			);
END ProjectV2;

ARCHITECTURE Simon OF ProjectV2 IS
	TYPE State_type Is (A, B, C, D, E, F);
	Signal y : State_type := D;
	Signal clk : integer;
	Signal x : integer := 0;
	Signal x2 : integer := 0;
	Shared Variable q : integer := 3;
	Shared Variable s : std_logic_vector(1000 downto 0); --pretend this is a variable size array (even though it's just really really big)
	Shared Variable u : integer := 3 ;
	Shared Variable random_num : std_logic_vector(3 downto 0);
	Signal clkr : std_logic := '0';
	Shared Variable rnd : std_logic_vector(3 downto 0);
	Shared Variable Aflag : std_logic := '0';
	Shared Variable temp : std_logic_vector(3 downto 0);
	Shared Variable Bflag : std_logic := '0';
	Shared Variable Cflag : std_logic := '0';
	Shared Variable clkTime : integer := 50000000;
	Shared Variable sev_0 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable sev_1 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable high_0 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable high_1 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable hardHigh_0 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable hardHigh_1 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable threeHigh_0 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable threeHigh_1 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable twoHigh_0 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable twoHigh_1 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable oneHigh_0 : std_logic_vector(3 downto 0) := "0000";
	Shared Variable oneHigh_1 : std_logic_vector(3 downto 0) := "0000";
	
BEGIN

	z(3) <= temp(3) OR ((NOT w(3)) AND (Cflag));
	z(2) <= temp(2) OR ((NOT w(2)) AND (Cflag));
	z(1) <= temp(1) OR ((NOT w(1)) AND (Cflag));
	z(0) <= temp(0) OR ((NOT w(0)) AND (Cflag));
	
	--Random Stuff----------------------------------------------------------------------------------------------------
	uut: entity work.random generic map (width => 4) PORT MAP (
          clk => clkr,
          random_num => random_num
        );

	--Methods for Binary to 7seg Display------------------------------------------------------------------------------
	high0: entity work.sevenseg PORT MAP (
          clk => Clock,
          sev => high_0,
			 disp => highScore_0
        );
		  
	high1: entity work.sevenseg PORT MAP (
          clk => Clock,
          sev => high_1,
			 disp => highScore_1
        );	  
		  
	score0: entity work.sevenseg PORT MAP (
          clk => Clock,
          sev => sev_0,
			 disp => disp_0
        );	
		  
	score1: entity work.sevenseg PORT MAP (
          clk => Clock,
          sev => sev_1,
			 disp => disp_1
        );	
	------------------------------------------------------------------------------------------------------------------
	
	PROCESS (Clock) --Random Clock-------------------
		BEGIN
		IF (Clock'Event AND Clock = '1') THEN
			IF (x2 < 2) THEN
				x2 <= x2 + 1;
				clkr <= '0';
			ELSE
				clkr <= '1';
				x2 <= 0;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (Clock) --Process Clock-------------------
	BEGIN
		IF (Clock'Event AND Clock = '1') THEN
			IF (x < clkTime) THEN
				x <= x + 1;
					clk <= 0;
			ELSE
				clk <= 1;
				x <= 0;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS(Clock, Reset)
		BEGIN
		IF (Reset = '0') THEN
			y <= A;
			temp(3 downto 0) := "0000";
			Aflag := '0';
			Bflag := '0';
			Cflag := '0';
			q := 3;
			u := 3;
			sev_0 := "0000";
			sev_1 := "0000";
			
			--Adjust Clock speed, change difficulty display; Prioritize highest difficulty
			IF (hard = '1') THEN
				dif_0 <= "0001011";
				dif_1 <= "0001000";
				dif_2 <= "0101111";
				dif_3 <= "0100001";
				clkTime := 25000000;
				high_0 := hardHigh_0;
				high_1 := hardHigh_1;
			ELSIF(lvl3 = '1') THEN
				dif_0 <= "1000111";
				dif_1 <= "1100011";
				dif_2 <= "1000111";
				dif_3 <= "0110000";
				clkTime := 33333333;
				high_0 := threeHigh_0;
				high_1 := threeHigh_1;
			ELSIF(lvl2 = '1') THEN
				dif_0 <= "1000111";
				dif_1 <= "1100011";
				dif_2 <= "1000111";
				dif_3 <= "0100100";
				clkTime := 37500000;
				high_0 := twoHigh_0;
				high_1 := twoHigh_1;
			ELSE
				dif_0 <= "1000111";
				dif_1 <= "1100011";
				dif_2 <= "1000111";
				dif_3 <= "1111001";
				clkTime := 50000000;
				high_0 := oneHigh_0;
				high_1 := oneHigh_1;
			END IF;
		ELSIF(Clock'Event AND Clock = '1' AND clk = 1) THEN
			CASE y IS
				WHEN A => --Add to Pattern
					g <= '1';
					IF(Aflag = '0') THEN
						Aflag := '1';
					ELSE
						q := (q + 4);
					END IF;
					s(q) := rnd(3);
					s(q-1) := rnd(2);
					s(q-2) := rnd(1);
					s(q-3) := rnd(0);	
					u := 3;
					y <= B;
					Bflag := '0';
				WHEN B => --Display Pattern
					IF(Bflag = '0') THEN
						temp(3) := s(u);
						temp(2) := s(u-1);
						temp(1) := s(u-2);
						temp(0) := s(u-3);
						IF(u < q) THEN
							u := (u + 4);
						ELSE
							u := 3;
							Cflag := '1';
							y <= C;
						END IF;
						Bflag := '1';
					ELSE
						temp(3 downto 0) := "0000";
						Bflag := '0';
					END IF;
					
				WHEN C => --Adds extra clock cycle for input
					temp(3 downto 0) := "0000";
					g <= '0';
					y <= F;
				When F => --Check User Pattern
						IF( (NOT w(3)) = s(u) AND (NOT w(2)) = s(u-1) AND (NOT w(1)) = s(u-2) AND (NOT w(0)) = s(u-3)) THEN
							IF (u = (q)) THEN
								Cflag := '0';
								y <= A;
								sev_0 := sev_0 + '1';
								IF(sev_0 = "1010") THEN
									sev_0 := "0000";
									sev_1 := sev_1 + '1';
								END IF;
								IF (sev_1 > high_1) THEN
									high_1 := sev_1;
									high_0 := sev_0;
								ELSIF (sev_1 = high_1 AND sev_0 > high_0) THEN
									high_0 := sev_0;
								END IF;
								IF (clkTime = 25000000) THEN
									hardHigh_0 := high_0;
									hardHigh_1 := high_1;
								ELSIF (clkTime = 33333333) THEN
									threeHigh_0 := high_0;
									threeHigh_1 := high_1;
								ELSIF (clkTime = 37500000) THEN
									twoHigh_0 := high_0;
									twoHigh_1 := high_1;
								ELSE
									oneHigh_0 := high_0;
									oneHigh_1 := high_1;
								END IF;
							ELSE
								y <= C;
							END IF;
							g <= '1';
							u := (u + 4);
						ELSE
							Cflag := '0';
							y <= D;
					END IF;
				WHEN D => --Failed
					temp(3 downto 0) := "1010";
					y <= E;
				WHEN E => --Failed Flash
					temp(3 downto 0) := "0101";
					y <= D;
			END CASE;
		END IF;
	END PROCESS;
	
	PROCESS(Clock, Reset)
		BEGIN
			if(random_num(1 downto 0) = "00") THEN
				rnd(0) := '1';
				rnd(1) := '0';
				rnd(2) := '0';
				rnd(3) := '0';
			ELSIF(random_num(1 downto 0) = "01") THEN
				rnd(0) := '0';
				rnd(1) := '1';
				rnd(2) := '0';
				rnd(3) := '0';
			ELSIF(random_num(1 downto 0) = "10") THEN
				rnd(0) := '0';
				rnd(1) := '0';
				rnd(2) := '1';
				rnd(3) := '0';
			ELSIF(random_num(1 downto 0) = "11") THEN
				rnd(0) := '0';
				rnd(1) := '0';
				rnd(2) := '0';
				rnd(3) := '1';
			END IF;
	END PROCESS;	
END Simon;