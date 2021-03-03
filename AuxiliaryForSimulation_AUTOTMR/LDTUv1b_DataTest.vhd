library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataTest is
  Port(
    A : in STD_LOGIC_VECTOR(29 downto 0);
    ones : out STD_LOGIC_VECTOR(4 downto 0)
    );
end DataTest;

architecture Behavioral of DataTest is
  
begin
  process(A) 
    variable count : unsigned(4 downto 0) := ("00000");
    begin
      count := "00000";   --initialize count variable.  
      for i in 0 to 29 loop
        count := count + ("0000" & A(i));
      end loop;
      ones <= std_logic_vector(count);
    end process;        
  end Behavioral;
