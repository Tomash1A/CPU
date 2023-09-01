LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

-------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT (  Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o: OUT STD_LOGIC);
END top;

------------- Architecture code --------------
ARCHITECTURE struct OF top IS 
	SIGNAL addersub_output : std_logic_vector(n-1 DOWNTO 0);
	SIGNAL logic_output : std_logic_vector(n-1 DOWNTO 0);
	SIGNAL shifter_output : std_logic_vector(n-1 DOWNTO 0);
	signal Z_AddSub : std_logic;	
	signal Z_shifter : std_logic;
	signal Z_logic : std_logic;
	signal N_AddSub : std_logic;	
	signal N_shifter : std_logic;
	signal N_logic : std_logic;
	signal C_AddSub : std_logic;	
	signal C_shifter : std_logic;
	signal C_logic : std_logic;
BEGIN
	
first_block:  AdderSub generic map (n,k,m) port map(
			  x => X_i,
			  y => Y_i,
			  ALUFN => ALUFN_i,
			  s_full => addersub_output,
			  Cflag => C_AddSub,
			  Nflag => N_AddSub,
			  Zflag => Z_AddSub);
		
second_block: logic generic map (n,k,m) port map(
			  x => X_i,
			  y => Y_i,
			  ALUFN => ALUFN_i,
			  s => logic_output,
			  Cflag => C_logic,
			  Nflag => N_logic,
			  Zflag => Z_logic);
              
third_block: shifter generic map (n,k,m) port map(
			  x => X_i,
			  y => Y_i,
			  ALUFN => ALUFN_i,
			  s => shifter_output,
			  Cflag => C_shifter,
			  Nflag => N_shifter,
			  Zflag => Z_shifter);
              			  
ALUout_o <= addersub_output when ALUFN_i(4 downto 3) = "01" else
            logic_output when ALUFN_i(4 downto 3) = "11" else
			shifter_output when ALUFN_i(4 downto 3) = "10" else 
            unaffected;
			
Nflag_o <= N_AddSub when ALUFN_i(4 downto 3) = "01" else
            N_logic when ALUFN_i(4 downto 3) = "11" else
			N_shifter when ALUFN_i(4 downto 3) = "10" else 
            unaffected;
			
Zflag_o <= Z_AddSub when ALUFN_i(4 downto 3) = "01" else
            Z_logic when ALUFN_i(4 downto 3) = "11" else
			Z_shifter when ALUFN_i(4 downto 3) = "10" else 
            unaffected;
			
Cflag_o <= C_AddSub when ALUFN_i(4 downto 3) = "01" else
            C_logic when ALUFN_i(4 downto 3) = "11" else
			C_shifter when ALUFN_i(4 downto 3) = "10" else 
            unaffected;
			
END struct;