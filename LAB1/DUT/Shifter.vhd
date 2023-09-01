LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
----------------------------------------------------------
entity shifter is
	GENERIC(n: INTEGER := 8;
	        k: integer := 3;
			m : integer := 4);
	port   (x,y: in std_logic_vector (n-1 downto 0);
		    ALUFN: in std_logic_vector (4 downto 0);
			Cflag,Nflag, Zflag: OUT STD_LOGIC;
	        s: out std_logic_vector (n-1 downto 0));
end shifter;

----------------------------------------------------------

architecture shifter_logic of shifter is
		signal s_temp :std_logic_vector(n-1 downto 0);   --generating the general signals needed
		signal sel_vec : std_logic_vector(k-1 downto 0); 
		signal dir_bit: std_logic;
		signal z_vec: std_logic_vector(n-1 downto 0);
		
		subtype vector_l is std_logic_vector (n-1 downto 0); --generating the matrix for left shifts
		type matrix_l is array (k downto 0) of vector_l;
		signal row_l: matrix_l;
		
		subtype vector_r is std_logic_vector (n-1 downto 0); --generating the matrix for right shifts
		type matrix_r is array (k downto 0) of vector_r;
		signal row_r: matrix_r;
	
		subtype carry_vec is std_logic_vector (1 downto 0);  --generating the matrix that recieves the carry
		type carry_matrix is array (k downto 0) of carry_vec;-- after every shift, '1' is the left shift carry
		signal carry_row: carry_matrix;						 --'0' is the right shift carry
		
	begin
        sel_vec <= x(k-1 downto 0);
		z_vec <= (others => '0');
		row_l(0) <= y when ALUFN(2 downto 0) = "000" else    --setting the input for the matrices that we created
              	    y when ALUFN(2 downto 0) = "001" else	 --according to the ALUFN(2:0) given, and Y_i inputs
				    (others => '0');

		row_r(0) <= y when ALUFN(2 downto 0) = "000" else
              	    y when ALUFN(2 downto 0) = "001" else
				    (others => '0');					
			
				  
		dir_bit <= '0' when ALUFN(2 downto 0) = "000" else
		           '1' when ALUFN(2 downto 0) = "001" else
				   'Z';
				   
--following: three blocks, each block consists of a right shift sub-block and a left shift sub-block
--			 first block is for 1 bit shift, second block for a changing range of shifts, depends on k
--			 third block is for a shift of 2^(k-1) bits.				   
------------------------First Level - shift left ------------------------	

		row_l(1) <= row_l(0)(n-2 downto 0) & '0' when sel_vec(0) = '1' else
		            row_l(0);
		carry_row(0)(1) <= row_l(0)(n-1) when sel_vec(0) = '1' else '0';
------------------------First Level - shift right ------------------------
	
	    row_r(1) <= '0' & row_r(0)(n-1 downto 1) when sel_vec(0) = '1' else
		            row_r(0);
  		carry_row(0)(0)  <= row_r(0)(0) when sel_vec(0) = '1' else '0';
------------------------Second Level - shift left ------------------------	

	m2_l_top: for i in 1 to (k-2) generate	
			row_l(i+1) <= row_l(i)(n-1-(2**i) downto 0) & ((2**i)-1 downto 0=> '0') when sel_vec(i) = '1' else 
                          row_l(i);
 			carry_row(i)(1) <= row_l(i)(n-(2**i)) when sel_vec(i) = '1' else
			              carry_row(i-1)(1);						  
	end generate m2_l_top;
	
------------------------Second Level - shift right ------------------------	

	m2_r_top: for i in 1 to (k-2) generate	
			row_r(i+1) <= (n-1 downto (n-(2**i))=> '0') & (row_r(i)(n-1 downto (2**i))) when sel_vec(i) = '1' else 
                          row_r(i);
 			carry_row(i)(0)    <= row_r(i)((2**i)) when sel_vec(i) = '1' else
			              carry_row(i-1)(0);						  
	end generate m2_r_top;
	
------------------------Third Level - shift left ------------------------

		row_l(k) <= row_l(k-1)((n/2)-1 downto 0) & ((n/2)-1 downto 0=> '0') when sel_vec(k-1) = '1' else
				    row_l(k-1);
		carry_row(k-1)(1) <= row_l(k-1)(n/2) when sel_vec(k-1) = '1' else
		           unaffected;				 
------------------------Third Level - shift right ------------------------

		row_r(k) <= (n-1 downto n/2 => '0') & row_r(k-1)(n-1 downto n/2) when sel_vec(k-1) = '1' else
				    row_r(k-1);
		carry_row(k-1)(0) <= row_r(k-1)((n/2)-1) when sel_vec(k-1) = '1' else
		           unaffected;				   
	
------------------------final stage------------------------
	s_temp <= row_l(k) when dir_bit = '0' else 
			  row_r(k) when dir_bit = '1' else
			  (others => '0');
	
	Cflag <= '0' when sel_vec = z_vec(k-1 downto 0) else	
			 carry_row(k-1)(1) when dir_bit = '0' else 
			 carry_row(k-1)(0) when dir_bit = '1' else
			 '0'; 			

	Nflag <= s_temp(n-1);

	Zflag <= '1' when (s_temp = z_vec) else '0';
	
	s <= s_temp;

end shifter_logic;
