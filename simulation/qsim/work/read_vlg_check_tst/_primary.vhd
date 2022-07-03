library verilog;
use verilog.vl_types.all;
entity read_vlg_check_tst is
    port(
        buffer1_open    : in     vl_logic_vector(17 downto 0);
        buffer2_open    : in     vl_logic_vector(17 downto 0);
        buffer3_open    : in     vl_logic_vector(17 downto 0);
        buffer4_open    : in     vl_logic_vector(17 downto 0);
        disp            : in     vl_logic_vector(1 downto 0);
        sampler_rx      : in     vl_logic
    );
end read_vlg_check_tst;
