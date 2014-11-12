library verilog;
use verilog.vl_types.all;
entity interrupt_controller is
    port(
        irq             : in     vl_logic_vector(5 downto 0);
        rst_n           : in     vl_logic;
        clk             : in     vl_logic;
        if_pc           : in     vl_logic_vector(31 downto 0);
        mem_pc          : in     vl_logic_vector(31 downto 0);
        intctl_epc      : out    vl_logic_vector(31 downto 0);
        intctl_status   : out    vl_logic_vector(31 downto 0);
        intctl_cause    : out    vl_logic_vector(31 downto 0);
        iack            : out    vl_logic;
        id2intctl_status: in     vl_logic_vector(31 downto 0)
    );
end interrupt_controller;
