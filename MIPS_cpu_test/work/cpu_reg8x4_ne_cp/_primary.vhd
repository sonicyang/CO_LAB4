library verilog;
use verilog.vl_types.all;
entity cpu_reg8x4_ne_cp is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        din             : in     vl_logic_vector(31 downto 0);
        iack            : in     vl_logic;
        intcrl_din      : in     vl_logic_vector(31 downto 0);
        wren            : in     vl_logic;
        mask            : in     vl_logic_vector(3 downto 0);
        dout            : out    vl_logic_vector(31 downto 0)
    );
end cpu_reg8x4_ne_cp;
