library verilog;
use verilog.vl_types.all;
entity top is
    generic(
        RAM_SIZE        : integer := 8;
        ADDR_BITS       : integer := 3;
        IDLE            : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        READ            : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        WRITE           : vl_logic_vector(0 to 1) := (Hi1, Hi0)
    );
    port(
        UART_RXD        : in     vl_logic;
        UART_TXD        : out    vl_logic;
        CLOCK_50        : in     vl_logic;
        KEY             : in     vl_logic_vector(0 downto 0);
        SW              : in     vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RAM_SIZE : constant is 1;
    attribute mti_svvh_generic_type of ADDR_BITS : constant is 1;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of READ : constant is 1;
    attribute mti_svvh_generic_type of WRITE : constant is 1;
end top;
