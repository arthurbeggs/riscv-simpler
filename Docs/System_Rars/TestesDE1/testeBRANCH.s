
.text
ori t1, zero, 0x23
ori t2, zero, -3
branch:
bgtz t1, lessequalzero
ori t0, zero, 0xffff
lessequalzero:
blez t2, greaterequal
ori t0, zero, 0xfffe
greaterequal:
bgez t1, greaterandlink
ori t0, zero, 0xfffd
greaterandlink:
bgezal t1, lessthan
ori t0, zero, 0xfffc
lessthan:
bltz t2, lessandlink
ori t0, zero, 0xfffb
lessandlink:
bltzal t2, naobranch
ori t0, zero, 0xfffa


naobranch:
bgtz t2, label1
ori t0, zero, 0x0fff
label1:
blez t1, label2
ori t0, zero, 0x0ffe
label2:
bgez t2, label3
ori t0, zero, 0x0ffd
label3:
bgezal t2, label4
ori t0, zero, 0x0ffc
label4:
bltz t1, label5
ori t0, zero, 0x0ffb
label5:
bltzal t1, zeros
ori t0, zero, 0x0ffa

zeros:
bgtz zero, zero1
ori t0, zero, 0x00ff
zero1:
blez zero, zero2
ori t0, zero, 0x00fe
zero2:
bgez zero, zero3
ori t0, zero, 0x00fd
zero3:
bgezal zero, zero4
ori t0, zero, 0x00fc
zero4:
bltz zero, zero5
ori t0, zero, 0x00fb
zero5:
bltzal zero, fim
ori t0, zero, 0x00fa

fim: j fim


