; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    0AH,0DH,"Press Enter to Exit",0AH,0DH,0

         .DATA
F SDWORD ?
inpB DB 'Input b:',13,10,0
inpC DB 'Input c:',13,10,0
inpD DB 'Input d:',13,10,0
inpM DB 'Input m:',13,10,0
res DB 'Result=', 0
err DB 13,10,'Since M is a divisor, it cannot be equal to 0, so enter please another value...',13,10,0
valstr DB 15 DUP (' '), 0

         .DATA?
B SDWORD ?
CV SDWORD ?
D SDWORD ?
M SDWORD ?
buffer    DB    100 DUP (?)

         .CODE
Start:

        Invoke StdOut, ADDR inpB
        Invoke StdIn, ADDR buffer,LengthOf buffer
        Invoke StripLF, ADDR buffer
        Invoke atol, ADDR buffer
        mov SDWORD PTR B,EAX
        
        Invoke StdOut, ADDR inpC
        Invoke StdIn, ADDR buffer,LengthOf buffer
        Invoke StripLF, ADDR buffer
        Invoke atol, ADDR buffer
        mov SDWORD PTR CV,EAX
        
        Invoke StdOut, ADDR inpD
        Invoke StdIn, ADDR buffer,LengthOf buffer
        Invoke StripLF, ADDR buffer
        Invoke atol, ADDR buffer
        mov SDWORD PTR D,EAX
reenter:      
        Invoke StdOut, ADDR inpM
        Invoke StdIn, ADDR buffer,LengthOf buffer
        Invoke StripLF, ADDR buffer
        Invoke atol, ADDR buffer
        cmp EAX,0
        jne continue
        Invoke StdOut, ADDR err
        jmp reenter
continue:
        mov SDWORD PTR M,EAX

        mov EAX,CV
        sub EAX,D
        cmp EAX,10d
        jle less
        imul B
        mov F,EAX
        jmp continue2
        
less:     mov EAX,CV
          cdq
          idiv M
          mov F,EAX
continue2:

        Invoke dwtoa, F, ADDR valstr
        Invoke StdOut, ADDR res
        Invoke StdOut, ADDR valstr

         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR buffer,LengthOf buffer		
	
         Invoke ExitProcess,0
         End    Start

