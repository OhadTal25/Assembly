.data 

str1: .asciiz "Please enter some words:"
str2: .asciiz "Number of words = "
str3: .asciiz "Letters in longest word ="
str4: .asciiz "Letters in shortest word = "
str5: .asciiz "Difference = "
str6: .asciiz "Total number of letters = "
str7: .asciiz "Total number of vowels = "
str8: .asciiz "The longest word = "
str9: .asciiz "The shortest word = "
strdown: .asciiz "\n"

buffer: .space 81

.text
.globl main

main: 
recive:
	li $v0,4   #print str1
	la $a0,str1
	syscall

	li $v0,8    #get string from user
	la $a0,buffer
	li $a1,81
	syscall
	
	j check_If_Valid_String

str_Ok: 
	li $s0,1 #counter
	j check_Num_Of_Words

print_Count:
	li $v0,4   #print str1
	la $a0,str2
	syscall
	
	add $a0,$zero,$s0
	li $v0,1
	syscall
	
	li $s0,0 #max counter
	li $s1,100 #min counter
	
	j count_Longest_Word
	
shortest: 
	j count_Shortest_Word
	
	
	
print_Char_Count:
	jal print_str_down
	
	li $v0,4   #print str3
	la $a0,str3
	syscall
	
	add $a0,$zero,$s0
	li $v0,1
	syscall
		
	jal print_str_down
	
	li $v0,4   #print str4
	la $a0,str4
	syscall
	
	add $a0,$zero,$s1
	li $v0,1
	syscall
	
	jal print_str_down #go down 
	
	li $v0,4   #print str5
	la $a0,str5
	syscall
	
	subu $a0,$s0,$s1
	li $v0,1
	syscall
	
	jal print_str_down
	li $s0,0
	j count_Chars
	
print_Count_Chars:
	
	li $v0,4   #print str6
	la $a0,str6
	syscall
	
	add $a0,$zero,$s0
	li $v0,1
	syscall
	jal print_str_down
	
	j count_Vowels #jump to vowels
	
	
print_Vowels_Count:
	li $v0,4   #print str7
	la $a0,str7
	syscall
	
	add $a0,$zero,$t0
	li $v0,1
	syscall
	jal print_str_down
	
	j exit
	
#########################################################################
#########################################################################
#########################################################################
#########################################################################
#########################################################################


print_str_down:
	li $v0,4 
	la $a0,strdown
	syscall
	jr $ra
	
check_If_Valid_String:
	#pointer for each character 
	li $t0,0
	li $t1,1
	j loop
	
space: 
	#check if both pointers are ' '
	beq $t2,$t3,recive
	
	
loop: 
	#read char in place of $t0
	lb $t2,buffer($t0)
	#read char in place of $t1
	lb $t3,buffer($t1)
	
	#moving pointer to next char
	addi $t0,$t0,1
	addi $t1,$t1,1
	
	#check if input is ok
	beq $t2,'\n',str_Ok
	beq $t2,' ',space
	blt $t2,'A',recive
	ble $t2,'Z',loop
	blt $t2,'a',recive
	ble $t2,'z',loop
	

check_Num_Of_Words:
	li $t0,0 #pointer
	
	
	
loop_Check_Num:
	#read char in place of $t0
	lb $t1,buffer($t0)
	
	#moving pointer to next char
	addi $t0,$t0,1
	beq $t1,'\n',print_Count
	bne $t1,' ',loop_Check_Num
	addi $s0,$s0,1
	j loop_Check_Num
	

count_Longest_Word:
	li $t0,0 #pointer
	li $t1,0 #current counter
	li $t2,'a'
	
change_Counter:
	beq $t2,'\n',shortest
	li $t1,0

count_Char_Loop: #function for counting char
	lb $t2,buffer($t0)
	addi $t0,$t0,1
	beq $t2,'\n',space_Char
	beq $t2,' ',space_Char
	addi $t1,$t1,1
	j count_Char_Loop
	
	
space_Char:
	blt $t1,$s0,change_Counter
	add $s0,$t1,$zero
	j change_Counter
	
	
count_Shortest_Word:
	li $t0,0 #pointer
	li $t2, 'v'
	
shortest_Counter: 
	beq $t2,'\n',print_Char_Count
	li $t1,0 #current counter
	
	
	
loop_Shortest:
	lb $t2,buffer($t0)
	addi $t0,$t0,1
	beq $t2,'\n',space_Char2
	beq $t2,' ',space_Char2
	addi $t1,$t1,1
	j loop_Shortest
	
space_Char2:
	bgt $t1,$s1,shortest_Counter
	add $s1,$t1,$zero
	
	j shortest_Counter
	
	
count_Chars:
	li $t0,0 #pointer
	
loop_Count_Chars:
	lb $t1,buffer($t0) 
	addi $t0,$t0,1 
	beq $t1,' ',loop_Count_Chars
	beq $t1,'\n',print_Count_Chars
	addi $s0,$s0,1 
	j loop_Count_Chars
	
	
count_Vowels:
	li $t0,0 #counter vowels
	li $t1,0 #pointer

loop_Vowels:
	lb $t6,buffer($t1)
	addi $t1,$t1,1
	beq $t6,' ', loop_Vowels
	beq $t6, '\n', print_Vowels_Count
	beq $t6, 'a', up_counter_Vowels 
	beq $t6, 'A', up_counter_Vowels
	beq $t6, 'e', up_counter_Vowels
	beq $t6, 'E', up_counter_Vowels
	beq $t6, 'i', up_counter_Vowels
	beq $t6, 'I', up_counter_Vowels
	beq $t6, 'o', up_counter_Vowels
	beq $t6, 'O', up_counter_Vowels
	beq $t6, 'u', up_counter_Vowels
	beq $t6, 'U', up_counter_Vowels
	j loop_Vowels
	
up_counter_Vowels:
	addi $t0,$t0,1
	j loop_Vowels
	

exit:
	li $v0,10
	syscall
	
