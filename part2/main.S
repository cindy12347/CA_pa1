.section .data
# There are two global variables:
#  1. array: Store the input numbers.
#  2. size: the number of the list
# You can modify the following two lines to test your program,
# but DO NOT change the line number
array: .dword 15, 20, 6, 35, 70, 7, 14, 36, 1, 21, 13, 3, 24, 5, 22, 2, 4, 10, 8, 12
size: .dword 20

# Variables for print function
# DO NOT modify these
dummy_msg: .ascii "   "
newline_msg: .ascii "\n"
ascii_msg: .ascii "Test"
magic_mem: .space 64

.section .text
.global main
main:

  # save return pointer
  addi sp, sp, -8
  sd ra, 0(sp)

  la a0, array      # assign array address to a0
  ld a2, size       # assign array size to a2

  li a3, 0          # low
  addi a2, a2, -1   # high

  jal partition     # jump to function
  
  jal print         # show results

  li a0, 0

  ld ra, 0(sp)
  addi sp, sp, 8

  ret               # return (jump to the address stored in register ra)

.global partition
partition:

  #########################
  addi sp, sp, -40
  sd t0, 40(sp)
  sd t1, 32(sp)
  sd t2, 24(sp)
  sd t3, 16(sp)
  sd t4, 8(sp)
  sd t5, 0(sp)

  # a3=low
  # a2=high
  slli t0, a2, 3
  addi t1, t0, a0 
  ld t2, 0(t1) # assign t2=pivot
  addi t3, a3, 0 # assign t3=i=low
  addi t4, a3, 0 # assign t4=j=low

Loop:
  # if j >= high, then exit loop
  bge t4, a2, Exit1
  # if j < high, then enter loop

  slli t0, t4, 3
  add t1, t0, a0 
  ld t5, 0(t1)  # assign t5=arr[j]
  # if arr[j] >= pivot, then exit if
  bge t5, t2, Exit2
  # if arr[j] < pivot, then enter if

  slli t0, t3, 3
  add t1, t0, a0
  ld a4 0(t1) # a4=arr[i]
  slli t0, t4, 3
  add t1, t0, a0
  ld a5, 0(t1) # a5=arr[j]
  jal swap
  addi t3, t3, 1

# j++
Exit2:
  addi t4, t4, 1
  jal Loop
Exit1:
  slli t0, t3, 3
  add t1, t0, a0
  ld a4 0(t1) # a4=arr[i]
  slli t0, t4, 3
  add t1, t0, a0
  ld a5, 0(t1) # a5=arr[j]
  jal swap
  # a1 = i
  addi a1, a3, 0

  sd t0, 40(sp)
  sd t1, 32(sp)
  sd t2, 24(sp)
  sd t3, 16(sp)
  sd t4, 8(sp)
  sd t5, 0(sp)
  addi sp, sp, 40


.global swap
swap:

  ######################### 
  addi sp sp -32
  sd t0 32(sp)
  sd t1 24(sp)
  sd t2 16(sp)
  sd t3 8(sp)
  sd t4 0(sp)

  # Calculate the byte offset for the first element
  slli t0, a4, 3 
  add t1, t0, a0
  ld t2, 0(t1)   

  # Calculate the byte offset for the second element
  slli t0, a5, 3      
  add t3, t3, a0
  ld t4, 0(t3)    

  # Swap the elements
  sd t2, 0(t3)      
  sd t4, 0(t1)     

  ld t0 32(sp)
  ld t1 24(sp)
  ld t2 16(sp)
  ld t3 8(sp)
  ld t4 0(sp)
  addi sp sp 32
  #########################



####################################
# Helper function to print results #
#     DO NOT modify this!!!!!!     #
####################################
.global print
print:

  addi sp, sp, -72
  sd s7, 64(sp)
  sd s6, 56(sp)
  sd s5, 48(sp)
  sd s4, 40(sp)
  sd s3, 32(sp)
  sd s2, 24(sp)
  sd s1, 16(sp)
  sd s0, 8(sp)
  sd ra, 0(sp)

  la s0, array
  ld s1, size

  li s2, 0

print_loop:
  slli s3, s2, 3
  add s3, s0, s3
  ld s4, 0(s3)

  li s3, 10
  div s5, s4, s3
  rem s4, s4, s3

  beq s5, zero, less_than_10

  addi s5, s5, 48
  la s7, ascii_msg 
  sw s5, 0(s7)

  la s7, magic_mem
  li s6, 64
  sw s6, 0(s7)
  li s6, 1
  sw s6, 8(s7)
  la s6, ascii_msg
  sw s6, 16(s7)
  li s6, 1
  sw s6, 24(s7)
  la s6, tohost
  sw s7, 0(s6)

wait1:
  la s6, fromhost
  ld s7, 0(s6)
  beq s7, zero, wait1

  sw zero, 0(s6)

less_than_10:

  addi s4, s4, 48
  la s7, ascii_msg 
  sw s4, 0(s7)

  la s7, magic_mem
  li s6, 64
  sw s6, 0(s7)
  li s6, 1
  sw s6, 8(s7)
  la s6, ascii_msg
  sw s6, 16(s7)
  li s6, 1
  sw s6, 24(s7)
  la s6, tohost
  sw s7, 0(s6)

wait2:
  la s6, fromhost
  ld s7, 0(s6)
  beq s7, zero, wait2

  sw zero, 0(s6)

  la s7, magic_mem
  li s6, 64
  sw s6, 0(s7)
  li s6, 1
  sw s6, 8(s7)
  la s6, newline_msg
  sw s6, 16(s7)
  li s6, 1
  sw s6, 24(s7)
  la s6, tohost
  sw s7, 0(s6)

wait3:
  la s6, fromhost
  ld s7, 0(s6)
  beq s7, zero, wait3

  sw zero, 0(s6)

  addi s2, s2, 1
  bne s2, s1, print_loop

  ld ra, 0(sp)
  ld s0, 8(sp)
  ld s1, 16(sp)
  ld s2, 24(sp)
  ld s3, 32(sp)
  ld s4, 40(sp)
  ld s5, 48(sp)
  ld s6, 56(sp)
  ld s7, 64(sp)
  addi sp, sp, 72

  ret