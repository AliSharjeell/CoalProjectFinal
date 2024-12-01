include irvine32.inc
.data

titleMsg byte "DOTS AND BOXES", 0
pressStartMsg byte "Press any key to start...", 0
creditsMsg byte "Made by:", 0
credit1 byte "M. Mustafa", 0
credit2 byte "Ali Sharjeel", 0
credit3 byte "Affan Rehman", 0
gameOverMsg byte "Game Over!", 0
winnerMsg1 byte "Player 1 Wins!", 0
winnerMsg2 byte "Player 2 Wins!", 0
drawMsg byte "It's a Draw!", 0
playAgainMsg byte "Press any key to play again...", 0

player1score dword 0
player2score dword 0
strscores byte "Scores",0
strscore1 byte "Player 1: ",0
strscoregap byte "         ",0
strscore2 byte "Player 2: ",0

liner byte "==========================================",0

dot byte ".", 0

space byte "   ", 0
dspace byte "  ", 0
singlespace byte " ", 0
substr1 BYTE 2 DUP(0)       ; Reserve space for one character + null terminator
tempeax dword ?
tempecx dword ?


r0 byte ".   .   .   .   .", 0
r1 byte "                       .", 0
r2 byte "                       .", 0
r3 byte ".   .   .   .   .", 0
r4 byte "                       .", 0
r5 byte "                       .", 0
r6 byte ".   .   .   .   .", 0
r7 byte "                       .", 0
r8 byte "                       .", 0
r9 byte ".   .   .   .   .", 0
r10 byte "                       .", 0
r11 byte "                       .", 0
r12 byte ".   .   .   .   .", 0


r13 byte "                 ", 0
r14 byte "                       .", 0
r15 byte "                       .", 0
r16 byte "                 ", 0
r17 byte "                       .", 0
r18 byte "                       .", 0
r19 byte "                 ", 0
r20 byte "                       .", 0
r21 byte "                       .", 0
r22 byte "                 ", 0
r23 byte "                       .", 0
r24 byte "                       .", 0
r25 byte "                 ", 0

r26 byte "                 ", 0
r27 byte "                       .", 0
r28 byte "                       .", 0
r29 byte "                 ", 0
r30 byte "                       .", 0
r31 byte "                       .", 0
r32 byte "                 ", 0
r33 byte "                       .", 0
r34 byte "                       .", 0
r35 byte "                 ", 0
r36 byte "                       .", 0
r37 byte "                       .", 0
r38 byte "                 ", 0


array dword offset r0, offset r1, offset r2, offset r3, offset r4, offset r5, offset r6, offset r7, offset r8, offset r9, offset r10, offset r11, offset r12
RedArray dword offset r13, offset r14, offset r15, offset r16, offset r17, offset r18, offset r19, offset r20, offset r21, offset r22, offset r23, offset r24, offset r25
BlueArray dword offset r26, offset r27, offset r28, offset r29, offset r30, offset r31, offset r32, offset r33, offset r34, offset r35, offset r36, offset r37, offset r38


startc byte ?
startr byte ?

startPrompt byte "Input the Row: ", 0
endPrompt byte "Input the Col: ", 0
rcPrompt byte "Input the row or column movement: ", 0
p1prompt byte "Player 1 Turn", 0
p2prompt byte "Player 2 Turn", 0
contprompt byte "Press any key to continue: ", 0

turns dword 0
rc byte ?
row byte "r", 0
.code
main proc
    Start:
    ; Clear screen at start
    call clrscr
    
    ; Display title screen
    mov dh, 10    ; Row 10
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET titleMsg
    call WriteString
    
    ; Display credits
    mov dh, 13    ; Row 13
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET creditsMsg
    call WriteString
    
    mov dh, 14    ; Row 14
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET credit1
    call WriteString
    
    mov dh, 15    ; Row 15
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET credit2
    call WriteString
    
    mov dh, 16    ; Row 16
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET credit3
    call WriteString
    
    ; Display press start message
    mov dh, 19    ; Row 19
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET pressStartMsg
    call WriteString
    
    ; Wait for key press
    call ReadChar
    call clrscr
    
    ; Reset game variables
    mov player1score, 0
    mov player2score, 0
    mov turns, 0
    
    gameLoop:
    call drawgridbox
    lea edx, liner
    call writestring
    call crlf
	lea edx,strscores 
	call writestring
	call crlf
	lea edx,liner
	call writestring
	call crlf
	lea edx,strscore1  
	call writestring
	push eax
	mov eax,player1score 
	call writedec
	lea edx,strscoregap  
	call writestring
	lea edx,strscore2   
	call writestring
	mov eax,player2score 
	call writedec
	pop eax
	call crlf
	lea edx,liner
	call writestring
	call crlf

	mov eax, turns
	test turns, 1
	jz player1    ;player 1 turn
	
	player2:
	mov edx, offset p2prompt
	call writestring
	call crlf
	jmp cont
	
	player1:
	mov edx, offset p1prompt
	call writestring
	call crlf




	cont:
    call takeInputs
    
    mov esi, 0
    mov al, rc[esi]
    cmp al, 'r'
    jne stringsAreNotEqual
    jmp stringsAreEqual 

stringsAreEqual:
    call modifyRow
    jmp continueGame

stringsAreNotEqual:
    ; code to execute if strings are not equal
    call modifyCol
    jmp continueGame

continueGame:
    call checkthegrids
    call drawgridbox
    
    ; Check if game is over (total score = 16)
    mov eax, player1score
    add eax, player2score
    cmp eax, 16
    je GameOver
    
    inc turns
    mov edx, offset contprompt
    call writestring
    ;call ReadChar
    call clrscr
    jmp gameLoop

GameOver:
    call clrscr
    
    ; Display game over message
    mov dh, 10    ; Row 10
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET gameOverMsg
    call WriteString
    
    ; Compare scores and display winner
    mov eax, player1score
    cmp eax, player2score
    ja Player1Wins
    jb Player2Wins
    
    ; If equal, display draw
    mov dh, 12    ; Row 12
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET drawMsg
    jmp DisplayFinalScore
    
Player1Wins:
    mov dh, 12    ; Row 12
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET winnerMsg1
    jmp DisplayFinalScore
    
Player2Wins:
    mov dh, 12    ; Row 12
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET winnerMsg2
    
DisplayFinalScore:
    call WriteString
    
    ; Display final scores
    mov dh, 14    ; Row 14
    mov dl, 35    ; Column 35
    call Gotoxy
    lea edx, strscore1
    call writestring
    mov eax, player1score
    call writedec
    
    mov dh, 15    ; Row 15
    mov dl, 35    ; Column 35
    call Gotoxy
    lea edx, strscore2
    call writestring
    mov eax, player2score
    call writedec
    
    ; Display play again message
    mov dh, 17    ; Row 17
    mov dl, 35    ; Column 35
    call Gotoxy
    mov edx, OFFSET playAgainMsg
    call WriteString
    
    ; Wait for key press
    call ReadChar
    jmp Start     ; Jump back to start for new game

    mov eax, 0
    call ExitProcess
main endp

checkthegrids proc

nextbox1:
mov esi,0
mov eax,array[esi]
add eax,1
cmp byte ptr [eax],'_'
je check2ofbox
jmp nextbox2
check2ofbox:
	mov esi, 0
	imul esi, 3
	inc esi 
	mov eax, array[esi * TYPE array] 
    mov ecx, 0
	imul ecx, 4
	add eax, ecx
cmp byte ptr [eax],'|'
je check3ofbox
jmp nextbox2
check3ofbox:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox
jmp nextbox2
check4ofbox:

	mov esi, 1           
	imul esi, 3
    mov eax, array[esi * type array] 

    mov ecx, 0                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken
jmp nextbox2
checkiftaken:
mov esi, 0
	imul esi, 3
	inc esi 
	mov eax, array[esi * TYPE array] 
    mov ecx, 0
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox2
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored
inc player2score
jmp nextbox2
player1scored:
inc player1score

nextbox2:
mov esi,0
mov eax,array[esi]
add eax,5
cmp byte ptr [eax],'_'
je check2ofbox2
jmp nextbox3
check2ofbox2:
	mov esi, 0
	imul esi, 3
	inc esi 
	mov eax, array[esi * TYPE array] 
    mov ecx, 1
	imul ecx, 4
	add eax, ecx
cmp byte ptr [eax],'|'
je check3ofbox2
jmp nextbox3
check3ofbox2:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox2
jmp nextbox3
check4ofbox2:

	mov esi, 1           
	imul esi, 3
    mov eax, array[esi * type array] 

    mov ecx, 0                
	inc eax
    imul ecx, 4                      
    add eax, ecx
	add eax,4

cmp byte ptr [eax],'_'
je checkiftaken2
jmp nextbox3
checkiftaken2:
mov esi, 0
	imul esi, 3
	inc esi 
	mov eax, array[esi * TYPE array] 
    mov ecx, 0
	imul ecx, 4
	add eax, ecx
	inc eax
	add eax,4
cmp byte ptr [eax],'.'
je nextbox3
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored2
inc player2score
jmp nextbox3
player1scored2:
inc player1score









nextbox3:
mov startr,0
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,2
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox3
jmp nextbox4
check2ofbox3:
	mov startr,0
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, array[esi * TYPE array] 
	
	mov startc,2
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx


cmp byte ptr [eax],'|'
je check3ofbox3
jmp nextbox4
check3ofbox3:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox3
jmp nextbox4
check4ofbox3:

	mov startr,1
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,2
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken3
jmp nextbox4
checkiftaken3:
	mov startr,0
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, array[esi * TYPE array] 
	
	mov startc,2
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox4
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored3
inc player2score
jmp nextbox4
player1scored3:
inc player1score














nextbox4:
mov startr,0
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,3
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox4
jmp nextbox5
check2ofbox4:
	mov startr,0
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, array[esi * TYPE array] 
	
	mov startc,3
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx


cmp byte ptr [eax],'|'
je check3ofbox4
jmp nextbox5
check3ofbox4:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox4
jmp nextbox5
check4ofbox4:

	mov startr,1
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,3
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken4
jmp nextbox5
checkiftaken4:
	mov startr,0
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, array[esi * TYPE array] 
	
	mov startc,3
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox5
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored4
inc player2score
jmp nextbox5
player1scored4:
inc player1score





nextbox5:

mov startr,1
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,0
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox5
jmp nextbox6
check2ofbox5:
	mov startr,1
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, array[esi * TYPE array] 
	
	mov startc,0
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx


cmp byte ptr [eax],'|'
je check3ofbox5
jmp nextbox6
check3ofbox5:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox5
jmp nextbox6
check4ofbox5:

	mov startr,2
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,0
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken5
jmp nextbox6
checkiftaken5:
	mov startr,1
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, array[esi * TYPE array] 
	
	mov startc,0
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox6
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored5
inc player2score
jmp nextbox6
player1scored5:
inc player1score




nextbox6:

mov startr,1
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,1
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox6
jmp nextbox7
check2ofbox6:
	mov startr,1
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,1
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox6
jmp nextbox7
check3ofbox6:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox6
jmp nextbox7
check4ofbox6:

	mov startr,2
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,1
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken6
jmp nextbox7
checkiftaken6:
	mov startr,1
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,1
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox7
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored6
inc player2score
jmp nextbox7
player1scored6:
inc player1score

nextbox7:

mov startr,1
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,2
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox7
jmp nextbox8
check2ofbox7:
	mov startr,1
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,2
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox7
jmp nextbox8
check3ofbox7:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox7
jmp nextbox8
check4ofbox7:

	mov startr,2
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,2
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken7
jmp nextbox8
checkiftaken7:
	mov startr,1
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,2
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox8
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored7
inc player2score
jmp nextbox8
player1scored7:
inc player1score

nextbox8:

mov startr,1
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,3
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox8
jmp nextbox9
check2ofbox8:
	mov startr,1
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,3
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox8
jmp nextbox9
check3ofbox8:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox8
jmp nextbox9
check4ofbox8:

	mov startr,2
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,3
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken8
jmp nextbox9
checkiftaken8:
	mov startr,1
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,3
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox9
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored8
inc player2score
jmp nextbox9
player1scored8:
inc player1score

nextbox9:

mov startr,2
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,0
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox9
jmp nextbox10
check2ofbox9:
	mov startr,2
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,0
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox9
jmp nextbox10
check3ofbox9:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox9
jmp nextbox10
check4ofbox9:

	mov startr,3
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,0
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken9
jmp nextbox10
checkiftaken9:
	mov startr,2
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,0
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox10
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored9
inc player2score
jmp nextbox10
player1scored9:
inc player1score

nextbox10:

mov startr,2
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,1
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox10
jmp nextbox11
check2ofbox10:
	mov startr,2
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,1
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox10
jmp nextbox11
check3ofbox10:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox10
jmp nextbox11
check4ofbox10:

	mov startr,3
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,1
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken10
jmp nextbox11
checkiftaken10:
	mov startr,2
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,1
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox11
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored10
inc player2score
jmp nextbox11
player1scored10:
inc player1score

nextbox11:

mov startr,2
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,2
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox11
jmp nextbox12
check2ofbox11:
	mov startr,2
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,2
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox11
jmp nextbox12
check3ofbox11:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox11
jmp nextbox12
check4ofbox11:

	mov startr,3
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,2
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken11
jmp nextbox12
checkiftaken11:
	mov startr,2
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,2
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox12
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored11
inc player2score
jmp nextbox12
player1scored11:
inc player1score

nextbox12:

mov startr,2
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,3
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox12
jmp nextbox13
check2ofbox12:
	mov startr,2
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,3
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox12
jmp nextbox13
check3ofbox12:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox12
jmp nextbox13
check4ofbox12:

	mov startr,3
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,3
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken12
jmp nextbox13
checkiftaken12:
	mov startr,2
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,3
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox13
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored12
inc player2score
jmp nextbox13
player1scored12:
inc player1score

nextbox13:

mov startr,3
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,0
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox13
jmp nextbox14
check2ofbox13:
	mov startr,3
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,0
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox13
jmp nextbox14
check3ofbox13:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox13
jmp nextbox14
check4ofbox13:

	mov startr,4
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,0
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken13
jmp nextbox14
checkiftaken13:
	mov startr,3
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,0
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox14
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored13
inc player2score
jmp nextbox14
player1scored13:
inc player1score

nextbox14:

mov startr,3
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,1
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox14
jmp nextbox15
check2ofbox14:
	mov startr,3
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,1
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox14
jmp nextbox15
check3ofbox14:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox14
jmp nextbox15
check4ofbox14:

	mov startr,4
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,1
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken14
jmp nextbox15
checkiftaken14:
	mov startr,3
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,1
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox15
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored14
inc player2score
jmp nextbox15
player1scored14:
inc player1score

nextbox15:

mov startr,3
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,2
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox15
jmp nextbox16
check2ofbox15:
	mov startr,3
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,2
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox15
jmp nextbox16
check3ofbox15:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox15
jmp nextbox16
check4ofbox15:

	mov startr,4
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,2
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken15
jmp nextbox16
checkiftaken15:
	mov startr,3
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,2
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je nextbox16
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored15
inc player2score
jmp nextbox16
player1scored15:
inc player1score

nextbox16:

mov startr,3
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,3
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx     
cmp byte ptr [eax],'_'
je check2ofbox16
jmp done
check2ofbox16:
	mov startr,3
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,3
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

cmp byte ptr [eax],'|'
je check3ofbox16
jmp done
check3ofbox16:
add eax,4
cmp byte ptr [eax],'|'
je check4ofbox16
jmp done
check4ofbox16:

	mov startr,4
movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

	mov startc,3
    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx  

cmp byte ptr [eax],'_'
je checkiftaken16
jmp done
checkiftaken16:
	mov startr,3
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    mov eax, array[esi * TYPE array] 
	
	mov startc,3
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	inc eax
cmp byte ptr [eax],'.'
je done
mov byte ptr [eax],'.'
mov eax, turns
test turns, 1
jz player1scored16
inc player2score
jmp done
player1scored16:
inc player1score

done:



ret
checkthegrids endp

takeInputs proc

	; take row or column input
	mov edx, offset rcPrompt
	call writestring
	mov edx, offset rc
	mov ecx, 2
	call readstring
	
	;call writestring
	call crlf



	; Ask for the row
    mov edx, offset startPrompt
    call writestring
    call readint
    mov startr, al       ; Store the row in startr

    ; Ask for the column
    mov edx, offset endPrompt
    call writestring
    call readint
    mov startc, al       ; Store the column in startc

    call crlf
	ret
	takeInputs endp

modifyRow proc
    ; For main array
    movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx                     

    mov byte ptr [eax], '_'          
    inc eax
    mov byte ptr [eax], '_'          
	inc eax
	mov byte ptr [eax], '_' 

	; for red or blue array

	test turns, 1	; if even(0) player 1, else player 2
	jz p1
	; p2 part, Bluearray
	
	movzx esi, startr           
	imul esi, 3
    mov eax, Bluearray[esi * type array] 

    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx                     

    mov byte ptr [eax], '_'          
    inc eax
    mov byte ptr [eax], '_'          
	inc eax
	mov byte ptr [eax], '_'
	jmp cont

	; p1 part, Redarray
	p1:
	
	movzx esi, startr           
	imul esi, 3
    mov eax, Redarray[esi * type array] 

    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx                     

    mov byte ptr [eax], '_'          
    inc eax
    mov byte ptr [eax], '_'          
	inc eax
	mov byte ptr [eax], '_'

	cont:
    ret
modifyRow endp




modifyCol proc
	
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, array[esi * TYPE array] 
	
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

    mov byte ptr [eax], '|' 
	inc esi
	mov eax, array[esi * TYPE array] 
	movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	mov byte ptr [eax], '|' 


	test turns, 1	; if even(0) player 1, else player 2
	jz p1
	; p2 part, Bluearray
	
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, Bluearray[esi * TYPE array] 
	
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

    mov byte ptr [eax], '|' 
	inc esi
	mov eax, Bluearray[esi * TYPE array] 
	movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	mov byte ptr [eax], '|' 
	jmp cont


	p1:
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, Redarray[esi * TYPE array] 
	
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

    mov byte ptr [eax], '|' 
	inc esi
	mov eax, Redarray[esi * TYPE array] 
	movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	mov byte ptr [eax], '|' 


	cont:
    ret
modifyCol endp






drawgridbox proc	
	
	mov eax, white
	call settextcolor
	mov eax, 0
	mov edx, offset dspace
	call writestring
	l3:
		call writedec
		mov edx, offset space
		call writestring
		cmp eax, 4
		jge out3
		inc eax
		jmp l3
	
	out3:
	mov esi, 0
	mov eax, 0
	call crlf
	call crlf
	mov ecx, 0
	

	L2:
		Cmp eax, 13
		Jge out2

		mov tempeax, eax
		mov tempecx, ecx
		mov eax, white
		call settextcolor
		mov eax, tempeax
		mov ecx, 3
		mov edx, 0 ; 
		div ecx	; eax gets divided by 3, edx has the remainder, 
		test edx, edx
		jnz nn
		call writedec ; quotient already in eax
		
		jmp cont1
		
		nn:
			mov edx, offset singlespace
			call writestring
		cont1:
		mov edx, offset singlespace
		call writestring
		mov eax, tempeax
		mov ecx, tempecx

		mov ecx, array[esi * type array]		; current string
		mov edx, Redarray[esi * type Redarray]
		mov edi, Bluearray[esi * type Bluearray]
		mov tempeax, eax
		
		L1:
			Cmp byte ptr [ecx], 0	; check if end of current
			Je out1
			Mov bl, [ecx]		; only one byte gets moved
			Mov bh, [edx]		; the red array
			Mov [substr1], bl
			mov byte ptr [substr1 + 1], 0
			push edx
			Cmp bl, bh			
			Je dosmth
	
			Dosmthelse:
				Mov bl, [ecx]		; only one byte gets moved
				Mov bh, [edi]		; the red array
				Cmp bl, bh
				jne cont3
				mov eax, blue
				call settextcolor
				jmp cont
				cont3:
				Mov eax, white
				Call settextcolor
				Jmp cont
			Dosmth:
	
				Mov eax, red
				Call settextcolor
			Cont:
				Mov edx, offset substr1
				Call writestring
				Pop edx
				Inc edx
				Inc ecx
				inc edi
				Jmp l1
				Out1:

			mov eax, tempeax
			Inc eax	; eax is used as row counter
			Inc esi	; row index
			Call crlf
			Jmp l2
			Out2:

	
	call crlf
	mov eax, white
	call settextcolor
	ret
drawgridbox endp

end main
