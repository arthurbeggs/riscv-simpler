`ifndef PARAM
	`include "../Parametros.v"
`endif

//
// Caminho de dados processador RISC-V Pipeline
//
// 2019-1 Marcus Vinicius Lamar
//
 

module Datapath_PIPEM (
    // Inputs e clocks
    input  wire        iCLK, iCLK50, iRST,
    input  wire [31:0] iInitialPC,

    // Para monitoramento
    output wire [31:0] mPC,
    output wire [31:0] mInstr,
    output wire [31:0] mDebug,	
    input  wire [ 4:0] mRegDispSelect,
    output wire [31:0] mRegDisp,
	 output wire [31:0] mFRegDisp,
    input  wire [ 4:0] mVGASelect,
    output wire [31:0] mVGARead,
    output wire [31:0] mFVGARead,
	 output wire [31:0] mRead1,
	 output wire [31:0] mRead2,
	 output wire [31:0] mRegWrite,
	 output wire [31:0] mULA,
`ifdef RV32IMF
	 output wire [31:0] mFPALU,         // Fio de monitoramento da FPALU
	 output wire [31:0] mFRead1,        // Monitoramento Rs1 FRegister
	 output wire [31:0] mFRead2,        // Monitoramento Rs2 FRegister
	 output wire [31:0] mOrigAFPALU,    // Monitoramento entrada A da FPULA
	 output wire [31:0] mFWriteData,    // Para verificar o que esta entrando no FRegister
	 output wire		  mCFRegWrite,
	 output wire        oEX_FPALUReady,
`endif	 
	 


	// Sinais do Controle
	output wire	[31:0] wID_Instr,
	input wire         wID_CRegWrite,
	input wire 		    wID_COrigAULA,
	input wire 			 wID_COrigBULA,
	input wire 	[ 1:0] wID_COrigPC,
	input wire 	[ 1:0] wID_CMem2Reg,
	input wire 			 wID_CMemRead,
	input wire 			 wID_CMemWrite,
	input wire 	[ 4:0] wID_CALUControl,
`ifndef RV32IMF
	input wire 	[ 7:0] wID_InstrType,
`else
	input wire 	[12:0] wID_InstrType,
	input wire         wID_CFRegWrite, // Fio que vem da controladora e habilita escrita no FReg
	input wire  [ 4:0] wID_CFPALUControl,
	input wire         wID_CFPALUStart,
`endif
	 
    //  Barramento de Dados
    output wire        DwReadEnable, DwWriteEnable,
    output wire [ 3:0] DwByteEnable,
    output wire [31:0] DwAddress, DwWriteData,
    input  wire [31:0] DwReadData,

    // Barramento de Instrucoes
    output wire        IwReadEnable, IwWriteEnable,
    output wire [ 3:0] IwByteEnable,
    output wire [31:0] IwAddress, IwWriteData,
    input  wire [31:0] IwReadData,
	 
	 
	 
	 // Para Debug
	 output wire [      31:0] oiIF_PC,
	 output wire [      31:0] oiIF_Instr,
	 output wire [      31:0] oiIF_PC4,
	 output wire [ NIFID-1:0] oRegIFID,
	 output wire [ NIDEX-1:0] oRegIDEX,
	 output wire [NEXMEM-1:0] oRegEXMEM,
	 output wire [NMEMWB-1:0] oRegMEMWB,
	 output wire [      31:0] oWB_RegWrite	 
);





// Sinais de monitoramento e Debug
wire [31:0] wRegDisp, wFRegDisp, wVGARead, wFVGARead;
wire [ 4:0] wRegDispSelect, wVGASelect;

assign mPC					= PC; 
assign mInstr				= wIF_Instr;
assign mRead1				= wID_Read1;
assign mRead2				= wID_Read2;
assign mRegWrite			= wWB_RegWrite;
assign mULA					= wEX_ALUresult;
assign mDebug				= 32'h000ACE10;	// Ligar onde for preciso	
assign wRegDispSelect 	= mRegDispSelect;
assign wVGASelect 		= mVGASelect;
assign mRegDisp			= wRegDisp;
assign mVGARead			= wVGARead;

`ifdef RV32IMF
assign mFRegDisp			= wFRegDisp;
assign mFVGARead			= wFVGARead;
`else
assign mFRegDisp			= ZERO;
assign mFVGARead			= ZERO;
`endif

`ifdef RV32IMF
assign mFPALU				= wEX_FPALUResult;
assign mFRead1          = wEX_ForwardA;
assign mFRead2          = wEX_ForwardB;
assign mOrigAFPALU      = wEX_CFPALUControl; // Nao existe mais, estou colocando a operacao no lugar
assign mFWriteData      = wWB_RegWrite;
assign mCFRegWrite      = wWB_CFRegWrite;
assign oEX_FPALUReady   = wEX_FPALUReady;    // Para dar o feedback a controladora
`endif

assign oiIF_PC   	= PC;
assign oiIF_Instr = wIF_Instr;
assign oiIF_PC4   = wIF_PC4;

assign oRegIFID  = RegIFID;
assign oRegIDEX  = RegIDEX;
assign oRegEXMEM = RegEXMEM;
assign oRegMEMWB = RegMEMWB;

assign oWB_RegWrite = wWB_RegWrite;


// Registradores do Pipeline

// Quando fizer alguma modificação basta modificar esses parâmetros no Parametros.v
//parameter NIFID  = 96,
//			 NIDEX  = 198,
//			 NEXMEM = 149,
//			 NMEMWB = 144;

reg [ NIFID-1:0] RegIFID;
reg [ NIDEX-1:0] RegIDEX;
reg [NEXMEM-1:0] RegEXMEM;
reg [NMEMWB-1:0] RegMEMWB;

initial
	begin
		RegIFID  <= {NIFID {1'b0}};
		RegIDEX  <= {NIDEX {1'b0}};
		RegEXMEM <= {NEXMEM{1'b0}};
		RegMEMWB <= {NMEMWB{1'b0}};
	end



//=====================================================================//
//======================== Estagio IF =================================//
//=====================================================================//


// ****************************************************** 
// Definicao dos registradores	

reg  [31:0] PC;        // registrador PC

initial PC <= BEGINNING_TEXT;



// ****************************************************** 
// Instanciacao das estruturas 	
 
wire [31:0] wIF_PC4 = PC + 32'h00000004; 			// Calculo PC+4 // PC+4 do estagio IF


// Barramento da Memoria de Instrucoes  // Aqui eh so o barramento porque a memoria esta fora do datapath

assign      IwReadEnable      = ON;
assign      IwWriteEnable     = OFF;
assign      IwByteEnable      = 4'b1111;
assign      IwAddress         = PC;
assign      IwWriteData       = ZERO;
wire [31:0] wIF_Instr         = IwReadData; // Dado lido da memoria de instrucoes IF na variavel significa que o sinal esta sendo gerado na etapa IF



// ******************************************************
// multiplexadores	

wire [31:0] wIF_iPC;
always @(*)
	case(wID_COrigPC)
		2'b00:     wIF_iPC <= wIF_PC4;															// PC+4
      2'b01:     wIF_iPC <= wID_BranchResult ? wID_BranchPC: wID_PC4;				// Branches
      2'b10:     wIF_iPC <= wID_BranchPC;														// jal
      2'b11:     wIF_iPC <= wID_JalrPC;														// jalr
		default:	  wIF_iPC <= ZERO;
	endcase


// ****************************************************** 
// A cada ciclo de clock	

always @(posedge iCLK or posedge iRST) 
	if(iRST) 
		begin
			PC      	<= iInitialPC;
			RegIFID  <= {NIFID{1'b0}};
		end
	else 
		begin
		
		if (!wIF_Stall) // Verifica se o estagio IF nao esta em stall (se estiver, desabilita escrita em PC)
			PC <= wIF_iPC;
			
		
		if (wIFID_Flush) // "Zera" o registrador IFID, zerar eh colocar um NOP
			begin
				RegIFID[31: 0] <= PC;
				RegIFID[63:32]	<= 32'h00000013;  // NOP = addi x0,x0,0
				RegIFID[95:64] <= wIF_PC4;
			end	
		else
			if (!wIF_Stall) // Se o stall estiver ativado o RegIFID tambem nao pode ser alterado
				begin
					RegIFID[31: 0] <= PC;
					RegIFID[63:32] <= wIF_Instr;
					RegIFID[95:64] <= wIF_PC4; // PC+4 tambem esta sendo passado adiante no laboratorio por causa do jal e jalr
				end
		end
	

//=====================================================================//
//======================== Estagio ID =================================//
//=====================================================================//


// ****************************************************** 
// Definicao dos fios e registradores	

// IF/ID register wires
wire [31:0] wID_PC   	= RegIFID[31: 0]; // ID_PC eh o PC que esta no estagio ID
assign  		wID_Instr 	= RegIFID[63:32]; // Instrucao que estiver no estagio ID
wire [31:0] wID_PC4		= RegIFID[95:64];


// Instruction decode wires
wire [ 2:0] wID_Funct3	= wID_Instr[14:12]; // Decomposicao da instrucao
wire [ 4:0] wID_Rs1   	= wID_Instr[19:15];
wire [ 4:0] wID_Rs2   	= wID_Instr[24:20];
wire [ 4:0] wID_Rd		= wID_Instr[11: 7];


// ****************************************************** 
// Instanciacao das estruturas 	 

wire [31:0] wID_BranchPC	= wID_PC + wID_Immediate;                             // Somador para calcular o branch
wire [31:0] wID_JalrPC		= (wID_ForwardRs1 + wID_Immediate) & ~(32'h00000001); // Somador para calcular jalr


// Banco de Registradores 
wire [31:0] wID_Read1;    // Fios de saida do banco de registradores
wire [31:0] wID_Read2;

Registers REGISTERS0 (
	.iCLK(iCLK),
	.iRST(iRST),
	.iReadRegister1(wID_Rs1),
	.iReadRegister2(wID_Rs2),
	.iWriteRegister(wWB_Rd),
	.iWriteData(wWB_RegWrite),
	.iRegWrite(wWB_CRegWrite),
	.oReadData1(wID_Read1),
	.oReadData2(wID_Read2),
	 
   .iRegDispSelect(wRegDispSelect),    // seleção para display
   .oRegDisp(wRegDisp),                // Reg display
   .iVGASelect(wVGASelect),            // para mostrar Regs na tela
   .oVGARead(wVGARead)                 // para mostrar Regs na tela
);


`ifdef RV32IMF
wire [31:0] wID_FRead1;    // Fios de saida do banco de registradores de ponto flutuante
wire [31:0] wID_FRead2;

FRegisters REGISTERS1 (
    .iCLK(iCLK),
    .iRST(iRST),
    .iReadRegister1(wID_Rs1),
    .iReadRegister2(wID_Rs2),     
    .iWriteRegister(wWB_Rd),      
    .iWriteData(wWB_RegWrite),  
    .iRegWrite(wWB_CFRegWrite),   
    .oReadData1(wID_FRead1),      
    .oReadData2(wID_FRead2),     
	 
    .iRegDispSelect(wRegDispSelect),    // seleção para display
    .oRegDisp(wFRegDisp),                // Reg display
    .iVGASelect(wVGASelect),            // para mostrar Regs na tela
    .oVGARead(wFVGARead)                 // para mostrar Regs na tela 
);
`endif
	
	
// Unidade geradora do imediato 
wire [31:0] wID_Immediate;

ImmGen IMMGEN0 (
    .iInstrucao(wID_Instr),
    .oImm(wID_Immediate)
);



// Unidade de controle de Branches 
wire wID_BranchResult;

BranchControl BC0 (
    .iFunct3(wID_Funct3),
    .iA(wID_ForwardRs1), // Esta sendo feito o forward aqui!
	 .iB(wID_ForwardRs2),
    .oBranch(wID_BranchResult)
);


// Unidade de Forward e Harzard
wire 			wIF_Stall, wID_Stall, wEX_Stall, wMEM_Stall, wWB_Stall;
wire 			wIFID_Flush, wIDEX_Flush, wEXMEM_Flush, wMEMWB_Flush;
wire [2:0] 	wFwdA, wFwdB;
wire [2:0] 	wFwdRs1, wFwdRs2;

FwdHazardUnitM FHU0 (
	.iCLK(iCLK),
	.iID_Rs1(wID_Rs1),
	.iID_Rs2(wID_Rs2),
	.iID_Rd(wID_Rd),

	.iEX_Rs1(wEX_Rs1),
	.iEX_Rs2(wEX_Rs2),	
	.iEX_Rd(wEX_Rd),	
	
	.iMEM_Rd(wMEM_Rd),
	
	.iWB_Rd(wWB_Rd),
	
	.iID_InstrType(wID_InstrType),
	.iEX_InstrType(wEX_InstrType),
	.iMEM_InstrType(wMEM_InstrType),
	.iWB_InstrType(wWB_InstrType),
		
	.iBranch(wID_BranchResult),				// resultado do branch em ID
`ifdef RV32IMF
	.iEX_FPALUStart(wEX_CFPALUStart),
   .iEX_FPALUReady(wEX_FPALUReady),
`endif

	.oIF_Stall(wIF_Stall),			
	.oID_Stall(wID_Stall),			
	.oEX_Stall(wEX_Stall),
	.oMEM_Stall(wMEM_Stall),			
	.oWB_Stall(wWB_Stall),		
	.oIFID_Flush(wIFID_Flush),		
	.oIDEX_Flush(wIDEX_Flush),			
	.oEXMEM_Flush(wEXMEM_Flush),
	.oMEMWB_Flush(wMEMWB_Flush),
	
	.oFwdRs1(wFwdRs1),
	.oFwdRs2(wFwdRs2),
	.oFwdA(wFwdA),
	.oFwdB(wFwdB)
);





	
// ******************************************************
// multiplexadores	


wire [31:0] wID_ForwardRs1;
always @(*) 
	case(wFwdRs1)
		3'b000:   wID_ForwardRs1 <= wID_Read1;
		3'b001:   wID_ForwardRs1 <= wEX_ALUresult;
		3'b010:   wID_ForwardRs1 <= wMEM_ALUresult;
		3'b011:   wID_ForwardRs1 <= wWB_RegWrite;
//		3'b100:   wID_ForwardRs1 <= wID_PC4;
`ifdef RV32IMF
		3'b100:   wID_ForwardRs1 <= wEX_FPALUResult; // Nao sei se vai ser necessario ainda
`endif
		3'b101:   wID_ForwardRs1 <= wEX_PC4;
		3'b110:   wID_ForwardRs1 <= wMEM_PC4;
//		3'b111:   wID_ForwardRs1 <= wWB_PC4;
`ifdef RV32IMF
		3'b111:   wID_ForwardRs1 <= wMEM_FPALUResult; // Nao sei se vai ser necessario ainda
`endif
		default:  wID_ForwardRs1 <= ZERO;
	endcase



wire [31:0] wID_ForwardRs2;
always @(*) 
	case(wFwdRs2)
		3'b000:   wID_ForwardRs2 <= wID_Read2;
		3'b001:   wID_ForwardRs2 <= wEX_ALUresult;
		3'b010:   wID_ForwardRs2 <= wMEM_ALUresult;
		3'b011:   wID_ForwardRs2 <= wWB_RegWrite;
//		3'b100:   wID_ForwardRs2 <= wID_PC4;
`ifdef RV32IMF
		3'b100:   wID_ForwardRs2 <= wEX_FPALUResult; // Nao sei se vai ser necessario ainda
`endif
		3'b101:   wID_ForwardRs2 <= wEX_PC4;
		3'b110:   wID_ForwardRs2 <= wMEM_PC4;
//		3'b111:   wID_ForwardRs2 <= wWB_PC4;
`ifdef RV32IMF
		3'b111:   wID_ForwardRs2 <= wMEM_FPALUResult; // Nao sei se vai ser necessario ainda
`endif
		default:  wID_ForwardRs2 <= ZERO;
	endcase

	


// ****************************************************** 
// A cada ciclo de clock	

always @(posedge iCLK or posedge iRST)
	if (iRST) 
		RegIDEX <= {NIDEX{1'b0}};
	else
		if (wIDEX_Flush)
			RegIDEX <= {NIDEX{1'b0}};
		else
			if (!wID_Stall) // Necessita de stall qnd eh um load seguido de uma instrucao do tipo R
				begin
					RegIDEX[ 31:  0] <= wID_PC; 			  // 32
					RegIDEX[ 63: 32] <= wID_Read1; 		  // 32
					RegIDEX[ 95: 64] <= wID_Read2; 		  // 32
					RegIDEX[100: 96] <= wID_Rs1;			  // 5
					RegIDEX[105:101] <= wID_Rs2;			  // 5
					RegIDEX[110:106] <= wID_Rd;			  // 5
					RegIDEX[113:111] <= wID_Funct3;		  // 3					
					RegIDEX[118:114] <= wID_CALUControl;  // 5
					RegIDEX[		119] <= wID_COrigAULA;    // 1
					RegIDEX[		120] <= wID_COrigBULA;    // 1
					RegIDEX[    121] <= wID_CMemRead;  	  // 1
					RegIDEX[    122] <= wID_CMemWrite; 	  // 1
					RegIDEX[    123] <= wID_CRegWrite; 	  // 1
					RegIDEX[125:124] <= wID_CMem2Reg; 	  // 2
					RegIDEX[157:126] <= wID_Immediate; 	  // 32
					RegIDEX[189:158] <= wID_PC4;			  // 32
`ifndef RV32IMF
					RegIDEX[197:190] <= wID_InstrType;	  // 8
`else
					RegIDEX[202:190] <= wID_InstrType;	  // 13
					RegIDEX[    203] <= wID_CFRegWrite;   // 1
					RegIDEX[235:204] <= wID_FRead1;       // 32
					RegIDEX[267:236] <= wID_FRead2;       // 32
					RegIDEX[272:268] <= wID_CFPALUControl; // 5
					RegIDEX[    273] <= wID_CFPALUStart;   // 1
`endif
				end
				
				
//=====================================================================//
//======================== Estagio EX =================================//
//=====================================================================//


// ****************************************************** 
// Definicao dos fios e registradores	

// ID/EX register wires
wire [31:0] wEX_PC     			= RegIDEX[ 31:  0];
wire [31:0] wEX_Read1  			= RegIDEX[ 63: 32];
wire [31:0] wEX_Read2  			= RegIDEX[ 95: 64];
wire [ 4:0] wEX_Rs1				= RegIDEX[100: 96];
wire [ 4:0] wEX_Rs2				= RegIDEX[105:101];
wire [ 4:0] wEX_Rd				= RegIDEX[110:106];
wire [ 2:0] wEX_Funct3			= RegIDEX[113:111];
wire [ 4:0] wEX_CALUControl	= RegIDEX[118:114];
wire 			wEX_COrigAULA		= RegIDEX[    119];
wire			wEX_COrigBULA		= RegIDEX[    120];
wire 			wEX_CMemRead 		= RegIDEX[    121];
wire			wEX_CMemWrite		= RegIDEX[    122];
wire			wEX_CRegWrite		= RegIDEX[    123];
wire [ 1:0]	wEX_CMem2Reg		= RegIDEX[125:124];
wire [31:0] wEX_Immediate    	= RegIDEX[157:126];
wire [31:0] wEX_PC4				= RegIDEX[189:158];
`ifndef RV32IMF
wire [7:0]	wEX_InstrType		= RegIDEX[197:190];
`else
wire [12:0]	wEX_InstrType		= RegIDEX[202:190];
wire        wEX_CFRegWrite    = RegIDEX[    203];
wire [31:0] wEX_FRead1			= RegIDEX[235:204];
wire [31:0] wEX_FRead2        = RegIDEX[267:236];
wire [ 4:0] wEX_CFPALUControl = RegIDEX[272:268];
wire        wEX_CFPALUStart   = RegIDEX[    273];
`endif



// ****************************************************** 
// Instanciacao das estruturas 	 

// ALU 
wire [31:0] wEX_ALUresult; 

ALU ALU0 (
    .iControl(wEX_CALUControl),
    .iA(wEX_OrigAULA),
    .iB(wEX_OrigBULA),
    .oResult(wEX_ALUresult),
    .oZero()
);

`ifdef RV32IMF
//FPALU
wire        wEX_FPALUReady;
wire [31:0] wEX_FPALUResult;

FPALU FPALU0 (
    .iclock(iCLK),
    .icontrol(wEX_CFPALUControl),
    .idataa(wEX_ForwardA),          // Esse mux ja seleciona entre Reg e FReg (adicao minha)
    .idatab(wEX_ForwardB),          // Esse mux ja seleciona entre Reg e FReg (adicao minha)
	 .istart(wEX_CFPALUStart),       // Sinal de reset (start) que sera enviado pela controladora
	 .oready(wEX_FPALUReady),        // Output que sinaliza a controladora que a FPULA terminou a operacao
    .oresult(wEX_FPALUResult)
);

`endif

	
	
// ******************************************************
// multiplexadores


wire [31:0] wEX_ForwardA;
always @(*) 
	case(wFwdA)
		3'b000:   wEX_ForwardA <= wEX_Read1;		// Seleciona read1 do Reg
//		3'b001:   wEX_ForwardA <= wEX_ALUresult;
`ifdef RV32IMF
		3'b001:   wEX_ForwardA <= wEX_FRead1;     // Seleciona read1 do FReg
`endif
		3'b010:   wEX_ForwardA <= wMEM_ALUresult;
		3'b011:   wEX_ForwardA <= wWB_RegWrite;
//		3'b100:   wEX_ForwardA <= wID_PC4;
`ifdef RV32IMF
		3'b100:   wEX_ForwardA <= wMEM_FPALUResult;
`endif
//		3'b101:   wEX_ForwardA <= wEX_PC4;
		3'b110:   wEX_ForwardA <= wMEM_PC4;
//		3'b111:   wEX_ForwardA <= wWB_PC4;
		default:  wEX_ForwardA <= ZERO;
	endcase



wire [31:0] wEX_ForwardB;
always @(*) 
	case(wFwdB)
		3'b000:   wEX_ForwardB <= wEX_Read2;		// sem forward
//		3'b001:   wEX_ForwardB <= wEX_ALUresult;
`ifdef RV32IMF
		3'b001:   wEX_ForwardB <= wEX_FRead2;
`endif
		3'b010:   wEX_ForwardB <= wMEM_ALUresult;
		3'b011:   wEX_ForwardB <= wWB_RegWrite;
//		3'b100:   wEX_ForwardB <= wID_PC4;
`ifdef RV32IMF
		3'b100:   wEX_ForwardB <= wMEM_FPALUResult;
`endif
//		3'b101:   wEX_ForwardB <= wEX_PC4;
		3'b110:   wEX_ForwardB <= wMEM_PC4;
//		3'b111:   wEX_ForwardB <= wWB_PC4;
		default:  wEX_ForwardB <= ZERO;
	endcase


	

wire [31:0] wEX_OrigAULA;
always @(*)
    case(wEX_COrigAULA)
        1'b0:      wEX_OrigAULA <= wEX_ForwardA;
        1'b1:      wEX_OrigAULA <= wEX_PC;
		  default:	 wEX_OrigAULA <= ZERO;
    endcase

	 
wire [31:0] wEX_OrigBULA;
always @(*)
    case(wEX_COrigBULA)
        1'b0:      wEX_OrigBULA <= wEX_ForwardB;
        1'b1:      wEX_OrigBULA <= wEX_Immediate;
		  default:	 wEX_OrigBULA <= ZERO;
    endcase	 


	
	
// ****************************************************** 
// A cada ciclo de clock		

always @(posedge iCLK or posedge iRST)
	if (iRST)
		RegEXMEM <= {NEXMEM{1'b0}};
	else
		if (wEXMEM_Flush)
			RegEXMEM <= {NEXMEM{1'b0}};
		else
			if (!wEX_Stall) 
				begin
					RegEXMEM[ 31:  0] <= wEX_PC;
					RegEXMEM[ 63: 32] <= wEX_ALUresult;
					RegEXMEM[ 95: 64] <= wEX_ForwardB;
					RegEXMEM[     96] <= wEX_CMemRead;
					RegEXMEM[     97] <= wEX_CMemWrite;
					RegEXMEM[     98] <= wEX_CRegWrite;
					RegEXMEM[103: 99]	<= wEX_Rd;
					RegEXMEM[106:104] <= wEX_Funct3;
					RegEXMEM[108:107] <= wEX_CMem2Reg;
					RegEXMEM[140:109] <= wEX_PC4;
`ifndef RV32IMF
					RegEXMEM[148:141] <= wEX_InstrType;	// 8
`else
					RegEXMEM[153:141] <= wEX_InstrType;	// 13
					RegEXMEM[    154] <= wEX_CFRegWrite; // 1
					RegEXMEM[186:155] <= wEX_FPALUResult; //32
`endif
				end



//=====================================================================//
//======================== Estagio MEM ================================//
//=====================================================================//


// ****************************************************** 
// Definicao dos fios e registradores		

// EX/MEM register wires
wire [31:0] wMEM_PC            	= RegEXMEM[ 31:  0];
wire [31:0] wMEM_ALUresult      	= RegEXMEM[ 63: 32];
wire [31:0] wMEM_ForwardB 			= RegEXMEM[ 95: 64]; 
wire        wMEM_CMemRead        = RegEXMEM[     96];
wire        wMEM_CMemWrite       = RegEXMEM[     97];
wire        wMEM_CRegWrite      	= RegEXMEM[     98];
wire [ 4:0]	wMEM_Rd					= RegEXMEM[103: 99];
wire [ 2:0] wMEM_Funct3				= RegEXMEM[106:104];
wire [ 1:0] wMEM_CMem2Reg			= RegEXMEM[108:107];
wire [31:0] wMEM_PC4					= RegEXMEM[140:109];
`ifndef RV32IMF
wire [ 7:0] wMEM_InstrType			= RegEXMEM[148:141];
`else
wire [12:0] wMEM_InstrType		   = RegEXMEM[153:141];
wire        wMEM_CFRegWrite      = RegEXMEM[    154];
wire [31:0] wMEM_FPALUResult     = RegEXMEM[186:155];
`endif

// ****************************************************** 
// Instanciacao das estruturas 
		
		
// Unidade de controle de escrita 
wire [31:0] wMEM_MemDataWrite;
wire [ 3:0] wMEM_MemEnable;

MemStore MEMSTORE0 (
    .iAlignment(wMEM_ALUresult[1:0]),
    .iFunct3(wMEM_Funct3),
    .iData(wMEM_ForwardB),
    .oData(wMEM_MemDataWrite),
    .oByteEnable(wMEM_MemEnable),
    .oException()
);


// Barramento da memoria de dados 
assign 		DwReadEnable   = wMEM_CMemRead;
assign 		DwWriteEnable  = wMEM_CMemWrite;
assign 		DwByteEnable   = wMEM_MemEnable;
assign 		DwWriteData    = wMEM_MemDataWrite;
assign 		DwAddress      = wMEM_ALUresult;
wire [31:0] wMEM_ReadData 	= DwReadData;


// Unidade de controle de leitura 
wire [31:0] wMEM_MemLoad;

MemLoad MEMLOAD0 (
    .iAlignment(wMEM_ALUresult[1:0]),
    .iFunct3(wMEM_Funct3),
    .iData(wMEM_ReadData),
    .oData(wMEM_MemLoad),
    .oException()
);

	
// ******************************************************
// multiplexadores		
	


// ****************************************************** 
// A cada ciclo de clock	

always @(posedge iCLK or posedge iRST) 
	if (iRST) 
		RegMEMWB <= {NMEMWB{1'b0}};
	else 
		begin
		
		if (wMEMWB_Flush)
			RegMEMWB <= {NMEMWB{1'b0}};
		else
			if (!wMEM_Stall) 
				begin
					RegMEMWB[ 31:  0] <= wMEM_PC;
					RegMEMWB[ 63: 32] <= wMEM_MemLoad;
					RegMEMWB[ 95: 64] <= wMEM_ALUresult;				
					RegMEMWB[100: 96] <= wMEM_Rd;
					RegMEMWB[    101] <= wMEM_CRegWrite;
					RegMEMWB[103:102] <= wMEM_CMem2Reg;
					RegMEMWB[135:104] <= wMEM_PC4;
`ifndef RV32IMF
					RegMEMWB[143:136] <= wMEM_InstrType;
`else
					RegMEMWB[148:136] <= wMEM_InstrType;
					RegMEMWB[    149] <= wMEM_CFRegWrite;
					RegMEMWB[181:150] <= wMEM_FPALUResult;
`endif
				end
				
		end
		
	
//=====================================================================//
//======================== Estagio WB =================================//
//=====================================================================//


// ****************************************************** 
// Definicao dos fios e registradores		

//wire [31:0] wWB_PC  			= RegMEMWB[ 31:  0];		Evitar Warning
wire [31:0] wWB_MemLoad		= RegMEMWB[ 63: 32];
wire [31:0] wWB_ALUresult 	= RegMEMWB[ 95: 64];
wire [ 4:0] wWB_Rd			= RegMEMWB[100: 96];
wire        wWB_CRegWrite  = !wWB_Stall && RegMEMWB[    101];  // Stall em WB
wire [ 1:0] wWB_CMem2Reg 	= RegMEMWB[103:102];
wire [31:0] wWB_PC4			= RegMEMWB[135:104];
`ifndef RV32IMF
wire [ 7:0] wWB_InstrType   = RegMEMWB[143:136];
`else
wire [12:0] wWB_InstrType   = RegMEMWB[148:136];
wire        wWB_CFRegWrite  = !wWB_Stall && RegMEMWB[    149];
wire [31:0] wWB_FPALUResult = RegMEMWB[181:150];
`endif



// ****************************************************** 
// Instanciacao das estruturas 



// ******************************************************
// multiplexadores	

wire [31:0] wWB_RegWrite;
always @(*)
    case(wWB_CMem2Reg)
        2'b00:     wWB_RegWrite <= wWB_ALUresult;				// Tipo-R e Tipo-I
        2'b01:     wWB_RegWrite <= wWB_PC4;						// jalr e jal
        2'b10:     wWB_RegWrite <= wWB_MemLoad;					// Loads
`ifdef RV32IMF
		  2'b11:     wWB_RegWrite <= wWB_FPALUResult;         // Tipo-FR
`endif
        default:   wWB_RegWrite <= ZERO;
    endcase



// ****************************************************** 
// A cada ciclo de clock	


endmodule
