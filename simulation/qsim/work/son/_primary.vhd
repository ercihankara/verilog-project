library verilog;
use verilog.vl_types.all;
entity son is
    port(
        clk             : in     vl_logic;
        btnStart        : in     vl_logic;
        btn0            : in     vl_logic;
        btn1            : in     vl_logic;
        inputReg        : out    vl_logic_vector(4 downto 0);
        buffer1         : out    vl_logic_vector(18 downto 0);
        buffer2         : out    vl_logic_vector(18 downto 0);
        buffer3         : out    vl_logic_vector(18 downto 0);
        buffer4         : out    vl_logic_vector(18 downto 0)
    );
end son;
