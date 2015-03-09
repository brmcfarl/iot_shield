module debouncer (output pressed, held, input button, clk, reset);

	localparam sample_time = 1000000-1; //20ms
	
	reg [19:0] timer;
	reg button_sample, button_debounced, button_debounced_d;
	//reg button_n = ~button;

	
	always @ (posedge clk) begin
		//timer
		if (reset) begin
			timer <= sample_time;
		end
		else begin
			timer <= timer-1;
			if (timer <= 0)
				timer <= sample_time;
		end
		
		if (reset) begin
			button_sample <= 0;
			button_debounced <= 0;
			button_debounced <=0;
		end
		else begin
			button_debounced_d <= button_debounced;
			if (timer <= 0) begin
				button_sample <= button;
				if (button_sample == button)
					button_debounced <= button;
			end
		end
	end
	
	
	assign held = button_debounced;
	assign pressed = button_debounced & ~button_debounced_d;

	
endmodule
	