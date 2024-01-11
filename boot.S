BITS 16
ORG 0

start:
  cld
  cli
;;;;;;;;;;;;;;;;;;;;;;;;;;
  jmp 07c0h:.setcs              ; set CS:IP to 07c0:.setcs

.setcs:
  mov ax, 07c0h			; set DS to 07c0h
  mov ds, ax

  xor ax, ax 			; set SS:SP to 0:07c0h
  mov ss, ax
  mov sp, 7c00h
;;;;;;;;;;;;;;;;;;;;;;;;;

  mov si, .message
.next_char:
  lodsb
  cmp al, 0
  je .reboot
  mov ah, 0eh
  mov bx, 7
  int 10h
  jmp .next_char

.reboot: 
  xor ax, ax                    ; wait for a key
  int 16h        
  int 19h                       ; reboot

.message:
  db 'Hello World', 13, 10, 0

;;;;;;;;;;;;;;;;;;;;;;;;;
  times 510-($-$$) db 0
  dw 0aa55h                     ; valid boot setcor ID
  


  
  


