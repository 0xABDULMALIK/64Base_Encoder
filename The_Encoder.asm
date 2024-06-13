%include "io.inc"
global _main
extern _printf

section .data

Table: db 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/', 0
Input: db 'QU0xNjQxMTQ=', 0 ;
Output: db 'X', 0
Counter: dd 0
edxCopy: dd 0

section .text

_main:

 xor eax, eax
 xor edx, edx
 mov ebx, Input
 charNumsCounter:
 mov al, [ebx]
 cmp al, 0
 jz mainProcess
 inc edx
 inc ebx
 jmp  charNumsCounter
 cmp edx, 0
 je done
 
 mainProcess:
 mov [Counter], edx
 xor eax, eax
 xor ecx, ecx
 mov ebx, Table
 mov esi, Input
 mov edi, Output
 add esi, edx
 sub esi, 4
 mov edi, Output
 mov eax, [esi]
 bswap eax
 cmp ah, '='
 jne oneEqual
 add ecx, 4
 jmp caseTwoEquals
 oneEqual:
 cmp al, '='
 jne caseNoEquals
 add ecx, 2
 jmp caseOneEqual
 
 caseTwoEquals:
 shr eax, 16
 xor edx, edx
 search1:
 inc edx
 inc ebx
 cmp al, [ebx-1]
 jne search1
 dec edx
 shr edx, 4
 mov ecx, edx
 mov ebx, Table
 shr eax, 8
 xor edx, edx
 search2:
 inc edx
 inc ebx
 cmp al, [ebx-1]
 jne search2
 dec edx
 shl edx, 2
 add ecx, edx
 mov ebx, Table
 sub dword[Counter], 4
 sub esi, 4
 mov [edi], cl
 dec edi
 jmp caseNoEquals
  
 caseOneEqual:
 shr eax, 8
 xor edx, edx
 search3:
 inc edx
 inc ebx
 cmp al, [ebx-1]
 jne search3
 dec edx
 shr edx, 2
 mov ecx, edx
 mov ebx, Table
 shr eax, 8
 xor edx, edx
 search4:
 inc edx
 inc ebx
 cmp al, [ebx-1]
 jne search4
 dec edx
 shl edx, 4
 add ecx, edx
 mov ebx, Table
 shr eax, 8
 xor edx, edx
 search5:
 inc edx
 inc ebx
 cmp al, [ebx-1]
 jne search5
 dec edx
 shl edx, 10
 add ecx, edx
 mov ebx, Table
 sub dword[Counter], 4
 sub esi, 4
 mov [edi], cl
 dec edi
 mov [edi], ch
 dec edi
 jmp caseNoEquals
 
 caseNoEquals:
 xor edx, edx
 cmp dword[Counter], 0
 je done
 mov eax, [esi]
 bswap eax
 xor ecx, ecx
 mainLoop:
 mov dword[edxCopy], 0
 search:
 inc dword[edxCopy]
 inc ebx
 cmp al, [ebx-1]
 jne search
 dec dword[edxCopy]
 shl dword[edxCopy], cl
 add edx, dword[edxCopy]
 add cl, 6
 mov ebx, Table
 cmp eax, 0
 je temp
 shr eax, 8
 jmp mainLoop  
 temp:
 sub dword[Counter], 4
 sub esi, 4
 mov [edi], dl
 dec edi
 mov [edi], dh
 dec edi
 shr edx, 16
 mov [edi], dl
 dec edi
 jmp caseNoEquals
 
 done:
 inc edi
 push edi
 call printf
 add esp, 4

 ret
