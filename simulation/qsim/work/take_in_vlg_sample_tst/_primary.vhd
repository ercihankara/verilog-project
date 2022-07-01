library verilog;
use verilog.vl_types.all;
entity take_in_vlg_sample_tst is
    port(
        data            : in     vl_logic_vector(3 downto 0);
        start           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end take_in_vlg_sample_tst;
