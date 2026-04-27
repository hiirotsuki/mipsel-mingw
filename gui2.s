    .text
    .globl main
    .globl WndProc

# --------------------------------------------------
# main (acts like WinMain)
# --------------------------------------------------
main:
    addiu $sp, $sp, -64
    sw    $ra, 60($sp)

    # GetModuleHandleA(NULL)
    move  $a0, $zero
    la    $t9, GetModuleHandleA
    jalr  $t9
    nop
    move  $s1, $v0              # hInstance

    # wc.hInstance = hInstance
    la    $t0, wc
    sw    $s1, 16($t0)

    # RegisterClassA(&wc)
    la    $a0, wc
    la    $t9, RegisterClassA
    jalr  $t9
    nop

    # CreateWindowExA(...)
    li    $a0, 0
    la    $a1, className
    la    $a2, windowTitle
    li    $a3, 0x10CF0000

    li    $t0, 100
    sw    $t0, 16($sp)
    li    $t0, 100
    sw    $t0, 20($sp)
    li    $t0, 400
    sw    $t0, 24($sp)
    li    $t0, 200
    sw    $t0, 28($sp)

    sw    $zero, 32($sp)
    sw    $zero, 36($sp)
    sw    $s1,   40($sp)
    sw    $zero, 44($sp)

    la    $t9, CreateWindowExA
    jalr  $t9
    nop

    move  $s0, $v0              # hwnd

    # ShowWindow(hwnd, 1)
    move  $a0, $s0
    li    $a1, 1
    la    $t9, ShowWindow
    jalr  $t9
    nop

    # UpdateWindow(hwnd)
    move  $a0, $s0
    la    $t9, UpdateWindow
    jalr  $t9
    nop

# --------------------------------------------------
# Message loop
# --------------------------------------------------
msg_loop:
    la    $a0, msg
    li    $a1, 0
    li    $a2, 0
    li    $a3, 0
    la    $t9, GetMessageA
    jalr  $t9
    nop

    bne   $v0, $zero, msg_continue
    nop
    j     msg_exit
    nop

msg_continue:
    la    $a0, msg
    la    $t9, TranslateMessage
    jalr  $t9
    nop

    la    $a0, msg
    la    $t9, DispatchMessageA
    jalr  $t9
    nop

    j msg_loop
    nop

msg_exit:
    move  $a0, $zero
    la    $t9, ExitProcess
    jalr  $t9
    nop


# --------------------------------------------------
# WndProc (FIXED)
# --------------------------------------------------
WndProc:
    addiu $sp, $sp, -40
    sw    $ra, 36($sp)

    # WM_CREATE
    li    $t0, 1
    bne   $a1, $t0, check_destroy
    nop

    move  $t1, $a0              # save hwnd

    move  $a0, $zero
    la    $a1, staticClass
    la    $a2, helloText
    li    $a3, 0x50000000       # WS_CHILD|WS_VISIBLE

    li    $t0, 50
    sw    $t0, 16($sp)
    li    $t0, 80
    sw    $t0, 20($sp)
    li    $t0, 300
    sw    $t0, 24($sp)
    li    $t0, 40
    sw    $t0, 28($sp)

    sw    $t1, 32($sp)          # parent
    sw    $zero, 36($sp)
    sw    $zero, 40($sp)
    sw    $zero, 44($sp)

    la    $t9, CreateWindowExA
    jalr  $t9
    nop

    j return_zero
    nop


check_destroy:
    li    $t0, 2
    bne   $a1, $t0, defproc
    nop

    li    $a0, 0
    la    $t9, PostQuitMessage
    jalr  $t9
    nop

    j return_zero
    nop


defproc:
    la    $t9, DefWindowProcA
    jalr  $t9
    nop
    j end_wndproc
    nop


return_zero:
    move  $v0, $zero


end_wndproc:
    lw    $ra, 36($sp)
    addiu $sp, $sp, 40
    jr    $ra
    nop


# --------------------------------------------------
# Data
# --------------------------------------------------
    .data
    .align 2

className:
    .asciiz "MIPSWnd"

windowTitle:
    .asciiz "MIPS GUI"

helloText:
    .asciiz "hello world mips!"

staticClass:
    .asciiz "STATIC"

msg:
    .space 48

# Proper WNDCLASS
wc:
    .word 0                  # style
    .word WndProc            # lpfnWndProc
    .word 0
    .word 0
    .word 0                  # hInstance (patched at runtime)
    .word 0
    .word 0
    .word 6                  # background brush
    .word 0
    .word className
