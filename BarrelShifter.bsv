import Vector::*;


function Bit#(32) multiplexer32(Bit#(1) sel, Bit#(32) a, Bit#(32) b);
    
	return (sel == 0)?a:b; 

endfunction

function Bit#(32) logicalBarrelShifter(Bit#(32) operand, Bit#(5) shamt);
    Bit#(32) ret = operand;
    Bit#(32) shift16 = 0; shift16[15:0] = ret[31:16];
    ret = multiplexer32(shamt[4], ret, shift16);
    Bit#(32) shift8 = 0; shift8[23:0] = ret[31:8];
    ret = multiplexer32(shamt[3], ret, shift8);
    Bit#(32) shift4 = 0; shift4[27:0] = ret[31:4];
    ret = multiplexer32(shamt[2], ret, shift4);
    Bit#(32) shift2 = 0; shift2[29:0] = ret[31:2];
    ret = multiplexer32(shamt[1], ret, shift2);   
    Bit#(32) shift1 = 0; shift1[30:0] = ret[31:1];
    ret = multiplexer32(shamt[0], ret, shift1);
    
    return ret;
endfunction

function Bit#(32) arithmeticBarrelShifter(Bit#(32) operand, Bit#(5) shamt);
    Bit#(32) ret = operand;
    Bit#(32) max32 = 'b11111111111111111111111111111111;
    Bit#(32) shift16 = (ret[31] ==0)?0:max32; shift16[15:0] = ret[31:16];
    ret = multiplexer32(shamt[4], ret, shift16);
    Bit#(32) shift8 = (ret[31] == 0)?0:max32; shift8[23:0] = ret[31:8];
    ret = multiplexer32(shamt[3], ret, shift8);
    Bit#(32) shift4 = (ret[31] == 0)?0:max32; shift4[27:0] = ret[31:4];
    ret = multiplexer32(shamt[2], ret, shift4);
    Bit#(32) shift2 = (ret[31] == 0)?0:max32; shift2[29:0] = ret[31:2];
    ret = multiplexer32(shamt[1], ret, shift2);
    Bit#(32) shift1 = (ret[31] == 0)?0:max32; shift1[30:0] = ret[31:1];
    ret = multiplexer32(shamt[0], ret, shift1);
    return ret;
endfunction

function Bit#(32) logicalLeftRightBarrelShifter(Bit#(1) shiftLeft, Bit#(32) operand, Bit#(5) shamt);
    Bit#(32) reversedOp;
    for (Integer i = 0; i < 32; i=i+1)
    begin 
        reversedOp[i] = operand[31-i];
    end
    Bit#(32) toShift = multiplexer32(shiftLeft, operand, reversedOp);
    Bit#(32) ret = logicalBarrelShifter(toShift, shamt);
    Bit#(32) reversedShifted;
    for (Integer i = 0; i < 32; i=i+1)
    begin
        reversedShifted[i] = ret[31-i];
    end
    return multiplexer32(shiftLeft, ret, reversedShifted);
endfunction

