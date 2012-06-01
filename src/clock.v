module vsync(line_clk, vsync_out, blank_out);
   input line_clk;
   output vsync_out;
   output blank_out;
   
   reg [10:0] count = 10'b0000000000;
   reg vsync  = 0;
   reg blank  = 0;

   always @(posedge line_clk)
	 if (count < 666)
	   count <= count + 1;
	 else
	   count <= 0;
   
   always @(posedge line_clk)
	 if (count < 600)
	   blank 		<= 0;
	 else
	   blank 		<= 1;
      
   always @(posedge line_clk)
	 begin
		if (count < 637)
		  vsync 	<= 1;
		else if (count >= 637 && count < 643)
		  vsync 	<= 0;
		else if (count >= 643)
		  vsync 	<= 1;
	 end

   assign vsync_out  = vsync;
   assign blank_out  = blank;
   
endmodule // hsync   

module hsync(clk50, hsync_out, blank_out, newline_out);
   input clk50;
   output hsync_out, blank_out, newline_out;
   
   reg [10:0] count = 10'b0000000000;
   reg hsync 	= 0;
   reg blank 	= 0;
   reg newline 	= 0;

   always @(posedge clk50)
	 begin
		if (count < 1040)
		  count  <= count + 1;
		else
		  count  <= 0;
	 end
   
   always @(posedge clk50)
	 begin
		if (count == 0)
		  newline <= 1;
		else
		  newline <= 0;
	 end

   always @(posedge clk50)
	 begin
		if (count >= 800)
		  blank  <= 1;
		else
		  blank  <= 0;
	 end

   always @(posedge clk50)
	 begin
		if (count < 856) // pixel data plus front porch
		  hsync <= 1;
		else if (count >= 856 && count < 976)
		  hsync <= 0;
		else if (count >= 976)
		  hsync <= 1;
	 end // always @ (posedge clk50)
				 
   assign hsync_out    = hsync;
   assign blank_out    = blank;
   assign newline_out  = newline;
   
endmodule // hsync


module color(clk, blank, red_out, green_out, blue_out);
   input clk, blank;
   output red_out, green_out, blue_out;

   reg [8:0] count;
   
   always @(posedge clk)
	 begin
		if (blank)
		  count 	<= 0;
		else
		  count 	<= count + 1;
	 end

   assign red_out 	 = count[8];
   assign green_out  = count[7];
   assign blue_out 	 = count[6];
   
endmodule // color


module top(clk50, hsync_out, vsync_out, red_out, blue_out, green_out);
   input clk50;
   output hsync_out, vsync_out, red_out, blue_out, green_out;
   wire line_clk, blank, hblank, vblank;
   
   hsync   hs(clk50, hsync_out, hblank, line_clk);
   vsync   vs(line_clk, vsync_out, vblank);   
   color   cg(clk50, blank, red_out, green_out, blue_out);

   assign blank 	 = hblank || vblank;

endmodule // top
