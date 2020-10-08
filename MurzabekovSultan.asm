format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        strVecSize   db 'Enter array length ', 0
        strKNumber   db 'Enter K number ', 0
        strIncorSize db 'Incorrect array length = %d', 10, 0
        strVecElemI  db 'Enter [%d] array item ', 0
        strScanInt   db '%d', 0
        strSumValue  db 'Summa = %d', 10, 0
        strVecElemOut  db '[%d] = %d', 10, 0

        k            dd 0
        vec_size     dd 0
        sum          dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        vec          rd 100

;--------------------------------------------------------------------------
section '.code' code readable executable
start:

        call VectorInput

        call VectorSum

        call VectorOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        push strKNumber
        call [printf]
        add esp, 4

        push k
        push strScanInt
        call [scanf]
        add esp, 8

        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector

        push vec_size
        push strIncorSize
        call [printf]
        push 0
        call [ExitProcess]

getVector:
        xor ecx, ecx
        mov ebx, vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector


        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------
VectorSum:
        xor ecx, ecx
        mov ebx, vec
sumVecLoop:

        cmp ecx, [vec_size]
        je endSumVector
        mov eax, [sum]
        add eax, [ebx]
        mov [sum], eax

        inc ecx

        add ebx, 4
        jmp sumVecLoop
endSumVector:
        ret
;--------------------------------------------------------------------------
VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx
        xor eax, eax
        xor edx, edx
        mov ebx, vec
putVecLoop:
        cmp ecx, [vec_size]
        je endOutputVector

        xor eax, eax
        xor edx, edx
        mov eax, [ebx]
        div [k]

        cmp edx, 0
        je Method


        dec [vec_size]
        add ebx, 4
        jmp putVecLoop


Method:
        mov [tmp], ebx
        mov [i], ecx

        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop

endOutputVector:
        mov esp, [tmpStack]
        ret
;------------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'