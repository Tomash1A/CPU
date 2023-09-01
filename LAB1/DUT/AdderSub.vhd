LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------

ENTITY AdderSub IS
  GENERIC (n : INTEGER := 8;
		   k : INTEGER := 3;
		   m : INTEGER := 4);
  PORT (	x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			ALUFN: IN STD_LOGIC_VECTOR (4 downto 0);
			Cflag,Nflag,Zflag: OUT STD_LOGIC;
			s_full: OUT STD_LOGIC_VECTOR(n-1 downto 0));
END AdderSub;

--------------------------------------------------------------
ARCHITECTURE dfl OF AdderSub IS

	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
	
	SIGNAL reg : std_logic_vector(n-1 DOWNTO 0);
	signal s_temp : std_logic_vector(n-1 DOWNTO 0);
	signal c0  : std_logic;
	signal x1 : std_logic_vector (n-1 downto 0);
	signal y1 : std_logic_vector(n-1 downto 0);
	signal z_vec: std_logic_vector(n-1 downto 0);
	BEGIN

		c0 <=  '1' when ALUFN(2 downto 0) = "001" else
			   '1' when ALUFN(2 downto 0) = "010" else
			   '0' ;
			   
		y1 <=  y when ALUFN(2 downto 0) = "000" else
			   y when ALUFN(2 downto 0) = "001" else
			   (others => '0');
			   
		x1 <=  x when ALUFN(2 downto 0) = "000" else
		       not x when ALUFN(2 downto 0) = "001" else
			   not x when ALUFN(2 downto 0) = "010" else
			   (others => '0');
			   
		z_vec <= (others =>'0');
			    
		  
	first : FA port map(
			xi => x1(0),
			yi => y1(0),
			cin => c0,
			s  => s_temp(0),
			cout => reg(0)
			);

	rest : for i in 1 to n-1 generate
		chain : FA port map(
			xi => x1(i),
			yi => y1(i),
			cin => reg(i-1),
			s => s_temp(i),
			cout => reg(i)
		);
end generate;
	
	Cflag <= reg(n-1);
	Nflag <= s_temp(n-1);
	Zflag <= '1' when s_temp = z_vec else '0';
	s_full <= s_temp;

END dfl;


