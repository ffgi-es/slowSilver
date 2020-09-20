SECTION .data
mem_start   dq 0
mem_last    dq 0

SECTION .text
global init
global alloc
global free

init:
        mov     rax, 12
        xor     rdi, rdi
        syscall
        mov     [mem_start], rax
        mov     [mem_last], rax
        ret

alloc:
        push    rbp
        mov     rbp, rsp
        
        push    r12
        push    r13
        push    r14

        mov     r12, [rbp+16]
        add     r12, 9
        mov     r13, [mem_start]
        mov     r14, [mem_last]

.search:
        cmp     r13, r14
        je      .alloc
        movzx   r9, byte [r13]
        mov     r10, [r13+1]
        cmp     r9, 1
        je      .next
        cmp     r10, r12
        jl      .next
        mov     byte [r13], 1
        lea     rax, [r13+9]
        jmp     .done

.next:
        add     r13, r10
        jmp     .search

.alloc:
        lea     rdi, [r14+r12]
        mov     rax, 12
        syscall
        mov     [mem_last], rdi
        mov     byte [r14], 1
        mov     qword [r14+1], r12
        lea     rax, [r14+9]

.done:
        pop     r14
        pop     r13
        pop     r12
        mov     rsp, rbp
        pop     rbp
        ret

free:
        push    rbp
        mov     rbp, rsp
        mov     r9, qword [rbp+16]
        mov     byte [r9-9], 0
        mov     rsp, rbp
        pop     rbp
        ret
