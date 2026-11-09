# P30 program: string table in ROM
# Reads indexes until 9; prints string + offset for 0-4, else "no such string"

        .text
p30_main:
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)
        sw      s1, 4(sp)

p30_loop:
        jal     ra, rcv_read_dec
        mv      s0, a0
        li      t0, 9
        beq     s0, t0, p30_done
        li      t0, 4
        bltu    t0, s0, p30_nosuch

        la      a0, p30_s_string
        jal     ra, rcv_puts
        mv      a0, s0
        jal     ra, rcv_print_udec
        la      a0, p30_s_colon
        jal     ra, rcv_puts

        la      t0, p30_table
        slli    t1, s0, 2
        add     t1, t0, t1
        lw      s1, 0(t1)
        mv      a0, s1
        jal     ra, rcv_puts

        la      a0, p30_s_offset
        jal     ra, rcv_puts
        la      t0, p30_table
        lw      t1, 0(t0)
        sub     a0, s1, t1
        jal     ra, rcv_print_hex
        la      a0, p30_s_close
        jal     ra, rcv_puts
        jal     ra, rcv_newline
        j       p30_loop

p30_nosuch:
        la      a0, p30_s_nosuch
        jal     ra, rcv_puts
        jal     ra, rcv_newline
        j       p30_loop

p30_done:
        lw      s1, 4(sp)
        lw      s0, 8(sp)
        lw      ra, 12(sp)
        addi    sp, sp, 16
        ret

        .rodata
        .align  2
p30_table:
        .word   p30_str0, p30_str1, p30_str2, p30_str3, p30_str4
p30_str0:
        .asciz  "ROM"
p30_str1:
        .asciz  "RAM"
p30_str2:
        .asciz  "UART"
p30_str3:
        .asciz  "KEYBOARD"
p30_str4:
        .asciz  "TIMER"
p30_s_string:
        .asciz  "string "
p30_s_colon:
        .asciz  ": "
p30_s_offset:
        .asciz  " (offset "
p30_s_close:
        .asciz  ")"
p30_s_nosuch:
        .asciz  "no such string"
        .align  2