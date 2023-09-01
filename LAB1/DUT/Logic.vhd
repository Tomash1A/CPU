LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
----------------------------------------------------------
entity logic is
	GENERIC (n : INTEGER := 8;
	         k : integer := 3;
			 m : integer := 4);
	port ( x,y : in std_logic_vector(n-1 downto 0);
		   ALUFN : in std_logic_vector(4 downto 0);
		   Cflag,Nflag, Zflag: OUT STD_LOGIC;
	       s   : out std_logic_vector(n-1 downto 0));
end logic;
----------------------------------------------------------
architecture logic_arch of logic is

	signal s_temp : std_logic_vector(n-1 DOWNTO 0);
	signal z_vec: std_logic_vector(n-1 downto 0);

begin	
	z_vec <= (others => '0');
	s_temp <= not (y) when ALUFN(2 downto 0) = "000" else	
		 (y or x) when ALUFN(2 downto 0) = "001" else
		 (y and x) when ALUFN(2 downto 0) = "010" else
		 (y xor x) when ALUFN(2 downto 0) = "011" else
		 (y nor x) when ALUFN(2 downto 0) = "100" else
		 (y nand x) when ALUFN(2 downto 0) = "101" else
		 (y xnor x) when ALUFN(2 downto 0) = "111" else	
		 (others => '0');
	
	s <= s_temp;
	Cflag <= '0'; --פעולה לוגית לא תיתן נשא?
	Nflag <= '1' when s_temp(n-1) = '1' else '0';  --פעולה לוגית תיתן מינוס?
	Zflag <= '1' when (s_temp = z_vec) else '0';

	
	
end logic_arch;		 