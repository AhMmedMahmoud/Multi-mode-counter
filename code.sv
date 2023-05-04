/* Design */ 
module multi_mode_counter(mode,init,initialValue,clk,rst,who,winner,loser,count,GAMEOVER);

    //--------------defination part--------------
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
    parameter IDLE   = 1'b0;
    parameter RUNNING = 1'b1;
    // Inputs
    input wire [1:0]mode;
    input wire init, clk, rst;
    input wire [MULTICOUNTER_SIZE-1:0]initialValue;
    // Outputs
    output reg [MULTICOUNTER_SIZE-1:0]count;  // update at posedge of clock only
    output wire [1:0]who;
    output wire winner,loser;
    output reg GAMEOVER;
  
    //--------------physical part--------------
    // storing elements
    reg state;
    reg [3:0]winner_count;
    reg [3:0]loser_count;
    reg raised;
    // continous assignment
    assign loser = ( state == RUNNING && !rst && count == 0);
    assign winner = (!rst && count == MULTICOUNTER_MAX_VALUE);
    assign who = (!GAMEOVER)?0:((winner_count==COUNTERS_MAX_VALUE)?2'b10:2'b01);
	
  
    //--------------trigger part--------------
    // asychnrous reset
    always @(rst) begin
      if(rst) begin
      	 state <= IDLE;
         winner_count <= 0;
	     loser_count <= 0;
         GAMEOVER <= 0;
         count <= 0;
      end
    end
    // count logic
    always @(posedge clk) begin
      if(!rst) begin
          if(state == IDLE) begin
                   case(mode)
		       COUNT_UP_BY_1:	 count <= 0;        
	    	       COUNT_UP_BY_2:    count <= 0; 
		       COUNT_DOWN_BY_1:  count <= MULTICOUNTER_MAX_VALUE;
	               COUNT_DOWN_BY_2:  count <= MULTICOUNTER_MAX_VALUE;
                   endcase
                   state <= RUNNING;
          end
          else if(init == 1)
				   count <= initialValue;
          else if(raised == 1) begin
                   case(mode)
			       COUNT_UP_BY_1:	 count <= 0;        
	    	       COUNT_UP_BY_2:    count <= 0; 
		           COUNT_DOWN_BY_1:  count <= MULTICOUNTER_MAX_VALUE;
	               COUNT_DOWN_BY_2:  count <= MULTICOUNTER_MAX_VALUE;
                   endcase
                   raised <= 0;
          end
          else if(state == RUNNING)begin
                   case(mode)
			       COUNT_UP_BY_1:	 count <= count + 1;        
	    	       COUNT_UP_BY_2:    count <= count + 2; 
		           COUNT_DOWN_BY_1:  count <= count - 1;
	               COUNT_DOWN_BY_2:  count <= count - 2;
                   endcase 
          end
      end
   end	  
   // increase winner counter
   always @(posedge winner) begin
     if(!rst && GAMEOVER == 0)
   	   	winner_count <= winner_count + 1;
   end 
   // increase loser counter
   always @(posedge loser) begin
     if(!rst  && GAMEOVER == 0)
   	   loser_count <= loser_count + 1;
   end  
   // raise GAMEOVRE for one clock then down
   always @(loser_count or winner_count) begin
      if(loser_count == COUNTERS_MAX_VALUE || winner_count == COUNTERS_MAX_VALUE)
      begin
          GAMEOVER <= 1;
          raised <= 1;
          @(posedge clk);
          if(count == 0 && (mode == COUNT_UP_BY_1 || mode == COUNT_UP_BY_2) )
	      	loser_count <= 1;
          else
	      	loser_count <= 0;  
          if(count == MULTICOUNTER_MAX_VALUE && (mode == COUNT_DOWN_BY_1 || mode == COUNT_DOWN_BY_2) )
	      	winner_count <= 1;
          else
	      	winner_count <= 0;
          GAMEOVER <= 0;
      end  
   end 
  
endmodule



/* test bench */
module multi_mode_counter_tb;

  // switches
  reg clk;
  reg rst;
  reg [1:0] mode;
  reg init;
  reg [4:0] init_val;
  // to see their values with switches
  wire winner;
  wire loser;
  wire [1:0] who;
  wire gameover;
  wire [4:0] count;
  // clock cycle duration
  parameter CYCLE = 4;
  
  // Instantiate the DUT  
  multi_mode_counter dut  (mode,init,init_val,clk,rst,who,winner,loser,count,gameover);
  
  // Clock generation
  initial  begin
   forever #(CYCLE/2) clk <= ~clk;
  end
  
  // initialization
  initial begin
     clk = 0;
     init = 1'b0;
     rst = 1'b0;
     init_val = 5'b11111;
  end
  
  // Reset generation
  initial begin
    #3; 
    rst <= 1'b1;
    #6
    rst <= 1'b0;
  end
 
  // Test all combinations of control and initialization values
  initial begin
    mode <= 2'b11;
    #1000;   
    mode <= 2'b10;
    #200;
    mode <= 2'b01;
    #200;  
    
    rst <= 1'b1;
    #6;
    rst <= 1'b0;
    #20;
    
    mode <= 2'b00;
    #100;
    for(int i = 0 ; i < 32 ; i++)
    begin
      init = 1'b1;
      #9;
      init_val = i;
      #8;
      init = 1'b0;
      #8;
    end
  end
  
  initial begin
    $dumpfile("counter.vcd");
    $dumpvars;
    #3500 $finish;
  end
  
endmodule
