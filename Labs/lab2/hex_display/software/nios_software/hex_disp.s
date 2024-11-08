# Author: Diego Lopez

/* Program that takes input from switches and displays the hex value on a seven segment display */
.text

# define a macro to move a 32 bit address to a register

.macro MOVIA reg, addr
  movhi \reg, %hi(\addr)
  ori \reg, \reg, %lo(\addr)
.endm

# define constants
.equ Switches, 0x11020  # find the base address of Switches in the system.h file
.equ keys,     0x11010  # find the base address of keys in the system.h file
.equ HEX0,     0x11000  # base address of HEX0
.equ KEY1_MASK, 0x02    # bitmask for detecting key[1] press (assuming key[1] is the second bit)
.equ SWITCH_MASK, 0x01  # Bitmask for detecting switch press
.equ max_num, 9
.equ min_num, 0

# define the main program
.global main
main: 
  movia r2, Switches	# load the address of switches into r2
  movia r3, keys  		# load the address of keys into r3
  movia r12, 0x02
  movia r13, max_num
  movia r17, min_num
  
call display

loop:
  ldbio r11, 0(r3)           # Load the value of r3(keys) into r11
  andi r11, r11, KEY1_MASK   # check if key[1] is pressed by bit masking everyhting except 0x02
  beq r11, r0, switch_status # If key[1] is pressed start the loop of waiting for it to be released.
  br loop

switch_status: 				 # If switch is 1 decrement, else increment
  ldbio r16, 0(r2) 			 # Check switch
  andi r16, r16, SWITCH_MASK # check value of switch by bit masking everyhting except 0x01
  bne r16, r0, increment
  call decrement
  ret
  
key_debounce						 # Check if key[1] has been released
  movia r15, keys					 # Move the address of the keys varaible into r15
  key_debounce_loop:				 # Declare branch for waiting for key[1] to be released	
    ldbio r14, 0(r15) 				 # Load the value of keys[1] to r11
	andi r14, r14, KEY1_MASK		 # Use and masking to check the key[1] value
    bne r14, r12, key_debounce_loop  # If key[1] is still bounced restart loop
	ret

increment:  			 # Add 1 to the hex value array address
  addi r6, r6, 1 		 # Increment the r6(address register) by one
  bgt r6, r13, find_min  # If the address is greater than the max(nine) make the address the min(zero)
  call key_debounce		 # Wait for key[1] to be released
  call display			 # Display the result
  br loop

decrement:  			 # Subtract 1 to the hex value array address
  subi r6, r6, 1 		 # Decrement the r6(address register) by one
  blt r6, r17, find_max  # If the address is less than the min(zero make the address the max(nine)
  call key_debounce		 # Wait for key[1] to be released
  call display			 # Display the result
  br loop

find_max:
  movia r6, max_num  # Move address of the max num to r6
  call key_debounce  # Wait for key[1] to be released
  call display		 # Display result
  br loop			 # Return to loop subroutine
  
find_min:
  movia r6, min_num  # Move address of the min num to r6
  call key_debounce  # Wait for key[1] to be released
  call display		 # Display result
  br loop			 # Return to loop subroutine
  
display:  			 # Subroutine to display the current value of r10 on HEX0
  movia r9, Astart   # load address of the Astart array (data section) into r6
  add r9, r9, r6     # add the value of r9 to r6 to get the correct byte
  ldbio r5, 0(r9)    # load the byte at the calculated address into r5
  movia r4, HEX0     # load the address of HEX0 into r4
  stbio r5, 0(r4)    # store the byte in r5 (which is the current count) to HEX0
  ret
	
.data
Astart: # Holds the hex values for 0-9 for the seven segment display.
  .byte 0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x18, 0x08, 0x03, 0x46, 0x21, 0x06, 0x0E

Aend:
  .end
