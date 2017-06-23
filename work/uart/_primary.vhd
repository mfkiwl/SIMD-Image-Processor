library verilog;
use verilog.vl_types.all;
entity uart is
    generic(
        CLK_FREQ        : integer := 50000000;
        BAUD            : integer := 115200
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        rx              : in     vl_logic;
        rx_data         : out    vl_logic_vector(7 downto 0);
        rx_valid        : out    vl_logic;
        tx              : out    vl_logic;
        tx_data         : in     vl_logic_vector(7 downto 0);
        tx_transmit     : in     vl_logic;
        tx_ready        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_FREQ : constant is 1;
    attribute mti_svvh_generic_type of BAUD : constant is 1;
end uart;
