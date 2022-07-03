library verilog;
use verilog.vl_types.all;
entity son_vlg_check_tst is
    port(
        buffer1         : in     vl_logic_vector(18 downto 0);
        buffer2         : in     vl_logic_vector(18 downto 0);
        buffer3         : in     vl_logic_vector(18 downto 0);
        buffer4         : in     vl_logic_vector(18 downto 0);
        inputReg        : in     vl_logic_vector(4 downto 0);
        sampler_rx      : in     vl_logic
    );
end son_vlg_check_tst;
