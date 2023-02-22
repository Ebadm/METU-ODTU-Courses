`timescale 1ns / 1ps
module QueueCounter(
	input [7:0] llmt,
	input [7:0] ulmt,
	input en,
	input mode, // 1:delete, 0:insert
	input clk,
	output reg [7:0] head,
	output reg [7:0] tail,
	output empty,
	output full);
	reg wf;
	reg we;
	


	initial
	begin
		head = llmt;
		tail = llmt;
		we = 1;
		wf = 0;
	end
	
	always@(posedge clk)
		begin
		if (en == 1) begin
			 if (mode == 0) begin
				if (head == tail) begin
					if (empty == 1) begin 
						if (tail != ulmt) begin  tail = tail  + 1; we = 0; end
						else begin tail = llmt; end
					end else begin tail = tail; end
				end else begin if (tail != ulmt) begin  tail = tail  + 1; we = 0; end else begin tail = llmt; end end
			 end 
			 else begin //mode is 1
			 if (empty == 0) begin
				if (head == tail) begin
					if (full == 1) begin wf = 0; end
						if (head != ulmt) begin head = head  + 1; end
						else begin head = llmt; end
				end else begin if (head != ulmt) begin head = head  + 1; end else begin head = llmt; end end
			end end
		if (head == tail && empty == 0 && mode == 0) begin wf = 1; end else begin wf = wf; end
		if (head == tail && full == 0 && mode == 1) begin we  = 1; end else begin we = we; end
		end
		else begin end
		end
		assign empty = we;
		assign full = wf;


endmodule


module Numerator(
	input clinic, 
	input mode, 
	input en, 
	input clk,
	output [7:0] ann,
	output [7:0] print);
	wire en1,en2;
	wire empty1,empty2;
	wire full1,full2;
	wire [7:0] head_1,tail_1,head_2,tail_2;
	
	wire [7:0] lower_1,lower_2,upper_1,upper_2;
	reg lower,upper;
	assign lower_1 = 5 ;assign lower_2 = 10; assign upper_1 = 9; assign upper_2 = 14;
	

	
	assign en1  =  en == 1 && (clinic == 0);
	assign en2  = en == 1 && (clinic == 1);

	QueueCounter q1 (.llmt(lower_1),.ulmt(upper_1) , .en(en1), .mode (mode), .clk(clk),.head(head_1), .tail(tail_1), .empty(empty1), .full(full1));
	QueueCounter q2 (.llmt(lower_2),.ulmt(upper_2) , .en(en2), .mode (mode), .clk(clk),.head(head_2), .tail(tail_2), .empty(empty2), .full(full2));
	
	
	assign head  = (clinic == 0) ? head_1 : head_2;
	assign tail  = (clinic == 0) ? tail_1 : tail_2;
	assign ann   = (clinic == 0) ? head_1 : head_2;
	assign print = (clinic == 0) ? tail_1 : tail_2;



endmodule
