library verilog;
use verilog.vl_types.all;
entity take_in_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        key0            : in     vl_logic;
        key1            : in     vl_logic;
        start           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end take_in_vlg_sample_tst;
