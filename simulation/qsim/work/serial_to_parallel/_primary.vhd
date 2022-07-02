library verilog;
use verilog.vl_types.all;
entity serial_to_parallel is
    port(
        sEEG            : in     vl_logic;
        nclk            : in     vl_logic;
        clk             : in     vl_logic;
        eegOut          : out    vl_logic_vector(3 downto 0)
    );
end serial_to_parallel;
