-- Hello world example
-- an example to check if your simulation stuff is working!

library ieee;
use ieee.std_logic_1164.all;

entity hello_and_gate is
    port(
        x1 : in std_logic;
        x2 : in std_logic;
        y  : out std_logic
    );
end hello_and_gate;

architecture rtl of hello_and_gate is
    begin
    y <= x1 and x2;
end rtl;
