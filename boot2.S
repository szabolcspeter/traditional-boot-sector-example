BITS 16
ORG 0
  jmp short start
align 4
      db 'OS32'
Size  db 1
Track db 0
Head  db 0
Sec   db 2

;;;;;;;;;;;;;;; bootloader setup ;;;;;;;;;;;;;;;
start:
  cld
  cli
  jmp 07c0h:.setcs

.setcs:
  mov ax, 7c0h
  mov ds, ax

  xor ax, ax
  mov ss, ax
  mov sp, 7c00h

  mov si, boot_msg
  call print

;;;;;;;;;;;;;;; load sectors to 9000:0000h ;;;;;;;;;;;;;;;
  xor ax, ax
  mov dx, ax
  int 13h
  jc error

read_sectors:
  mov bx, 9000h
  mov es, bx
  xor bx, bx

next:
  cmp byte [Size], 0
  jz load			;ugrik a vegere
  mov ax, 201h
  mov cl, [Sec]
  mov ch, [Track]
  mov dl, 80h
  mov dh, [Head]
  int 13h
  jc error
  
  add bx, 512
  dec byte [Size]
  inc byte [Sec]
  cmp byte [Sec], 63
  jbe next
  mov byte [Sec], 1
  inc byte [Head]
  cmp byte [Head], 1
  jbe next
  mov byte [Head], 0
  inc byte [Track]
  cmp byte [Track], 80
  jbe next

;;;;;;;;;;;;;;; jump to 9000:0000h ;;;;;;;;;;;;;;;
load:
  jmp 9000h:0
  
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

error:
  mov si, error_msg
  call print
  xor ax, ax
  int 16h
  int 19h

;;;;;;;;;;;;;;;; string constans ;;;;;;;;;;;;;;;
boot_msg:
  db 'Booting OS32... ', 0

error_msg:
  db 13, 10, 'Disk Error', 13, 10, 
  db 'Press a key to reboot...', 13, 10, 0

;;;;;;;;;;;;;;; valid boot sector ID ;;;;;;;;;;;;;;;
  times 510-($-$$) db 0
  dw 0aa55h


