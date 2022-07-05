library verilog;
use verilog.vl_types.all;
entity take_in is
    port(
        start           : in     vl_logic;
        clk             : in     vl_logic;
        key0            : in     vl_logic;
        key1            : in     vl_logic;
        data            : out    vl_logic_vector(4 downto 0);
        drops           : out    vl_logic;
        received_data   : out    vl_logic;
        buffer1         : out    vl_logic_vector(18 downto 0);
        buffer2         : out    vl_logic_vector(18 downto 0);
        buffer3         : out    vl_logic_vector(18 downto 0);
        buffer4         : out    vl_logic_vector(18 downto 0);
        opener          : out    vl_logic;
        holder          : out    vl_logic_vector(3 downto 0);
        outputer        : out    vl_logic_vector(4 downto 0);
        swa             : in     vl_logic
    );
end take_in;
