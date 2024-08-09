BITS 16
org 0x7C00

start:
    cli
    lgdt [gdt_descriptor]   ; Load GDT

    ; Enable A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Enter protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:start_protected

gdt_start:
    dq 0x0000000000000000     ; Null desc
    dq 0x00CF9A000000FFFF     ; Code seg desc
    dq 0x00CF92000000FFFF     ; Data seg desc
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; Protected mode seg
BITS 32
start_protected:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

.loop:
    hlt
    jmp .loop

CODE_SEG equ gdt_start + 0x08
DATA_SEG equ gdt_start + 0x10

times 510-($-$$) db 0
dw 0xAA55