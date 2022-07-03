library verilog;
use verilog.vl_types.all;
entity test_vlg_sample_tst is
    port(
        key1            : in     vl_logic;
        key2            : in     vl_logic;
        start           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end test_vlg_sample_tst;
