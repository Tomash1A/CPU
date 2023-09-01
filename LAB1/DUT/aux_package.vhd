library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
-------------TOP Component---------------------
	component top is
	GENERIC (n : INTEGER := 8;
			 k : integer := 3;   -- k=log2(n)
		     m : integer := 4	); -- m=2^(k-1)

	PORT (Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o: OUT STD_LOGIC );
	end component;
		
---------------FullAdder Component-----------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
	
---------First Block- AdderSub Component-----------------	
	component AdderSub IS
	  GENERIC (n : INTEGER := 8;
			   k : INTEGER := 3;
			   m : INTEGER := 4);
	  PORT (	x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
				ALUFN: IN STD_LOGIC_VECTOR (4 downto 0);
				Cflag,Nflag,Zflag: OUT STD_LOGIC;
				s_full: OUT STD_LOGIC_VECTOR(n-1 downto 0));
	END component;
	
---------Second Block- Logic Component-------------------
	component logic is
		GENERIC (n : INTEGER := 8;
				 k : integer := 3;
				 m : integer := 4);
		port ( x,y : in std_logic_vector(n-1 downto 0);
			   ALUFN : in std_logic_vector(4 downto 0);
			   Cflag,Nflag,Zflag: OUT STD_LOGIC;
			   s   : out std_logic_vector(n-1 downto 0));
	end component;	
	
---------Third Block- Shifter Component-----------------
	component shifter is
		GENERIC(n: INTEGER := 8;
				k: integer := 3;
				m : integer := 4);
		port   (x,y: in std_logic_vector (n-1 downto 0);
				ALUFN: in std_logic_vector (4 downto 0);
				Cflag,Nflag,Zflag: OUT STD_LOGIC;
				s: out std_logic_vector (n-1 downto 0));
	end component;
	
end aux_package;

