library verilog;
use verilog.vl_types.all;
entity count_vlg_sample_tst is
    port(
        buffer1_o       : in     vl_logic_vector(17 downto 0);
        buffer2_o       : in     vl_logic_vector(17 downto 0);
        buffer3_o       : in     vl_logic_vector(17 downto 0);
        buffer4_o       : in     vl_logic_vector(17 downto 0);
        clk             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end count_vlg_sample_tst;
