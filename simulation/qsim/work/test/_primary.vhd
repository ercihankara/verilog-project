library verilog;
use verilog.vl_types.all;
entity test is
    port(
        start           : in     vl_logic;
        key1            : in     vl_logic;
        key2            : in     vl_logic;
        data            : out    vl_logic_vector(3 downto 0)
    );
end test;
