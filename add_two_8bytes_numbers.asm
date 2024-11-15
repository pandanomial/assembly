Comment !

Midterm: Assembly Programming Part

Write a general-purpose program that is able to add two 8 bytes length numbers. 
Numbers are saved in EBX: EAX and EDX: ECX Consider this sample call:

Number1 = 1234567898765432h
Number2 = 1234567898765432h
!

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword


.data

testNum1 QWORD 1234567898765432h	; for testing number, eg 1234567898765432h
testNum2 QWORD 1234567898765432h	; for testing number, eg 1234567898765432h
Number1 QWORD 0				; eg. 1234567898765432h, default is 0
Number2 QWORD 0				; eg. 1234567898765432h, default is 0
sumTwoQwords TBYTE 0	; eg. 2468ACF130ECA864h, default is 0
 

.code

main PROC 

	; use testNum1 to create the lower half bytes of Number1 for later use, saved in eax
	mov eax, DWORD ptr testNum1[0]			
	
	; use testNum1 to create the higher half bytes of Number1 for later use, saved in ebx
	mov ebx, DWORD ptr testNum1[4]	; type QWORD returns 8 bytes, DWORD 4 bytes

	;  use testNum2 to create the lower half bytes of Number2 for later use, saved in ecx
	mov ecx, DWORD ptr testNum2[0]	
	
	;  use testNum2 to create the higher half bytes of Number2 for later use, saved in edx
	mov edx, DWORD ptr testNum2[4]	; type QWORD returns 8 bytes, DWORD 4 bytes



	; use above code, Numbers are saved in EBX: EAX and EDX: ECX
	; now assign values to Number1 and Number2

	; dump eax to Number1 to create the lower half bytes of Number1
	mov DWORD ptr Number1[0], eax			
	
	; dump ebx to Number1 to create the higher half bytes of Number1
	mov DWORD ptr Number1[4], ebx	; type QWORD returns 8 bytes, DWORD 4 bytes

	; dump ecx to Number2 to create the lower half bytes of Number2
	mov DWORD ptr Number2[0], ecx			
	
	; dump edx to Number1 to create the higher half bytes of Number2
	mov DWORD ptr Number2[4], edx	; type QWORD returns 8 bytes, DWORD 4 bytes
													 
	
	mov edx, 0	; clean start to be used for sum
	mov esi, 0	; index of first byte 
	mov ecx, 8	; loop counter, to move byte by byte to the final sumTwoQwords

	 
LoopTop:

	mov eax, 0				; clean start to be used for sum
	mov ebx, 0				; clean start to be used for sum
	mov al, byte ptr Number1[esi]		; use byte by byte to add together
	mov bl, byte ptr Number2[esi]		; use byte by byte to add together
	add ax, bx				; use byte by byte to add together
	add ax, dx				; dl used as carry, first round dx=0

	mov dl, ah				; dl used as carry
	mov byte ptr sumTwoQwords[esi], al	; move from al to sumTwoQwords

	inc esi					  ; increase 1 byte at a time

	LOOP LoopTop

	mov dl, ah				; dl used as the very last carry
	mov byte ptr sumTwoQwords[8], dl	; finally move the carry to sumTwoQwords 9th byte
						        ; eg. TBYTE sumTwoQwords=2468ACF130ECA864h 

 
	; test if carry dl = 0001h
	;mov dl, 0001h
	;mov byte ptr sumTwoQwords[8], dl	; finally move the carry to sumTwoQwords 9th byte
	; sumTwoQwords is TBYTE 10 bytes
	; test successful


	invoke ExitProcess,0

main ENDP
END main
 