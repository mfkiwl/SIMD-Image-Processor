
// RAM MODULE
module ramModule(writeData, writeEnable, addr, readData);     
  
  input [7:0] writeData;
  input writeEnable;
  input [11:0] addr;
  output reg [31:0] readData;
  reg [12:0] i;
  
  reg [1:0] bitFieldCounter = 0;
  
  (* ramstyle = "M4K" *) reg [31:0] memory [4095:0];	

  initial	// initialize contents of RAM
    begin
      for(i = 0; i < 4096; i = i + 1)
        begin
          memory[i] <= 0;
        end
    end
	 
  // occurs when positive edge of clock occurs
  always @ (*)
    begin 
      
      if(writeEnable)	
        begin
          // Write data to memory
			 if(bitFieldCounter == 0)
            memory[addr][7:0] = writeData;
				
			 else if(bitFieldCounter == 1)
			   memory[addr][15:8] = writeData;
				
			 else if(bitFieldCounter == 2)
			   memory[addr][23:16] = writeData;
			 
			 else
			   memory[addr][31:24] = writeData; 
        end
		  
		  readData = memory[addr];
    end

endmodule




