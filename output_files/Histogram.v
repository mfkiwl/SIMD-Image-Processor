module Histogram(clk, dataIn, histAddr, reset, enable, histOut, resetm);
parameter numBins = 8;

input clk;
input reset, enable, resetm;
input [7:0] dataIn;
input [$clog2(numBins) - 1:0] histAddr;
output reg [15:0] histOut;

reg [numBins / 2 - 1:0] i = 0;

reg [15:0] data [numBins - 1: 0];

wire [numBins - 1: 0] inc;
assign inc = 256 / numBins;

initial begin
for(i = 0; i < numBins; i = i + 1) 
begin
	data[i] = 0;
end
	end


always @(posedge clk)
begin
	if (reset | resetm)
	begin
		for(i = 0; i < numBins; i = i + 1) 
		begin
			data[i] = 0;
		end
	end
	
	else if(enable)
	begin
	
	
		for(i = 0; i < numBins; i = i  + 1) begin
			if(dataIn >= (i * inc) && dataIn < ((i + 1) * inc)) begin
				data[i]  = data[i] + 1;
			end
		end
	
	
	/*
	

		if (dataIn < 32) 
			data0 = data0 +1;
		else if (dataIn < 64)
			data1 = data1 +1;
		else if (dataIn < 96)
			data2 = data2 +1;
		else if (dataIn < 128)
			data3 = data3 +1;
		
		else if (dataIn < 160)
			data4 = data4 +1;
		else if (dataIn < 192)
			data5 = data5 +1;
		else if (dataIn < 224)
			data6 = data6 +1;
		else if (dataIn < 256)
			data7 = data7 +1;
*/
	end 
	
	
	if(i == numBins - 1) begin
	histOut = data[0];
	end

	for(i = 0; i < numBins - 1; i = i  + 1) begin

			if(i == histAddr) begin
				histOut = data[i + 1];
			end
		end
	
	
	/*
	case (histAddr)
	3'b000: histOut = data1;
	3'b001:histOut = data2;
	3'b010:histOut = data3;
	3'b011:histOut = data4;
	
	3'b100:histOut = data5;
	3'b101:histOut = data6;
	3'b110:histOut = data7;
	3'b111:histOut = data0;
	
	endcase*/
end 


endmodule