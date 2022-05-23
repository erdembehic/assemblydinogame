;Author:Behi� Erdem
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
				 DCD	Button_Handler					 
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
				 beq	 interruptHandling
				 ;str	 r3,[r0]
				 ;bx		 lr


		AREA	demo, CODE, READONLY
		EXPORT	__main
		IMPORT  cactus_3
		;IMPORT  cactus_2
		;IMPORT  cactus_1
		
		IMPORT  ground_1
		;IMPORT  ground_2
		;IMPORT  ground_3
		;IMPORT  ground_4
		IMPORT dino_0
		IMPORT dino_1
		IMPORT dino_2
;storing road state counter at 
;storing dino state counter at 
;storing score at 
;storing cactus position column 
;storing row (column hep aynı) 



		ENTRY
__main	PROC
		movs    r5,	#0
		movs    r6,	#0
		movs 	r7,	#0			 
		push 	{r5,r6,r7} ;stack initialization
		push 	{r5,r6,r7}
		
imageDrawBG
		movs 	r5, #0
		movs 	r6, #0
		movs 	r1,#0
		movs 	r2,#0
		movs 	r3,#0
		movs 	r4,#0
		ldr		r1, =0x40010000
		ldr     r0, =0xff000000
		ldr 	r7, =320
		
		movs    r3, r5        	;row counter
rowbg		
		str     r3, [r1]       	;storing row to row register
		movs    r4, r6       	;col counter
columnbg
		ldr 	r7, =320
		str     r4, [r1, #0x4] 	;storing column to column register
		;ldr     r0, [r2]       	;loading the next pixel from image file
		;adds    r2, r2, #1     	;point to the next pixel in the image [R G B] values and 1 space
		str     r0, [r1, #0x8]	;storing the pixel to pixel register
		adds    r4, r4, #1    	;incrementig the column counter to next one
		;movs    r7,r6
		;adds    r7,r7,#30
		cmp     r4,r7       	;checking ending of the row
		bne     columnbg			;if it is not continuing column operation
		movs    r7,#0			;if it is
		adds    r3, r3, #1     	;incrementing the row counter to next one
		movs	r7,r5
		adds	r7,r7,#240
		cmp     r3, #240   		;checking if we reached end of image
		bne     rowbg
		
		;movs 	r5,#150
		;movs	r6,#0
		
		pop 	{r6}
		pop 	{r5}
		
		push 	{r5,r6}
		movs	r6,#0
imageDinoDecision
;dino pop 
; 		pop		{r1} ; dino state
; 		movs 	r2, r1
; 		cmp 	r1,#0
; 		beq 	dino0
; 		cmp		r1,#1
; 		beq		dino1
; 		cmp		r1,#2
; 		beq		dino2
		
; dino0
; 		movs 	r1, #1
; 		push 	{r1}
; 		b 		imageDrawDino
; dino1
; 		movs 	r1, #2
; 		push 	{r1}
; 		b 		imageDrawDino
; dino2
; 		movs 	r1, #0
; 		push 	{r1}
; 		b 		imageDrawDino

imageDrawDino
		; cmp 	r2,#0
		; ldr     r2, =dino_0
		; cmp 	r2,#1
		; ldr     r2, =dino_1
		; cmp 	r2,#2
		;ldr     r2, =dino_1


		ldr 	r2, =dino_0
		movs 	r1,#0
		;movs 	r2,#0
		movs 	r3,#0
		movs 	r4,#0
		ldr		r1, =0x40010000
		;ldr     r2, =dino_1
		
		movs    r3, r5        	;row counter
rowDino		
		str     r3, [r1]       	;storing row to row register
		movs    r4, r6       	;col counter
columnDino
		str     r4, [r1, #0x4] 	;storing column to column register
		ldr     r0, [r2]       	;loading the next pixel from image file
		adds    r2, r2, #4     	;point to the next pixel in the image [R G B] values and opacity
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
		movs 	r6,#250
imageCactusDraw
		movs 	r5, #150
		pop 	{r1}
		pop 	{r2}
		pop 	{r3}
		pop 	{r6} ;cactus column obtained
		push 	{r6,r3,r2,r1}
		movs 	r1,#0
		movs 	r2,#0
		movs 	r3,#0
		movs 	r4,#0
		ldr		r1, =0x40010000
		ldr     r2, =cactus_3
		
		movs    r3, r5        	;row counter
rowCactus	
		str     r3, [r1]       	;storing row to row register
		movs    r4, r6       	;col counter
columnCactus
		str     r4, [r1, #0x4] 	;storing column to column register
		ldr     r0, [r2]       	;loading the next pixel from image file
		adds    r2, r2, #4     	;point to the next pixel in the image [R G B] values and opacity
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
		movs    r2, #1
		str     r2, [r1, #0xc] 	;refreshing screen
		movs    r2, #2
		str     r2, [r1, #0xc]	;clearing screen
		b 	cactusMove
;----------------------------------------
;----------------------------------------
interruptHandling
		pop 	{r5} ; dinostate
		cmp 	r5, #16
		beq 	dinoMoveUp
		cmp 	r5, #45
		beq 	dinoMoveDown
dinoMoveUp
		movs 	r5,#16
		pop 	{r2} ;dino row
		subs 	r2, r2, #10
		cmp		r2, #100
		beq 	dinoUpEnd
		push 	{r5,r2}
		b 		cactusMove
dinoUpEnd
		movs 	r5, #45
		push 	{r5,r2}
		b 	cactusMove

dinoMoveDown	
		cmp 	r2,#45
		bne		cactusMove
		;pop {r1} ; dinostate
		pop {r2} ;dino row
		adds 	r2, r2, #10
		cmp		r2, #150
		beq 	dinoDownEnd
		push 	{r2,r1}
		b 		cactusMove
dinoDownEnd
		movs r2,#16		
		push {r2,r1}

cactusMove
		pop 	{r1}
		pop 	{r2}
		pop 	{r3}
		pop 	{r6} ;cactus column obtained
		cmp 	r6, #0
		beq 	moveEnd
		
		subs 	r6, r6, #10
		;cmp 	r6, #0
		push 	{r6,r3,r2,r1}
		b imageDrawBG
		
moveEnd
		movs r6, #250
		push 	{r6,r3,r2,r1}
		

; dinoMoveUp
; 		pop {r1} ; dinostate
; 		pop {r2} ;dino row
; 		subs 	r2, r2, #10
; 		cmp		r2, #100
; 		beq 	dinoMoveDown
		
; 		push {r2,r1}
; 		b 	imageDrawBG

; dinoMoveDown	
; 		pop {r1} ; dinostate
; 		pop {r2} ;dino row
; 		adds 	r2, r2, #10
; 		cmp		r2, #150
; 		beq 	dinoMoveDown
		
; 		push {r2,r1}
		b 	imageDrawBG

; 		movs 	r5,#120
; 		movs 	r6,#0
; imageRoadDecision
; 		ldr 	r1,=0x40020000
; 		ldr 	r2,[r1]
; 		cmp 	r2,#0
; 		beq 	road0
; 		cmp		r2,#1
; 		beq		road1
; 		cmp		r2,#2
; 		beq		road2
; 		cmp		r2,#3
; 		beq		road3
		
		
; road0
; 		movs 	r3,#1
; 		str 	r3, [r1]
; 		b 		imageDrawRoad
; road1
; 		movs 	r3,#2
; 		str 	r3, [r1]
; 		b 		imageDrawRoad
; road2
; 		movs 	r3,#3
; 		str 	r3, [r1]
; 		b 		imageDrawRoad
; road3
; 		movs 	r3,#0
; 		str 	r3, [r1]
; 		b 		imageDrawRoad

; imageDrawRoad
; 		cmp 	r2,#0
; 		ldr     r2, =ground_1
; 		cmp 	r2,#1
; 		ldr     r2, =ground_1
; 		cmp 	r2,#2
; 		ldr     r2, =ground_1
; 		cmp 	r2,#3
; 		ldr     r2, =ground_1

; 		movs 	r1,#0
; 		;movs 	r2,#0
; 		movs 	r3,#0
; 		movs 	r4,#0
; 		ldr		r1, =0x40010000
; 		;ldr     r2, =ground_1

		
; 		movs    r3, r5        	;row counter
; rowGround		
; 		str     r3, [r1]       	;storing row to row register
; 		movs    r4, r6       	;col counter
; columnGround
; 		str     r4, [r1, #0x4] 	;storing column to column register
; 		ldr     r0, [r2]       	;loading the next pixel from image file
; 		adds    r2, r2, #4     	;point to the next pixel in the image [R G B] values and opacity
; 		str     r0, [r1, #0x8]	;storing the pixel to pixel register
; 		adds    r4, r4, #1    	;incrementig the column counter to next one
; 		movs    r7,r6
; 		adds    r7,r7,#240
; 		cmp     r4,r7       	;checking ending of the row
; 		bne     columnGround			;if it is not continuing column operation
; 		movs    r7,#0			;if it is
; 		adds    r3, r3, #1     	;incrementing the row counter to next one
; 		movs	r7,r5
; 		adds	r7,r7,#10
; 		cmp     r3, r7   		;checking if we reached end of image
; 		bne     rowGround
			
; 		pop		{r5}
; 		pop		{r6}
		
; 		movs 	r5,#120
; 		movs	r6,#50

; ;cactus location taken from memory

; 		ldr		r4, =0x4005400 ;cactus x row aslında sadece column değişecek
; 		movs 	r6,r4
; 		ldr		r4, =0x4005800 ;cactus y col
; 		movs 	r5,r4
; imageCactusDecision
; 		ldr 	r1,=0x4005000 
; 		ldr 	r2,[r1]
; 		;cmp 	r6,#320
; 		bne		imageDrawCactus
; 		cmp 	r2,#0
; 		beq 	road0
; 		cmp		r2,#1
; 		beq		road1
; 		cmp		r2,#2
; 		beq		road2
; 		cmp		r2,#3
; 		beq		road3
		
		
; cactus0
; 		movs 	r3,#1
; 		str 	r3, [r1]
; 		b 		imageDrawCactus
; cactus1
; 		movs 	r3,#2
; 		str 	r3, [r1]
; 		b 		imageDrawCactus
; cactus2
; 		movs 	r3,#3
; 		str 	r3, [r1]
; 		b 		imageDrawCactus	


; imageDrawCactus
; 		cmp 	r2,#0
; 		ldr     r2, =cactus_1
; 		cmp 	r2,#1
; 		ldr     r2, =cactus_1
; 		cmp 	r2,#2
; 		ldr     r2, =cactus_1

; 		movs 	r1,#0
; 		;movs 	r2,#0
; 		movs 	r3,#0
; 		movs 	r4,#0
; 		ldr		r1, =0x40010000
; 		;ldr     r2, =ground_1

		
; 		movs    r3, r5        	;row counter
; rowCactus		
; 		str     r3, [r1]       	;storing row to row register
; 		movs    r4, r6       	;col counter
; columnCactus
; 		str     r4, [r1, #0x4] 	;storing column to column register
; 		ldr     r0, [r2]       	;loading the next pixel from image file
; 		adds    r2, r2, #4     	;point to the next pixel in the image [R G B] values and opacity
; 		str     r0, [r1, #0x8]	;storing the pixel to pixel register
; 		adds    r4, r4, #1    	;incrementig the column counter to next one
; 		movs    r7,r6
; 		adds    r7,r7,#30
; 		cmp     r4,r7       	;checking ending of the row
; 		bne     columnCactus			;if it is not continuing column operation
; 		movs    r7,#0			;if it is
; 		adds    r3, r3, #1     	;incrementing the row counter to next one
; 		movs	r7,r5
; 		adds	r7,r7,#30
; 		cmp     r3, r7   		;checking if we reached end of image
; 		bne     rowCactus
			
; 		pop		{r5}
; 		pop		{r6}
		
		;movs 	r5,#120
	;	movs	r6,#50

		b		imageDrawBG
;----------------------------------------
;dinazor agaç yol

;----------------------------------------	

;moveRoad yolu oynatmamıza gerek yok 
;değişen yol görüntüleri hareket gibi olacak

; moveCactus
; 	ldr r4,=0x40058000 ; cactus column
; 	movs	r5,r4
; 	subs 	r5,#10
; 	cmp 	r5,#0
; 	movs 	r5,#255
; 	str		r5,[r4]
; 	b	imageDrawBG


; dinoDown
; 	pop {r7}
; 	adds r5,#10
; 	cmp	 r7,#60
; 	beq stop 
	
; 	adds r7,#10
; 	push {r7}
; 	push {r6}
; 	push {r5}
; 	movs r5,#0
; 	movs r6,#0
; 	b imageDrawBG
	
; downEnd
; 	movs r7, #0
; 	push {r7}
; 	push {r6}
; 	push {r5}
; 	movs r5,#0
; 	movs r6,#0
; 	b imageDrawBG


	


stop    b       stop		
		ENDP
		END
