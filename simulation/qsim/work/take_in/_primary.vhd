library verilog;
use verilog.vl_types.all;
entity take_in is
    port(
        start           : in     vl_logic;
        clk             : in     vl_logic;
        key0            : in     vl_logic;
        key1            : in     vl_logic;
        buffer1_o       : out    vl_logic_vector(17 downto 0);
        buffer2_o       : out    vl_logic_vector(17 downto 0);
        buffer3_o       : out    vl_logic_vector(17 downto 0);
        buffer4_o       : out    vl_logic_vector(17 downto 0)
    );
end take_in;
