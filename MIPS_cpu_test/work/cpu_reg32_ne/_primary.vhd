library verilog;
use verilog.vl_types.all;
entity cpu_reg32_ne is
    port(
        irq             : in     vl_logic_vector(7 downto 0);
        epc             : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        din             : in     vl_logic_vector(31 downto 0);
        wren            : in     vl_logic;
        dout            : out    vl_logic_vector(31 downto 0);
        if_pc           : out    vl_logic_vector(31 downto 0);
        id_pc           : out    vl_logic_vector(31 downto 0);
        exe_pc          : out    vl_logic_vector(31 downto 0);
        mem_pc          : out    vl_logic_vector(31 downto 0);
        wb_pc           : out    vl_logic_vector(31 downto 0);
        iack            : in     vl_logic
    );
end cpu_reg32_ne;
