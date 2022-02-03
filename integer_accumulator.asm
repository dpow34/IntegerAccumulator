TITLE Integer Accumulator     (program3_powdrild.asm)

; Author: David Powdrill
; Last Modified: 5/3/2020
; OSU email address: powdrild@oregonstate.edu
; Course number/section: 271-400
; Project Number: 3                Due Date: 5/3/2020
; Description: The user inputs as many negative numbers they'd like in a specified range ( [-88, -55] or [-40, -1]). 
;				Once the user inputs a non-negative value, the program then calculates and displays the number of 
;				valid entries, the maximum/minimum of the valid numbers, the sum of all the valid numbers, and the 
;				rounded average of the valid numbers. Lastly, a parting message is displayed. 

INCLUDE Irvine32.inc

LOWERLIMIT1 = -88
LOWERLIMIT2 = -55
UPPERLIMIT1 = -40
UPPERLIMIT2 = -1

.data
userName		OWORD	?											;name of user
currNum			DWORD	?											;current number user entered
maxNum			DWORD	?											;max value of valid numbers entered
minNum			DWORD	?											;min value of valid numbers entered
sum				DWORD	?											;sum of all valid numbers entered
num				DWORD	0											;number of valid numbers entered
avg				DWORD	?											;average of all valid numbers entered
remainder		DWORD	?											;remiander of division for average
intro_1			BYTE	"Welcome to the Integer Accumulator by David Powdrill ", 0
prompt_1		BYTE	"What is your name? ", 0
greeting_1		BYTE	"Hello there, ", 0
instruct_1		BYTE	"Please enter numbers in [-88, -55] or [-40, -1]. ", 0
instruct_2		BYTE	"Enter a non-negative number when you are finished to see the results. ", 0
prompt_2		BYTE	"Enter number: ", 0
error_1			BYTE	"Number Invalid! ", 0
error_2			BYTE	"No valid numbers entered! This was easy!", 0
numVals_1		BYTE	"You entered ", 0
numVals_2		BYTE	" valid numbers. ", 0
resultMax		BYTE	"The maximum valid number is ", 0
resultMin		BYTE	"The minimum valid number is ", 0
resultSum		BYTE	"The sum of your valid numbers is ", 0 
resultAvg		BYTE	"The rounded average is ", 0
goodBye			BYTE	"We have to stop meeting like this. Farewell, ", 0
negative		BYTE	"-", 0




.code
main PROC

;------------------------------
;Introduces title and author of program.
; Asks user for their name and greets user
;------------------------------
	;prints title
	mov		edx, OFFSET intro_1		
	call	WriteString				
	call	CrLf	

	;asks user for name and stores as userName
	mov		edx, OFFSET prompt_1	
	call	WriteString
	mov		edx, OFFSET userName	
	mov		ecx, 32
	call	ReadString				

	;greets user 
	mov		edx, OFFSET greeting_1
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf

;------------------------------
; Gives instructions and parameters to user
;-------------------------------
	;prints instructions
	mov		edx, OFFSET instruct_1
	call	WriteString
	call	CrLf

	;prints paramters for input by user
	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf

;--------------------------------
; Gets input from user and checks to 
; see if number entered fits parameters
; Keeps track of number of valid entries,
; max, min, sum, and average
;-------------------------------
top:	
	;gets data from user
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt

	;checks for non negative entry
	test	eax, eax
	jns		positive				

	;checks if entry fits parameters
	cmp		eax, LOWERLIMIT1		;-88
	jl		error1
	cmp		eax, LOWERLIMIT2		;-55
	jg		compare1
	jmp		maxmincheck

compare1:
	;checks if entry fits parameters
	cmp		eax, UPPERLIMIT1		;-40
	jl		error1
	cmp		eax, UPPERLIMIT2		;-1
	jg		error1

maxmincheck:
	;checks if this is first number entered
	mov		ebx, num
	cmp		ebx, 0			
	je		firstnum

	;checks if number entered is new max or min
	cmp		eax, maxNum
	jg		max
	cmp		eax, minNum
	jl		min
	jmp     add1

firstnum:
	;makes first number the max and min
	mov		maxNum, eax
	mov		minNum, eax
	jmp		add1	

error1:
	;prints error for invalid entry
	mov		edx, OFFSET error_1
	call	WriteString
	call	CrLf
	jmp		top

add1:
	;adds number entered to sum
	neg		eax
	mov		currNum, eax
	mov		eax, sum
	add		eax, currNum		;adds currNum to sum
	mov		sum, eax

	;increases number of valid entries
	mov		ebx, num
	add		ebx, 1				;increases number of valid numbers by 1
	mov		num, ebx
	jmp		top

max:
	;makes number new max
	mov		maxNum, eax
	mov		eax, maxNum
	jmp		add1

min:
	;makes number new min
	mov		minNum, eax
	mov		eax, minNum
	jmp		add1

positive:
	;once a non-negative entry is entered
	mov		eax, num
	cmp		num, 0				;checks if this is the first entry
	jg		average
	jmp		error2

average:
	;calculates the average of valid entires
	mov		eax, sum
	mov		ebx, num
	xor		edx, edx			
	div		ebx					;divides sum by num for average
	mov		avg, eax
	mov		remainder, edx

	;checks to see if rounding up is needed
	mov		eax, num
	mov		ebx, 2
	xor		edx, edx
	div		ebx					;divides the divisor by 2
	mov		ebx, remainder
	cmp		remainder, eax		;compare remainder to half of divisor for possible rounding
	jg		roundup
	jmp		display

roundup:
	;rounds the average up by 1
	mov		eax, avg
	add		eax, 1
	mov		avg, eax
	jmp		display

error2:
	;prints error message displayed when non-negative number is entered with no valid entires
	mov		edx, OFFSET error_2
	call	WriteString
	call	CrLf
	jmp		goodBye1

;--------------------------------
; Displays number of valid numbers, max
; number, min number, sum of all numbers, 
; and the rounded average
;--------------------------------

display:
	;displays number of valid numbers
	mov		edx, OFFSET numVals_1
	call	WriteString
	mov		eax, num
	call	WriteDec
	mov		edx, OFFSET numVals_2
	call	WriteString
	call	CrLf

	;displays max valid number
	mov		edx, OFFSET resultMax
	call	WriteString
	mov		edx, OFFSET negative
	call	WriteString
	mov		eax, maxNum
	neg		eax
	call	WriteDec
	call	CrLf

	;displays min valid number
	mov		edx, OFFSET resultMin
	call	WriteString
	mov		edx, OFFSET negative
	call	WriteString
	mov		eax, minNum
	neg		eax
	call	WriteDec
	call	CrLf

	;displays sum
	mov		edx, OFFSET resultSum
	call	WriteString
	mov		edx, OFFSET negative
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

	;displays average
	mov		edx, OFFSET resultAvg
	call	WriteString
	mov		edx, OFFSET negative
	call	WriteString
	mov		eax, avg
	call	WriteDec
	call	CrLf

;-------------------------------
; Displays goodbye message
;-------------------------------

 goodBye1:
	;displays goodbye message
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString



	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main





;----------------------------------------------------------
displayMath	PROC
;
; Gets the user's string of digits and converts to numeric
; value and validates it is in correct range and signed
;
; Preconditions: None
;
; Postconditions: None
;
; Receives: [ebp+24] = negative sign
;			[ebp+20] = sumdisplay		
;			[ebp+16] = avgdisplay		
;			[ebp+12] = list			
;			[ebp+8]  = ARRAYSIZE				
;
; Returns: None 
;----------------------------------------------------------
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]
	mov		ecx, 10
	mov		ebx, 0

addloop:
	mov		eax, [esi]
	test	eax, eax
	js		negadd

addd:
	add		ebx, eax
	add		esi, 4
	loop	addloop
	jmp		addtext

negadd:
	neg		eax
	jmp		addd

addtext:
	mdisplayString	[ebp+20]
	mov		eax, ebx
	js		negsign
	call	WriteDec
	jmp		avg

negsign:
	push	eax
	mdisplayString [ebp+24]
	pop		eax
	call	WriteDec

avg:	
	push	eax
	call	CrLf
	mdisplayString	[ebp+16]

	;average
	pop		eax
	mov		ebx, [ebp+8]
	cdq
	idiv	ebx
	cmp		edx, 0
	je		display

	cmp		edx, 5
	jl		display
	inc		eax

display:
	call	WriteDec
		

	pop		ebp
	ret	16


displayMath		ENDP
