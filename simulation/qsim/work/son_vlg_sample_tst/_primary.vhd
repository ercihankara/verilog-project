library verilog;
use verilog.vl_types.all;
entity son_vlg_sample_tst is
    port(
        btn0            : in     vl_logic;
        btn1            : in     vl_logic;
        btnStart        : in     vl_logic;
        clk             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end son_vlg_sample_tst;
