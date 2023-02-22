`timescale 1ns / 1ps

module ROM (
input [2:0] addr, 
output reg [7:0] dataOut);

	// write your code below
	always@(*) 
	begin
		case (addr)
			3'b000: dataOut = 8'b00000000;
			3'b001: dataOut = 8'b01010101;
			3'b010: dataOut = 8'b10101010;
			3'b011: dataOut = 8'b00110011;
			3'b100: dataOut = 8'b11001100;
			3'b101: dataOut = 8'b00001111;
			3'b110: dataOut = 8'b11110000;
			3'b111: dataOut = 8'b11111111;
		endcase
	end
	
endmodule


module XOR_RAM (
input mode, 
input [2:0] addr, 
input [7:0] dataIn, 
input [7:0] mask, 
input CLK, 
output reg [7:0] dataOut);
	
	// write your code below
reg[7:0] temp[0:7];
reg [7:0] store;
reg [2:0] oya;

	initial begin
		temp[0] = 8'b00000000;
		temp[1] = 8'b00000000;
		temp[2] = 8'b00000000;
		temp[3] = 8'b00000000;
		temp[4] = 8'b00000000;
		temp[5] = 8'b00000000;
		temp[6] = 8'b00000000;
		temp[7] = 8'b00000000;
		dataOut = 8'b00000000;
		store = 8'b00000000;
	end


	always@(posedge CLK)
		begin
			if (mode==0) begin
				case (addr)
					3'b000: temp[0] <= (dataIn ^ mask);
					3'b001: temp[1] <= (dataIn ^ mask);
					3'b010: temp[2] <= (dataIn ^ mask);
					3'b011: temp[3] <= (dataIn ^ mask);
					3'b100: temp[4] <= (dataIn ^ mask);
					3'b101: temp[5] <= (dataIn ^ mask);
					3'b110: temp[6] <= (dataIn ^ mask);
					3'b111: temp[7] <= (dataIn ^ mask);
				endcase
			end
		end
		
	always@(*)
		begin
			if (mode==1)
				begin
				case (addr)
					3'b000: dataOut <= temp[0];
					3'b001: dataOut <= temp[1];
					3'b010: dataOut <= temp[2];
					3'b011: dataOut <= temp[3];
					3'b100: dataOut <= temp[4];
					3'b101: dataOut <= temp[5];
					3'b110: dataOut <= temp[6];
					3'b111: dataOut <= temp[7];
				endcase		
				end
		end
endmodule


module EncodedMemory (
input mode, 
input [2:0] index, 
input [7:0] number, 
input CLK, 
output [7:0] result);
	
	// DO NOT EDIT THIS MODULE
	
	wire [7:0] mask;
	
	ROM R(index, mask);
	XOR_RAM XR(mode, index, number, mask, CLK, result);

endmodule