///////////////////////////////////////////////////////////////////////////////
//                   RISC-V SiMPLE - Compositor de Vídeo                     //
//                                                                           //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple        //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module video_compositor (
    input  [9:0] pixel_x_pos,
    input  [9:0] pixel_y_pos,
    input  [7:0] pixel_frame0,
    input  [7:0] pixel_frame1,
    input  frame_select_memory,
    input  frame_select_switch,

    output reg [7:0] pixel_red,
    output reg [7:0] pixel_green,
    output reg [7:0] pixel_blue
);

reg  frame_selected;

// XOR dos seletores de frame por memória e switch
assign frame_selected = frame_select_memory ^ frame_select_switch;

// TODO: montar debug dos registradores
always @ (*) begin
    if (frame_selected == 1'b0) begin
        pixel_red   = (pixel_frame0 & 8'b00000111) << 3'd5;
        pixel_green = (pixel_frame0 & 8'b00111000) << 3'd2;
        pixel_blue  = (pixel_frame0 & 8'b11000000);
    end
    else begin
        pixel_red   = (pixel_frame1 & 8'b00000111) << 3'd5;
        pixel_green = (pixel_frame1 & 8'b00111000) << 3'd2;
        pixel_blue  = (pixel_frame1 & 8'b11000000);
    end
end

endmodule

