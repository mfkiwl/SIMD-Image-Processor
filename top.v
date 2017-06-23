module top
#(parameter numLanes = 4)

(UART_RXD, UART_TXD, CLOCK_50, KEY, SW);


// Declaration of inputs and outputs
input UART_RXD, CLOCK_50;
input [0:0] KEY;
input [1:0] SW;
output UART_TXD;


parameter RAM_SIZE = 128;
parameter ADDR_BITS = 7;

wire ready;
reg start = 0;
reg nextStart = 0;

wire [7:0] dataOut;	// data that was read

reg [ADDR_BITS - 1:0] addr = 0;	// address we are accessing
reg [ADDR_BITS - 1:0] nextAddr = 5'b11111;

reg writeEnable = 0;
reg nextWriteEnable = 0;
reg [7:0] dataIn;	// data that was written to
reg [7:0] nextDataIn;

// State declarations
parameter IDLE = 0;
parameter READ = 1;
parameter WRITE = 2;
parameter INC = 3;
parameter LOAD_DATA_DISTRIBUTER = 4;
parameter SEND_DATA_DISTRIBUTER = 5;
parameter PREPARE_HISTOGRAM = 6;
parameter HISTOGRAM_INC = 7;
parameter COMPUTE_HIST_SUM = 8;

reg [0:3] currState = IDLE;
reg [0:3] nextState = IDLE;

wire [31:0] image_data_out;
reg [13:0] image_data_addr = 0;
wire image_received;
reg histogram_write_enable; 
reg next_histogram_write_enable;
reg [2:0] histogram_write_address = 0;
wire [15:0] histogram_data;
reg histogram_transmit = 0;
reg resetm;

reg [numLanes:0] i;	// incrementer for a for loop


reg [numLanes:0] histSumCounter = 0;
reg [numLanes:0] nextHistSumCounter = 0;



reg [12:0] next_image_data_addr = 0; //changed from 13 to 14 bits.

Data_Distributer dataDistributer(.clk(CLOCK_50),
   .reset(~KEY[0]),    // Active HIGH!!

   // Signals for reading image data
   .image_data_out(image_data_out),
   .image_data_address(image_data_addr[11:0]),
   //input wire [11:0] image_data_address,
   .image_received(image_received),

   // Signals for storing Histogram data
   .histogram_write_enable(histogram_write_enable),
    .histogram_write_address(histAddr),
   //input wire [2:0] histogram_write_address,
   .histogram_data(histSum),
   .histogram_transmit(histogram_transmit),

   // UART SIGNALS
   .UART_TX(UART_TXD),    // <---------------- May need these signals
   .UART_RX(UART_RXD));


wire [15:0] histOut [numLanes];
reg [15:0] histSum = 0;
reg [15:0] nextHistSum = 0;


reg [3:0] histAddr = 0;
reg[3:0] nextHistAddr = 0;
reg enable = 0;
reg nextEnable = 0;

reg [13:0] counter = 0;
reg [13:0] nextCounter = 0;
reg [2:0] count;

genvar j;

generate
	for (j = 0; j < numLanes; j = j + 1) begin : HIST
			Histogram H(CLOCK_50, image_data_out[(j + 1) * 8 - 1: j * 8], histAddr, ~KEY[0], enable, histOut[j], resetm);
		end
endgenerate


/*
Histogram hist1(CLOCK_50, image_data_out[31:24], histAddr, ~KEY[0], enable, histOut1, resetm);
Histogram hist2(CLOCK_50, image_data_out[23:16], histAddr, ~KEY[0], enable, histOut2, resetm);
Histogram hist3(CLOCK_50, image_data_out[15:8], histAddr, ~KEY[0], enable, histOut3, resetm);
Histogram hist4(CLOCK_50, image_data_out[7:0], histAddr, ~KEY[0], enable, histOut4, resetm);
*/




//assign histogram_data = histOut1 + histOut2 + histOut3 + histOut4;

// Sequential part of FSM
always @ (posedge CLOCK_50, negedge KEY[0])
begin
if(~KEY[0])
	currState <= IDLE;

else if(CLOCK_50)
	begin
	currState <= nextState;
	writeEnable <= nextWriteEnable;
	start <= nextStart;
	dataIn <= nextDataIn;
	addr <= nextAddr;
	
	enable <= nextEnable;
	
	histAddr <= nextHistAddr;
	
	histogram_write_enable <= next_histogram_write_enable;
	
	image_data_addr <= next_image_data_addr;
	
	histSum <= nextHistSum;
	
	histSumCounter <= nextHistSumCounter;
	

end

end


always @(*)
begin

nextState = currState;
nextAddr = addr;
nextWriteEnable = writeEnable;
nextStart = start;
nextDataIn = 0;
nextHistAddr = histAddr;
nextEnable = enable;
next_histogram_write_enable = histogram_write_enable;
next_image_data_addr = image_data_addr;
histogram_transmit = 0;
resetm = 0;


case(currState)

IDLE:
begin
	resetm = 1;
   nextAddr = 0;
	nextWriteEnable = 0;
	nextStart = 0;
	next_histogram_write_enable = 0;
	histogram_transmit = 0;
	i = 0;
	nextCounter = 0;
	//histSum = 0;
	/*
	if(ready)
	begin
		nextState = READ;
	end
	*/
	
	if(image_received)
	begin
		nextState = SEND_DATA_DISTRIBUTER;
		//nextEnable = 1;
		resetm = 0;
	end
	
end
  

SEND_DATA_DISTRIBUTER:
begin
	
	if(image_data_addr == 4096)
	begin
	  nextState = COMPUTE_HIST_SUM;
	  nextHistAddr = 0;
	  next_histogram_write_enable = 0;
	  nextEnable = 0;
	  count = 0;
	end
	  
	else begin
		nextEnable = 1;
		next_image_data_addr = image_data_addr + 1;
	  nextState = SEND_DATA_DISTRIBUTER;
	end
	
end


PREPARE_HISTOGRAM:
begin
 
	nextEnable = 0;

	//histSum= histOut[0] + histOut[1] +histOut[2] + histOut[3];
  if(histAddr == 8)
  begin
  

    histogram_transmit = 1; 
	 nextState = IDLE;
	 next_histogram_write_enable = 0;
  end
  else begin
  	 next_histogram_write_enable = 1;
	 nextHistSumCounter = 0;
    nextState = COMPUTE_HIST_SUM;
	 nextHistAddr = histAddr + 1;
  end
 //end
  
  
COPMUTE_HIST_SUM:
begin

	if(histSumCounter < numLanes)
	begin
		nextHistSum = histSum + histOut[i];	
		nextState = COMPUTE_HIST_SUM;
		nextHistSumCounter = histSumCounter + 1;
	end
	
	else
	begin
	
		nextState = PREPARE_HISTOGRAM;
		next_histogram_write_enable = 1;
	end

end  

end



endcase


end





endmodule