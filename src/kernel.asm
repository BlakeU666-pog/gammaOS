;; gammaOS is a project developed by Dominik Mazurek

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
        call newline
        ret

;; Cursor

get_c_position:
        mov ah, 03h
        mov bh, 0
        int 10h
        ret

set_c_position:
        mov ah, 02h
        mov bh, 0
        ;; You have to manually set DH (row) and DL (column) for this to work.
        int 10h
        ret

;; Keyboard support

newline:
        call get_c_position
        mov dl, 0x0
        add dh, 1
        call set_c_position
        ret

get_key:
        mov ah, 00h
        int 16h

        cmp ah, 0x1C ;; Check if enter was pressed
        je newline

        call print_char
        ret

;; Kernel main functions

k_init:
        call clear_screen
        mov al, 03h
        call set_videomode

        mov si, STARTING
        call print_string

        jmp k_mainloop

k_exit:
        call clear_screen
        cli
        hlt
        jmp $

k_mainloop: ;; It just waits for a key for now.
        call get_key

        jmp k_mainloop

STARTING db 'Starting gammaOS', 0

times 510-($-$$) db 0
dw 0xAA55
