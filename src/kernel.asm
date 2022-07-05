;; =======================================================================================================
;;
;;
;;       /-----------\       /-\        /------\        /------\ /------\        /------\       /-\
;;       |-----------|      /-_-\       |-------\      /-------| |-------\      /-------|      /-_-\
;;       |--|     |__|     /-| |-\      |----\---\    /---/----| |----\---\    /---/----|     /-| |-\
;;       |--|   _____     /--|_|--\     |----|\---\  /---/|----| |----|\---\  /---/|----|    /--|_|--\
;;       |--|  |___--\   /---------\    |----| \---\/---/ |----| |----| \---\/---/ |----|   /---------\
;;       |--|______|-|  /---/   \---\   |----|  \______/  |----| |----|  \______/  |----|  /---/   \---\
;;       \___________/ /___/     \___\  |____|            |____| |____|            |____| /___/     \___\
;;
;;
;; =======================================================================================================

	[org 0x7c00]

	jmp k_init

;; Function for clearing screen. It basically just scrolls up the screen to get rid of all text.

clear_screen:
	mov ah, 07h
	mov al, 0
	int 10h
	ret

;; Function for settings video mode. You have to provide what video mode you want before calling this function.

set_videomode:
	mov ah, 00h
	int 10h
	ret

;; Function for printing a character

print_char:
	mov ah, 0Eh
	int 10h
	ret

;; Function for printing a string

print_string:
	mov ah, 0Eh
.next_char:
	lodsb
	cmp al, 0
	je .string_done
	int 10h
	jmp .next_char
.string_done:
	ret

;; Kernel main functions

k_init:
	call clear_screen
	mov al, 03h
	call set_videomode

	mov si, WELCOME
	call print_string

	jmp k_mainloop

k_exit:
	call clear_screen
	cli
	hlt
	jmp $

k_mainloop: ;; It just waits for a key, that's all. Lmao
	mov ah, 00h
	int 16h
	cmp ah, 0x48
	je k_exit
	call print_char

	jmp k_mainloop

;; Text message variables
WELCOME db 'WELCOME TO GAMMA!', 0

;; Make OS bootable
times 510-($-$$) db 0
dw 0xAA55
