library verilog;
use verilog.vl_types.all;
entity read is
    port(
        clk             : in     vl_logic;
        disp            : out    vl_logic_vector(1 downto 0);
        buffer1_o       : in     vl_logic_vector(17 downto 0);
        buffer2_o       : in     vl_logic_vector(17 downto 0);
        buffer3_o       : in     vl_logic_vector(17 downto 0);
        buffer4_o       : in     vl_logic_vector(17 downto 0);
        buffer1_open    : out    vl_logic_vector(17 downto 0);
        buffer2_open    : out    vl_logic_vector(17 downto 0);
        buffer3_open    : out    vl_logic_vector(17 downto 0);
        buffer4_open    : out    vl_logic_vector(17 downto 0);
        read            : out    vl_logic
    );
end read;
