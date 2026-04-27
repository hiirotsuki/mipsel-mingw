    .text
    .globl WinMain
    .globl WndProc

# --------------------------------------------------
# WinMain
# --------------------------------------------------
WinMain:
    addiu $sp, $sp, -64
    sw    $ra, 60($sp)

    # GetModuleHandleA(NULL)
    move  $a0, $zero
    la    $t9, GetModuleHandleA
    jalr  $t9
    nop
    move  $s1, $v0              # hInstance

    # Fill WNDCLASS.hInstance
    la    $t0, wc
    sw    $s1, 16($t0)

    # RegisterClassA(&wc)
    la    $a0, wc
    la    $t9, RegisterClassA
    jalr  $t9
    nop

    # CreateWindowExA(...)
    li    $a0, 0                        # exStyle
    la    $a1, className
    la    $a2, windowTitle
    li    $a3, 0x10CF0000               # WS_OVERLAPPEDWINDOW

    li    $t0, 100
    sw    $t0, 16($sp)                  # x
    li    $t0, 100
    sw    $t0, 20($sp)                  # y
    li    $t0, 400
    sw    $t0, 24($sp)                  # width
    li    $t0, 200
    sw    $t0, 28($sp)                  # height

    sw    $zero, 32($sp)                # parent
    sw    $zero, 36($sp)                # menu
    sw    $s1,   40($sp)                # hInstance
    sw    $zero, 44($sp)                # param

    la    $t9, CreateWindowExA
    jalr  $t9
    nop

    move  $s0, $v0                      # hwnd

    # ShowWindow(hwnd, SW_SHOWNORMAL)
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
# Message Loop
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
# Window Procedure
# --------------------------------------------------
WndProc:
    addiu $sp, $sp, -32
    sw    $ra, 28($sp)

    # if (msg == WM_CREATE)
    li    $t0, 1
    bne   $a1, $t0, check_destroy
    nop

    # Create STATIC control
    move  $a0, $zero
    la    $a1, staticClass
    la    $a2, helloText
    li    $a3, 0x50000000       # WS_CHILD | WS_VISIBLE

    li    $t0, 50
    sw    $t0, 16($sp)
    li    $t0, 80
    sw    $t0, 20($sp)
    li    $t0, 300
    sw    $t0, 24($sp)
    li    $t0, 40
    sw    $t0, 28($sp)

    sw    $a0, 32($sp)          # parent hwnd
    sw    $zero, 36($sp)
    sw    $zero, 40($sp)
    sw    $zero, 44($sp)

    la    $t9, CreateWindowExA
    jalr  $t9
    nop

    j defproc
    nop

check_destroy:
    li    $t0, 2                # WM_DESTROY
    bne   $a1, $t0, defproc
    nop

    li    $a0, 0
    la    $t9, PostQuitMessage
    jalr  $t9
    nop

    move  $v0, $zero
    j end_wndproc
    nop

defproc:
    la    $t9, DefWindowProcA
    jalr  $t9
    nop

end_wndproc:
    lw    $ra, 28($sp)
    addiu $sp, $sp, 32
    jr    $ra
    nop


# --------------------------------------------------
# Data
# --------------------------------------------------
    .data

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
    .word 0                  # cbClsExtra
    .word 0                  # cbWndExtra
    .word 0                  # hInstance (filled at runtime)
    .word 0                  # hIcon
    .word 0                  # hCursor
    .word 5                  # hbrBackground (COLOR_WINDOW+1)
    .word 0                  # menu
    .word className          # class name
