library verilog;
use verilog.vl_types.all;
entity uart_handler is
    generic(
        RAM_SIZE        : integer := 64;
        ADDR_BITS       : integer := 5
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        UART_TX         : out    vl_logic;
        UART_RX         : in     vl_logic;
        addr            : in     vl_logic_vector;
        writeEnable     : in     vl_logic;
        dataIn          : in     vl_logic_vector(7 downto 0);
        dataOut         : out    vl_logic_vector(7 downto 0);
        start           : in     vl_logic;
        ready           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RAM_SIZE : constant is 1;
    attribute mti_svvh_generic_type of ADDR_BITS : constant is 1;
end uart_handler;
