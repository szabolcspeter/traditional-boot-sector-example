BITS 16
ORG 0
start:
  cld
  cli
  mov ax, cs
  mov ds, ax
  mov ss, ax
  mov sp, 0f000h

  mov si, boot_msg
  call print
  
  xor al, al
  mov dx, 3f2h
  out dx, al

  xor ax, ax
  int 16h
  int 19h



;;;;;;;;;;;;;;; routines ;;;;;;;;;;;;;;;
print:
  lodsb
  cmp al, 0
  je end
  mov ah, 0eh
  mov bx, 7
  int 10h
  jmp print
  end: ret

;;;;;;;;;;;;;;;; string constans ;;;;;;;;;;;;;;;
boot_msg:
  db 'OK :-)', 13, 10, 0
