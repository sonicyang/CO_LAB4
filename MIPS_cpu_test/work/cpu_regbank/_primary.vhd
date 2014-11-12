library verilog;
use verilog.vl_types.all;
entity cpu_regbank is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        iack            : in     vl_logic;
        cp0_ins         : in     vl_logic;
        mf_cp0_ins      : in     vl_logic;
        read_reg1_num   : in     vl_logic_vector(4 downto 0);
        read_reg2_num   : in     vl_logic_vector(4 downto 0);
        read_reg3_num   : in     vl_logic_vector(4 downto 0);
        write_reg_num   : in     vl_logic_vector(4 downto 0);
        wb_w_cp0reg     : in     vl_logic;
        write_data      : in     vl_logic_vector(31 downto 0);
        read_data1      : out    vl_logic_vector(31 downto 0);
        read_data2      : out    vl_logic_vector(31 downto 0);
        cs_regwrite     : in     vl_logic;
        cs_write_mask   : in     vl_logic_vector(3 downto 0);
        id2intctl       : out    vl_logic_vector(31 downto 0);
        id_intctl_epc   : in     vl_logic_vector(31 downto 0);
        id_intctl_cause : in     vl_logic_vector(31 downto 0);
        id_intctl_status: in     vl_logic_vector(31 downto 0)
    );
end cpu_regbank;
