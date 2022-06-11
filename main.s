;Author:Behi? Erdem
;Student ID: 040170213
Stack_Size       EQU     0x400;
	
				 AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem        SPACE   Stack_Size
__initial_sp

				 AREA    RESET, DATA, READONLY
                 EXPORT  __Vectors
                 EXPORT  __Vectors_End

__Vectors        DCD     __initial_sp               ; Top of Stack
                 DCD     Reset_Handler              ; Reset Handler
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	Button_Handler			  		;interrupt button handler vectr		 
__Vectors_End    

				 AREA    |.text|, CODE, READONLY
Reset_Handler    PROC
                 EXPORT  Reset_Handler
				 ldr	 r0, =0xE000E100
				 movs	 r1,#1	
				 str	 r1,[r0]						 
			     CPSIE	 i					 
                 LDR     R0, =__main
                 BX      R0
                 ENDP
					 
			     AREA	 button, CODE, READONLY
Button_Handler	 PROC
				 EXPORT	 Button_Handler
				 ldr	 r0, =0x40010010
				 ldr	 r1,[r0]
				 ;movs    r3, r1				 
				 movs	 r2,#0xFF
				 ands	 r1,r1,r2			; clearing pending bit				 
				 str 	 r1, [r0]
				 cmp	 r1, #0x10			; for up button
				 beq	 interruptService	;when up button pressed dinasour jumps
				 
				 cmp     r1, #0x04			;when A button pressed all game will be resetted 
				 beq 	playAgain	
				 bne	release
playAgain		
			
				movs 	r5,#75				;Setting game state to 75 for resetting all values at imageDrawBG labe
				mov 	r11,r5
				b 		release
				
interruptService

				mov 	r1, r8
				cmp	 	r1, #70 ; end dino jump
				movs	r1, #34
				mov 	r8, r1
				b 	release					
release
				ldr	 	r2, =0xff			;Again for pending bit			
				ldr 	r0, =0x40010010
				ldr 	r1, [r0]
				ands 	r1, r1, r2 	 ;Setting pending bit to 0
				str 	r1, [r0]
				bx 	lr

		AREA	demo, CODE, READONLY
		EXPORT	__main
		IMPORT cactus_3
		IMPORT dino_1
		IMPORT gameover
;higher registers used for storing data
;r8, jump movement control
;r9 dinasours row data
;r10 cactus's 	column data
;r11 game state 75->reset 	->14 game over

		ENTRY
__main	PROC
		movs    r5,	#70 	;initial dino row
		movs    r6,	#150
		mov 	r9, r6	;dino initial
		movs 	r7,	#250
		mov 	r8, r5	;jump state
		mov 	r10 ,r7	
		movs 	r7, #45
		mov 	r11,r7
		movs 	r5, #0
		movs	r6, #0
		movs 	r7, #0
			
		b 	imageDrawBG		
imageDrawBG
		
		mov 	r1,r11		;if game state takes 75 in interrupt game will reset
		cmp 	r1,#75
		beq 	__main
			
		cmp		r1,#14		;if game state is 14 gameover label is activated
		bne 	DrawBG
		beq 	gameOverCheck
DrawBG
		movs 	r1,#0
		movs 	r2,#0
		movs 	r3,#0
		movs 	r4,#0
		ldr		r1, =0x40010000		;lcd address
		ldr     r0, =0xff000000
		ldr 	r7, =320
		
		movs    r3, r5        		;row counter
rowbg		
		str     r3, [r1]       		;storing row to row register
		movs    r4, r6       		;col counter
columnbg
		ldr 	r7, =320
		str     r4, [r1, #0x4] 		;storing column to column register
		
		str     r0, [r1, #0x8]		;storing the pixel to pixel register
		adds    r4, r4, #1    		;incrementig the column counter to next one
	
		cmp     r4,r7       		;checking ending of the row
		bne     columnbg			;if it is not continuing column operation
		movs    r7,#0				;if it is
		adds    r3, r3, #1     		;incrementing the row counter to next one
		movs	r7,r5
		adds	r7,r7,#240
		cmp     r3, #240   			;checking if we reached end of image
		bne     rowbg
		

imageDrawDino

		mov 	r5, r9
		movs 	r1,#0
		movs 	r2,#0
		movs 	r3,#0
		movs 	r4,#0
		ldr		r1, =0x40010000
		ldr     r2, =dino_1
		
		movs 	r6, #30
		movs    r3, r5        	;row counter
rowDino		
		str     r3, [r1]       	;storing row to row register
		movs    r4, r6       	;col counter
columnDino
		str     r4, [r1, #0x4] 	;storing column to column register
		ldr     r0, [r2]       	;loading the next pixel from image file
		adds    r2, r2, #4     	;point to the next pixel in the image [R G B] values and 1 space
		str     r0, [r1, #0x8]	;storing the pixel to pixel register
		adds    r4, r4, #1    	;incrementig the column counter to next one
		movs    r7,r6
		adds    r7,r7,#30
		cmp     r4,r7       	;checking ending of the row
		bne     columnDino			;if it is not continuing column operation
		movs    r7,#0			;if it is
		adds    r3, r3, #1     	;incrementing the row counter to next one
		movs	r7,r5
		adds	r7,r7,#30
		cmp     r3, r7   		;checking if we reached end of image
		bne     rowDino

imageCactusDraw	;same drawing for cactus

		mov 	r3, r10
		movs 	r6,r3

		movs 	r1,#0
		movs 	r2,#0
		movs 	r3,#0
		movs 	r4,#0
		ldr		r1, =0x40010000
		ldr     r2, =cactus_3
	
		movs 	r5, #150
		movs    r3, r5        	;row counter
rowCactus		
		str     r3, [r1]       	;storing row to row register
		movs    r4, r6       	;col counter
columnCactus
		str     r4, [r1, #0x4] 	;storing column to column register
		ldr     r0, [r2]       	;loading the next pixel from image file
		adds    r2, r2, #4     	;point to the next pixel in the image [R G B] values and 1 space
		str     r0, [r1, #0x8]	;storing the pixel to pixel register
		adds    r4, r4, #1    	;incrementig the column counter to next one
		movs    r7,r6
		adds    r7,r7,#30
		cmp     r4,r7       	;checking ending of the row
		bne     columnCactus			;if it is not continuing column operation
		movs    r7,#0			;if it is
		adds    r3, r3, #1     	;incrementing the row counter to next one
		movs	r7,r5
		adds	r7,r7,#30
		cmp     r3, r7   		;checking if we reached end of image
		bne     rowCactus


;---------------------------------------- after every drawings is done it must be refreshed not before the drawings
;----------------------------------------
refresh
		movs    r2, #1
		str     r2, [r1, #0xc] 	;refreshing screen
		movs    r2, #2
		str     r2, [r1, #0xc]	;clearing screen
		b 	dinoMoveCheck
;----------------------------------------
; ;----------------------------------------
imageDrawJump	;check point for branch instruction because range is too far
		b 	imageDrawBG
goReset
		b	Reset_Handler
; ;------------------------------------------
dinoMoveCheck	;at first dinos movement it has to go up and after that down
				;to achieve that we check r8 if up button is pressed (interrupt)
				
		mov 	r1,r8		;if pressed it starts up and down move
		cmp 	r1, #34
		beq 	dinoMoveUp
		cmp 	r1, #40
		beq 	dinoMoveDown
		bne 	cactusMove	;if button did not pressed it goes cactus move

dinoMoveUp				;dino move up to 70 pixel

		mov  	r5,r9
		subs 	r5, r5, #10
		mov 	r9,r5
		cmp 	r5, #80
		beq 	dinoMoveUpEnd
		bne 		cactusMove

dinoMoveUpEnd

		mov 	r1,r8
		movs 	 r1, #40
		mov 	r8,r1
		b 		cactusMove
;------------------------------------------
;------------------------------------------

dinoMoveDown		;dino taking down move until pixel 150

		mov 	r5,r9
		adds 	r5, r5, #10
		mov 	r9, r5

		cmp 	r5, #150
		beq 	dinoMoveDownEnd
		bne 		cactusMove

dinoMoveDownEnd

		mov 	r1,r8
		movs 	r1, #70
		mov 	r8,r1
		b 		cactusMove
;------------------------------------------
;------------------------------------------
cactusMove 		;cactus has to move always left 
				;there fore row data is always stable 
 		mov 	r6, r10
 		subs 	r6, r6, #10
 		mov 	r10,r6
		
 		cmp 	r6, #0		;taking cactus to rightmost of the screen
		beq 	cactusPosReset
  		mov 	r10,r6
 		b 		gameOverCheck		; all moves have done we have to check if dino intersect with cactus or not

cactusPosReset
 		ldr 	r6	,=0x122
		mov 	r10,r6
		b 		gameOverCheck

	
gameOverCheck

	mov 	r3, r11 ; game over state taken
	cmp		r3,#75	;reset interrupt check if in gameover state reset button pressed game starts over
	beq		imageDrawJump
	
	mov 	r1,r9 	; dino location row
	mov 	r2,r10 	; cactus location col
	subs 	r2,r2,#30	;looking if cactus column is between 30 and 60
	cmp 	r2,#20
	ble		gameOverCheck2	;if it is next label we are going to check dino is in the intersect pixels or not
	b 		imageDrawBG		

gameOverCheck2

	movs 	r4,#140
	subs 	r1,r4,r1	;looking for the dino is between 150th and 130th row pixels 
	cmp 	r1,#20
	ble 	gameOverIn	;if it is gameover state is confirmed
	b		imageDrawBG
	
gameOverIn
	movs 	r3,#14 ;gameover confirmed
	mov 	r11,r3	;gameover state is written to r11
gameOver
		mov 	r3,r11		;in game over state in screen we will see game over text. there fore we do the exact lcd clear/print process again here
		cmp		r4, #14
		ldr		r1, =0x40010000
		movs    r2, #1
		str     r2, [r1, #0xc] 	;refreshing screen
		movs    r2, #2
		str     r2, [r1, #0xc]	;clearing screen
imageDrawGameOver

		movs 	r1,#0
		movs 	r2,#0
		movs 	r3,#0
		movs 	r4,#0
		movs 	r5,#110		;game over state positions approximately middle of the sceen
		movs	r6,#140
		ldr		r1, =0x40010000
		ldr     r2, =gameover	;game ove text image file

		movs    r3, #110       	;row counter
rowGame	
		str     r3, [r1]       	;storing row to row register
		movs    r4, r6       	;col counter
columnGame
		mov 	r5, r11 ; game over state taken
		cmp		r5,#75
		beq		imageDrawJump	;we need to check interrup is taken or not here because if we did not check here when interrupt comes
								;it did not seen by code and generates memory read/write errors
								;one reason to check here almost most of the execution cycle lies on image drawing labels 
								;for example if we check end of the drawing labels we check interrupt 1 time 
								;but in here we check almost thousands times
						
		str     r4, [r1, #0x4] 	;storing column to column register
		ldr     r0, [r2]       	;loading the next pixel from image file
		adds    r2, r2, #4    	;point to the next pixel in the image [R G B] values and 1 space
		str     r0, [r1, #0x8]	;storing the pixel to pixel register
		adds    r4, r4, #1    	;incrementig the column counter to next one
		movs    r7,r6
		adds    r7,r7,#38
		cmp     r4,r7       	;checking ending of the row
		bne     columnGame		;if it is not continuing column operation
		movs    r7,#0			;if it is
		adds    r3, r3, #1     	;incrementing the row counter to next one
		movs	r7,#110
		adds	r7,r7,#21
		cmp     r3, r7   		;checking if we reached end of image
		bne     rowGame

		
		b 		gameOverCheck
;------------------------------------------
;------------------------------------------
;------------------------------------------
;------------------------------------------
stop    b       stop		
		ENDP
		END