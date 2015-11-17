-- Listing 11.1
-- Single-port 1K x 8 RAM with synchronous read
-- Modified from XST 8.1i rams_07

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity RAM is
   generic(
      ADDR_WIDTH: integer:=12;
      DATA_WIDTH: integer:=8
   );
   port(
      clk: in std_logic;
      we: in std_logic;
      addr: in std_logic_vector(ADDR_WIDTH-1 downto 0);
      wrbus: in std_logic_vector(DATA_WIDTH-1 downto 0);
      rdbus: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end RAM;

architecture beh_arch of RAM is
   type ram_type is array (2**ADDR_WIDTH-1 downto 0)
        of std_logic_vector (DATA_WIDTH-1 downto 0);
   signal ram: ram_type;
   signal addr_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);
begin
   process (clk)
   begin
      if (clk'event and clk = '1') then
         if (we='1') then
            ram(to_integer(unsigned(addr))) <= wrbus;
            end if;
        addr_reg <= addr;
      end if;
   end process;
   rdbus <= ram(to_integer(unsigned(addr_reg)));
end beh_arch;