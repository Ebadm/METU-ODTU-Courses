`timescale 1ns / 1ps
module IntersectionSimulator(
	input [2:0] mode, //1xx:display, 000:remA, 001:remB, 010:addA, 011:addB
	input [4:0] plateIn,
	input action,
	input clk,
	output reg  greenForA,
	output reg  greenForB,
	output reg 	rushHourWarning,
	output reg [3:0]  hour,
	output reg [5:0]  minute,	
	output reg [5:0]  second,
	output reg	am_pm, //0:am, 1:pm
	output reg [4:0]  numOfCarsA,
	output reg [4:0]  numOfCarsB,
	output reg [6:0]  remainingTime,
	output reg [4:0]  blackListDisplay
	);
	
	//You may write your code anywhere
	reg [4:0] carqueueA [0:29];
	reg [4:0] carqueueB [0:29];
	reg [4:0] Blacklist [0:29];
	integer i;
	reg [5:0] RushminB; // 101000
	reg [6:0] RushmaxB; //1000110
	reg [5:0] RegularminB; //110010
	reg [6:0] RegularmaxB; //1010000
	reg [4:0] RushminA; //11110
	reg [5:0] RushmaxA; //111100
	reg [5:0] RegularminA; //101000
	reg [6:0] RegularmaxA; //1000110
	reg [6:0] RedA; 
	reg [6:0] RedB;
	reg [6:0] current_turn_A;
	reg [6:0] current_turn_B;
	reg change_lightToA;
	reg change_lightToB;
	reg [6:0] NumBlacklistedcars;
	reg [6:0] BLCDC;
	reg mytempdebugger;
		
	initial begin
		greenForA=1;
		greenForB=0;
		rushHourWarning=0;
		hour=6;
		minute=0;
		second=0;
		am_pm=0;
		numOfCarsA=0;
		numOfCarsB=0;
		remainingTime=50;
		blackListDisplay=0;
		
		
		mytempdebugger = 1;
		BLCDC = 0;
		NumBlacklistedcars = 0;
		current_turn_A = 40;
		current_turn_B = 50;
		change_lightToB = 0;
		change_lightToA = 0;
		RushminB = 6'd40;
		RushmaxB = 7'd70;
		RegularminB = 6'd50;
		RegularmaxB = 7'd80;
		RushminA = 5'd30;
		RushmaxA = 6'd60;
		RegularminA = 6'd40;
		RegularmaxA = 7'd70;
		RedA = 7'd40;
		RedB = 7'd50;
		
		for (i = 0; i < 30; i = i + 1) begin
			carqueueA[i] = 5'b00000;
		end
		for (i = 0; i < 30; i = i + 1) begin
			carqueueB[i] = 5'b00000;
		end
		for (i = 0; i < 30; i = i + 1) begin
			Blacklist[i] = 5'b00000;
		end
		
	end


	always@(posedge action)
	begin
		if (mode == 3'b000 && numOfCarsA > 0) begin
			if (greenForA == 0) begin Blacklist[NumBlacklistedcars] = carqueueA[0] ; NumBlacklistedcars = NumBlacklistedcars + 1; end
			for (i = 0; i < numOfCarsA; i = i + 1) begin
				carqueueA[i] = carqueueA[i+1];
			end
			numOfCarsA=numOfCarsA-1;
		end           //??
		
		else if (mode == 3'b001 && numOfCarsB > 0) begin 
			if (greenForB == 0) begin Blacklist[NumBlacklistedcars] = carqueueB[0] ; NumBlacklistedcars = NumBlacklistedcars + 1; end
			for (i = 0; i < numOfCarsB; i = i + 1) begin
				carqueueB[i] = carqueueB[i+1];
			end
			numOfCarsB=numOfCarsB-1;
		end  
		
		else if (mode == 3'b010) begin  carqueueA[numOfCarsA] = plateIn; numOfCarsA=numOfCarsA+1; end
		else if (mode == 3'b011) begin carqueueB[numOfCarsB] = plateIn; numOfCarsB=numOfCarsB+1;end
	end


	always @(posedge clk)
	begin
		
		
		if (mode === 3'b1xx ) begin 
			//$display("mode is 1xx naaaaaaaaaaaaaaaaaaaaaaaaa %b",mode);
			if (Blacklist[0]==0) begin blackListDisplay=0; end
			else if (Blacklist[1]==0) begin  blackListDisplay=Blacklist[0]; end
			else begin 
				blackListDisplay = Blacklist[BLCDC];
				BLCDC = BLCDC + 1;
				if (BLCDC == NumBlacklistedcars) begin BLCDC = 0; end
				end
			end        //??


		else begin
			blackListDisplay = blackListDisplay;
			BLCDC = 0;
			//$display("else");
			//$display("mode is in else but %b",mode);
			if (second == 59) begin
				second = 0;
				if (minute == 59) begin
					minute = 0;
					if(hour == 12) begin
						hour = 1;
					end
					else begin 
						hour = hour + 1; 
						if (hour == 12) begin am_pm = !am_pm; end
					end
					
				end
				else begin minute = minute + 1; end
			end
			else begin second = second + 1; end
			
			if (rushHourWarning == 0) begin 
				if ( (hour == 7 && minute == 0 && second == 0 && am_pm == 0) || (hour == 5 && minute == 0 && second == 0 && am_pm == 1)) begin
					rushHourWarning = 1;
				end
			end
			else begin
				if ( (hour == 9 && minute == 0 && second == 0 && am_pm == 0) || (hour == 7 && minute ==0 && second == 0 && am_pm == 1)) begin
					rushHourWarning = 0;
				end
			end
			
			if (greenForA == 1) begin  
				if (remainingTime == 1) begin
					greenForA = 0;
					change_lightToA = 1;
					remainingTime = 0;
				end
				else begin remainingTime = remainingTime -1; end                           //RedB = RedB - 1; end
			end
			else if (greenForB == 1) begin  
				if (remainingTime == 1) begin
					greenForB = 0;
					change_lightToB = 1;
					remainingTime = 0;
				end
				else begin remainingTime = remainingTime -1; end                           //RedA = RedA - 1; end
			end
			else if (change_lightToB == 1) begin
				//$display("Changed To B RED, B-Red time = %d, numOfCarsB= %d",current_turn_B,numOfCarsB);
				greenForA = 1;
				remainingTime = current_turn_B;
				change_lightToB = 0;
				if (rushHourWarning == 1) begin
					if (numOfCarsA < 11) begin
						if (current_turn_A < RushmaxA) begin current_turn_A = current_turn_A + 5; end 
						else begin current_turn_A = RushmaxA;  end 
					end
					else if (numOfCarsA > 10 && numOfCarsA < 20 ) begin
						current_turn_A  = current_turn_A;
					end
					else begin
						if ( current_turn_A > RushminA) begin current_turn_A = current_turn_A - 5; end
						else begin current_turn_A = RushminA; end
					end
				end
				else begin
					if (numOfCarsA < 11) begin
						if (current_turn_A < RegularmaxA) begin current_turn_A = current_turn_A + 5; end 
						else begin current_turn_A = RegularmaxA;  end 
					end
					else if (numOfCarsA > 10 && numOfCarsA < 20 ) begin
						current_turn_A  = current_turn_A;
					end
					else begin
						if ( current_turn_A > RegularminA) begin current_turn_A = current_turn_A - 5; end
						else begin current_turn_A = RegularminA; end 
					end
				end
				
			end
			else if (change_lightToA == 1) begin
				//$display("Changed To A RED, A-Red time = %d, numOfCarsA= %d",current_turn_A,numOfCarsA);
				greenForB = 1; 
				remainingTime = current_turn_A;
				change_lightToA = 0;
				if (rushHourWarning == 1) begin
					if (numOfCarsB < 11) begin
						if (current_turn_B < RushmaxB) begin current_turn_B = current_turn_B + 5; end 
						else begin current_turn_B = RushmaxB;  end 
					end
					else if (numOfCarsB > 10 && numOfCarsB < 20 ) begin
						current_turn_B  = current_turn_B;
					end
					else begin
						//$display("GREATER THAN 20 Rush YESSS");
						if (current_turn_B > RushminB) begin current_turn_B = current_turn_B - 5; end 
						else begin current_turn_B = RushminB;  end 
					end
				end
				else begin
					if (numOfCarsB < 11 ) begin
						if (current_turn_B < RegularmaxB) begin current_turn_B = current_turn_B + 5; end 
						else begin current_turn_B = RegularmaxB;  end 
					end
					else if (numOfCarsB > 10 && numOfCarsB < 20 ) begin
						current_turn_B  = current_turn_B;
					end
					else begin
						//$display("GREATER THAN 20 REG YESSS");
						if (current_turn_B > RegularminB) begin current_turn_B = current_turn_B - 5; end 
						else begin current_turn_B = RegularminB;  end 
					end
				end
				
			end
			
			if (hour == 12 && minute == 0 && second == 0 && am_pm == 0) begin 
				blackListDisplay=0;
				for (i = 0; i < 30; i = i + 1) begin
					Blacklist[i] = 5'b00000;
				end
			end //midnight check first.
			
		end
		
	end

endmodule

//add rush/regular difference, min max with car number update the remaining time. 11/6/12/14/15?/
