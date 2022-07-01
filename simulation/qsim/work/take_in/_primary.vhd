library verilog;
use verilog.vl_types.all;
entity take_in is
    port(
        start           : in     vl_logic;
        data            : in     vl_logic_vector(3 downto 0);
        buffer1_o       : out    vl_logic_vector(17 downto 0);
        buffer2_o       : out    vl_logic_vector(17 downto 0);
        buffer3_o       : out    vl_logic_vector(17 downto 0);
        buffer4_o       : out    vl_logic_vector(17 downto 0)
    );
end take_in;
