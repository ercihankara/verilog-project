library verilog;
use verilog.vl_types.all;
entity count is
    port(
        clk             : in     vl_logic;
        buffer1_o       : in     vl_logic_vector(17 downto 0);
        buffer2_o       : in     vl_logic_vector(17 downto 0);
        buffer3_o       : in     vl_logic_vector(17 downto 0);
        buffer4_o       : in     vl_logic_vector(17 downto 0);
        L1              : out    vl_logic_vector(2 downto 0);
        L2              : out    vl_logic_vector(2 downto 0);
        L3              : out    vl_logic_vector(2 downto 0);
        L4              : out    vl_logic_vector(2 downto 0);
        RS              : out    vl_logic_vector(5 downto 0);
        LS              : out    vl_logic_vector(5 downto 0)
    );
end count;
