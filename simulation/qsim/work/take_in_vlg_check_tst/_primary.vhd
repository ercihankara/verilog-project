library verilog;
use verilog.vl_types.all;
entity take_in_vlg_check_tst is
    port(
        buffer1         : in     vl_logic_vector(18 downto 0);
        buffer2         : in     vl_logic_vector(18 downto 0);
        buffer3         : in     vl_logic_vector(18 downto 0);
        buffer4         : in     vl_logic_vector(18 downto 0);
        data            : in     vl_logic_vector(4 downto 0);
        drops           : in     vl_logic;
        holder          : in     vl_logic_vector(3 downto 0);
        opener          : in     vl_logic;
        outputer        : in     vl_logic_vector(4 downto 0);
        received_data   : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end take_in_vlg_check_tst;
