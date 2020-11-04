%macro multiply 1
        pop     rcx
        imul    %1, rcx
%endmacro

%macro print 1
        mov     rsi, %1
        movsx   rdx, DWORD [%1-4]
        mov     rdi, 1
        mov     rax, 1
        syscall
        xor     rax, rax
%endmacro

%macro concat 1
        mov     r12, %1
        pop     r14
        movsx   rax, DWORD [r12-4]
        movsx   rcx, DWORD [r14-4]
        add     rax, rcx
        add     rax, 4
        call    alloc
        movsx   rbx, DWORD [r12-4]
        movsx   rcx, DWORD [r14-4]
        add     rbx, rcx
        mov     [rax], DWORD ebx
        add     rax, 4
        mov     rdi, rax
        mov     rsi, r12
        movsx   rcx, DWORD [r12-4]
        cld
        rep     movsb
        mov     rsi, r14
        movsx   rcx, DWORD [r14-4]
        rep     movsb
%endmacro

%macro compare 1
    pop     rcx
    compare %1, rcx
%endmacro

%macro compare 2
    mov     rbx, rax
    xor     rax, rax
    cmp     rbx, %2
    %1      al
%endmacro
