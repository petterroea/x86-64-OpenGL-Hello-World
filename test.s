.section .rodata # Constant values

windowTitle: .string "Hello, x86-64!"

float0: .float 0.0
float1: .float 1.0

float6: .float 0.6
float75: .float 0.75
floatn6: .float -0.6
floatn75: .float -0.75
float5: .float 0.5

.section .text # Assembly code

# Function parameter registers:
# %rdi %rsi %rdx %rcx %r8 %r9

.globl main
main:
	# rdi = argc
	# rsi = args
	push %rbp
	mov %rsp, %rbp
	# Make space for local variables. Align to 16 bit boundary for ABI
	sub $16, %rsp
	mov %rdi, -16(%rbp)
	mov %rsi, -8(%rbp)

	mov %rbp, %rdi # pointer to argc
	sub $16, %rdi # Local variable
	mov -8(%rbp), %rsi # poitner to argv
	call glutInit

	mov $18, %rdi
	call glutInitDisplayMode

	mov $80, %rdi
	mov $80, %rsi
	call glutInitWindowPosition
	mov $400, %rdi
	mov $300, %rsi
	call glutInitWindowSize

	mov $windowTitle, %rdi
	call glutCreateWindow

	mov $display, %rdi
	call glutDisplayFunc

	call glutMainLoop
	jmp END

# Display routine
.globl display
display:
	# Setup the stack frame
	push %rbp
	mov %rsp, %rbp

	mov $0x4100, %rdi
	call glClear

	mov $4, %rdi
	call glBegin

	#Draw the triangle
	movss float1, %xmm0
	movss float0, %xmm1
	movss float0, %xmm2
	call glColor3f

	movss floatn6, %xmm0
	movss floatn75, %xmm1
	movss float5, %xmm2
	call glVertex3f

	movss float0, %xmm0
	movss float1, %xmm1
	movss float0, %xmm2
	call glColor3f

	movss float6, %xmm0
	movss floatn75, %xmm1
	movss float0, %xmm2
	call glVertex3f

	movss float0, %xmm0
	movss float0, %xmm1
	movss float1, %xmm2
	call glColor3f

	movss float0, %xmm0
	movss float75, %xmm1
	movss float0, %xmm2
	call glVertex3f

	# Done drawing the triangle
	call glEnd

	call glutSwapBuffers

	# Tear down the stack frame
	pop %rbp
	ret

.globl END
END:
	movq %rax, %rdi
	add $16, %rsp
	pop %rbp
	call exit

.section .data # Variables
.section .bss # Uninitialized data
