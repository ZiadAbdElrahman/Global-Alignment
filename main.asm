
INCLUDE Irvine32.inc
.DATA
str1 byte 100 dup(?) 
str2 byte 100 dup(?) 
ans byte 100 dup(?)


lenstr2 dword ?
lenstr1 dword ?

slen dword ?
blen dword ?

gab dword ?
match dword ?
mismatch dword ?

dp dword 1000 dup(?)
cost dword 1000 dup(?)
road dword 1000 dup(?)
SimpleRoad byte 1000 dup(?)


i dword ?
j dword ?
index dword ?
temp dword ?

del dword ? 
insert dword ?
replace dword ?
.code

main PROC
	call input
	call  matching
	call FillDefultDP
	call FillDP
	call Backtrack
	call crlf
	mov ecx, temp 
	mov esi , temp 
	dec esi
	loop2 :
		mov eax, 0
		mov al, SimpleRoad[esi]
		sub esi , 1
		call writeint
		mov  al, ' '
		call writechar
		loop loop2
	call crlf
	call printS1
	call crlf
	call printSTick
	call crlf 
	call printS2
	EXIT
main ENDP

printS1 PROC 

	mov i, 0
	mov ecx, temp 
	mov esi , temp 
	dec esi
	loop1 :
		cmp SimpleRoad[esi], 2
		je prs1 
		cmp SimpleRoad[esi], 3
		je prs1
		cmp SimpleRoad[esi], 4
		je prs1 

		mov al, '-'
		call writechar
		jmp next
		
		prs1:
			mov ebx, i
			mov al, str1[ebx]
			call writechar
			inc i 
		next :
			dec esi
		loop loop1

	ret
printS1 ENDP

printS2 PROC 

	mov i, 0
	mov ecx, temp 
	mov esi , temp 
	dec esi
	loop1 :
		cmp SimpleRoad[esi], 1
		je prs1 
		cmp SimpleRoad[esi], 3
		je prs1
		cmp SimpleRoad[esi], 4
		je prs1 

		mov al, '-'
		call writechar
		jmp next
		
		prs1:
			mov ebx, i
			mov al, str2[ebx]
			call writechar
			inc i 
		next :
			dec esi
		loop loop1

	ret
printS2 ENDP
	
printSTick PROC
	mov ecx, temp 
	mov esi , temp 
	dec esi
	loop2 :
		
		mov al, ans[esi]
		sub esi , 1
		call writechar
		

		loop loop2
		ret
printStick ENDP
Backtrack PROC
	mov eax, lenstr2

	mov i, eax
	mov eax, lenstr1
	mov j , eax
	mov temp, 0
	loop1 :
		pushad
		push 0
		push i
		push j
		call indexConv
		pop index
		pop index
		pop index
		popad

		mov eax, index
		mov ecx, index
		
		mov esi, temp
		mov ans[esi], ' '

		mov eax, road[ecx]
		
		cmp road[ecx], 1
		je goINS
		cmp road[ecx], 2
		je goDEL
		cmp road[ecx], 3
		je goMIS
		cmp road[ecx], 4
		je goMA

		
		

		goINS :
			dec i
			mov SimpleRoad[esi], 1 
			jmp cont
		goDEL :
			dec j
			mov SimpleRoad[esi], 2
			jmp cont
		goMIS :
			dec i 
			dec j 
			mov SimpleRoad[esi], 3
			jmp cont
		goMA :
			mov ans[esi], '|'
			mov SimpleRoad[esi], 4
			dec j
			dec i 
			jmp cont


		cont : 
			add temp , 1
			mov eax, i 
			cmp eax, 0
			jne loop1
				mov eax, j 
				cmp eax, 0
				je done
				jmp loop1

		done :
		



	ret
Backtrack ENDP

FillDP PROC
	mov i, 1 
	
	mov ecx, lenstr2 

	loop1 :
		mov ebx, ecx
		mov ecx, lenstr1
		mov j ,1
		loop2 :
			pushad
			push 0
			push i
			push j	
			call indexConv
			pop index
			pop index
			pop index
			popad
			pushad
			call max
			popad
			inc j
			loop loop2
			inc i 
			mov ecx, ebx
			loop loop1
		

		
		
		mov i, 0
		mov ecx, lenstr2
		inc ecx 
		loop3 :
			mov j, 0
			mov ebx, ecx
			mov ecx, lenstr1
			inc ecx
			loop4  :
				pushad
				push 0 
				push i 
				push j 
				call indexConv
				pop index
				pop index
				pop index
				popad

				mov edx, index
				mov eax, dp[edx]
				call writeint
				mov al , ' '
				call writechar
				inc j
				loop loop4
				inc i
				mov ecx, ebx
				call crlf
				loop loop3
			call crlf
			call crlf
		
		mov i, 0
		mov ecx, lenstr2
		inc ecx 
		loop5 :
			mov j, 0
			mov ebx, ecx
			mov ecx, lenstr1
			inc ecx
			loop6  :
				pushad
				push 0 
				push i 
				push j 
				call indexConv
				pop index
				pop index
				pop index
				popad

				mov edx, index
				mov eax, road[edx]
				call writeint
				mov al , ' '
				call writechar
				inc j
				loop loop6
				inc i
				mov ecx, ebx
				call crlf
				loop loop5

				
	ret 
fillDP ENDP

max PROC
	
	 mov ebx, index
	 mov eax, dp[ebx - 4]
	 mov del, eax
	 mov ecx, gab
	 add del, ecx
	 mov eax, del
	 
	 mov edi, lenstr1
	 inc edi
	 mov ebx, index
	 mov eax, 4
	 mul edi
	 sub ebx, eax 
	 mov ecx, dp [ebx]
	 mov insert, ecx
	 mov ecx, gab
	 add insert, ecx
	 
	 mov edi, lenstr1
	 inc edi
	 mov ebx, index
	 mov eax, 4
	 mul edi
	 sub ebx, eax 
	 sub ebx, 4 
	 mov ecx, dp [ebx]
	 mov replace, ecx
	

	 mov ebx, j
	 dec ebx 
	 mov dl, str1[ebx]
	 mov ebx, i
	 dec ebx
	 
	 cmp dl, str2[ebx]
	 je EQUAL 
		mov eax, mismatch
		add replace, eax
		mov esi, 3
		jmp cont

	 EQUAL :
		mov eax, match
		add replace, eax 
		mov esi, 4

	 cont : 
		mov eax, del
		cmp eax, insert
		jg  compREP
		mov eax, insert
		cmp eax, replace
		jg makeINS
		jmp makeREP

		compREP :
			cmp eax, replace
			jg makeDEL
			jmp makeREP

			makeINS :
				mov eax, index
				mov road[eax], 1
				mov ebx, insert
				mov dp[eax], ebx
				jmp done
			
		
			makeDEL :
				mov eax, index
				mov road[eax], 2
				mov ebx, del 
				mov dp[eax], ebx
				jmp done
			
				
			makeREP :
				mov eax, index
				mov road[eax], esi
				mov ebx, replace 
				mov dp[eax], ebx
				jmp done

		
			done :
	ret
max ENDP

FillDefultDP PROC

	mov ecx, lenstr1 
	inc ecx 
	mov ebx, 0
	loopS1 :
		pushad
		push 0 
		push 0
		push ebx
		call indexConv
		pop eax
		pop eax
		pop temp
		popad
		mov esi, temp
		mov eax, ebx
		mul gab
		mov dp[esi], eax
		mov road[esi], 2
		inc ebx 
		loop loops1

	mov ecx, lenstr2 
	inc ecx 
	mov ebx, 0
	loopS2 :
		pushad
		push 0 
		push ebx
		push 0
		call indexConv
		pop eax
		pop eax
		pop temp
		popad
		mov esi, temp
		mov eax, ebx
		mul gab
		mov dp[esi], eax
		mov road[esi], 1
		inc ebx 
		loop loopS2
	
	
	ret
FillDefultDP ENDP

matching  PROC
	
	mov eax, lenstr1
	cmp eax, lenstr2
	jge len1B
		mov slen, eax
		mov eax, lenstr2
		mov blen, eax 
	jmp genrate
	
	len1B :
		mov blen, eax
		mov eax, lenstr2
		mov slen, eax 
	
	genrate :
		mov ecx, slen 
		mov ebx, 0
		mov edi, 0
		loop1 : 
			mov dl, str1[ebx]
			cmp dl, str2[ebx]
			je equal
			jmp notEq
			backLoop1 :
			inc ebx
			add edi , 4
			loop loop1
			jmp cont
			
			equal : 
				mov esi, match 
				mov cost[edi], esi
				jmp backLoop1
			notEq : 
				mov esi, mismatch 
				mov cost[edi], esi
				jmp backLoop1
		
		cont : 
			mov ECX, blen 
			sub ecx, slen
			cmp ecx, 0
			je done 
			loop2 :
				mov esi, mismatch 
				mov cost[edi], esi
				add edi, 4 
			loop loop2
			done :
			mov ecx, blen
			mov ebx, 0
	
	ret

matching ENDP

indexConv PROC
	
	mov eax, lenstr1
	inc eax 
	mul dword ptr[esp + 8]
	add eax, [esp + 4]
	mov ebx, 4
	mul ebx

	mov [esp + 12], eax 
	
	RET
indexConv ENDP

input PROC
	mov edx, offset str1
	mov ecx, 50
	call readstring
	mov lenstr1, eax 

	mov edx, offset str2
	mov ecx, 50
	call readstring
	mov lenstr2, eax 

	call readint
	mov gab , eax


	call readint 
	mov match, eax

	call readint 
	mov mismatch, eax
	
	RET
input ENDP
END main