Comment !
Write a general-purpose program (only assembly code and
no procedure call) that inserts a source string to the beginning
of a target string. Sufficient space must exist in the target string to
accommodate the new characters. You are not allowed to define a new string. 
Here is a sample
input:
.data
targetStr BYTE "Mellon University",30 DUP(0)
sourceStr BYTE "Carnegie ",0
.code
!


; INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword

.data
targetStr BYTE "Mellon University",30 DUP(0)
sourceStr BYTE "Carnegie ",0
 
.code
main proc
 
    mov esi,0                               ; indexed addresssing
    mov ebx,0                               ; use ebx as loop count, how many chars are in targetStr

CountTargetStrChars:                        ; count how many chars are in targetStr
                                            ; 0s are fillers, not actual values
        cmp targetStr[ebx], 0               ; 0 (null) is terminator
        je done                             ; if it is 0 (null), then counting chars is done
        add ebx,1                           ; otherwise, keep on counting chars in targetStr
        loop CountTargetStrChars            ; loop
done:
        mov ecx, ebx                        ; do not use mov lengthof targetStr, because
                                            ; lengthof targetStr has 17 chars plus 30 0s = 47.
                                            ; use ecx=11h=16+1= 17, mov ecx, 17 
                                            ; lengthof targetStr=2Fh=2*16+15=47
                                            ; ecx is loop counter mov ecx, 17

        mov esi,ebx                         ; esi is indexed addressing pointing first char of targetStr
        sub esi,1                           ; mov esi, 16; 17-1 , because index starts at 0
     
    


TargetStrShiftCopyItself:                   ; shift the whole string TargetStr to make spaces
                                            ; for sourceStr to be inserted in the front
        
        mov ah, TargetStr[esi]              ; TargetStr copy itself to shift in order to make spaces
        mov TargetStr[esi + LENGTHOF sourceStr - 1], ah
        dec esi
        Loop TargetStrShiftCopyItself



        mov esi, 0
        mov ecx, LENGTHOF sourceStr  - 1    ; do not copy 0(null) terminator

sourceStrAddToTargetStr:                    ; copy over sourceStr to TargetStr
                                            ; and insert it into the front of TargetStr
        mov ah, sourceStr[esi]
        mov TargetStr[esi], ah
        inc esi
        Loop sourceStrAddToTargetStr

        comment !
        ; testing successful
        call Clrscr			    ; locate cursor at upper left corner
        mov  edx,offset targetStr           ; display targetStr in window console
        call WriteString                    ; null terminated
        call Crlf			    ; end of line
        mov  edx, offset sourceStr          ; display targetStr in window console
        call WriteString                    ; null terminated
        call Crlf			    ; end of line 
        !
   
    invoke ExitProcess,0
main endp 
end main 