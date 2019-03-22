module keyscan(
	input Reset,
	input PS2scan_ready,
	input [7:0] PS2scan_code,
	output reg [127:0] KeyMap
	);


	reg resetar;

	initial
		resetar=1'b0;
	
	always @(posedge PS2scan_ready, posedge Reset)
		if(Reset)
			begin
				KeyMap <= 128'b0;
				resetar <= 1'b0;
			end
		else
		if (PS2scan_code != 8'h00)
			begin
				if(PS2scan_code == 8'hF0)
					resetar <= 1'b1;
				else
					begin
						if(~PS2scan_code[7])	
							KeyMap[PS2scan_code[6:0]] <= ~resetar;  // Os scancodes >0x80 não são mapeados 
						resetar <= 1'b0;
					end
        end

endmodule
