library verilog;
use verilog.vl_types.all;
entity count_vlg_check_tst is
    port(
        L1              : in     vl_logic_vector(2 downto 0);
        L2              : in     vl_logic_vector(2 downto 0);
        L3              : in     vl_logic_vector(2 downto 0);
        L4              : in     vl_logic_vector(2 downto 0);
        LS              : in     vl_logic_vector(5 downto 0);
        RS              : in     vl_logic_vector(5 downto 0);
        sampler_rx      : in     vl_logic
    );
end count_vlg_check_tst;
