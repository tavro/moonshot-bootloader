[BITS 16]
[org 0x7C00]

start:
    cli
    lgdt [gdt_descriptor]

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
    dq 0x0000000000000000     ; Null descriptor
    dq 0x00CF9A000000FFFF     ; Code segment descriptor
    dq 0x00CF92000000FFFF     ; Data segment descriptor
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
start_protected:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Load the kernel from disk
    mov bx, 0x100000          ; Address to load the kernel
    mov dl, 0x80              ; Boot drive
    call load_kernel

    jmp 0x08:0x100000

load_kernel:
    pusha
    mov ah, 0x02            ; BIOS read sectors function
    mov al, 10              ; Number of sectors to read
    mov ch, 0
    mov dh, 0
    mov cl, 2               ; Start reading from the second sector
    int 0x13                ; BIOS interrupt
    jc load_error
    popa
    ret

load_error:
    hlt
    jmp load_error

CODE_SEG equ gdt_start + 0x08
DATA_SEG equ gdt_start + 0x10

times 510-($-$$) db 0
dw 0xAA55
