/* code of multi_mode_counter */ 
module multi_mode_counter(mode,init,initialValue,clk,rst,who,winner,loser,count,GAMEOVER);

	/***********************************defination part*******************************/
	// multi mode counter parameters 
	parameter MULTICOUNTER_SIZE = 5;
	parameter MULTICOUNTER_MAX_VALUE = $pow(2, MULTICOUNTER_SIZE)-1;
	// Counters Parameters
	parameter COUNTERS_SIZE = 4;
	parameter COUNTERS_MAX_VALUE = $pow(2, COUNTERS_SIZE)-1;
	// counting modes
	parameter [1:0]COUNT_UP_BY_1   = 2'b00;
	parameter [1:0]COUNT_UP_BY_2   = 2'b01;
	parameter [1:0]COUNT_DOWN_BY_1 = 2'b10;
	parameter [1:0]COUNT_DOWN_BY_2 = 2'b11;
	// States
	parameter [1:0]IDLE     = 2'b00;
	parameter [1:0]COUNTING = 2'b01;
	parameter [1:0]LOADING  = 2'b10;
	// Inputs
	input wire [1:0]mode;
	input wire init;
	input wire [MULTICOUNTER_SIZE-1:0]initialValue;
	input wire clk;
	input wire rst;
	// Outputs
	output reg [MULTICOUNTER_SIZE-1:0]count;
	output wire [1:0]who;
	output wire winner;
	output wire loser;
	output wire GAMEOVER;
	
	
	/************************************physical part*****************************************/
	// storing elements
	reg [1:0]state;
	reg [1:0]next_state;
	reg [3:0]winner_count;
	reg [3:0]loser_count;
	// continous assignment
	assign loser = (count == 0);
	assign winner = (count == MULTICOUNTER_MAX_VALUE);
	assign GAMEOVER = ((winner_count==COUNTERS_MAX_VALUE)||(loser_count==COUNTERS_MAX_VALUE));
	assign who = (!GAMEOVER)?0:((winner_count==COUNTERS_MAX_VALUE)?2'b10:2'b01);
	
	
	/**************************************trigger part*****************************************/
	// State register and output logic
	always @(posedge clk or posedge rst) begin
	  if (rst == 1) begin
		  state <= IDLE;		
		  winner_count <= 0;
		  loser_count <= 0;
		  count <= 0;
		end
		else begin
		  state <= next_state;	
		  case(next_state)  IDLE:	   count <= 'bx;
			                  LOADING: count <= initialValue;     
			                  COUNTING:  begin   
			                     case(mode)
					                   COUNT_UP_BY_1:	   count <= count + 1;               
		                  	      COUNT_UP_BY_2:    count <= count + 2; 
				                     COUNT_DOWN_BY_1:  count <= count - 1;
	                           COUNT_DOWN_BY_2:  count <= count - 2;
                           endcase
       
                           if(count == 0) begin
                              if(loser_count==COUNTERS_MAX_VALUE) begin
	       	                       winner_count <= 0;
	       	                       loser_count <= 0;
	       	                    end
	       	                    else
	       	                       loser_count <= loser_count + 1;
	       	                 end  
	                         else if(count == MULTICOUNTER_MAX_VALUE)  begin
	                             if(winner_count==COUNTERS_MAX_VALUE) begin
	       	                        winner_count <= 0;
	       	                        loser_count <= 0;
	       	                   	 end
	       	                     else
                                  winner_count <= winner_count + 1;
                           end             
	       	                 else if((winner_count==COUNTERS_MAX_VALUE)||(loser_count==COUNTERS_MAX_VALUE)) begin
	       	               	    winner_count <= 0;
	       	                    loser_count <= 0;
	       	                 end	               
					             end    
		   endcase	 
	  end
	end
	
	
	// Next state logic
	always @(rst,state,init,mode) begin
			case(init)			1'b0 :	  next_state <= COUNTING;		
						       1'b1 :	  next_state <= LOADING;	
						       default: next_state <= COUNTING;
			endcase	   	
	end	
endmodule



/* test bench of multiCounter */
module multi_mode_counter_tb;
  
  // set size of multicounter
  parameter MULTICOUNTER_SIZE = 5;
  // switches
  reg clk;
  reg rst;
  reg [1:0] mode;
  reg init;
  reg [MULTICOUNTER_SIZE-1:0] init_val;
  // to see their values with switches
  wire winner;
  wire loser;
  wire [1:0] who;
  wire gameover;
  wire [MULTICOUNTER_SIZE-1:0]count;
  // set time of clock cycle
  parameter CYCLE = 4;
  // Instantiate the DUT  
  multi_mode_counter dut (mode,init,init_val,clk,rst,who,winner,loser,count,gameover);
 
  // Clock generation
  initial  begin
   clk <= 0;
   forever #(CYCLE/2) clk <= ~clk;
  end

  // Reset generation
  initial begin
    rst <= 1'b0;
    #10 
    rst <= 1'b1;
    #10;
    rst <= 1'b0;
  end

  // Test all possible combinations of control and initialization values
  initial begin
    for (int i = 0; i < 2; i++) begin
      for (int j = 0; j < 4; j++) begin
        mode = j;
        #200;
      end
    end
    init_val = 5'b10010;
    init = 1;
    #12;
    init = 0;
    #200;
  end
endmodule
