library verilog;
use verilog.vl_types.all;
entity take_in_vlg_check_tst is
    port(
        buffer1_o       : in     vl_logic_vector(17 downto 0);
        buffer2_o       : in     vl_logic_vector(17 downto 0);
        buffer3_o       : in     vl_logic_vector(17 downto 0);
        buffer4_o       : in     vl_logic_vector(17 downto 0);
        dataaa          : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end take_in_vlg_check_tst;
