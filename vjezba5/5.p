                       `ORG 0 
00000000  01 D8 A0 E3  GLAVNI	MOV	R13, #1<16		; inicijalizacija stoga 
00000004  01 14 A0 E3  	MOV	R1, #1<8		; ulazni blok (100 hex) 
00000008  04 24 A0 E3  	MOV	R2, #4<8		; izlazni blok (400 hex) 
0000000C  08 34 9F E5  	LDR	R3, ZADNJI		; ovaj oznacava prekid 
                        
                        
00000010  04 40 91 E4  LOOP	LDR	R4, [R1], #4		; R4 = R1, R1 = R1 + 4 
                        
00000014  04 00 53 E1  	CMP	R3, R4 
00000018  0D 00 00 0A  	BEQ	KRAJ			; Ucitan zadnji podatak  
                        
                       	;CMP	R4, #0 
0000001C  04 40 82 04  	STREQ	R4, [R2], #4		; R4 -> R2, R2 = R2 + 4 
00000020  FC FF FF 0A  	BEQ	LOOP			; Smece ne moze dijeliti s nulom 
                        
                       					; Baci trenutni podatak na stog 
00000024  10 00 2D E9  	STMFD 	R13!, {R4}		; STMFD = STMDB (store decrease befor
                       					; ! mijenja (povecava) R13 
                        
00000028  0A 00 00 EB  	BL	KUB 
0000002C  04 D0 8D E2  	ADD	R13, R13, #4		; Pozivatelj cisti stog 
                        
00000030  01 50 40 E2  	SUB	R5, R0, #1 
00000034  84 60 A0 E1  	MOV	R6, R4, LSL #1		; 2^1 left shift mnozi 
                        
00000038  60 00 2D E9  	STMFD	R13!, {R5, R6}		; Baci djelitelje na stog 
                        
0000003C  0D 00 00 EB  	BL	DIV 
00000040  08 D0 8D E2  	ADD 	R13, R13, #8		; Ocisti stog 
                        
00000044  04 00 82 E4  	STR	R0, [R2], #4		; R0 -> R2, R2 = R2 + 4 
                        
00000048  F2 FF FF EA  	B	LOOP			; Continue 
                        
                        
                        
0000004C  56 34 12 EF  KRAJ	SWI 123456			; Uduni 
                        
                        
                        
                        
                        
00000050  02 00 2D E9  KUB	STMFD	R13!, {R1}		; Spremi kontekst 
00000054  04 00 8D E2  	ADD	R0, R13, #4		; Preskakanje konteksta 
00000058  02 00 90 E8  	LDMFD	R0, {R1}		; Ucitaj parametar sa stoga  
0000005C  01 00 A0 E1  	MOV	R0, R1			; Backup broja za kasnije mnozenje 
                        
00000060  90 01 00 E0  	MUL	R0, R0, R1 		; ^2 
00000064  90 01 00 E0  	MUL	R0, R0, R1		; ^3 
                        
00000068  02 00 BD E8  	LDMFD	R13!, {R1}		; obnova konteksta 
0000006C  0E F0 A0 E1  	MOV	PC, LR			; Return 
                        
                        
                        
                        
                        
00000070  0E 00 2D E9  DIV 	STMFD	R13!, {R1, R2, R3}  	; Spremi kontekst 
00000074  0C 00 8D E2  	ADD	R0, R13, #0C		; Preskakanje konteksta 
00000078  06 00 90 E8  	LDMFD	R0, {R1, R2}		; Ucitaj parametre sa stoga 
0000007C  00 00 A0 E3  	MOV	R0, #0			; Rezultat 
00000080  00 30 E0 E3  	MVN	R3, #0			; NOT 0 => FFFF FFFF 
                        
00000084  01 10 91 E1  DIVNEG	ORRS	R1, R1, R1		; Or signed da se dobije predznak
00000088  05 00 00 5A  	BPL	DIVLOOP			; Pozitivan, preskoci 
                        
0000008C  01 10 41 E2  	SUB	R1, R1, #1		; Pretvori u pozitivne  
00000090  03 10 21 E0  	EOR	R1, R1, R3		; Exclusive OR  
00000094  01 20 42 E2  	SUB	R2, R2, #1 
00000098  03 20 22 E0  	EOR	R2, R2, R3 
                        
0000009C  02 10 51 E0  DIVLOOP	SUBS	R1, R1, R2 
000000A0  01 00 80 52  	ADDPL	R0, R0, #1 
000000A4  FE FF FF 5A  	BPL	DIVLOOP 
                        
000000A8  0E 00 BD E8  	LDMFD	R13!, {R1, R2, R3}	; Obnovi kontekst 
000000AC  0E F0 A0 E1  	MOV	PC, LR			; Return 
                        
                        
                        
                        
                        
                       `ORG 100 
00000100  00 00 00 00  ULAZNI `DW 00,00,00,00,03,00,00,00,06,00,00,00,FF,FF,FF,F
          03 00 00 00  
          06 00 00 00  
          FF FF FF FF  
          FA FF FF FF  
          00 00 00 80  
                        
                        
                       `ORG 400 
                       IZLAZNI `DS %D 20 
                        
                        
00000414  00 00 00 80  ZADNJI `DW 00,00,00,80 
                       	 
