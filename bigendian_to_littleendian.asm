
; Convert a doubleword from Big Endian order to Little Endian

; below is Block comment
Comment !
1. Converting from Big Endian to Little Endian
Write a program that uses the variables below and MOV instructions to copy the value from bigEndian to littleEndian, reversing the order of the bytes. The number’s 32-bit value is under- stood to be 12345678 hexadecimal.

    .data
    bigEndian BYTE 12h,34h,56h,78h
    littleEndian DWORD?
!



; below is another way to do Block comment
Comment &
1. Converting from Big Endian to Little Endian
Write a program that uses the variables below and MOV instructions to copy the value from bigEndian to littleEndian, reversing the order of the bytes. The number’s 32-bit value is under- stood to be 12345678 hexadecimal.

    .data
    bigEndian BYTE 12h,34h,56h,78h
    littleEndian DWORD?
&



; contains the .386 directive, which identifies this asa 32-bit program
; so it can access 32-bit registers and addresses.
.386


; selects program's memory model as flat. identifies the calling convention,
; which is named stdcall for the procedures because windows services require 
; stdcall convention.
.model flat,stdcall


; seta aside 4049 bytes of storage for runtime stack, every program must have
.stack 4096


; ExitProcess function is standard windows services.
; a prototype consists of function name, the proto as keyword , comma and a list
; of input parameter. the input parameter for ExitProcess isnamed dwExitCode. it
; can be regard as return value passed back to window operating system. 
; if return value is 0, then the program is successful.
ExitProcess proto, dwExitCode:dword


.data

; in memory stored as (small address 0000) 12h->34->56->78h (large address 0003)
bigEndian BYTE 12h,34h,56h,78h ; array, total 4 bytes

littleEndian DWORD ? ;need to be assigned with combined bytes, which is 4. 

.code

; PROC means proceduer
main proc

    ;Big-endian and little-endian are two ways to represent endianness.
    
    ;Big-endian keeps the most significant byte of a word at the smallest memory location 
    ;and the least significant byte at the largest.
    
    ;little-endian keeps the least significant address at the smallest memory location.

    ;--------------------------------------------------
    ;eg
    ;use array with index
    ;myArrWord WORD 1000h, 2000h, 3000h
    ;mov  esi 0 
    ;mov  ax,[myArrWord+esi] ; ax=1000h
    ;add  esi 2
    ;mov  ax,[myArrWord+esi] ; ax=2000h

    ;e.g.
    ;mov  esi 0 
    ;mov  al,[bigEndian+esi] ; al=12h
    ;add  esi 1
    ;mov  al,[bigEndian+esi] ; al=34h
    ;move ax word ptr 

    ;eg
    ;use PTR
    ;myDouble DWORD 12345678h   
    ;stored little endian as: (small address 0000)78->56->34->12(large address 0003)
    ;myDoubleList WORD 1234h, 5678h
    ;mov  AL,byte PTR myDouble     ; al=78h
    ;mov  AL,byte PTR [myDouble+1] ; al=56h
    ;mov  AL,byte PTR [myDouble+2] ; al=34h
    ;mov  AL,byte PTR [myDouble+3] ; al=12h
    ;mov  AX,WORD PTR myDouble     ; ax=5678h
    ;mov  AX,WORD PTR [myDouble+2] ; ax=1234h 
    ;mov  eax,dword PTR myDoubleList; eax=56781234h
    ;------------------------------------------------

    ; big Endian srored as 12h,34h,56h,78h ; it's an array, total 4 bytes

    ; myDouble DWORD 12345678h   ;for big endian
    ; in memory, stored as (small address 0000) 12h->34->56->78h (large address 0003)

    ; littleEndian DWORD ? ;assigned with combined bytes, which is 4 bytes

    ; little Endian is reversed, which should be 78563412h
    

    ;use PTR is to overrides the default type of variables, 
    ;to resize the operands and to make them have the same size

    ;bigEndian BYTE 12h,34h,56h,78h ; array, total 4 bytes

    
	mov  ah,byte PTR [bigEndian + 3]    ; retrive highest byte ah=78h in bigEndian
    mov  byte PTR [littleEndian],ah     ; put it in littleEndian lowest byte

    
	mov  al,byte PTR [bigEndian+2]      ; 2nd highest byte al=56h in bigEndian
    mov  byte PTR [littleEndian+1],al   ; put it in littleEndian second lowest byte

    
	mov  bh,byte PTR [bigEndian+1]	    ; 3rd highest byte ah=34h
    mov  byte PTR [littleEndian+2],bh   ; put it in littleEndian 3rd lowest byte


	mov  bl,byte PTR [bigEndian]	        ; 4th highest byte, which is lowest byte al= 12h
	mov  byte PTR [littleEndian+3],bl	    ; put it in littleEndian 3rd lowest byte



    ; exist means return
	invoke ExitProcess,0

; end proceduer
main ENDP

; end program
END main
 