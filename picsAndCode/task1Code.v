
/*
 * CLOCK_50 = clk
 * KEY[0] = reset
 */



module top(UART_RXD, UART_TXD, CLOCK_50, KEY);

// Declaration of inputs and outputs
input UART_RXD, CLOCK_50;
input [0:0] KEY;
output UART_TXD;

parameter RAM_SIZE = 28;
parameter ADDR_BITS = 5;

wire ready;


uart_handler # (RAM_SIZE, ADDR_BITS) uartHandler(.clk(CLOCK_50),
   .reset(KEY[0]),

   // RS232 Signals
   .UART_TX(UART_TXD),
   .UART_RX(UART_RXD),

   // Interfacing Signals
   .addr(0),
   .writeEnable(0),
   .dataIn(0),
	


   // Start and Ready Signals
   .start(ready), 
	.ready(ready));





endmodule