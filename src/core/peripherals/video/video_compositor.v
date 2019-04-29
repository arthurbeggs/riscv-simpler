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

    input  osd_display,
    output [4:0]  reg_debug_address,
    input  [31:0] reg_debug_data,
    input  [31:0] pc,
    input  [31:0] inst,
    input  [31:0] epc,
    input  [3:0]  ecause,

    output reg [7:0] pixel_red,
    output reg [7:0] pixel_green,
    output reg [7:0] pixel_blue
);

localparam OSD_LINE_START   = 10'd24;
localparam OSD_LINE_END     = 10'd455;
localparam OSD_COLUMN_START = 10'd160;
localparam OSD_COLUMN_END   = 10'd479;

reg  [7:0] mem_data_red;
reg  [7:0] mem_data_green;
reg  [7:0] mem_data_blue;
reg  draw_char_pixel;
reg  frame_selected;
reg  is_osd_area;

// XOR dos seletores de frame por memória e switch
assign frame_selected = frame_select_memory ^ frame_select_switch;

always @ (*) begin
    if (   (pixel_y_pos >= OSD_LINE_START)   && (pixel_y_pos <= OSD_LINE_END)
        && (pixel_x_pos >= OSD_COLUMN_START) && (pixel_x_pos <= OSD_COLUMN_END))
    begin
        is_osd_area = 1'b1;
    end
    else is_osd_area = 1'b0;
end

// Seleção do frame
always @ (*) begin
    if (frame_selected == 1'b0) begin
        mem_data_red    = (pixel_frame0 & 8'b00000111) << 3'd5;
        mem_data_green  = (pixel_frame0 & 8'b00111000) << 3'd2;
        mem_data_blue   = (pixel_frame0 & 8'b11000000);
    end
    else begin
        mem_data_red    = (pixel_frame1 & 8'b00000111) << 3'd5;
        mem_data_green  = (pixel_frame1 & 8'b00111000) << 3'd2;
        mem_data_blue   = (pixel_frame1 & 8'b11000000);
    end
end

// OSD de depuração
always @ (*) begin
    if (~osd_display) begin
        pixel_red   = mem_data_red;
        pixel_green = mem_data_green;
        pixel_blue  = mem_data_blue;
    end
    else begin
        if (~is_osd_area) begin
            pixel_red   = mem_data_red;
            pixel_green = mem_data_green;
            pixel_blue  = mem_data_blue;
        end
        else begin
            if (draw_char_pixel) begin
                pixel_red   = 8'hD5;
                pixel_green = 8'hC4;
                pixel_blue  = 8'hA1;
            end
            else begin
                pixel_red   = mem_data_red   >> 3;
                pixel_green = mem_data_green >> 3;
                pixel_blue  = mem_data_blue  >> 3;
            end
        end
    end
end

///////////////////////////////////////////////////////////////////////////////
//                Mapeamento do On Screen Display de depuração               //
///////////////////////////////////////////////////////////////////////////////

// O OSD tem 24 linhas e 32 colunas de caracteres.
// Cada caracter possui 8px de largura e 16 de altura, além de 1px de borda nos
//    quatro lados. Então cada célula efetivamente tem 10x18px.
localparam CELL_WIDTH  = 4'd10;
localparam CELL_HEIGHT = 5'd18;

localparam C_0 = 5'h00; // 0
localparam C_1 = 5'h01; // 1
localparam C_2 = 5'h02; // 2
localparam C_3 = 5'h03; // 3
localparam C_4 = 5'h04; // 4
localparam C_5 = 5'h05; // 5
localparam C_6 = 5'h06; // 6
localparam C_7 = 5'h07; // 7
localparam C_8 = 5'h08; // 8
localparam C_9 = 5'h09; // 9
localparam C_A = 5'h10; // a
localparam C_C = 5'h11; // c
localparam C_E = 5'h12; // e
localparam C_F = 5'h13; // f
localparam C_G = 5'h14; // g
localparam C_I = 5'h15; // i
localparam C_N = 5'h16; // n
localparam C_O = 5'h17; // o
localparam C_P = 5'h18; // p
localparam C_R = 5'h19; // r
localparam C_S = 5'h1A; // s
localparam C_T = 5'h1B; // t
localparam C_U = 5'h1C; // u
localparam C_X = 5'h1D; // x
localparam SPC = 5'h1E; // Espaço
// localparam C__ = 5'h1F; // Indica que o dado deve ser recperado de outra tabela
localparam C__ = 5'h00; // Indica que o dado deve ser recperado de outra tabela
// localparam R_0 = {1'b0, reg_debug_data[31:28]};
// localparam R_1 = {1'b0, reg_debug_data[27:24]};
// localparam R_2 = {1'b0, reg_debug_data[32:20]};
// localparam R_3 = {1'b0, reg_debug_data[19:16]};
// localparam R_4 = {1'b0, reg_debug_data[15:12]};
// localparam R_5 = {1'b0, reg_debug_data[11:8]};
// localparam R_6 = {1'b0, reg_debug_data[7:4]};
// localparam R_7 = {1'b0, reg_debug_data[3:0]};

reg  [4:0] osd_line;
reg  [4:0] osd_column;
reg  [4:0] osd_character;
reg  [4:0] osd_cell_line;
reg  [3:0] osd_cell_column;
reg  [4:0] osd_cell_line_without_border;
reg  [3:0] osd_cell_column_without_border;
reg  [4:0] osd_cell_matrix [0:23] [0:31];

font font(
    .character  (osd_character),
    .line       (osd_cell_line_without_border[3:0]),
    .column     (osd_cell_column_without_border[2:0]),
    .draw_pixel (draw_char_pixel)
);

// Contador de linhas e colunas do OSD
always @ (*) begin
    if (is_osd_area) begin
        osd_line    = 5'((pixel_y_pos - OSD_LINE_START)   / CELL_HEIGHT);
        osd_column  = 5'((pixel_x_pos - OSD_COLUMN_START) / CELL_WIDTH);
    end
    else begin
        osd_line    = 5'b0;
        osd_column  = 5'b0;
    end
end

// Contador de linhas e colunas das células do OSD
always @ (*) begin
    if (is_osd_area) begin
        osd_cell_column  = 4'((pixel_x_pos - OSD_COLUMN_START) % CELL_WIDTH);
        osd_cell_line    = 5'((pixel_y_pos - OSD_LINE_START)   % CELL_HEIGHT);
    end
    else begin
        osd_cell_column  = 4'b0;
        osd_cell_line    = 5'b0;
    end
end

// Trata a borda de 1px dos caracteres
always @ (*) begin
    if (   (osd_cell_line > 4'd0)   && (osd_cell_line < (CELL_HEIGHT - 1'b1))
        && (osd_cell_column > 5'd0) && (osd_cell_column < (CELL_WIDTH - 1'b1)))
    begin
        osd_cell_column_without_border  = osd_cell_column -1'b1;
        osd_cell_line_without_border    = osd_cell_line - 1'b1;
        osd_character                   = osd_cell_matrix[osd_line][osd_column];
    end
    else begin
        osd_cell_column_without_border  = 4'b0;
        osd_cell_line_without_border    = 5'b0;
        osd_character                   = SPC;
    end
end

// Bloco de memória
// always @ (posedge clock) begin
always @ (*) begin
    osd_cell_matrix = '{
        '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
        '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
        '{SPC, SPC, C_X, C_0, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_A, C_6, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_R, C_A, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_A, C_7, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_S, C_P, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_2, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_G, C_P, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_3, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_T, C_P, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_4, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_T, C_0, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_5, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_T, C_1, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_6, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_T, C_2, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_7, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
        '{SPC, SPC, C_S, C_0, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_8, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_S, C_1, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_9, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_A, C_0, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_1, C_0, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_A, C_1, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_S, C_1, C_1, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_A, C_2, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_T, C_3, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_A, C_3, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_T, C_4, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_A, C_4, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_T, C_5, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_A, C_5, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_T, C_6, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
        '{SPC, SPC, C_P, C_C, SPC, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_I, C_N, C_S, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC},
        '{SPC, SPC, C_E, C_P, C_C, SPC, C__, C__, C__, C__, C__, C__, C__, C__, SPC, SPC, SPC, SPC, C_C, C_A, C_U, C_S, C_E, SPC, C__, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
        '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC},
        '{SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC, SPC}
    };
end

endmodule

