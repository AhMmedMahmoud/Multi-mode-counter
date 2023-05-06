/* test bench */
module multi_mode_counter_tb;

  // clock cycle duration
  parameter CYCLE = 4;
  // Counters sizes
  parameter MULTI_MODE_COUNTER_WIDTH = 5;
  parameter COUNTERS_WIDTH = 4;
  // switches
  reg clk;
  reg rst;
  reg [1:0] mode;
  reg init;
  reg [MULTI_MODE_COUNTER_WIDTH-1:0] init_val;
  // to see their values with switches
  wire winner;
  wire loser;
  wire [1:0] who;
  wire gameover;
  wire [MULTI_MODE_COUNTER_WIDTH-1:0] count;

  
  // Instantiate the DUT  
  multi_mode_counter #(MULTI_MODE_COUNTER_WIDTH,COUNTERS_WIDTH) dut  (mode,init,init_val,clk,rst,who,winner,loser,count,gameover);
  
  // Clock generation
  initial  begin
   forever #(CYCLE/2) clk <= ~clk;
  end

  // generate stimuls
  initial begin
    
    clk <= 0;
    init <= 1'b0;
    rst <= 1'b0;
    init_val <= 5'b11111;

    // test rst in COUNT_DOWN_BY_2 mode
    // test count in  COUNT_DOWN_BY_2
    // test GAMEOVER due to winner
    // test winner in COUNT_DOWN_BY_2 mode
    mode <= 2'b11;
    #3; 
    rst <= 1'b1;
    #5;
    rst <= 1'b0;
    #920;   
    
    // test rst in COUNT_UP_BY_1 mode
    // test count in  COUNT_DOWN_BY_1
    // test GAMEOVER in COUNT_UP_BY_1 mode
    // test winner  and loser in COUNT_UP_BY_1 mode
    mode <= 2'b00;
    #12;
    rst <= 1'b1;
    #6;
    rst <= 1'b0;
    #2000;
    
    // test rst in COUNT_DOWN_BY_1 mode
    // count in  COUNT_DOWN_BY_1
    // test GAMEOVER in COUNT_DOWN_BY_1 mode
    // test winner  and loser in COUNT_DOWN_BY_1 mode
    mode <= 2'b10;
    #12;
    rst <= 1'b1;
    #6;
    rst <= 1'b0;
    #2000;
    
    // test rst in COUNT_UP_BY_2 mode
    // test count in  COUNT_UP_BY_2
    // test GAMEOVER
    // test winner  and loser in COUNT_UP_BY_2 mode
    mode <= 2'b01;
    #12;
    rst <= 1'b1;
    #6;
    rst <= 1'b0;
    #1600;
    
    // test init in different mode
    // test gameover with init
    // test switching between modes
    mode <= 2'b00;
    #20;
    for(int i = 0 ; i < 32 ; i++)
    begin
      init = 1'b1;
      #9;
      init_val = i;
      #8;
      init = 1'b0;
      #26;
    end
    
    mode <= 2'b01;
    #20;
    for(int i = 0 ; i < 32 ; i++)
    begin
      init = 1'b1;
      #9;
      init_val = i;
      #8;
      init = 1'b0;
      #26;
    end
    
    mode <= 2'b10;
    #20;
    for(int i = 0 ; i < 32 ; i++)
    begin
      init = 1'b1;
      #9;
      init_val = i;
      #8;
      init = 1'b0;
      #26;
    end
    
    mode <= 2'b11;
    #20;
    for(int i = 0 ; i < 32 ; i++)
    begin
      init = 1'b1;
      #9;
      init_val = i;
      #8;
      init = 1'b0;
      #26;
    end
    
  end
  
  initial begin
    $dumpfile("counter.vcd");
    $dumpvars;
    #12220 $finish;
  end
  
endmodule
