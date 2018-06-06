                       `ORG 0 
00000000  26 00 00 EA  	B	GLAVNI 
                       	 
                        
                        
                        
                        
                       `ORG 18 ; Adresa za obradu prekida  
00000018  3C 40 2D E9  PREKID	STMFD	R13!, {R2,R3,R4,R5,R14}	; Spremanje kontekst
                       						; R2: temp, ><, znak 
                       						; R3: CUNT 3 
                       						; R4: INDEX 
                       						; R5: backup znaka za provjeru 
                       						; R14: ugnjezdjeni program, spremi povratnu adresu 
                        
0000001C  08 00 80 E5  	STR	R0, [R0, #8]		; Prihvat prekida 
                        
00000020  00 20 A0 E3  	MOV	R2, #0 			; Resetiraj brojilo 
00000024  0C 20 80 E5  	STR	R2, [R0, #0C] 
                        
                        
00000028  0D 20 A0 E3  	MOV	R2, #0D			; Brisi interni registar na LCD-u (hint: 0
0000002C  26 00 00 EB  	BL	LCDWR 
                        
00000030  DC 34 9F E5  VECI	LDR	R3, CUNT		; Load 3 
00000034  DC 24 9F E5  	LDR	R2, VECE		; Load > 
00000038  23 00 00 EB  PRINT1	BL	LCDWR 
0000003C  01 30 53 E2  	SUBS	R3, R3, #1 
00000040  FE FF FF 1A  	BNE	PRINT1			; While !Z 
                        
00000044  C4 44 9F E5  ZNAK 	LDR	R4, INDEX 
00000048  04 44 84 E2  	ADD	R4, R4, #4<8 		; INDEX + ORG 400 (odmak) 
0000004C  00 20 D4 E5  	LDRB	R2, [R4] 
                        
00000050  00 00 52 E3  	CMP	R2, #0 
00000054  04 00 00 1A  	BNE	PRINTZ 
00000058  00 40 A0 E3  	MOV	R4, #0 
0000005C  04 44 84 E2  	ADD	R4, R4, #4<8 
00000060  00 20 D4 E5  	LDRB	R2, [R4] 
                        
                        
                       	;MOVEQ 	R4, #0 
                       	;ADDNE	R4, R4, 1 
                       	;STR	R4, INDEX 
                        
                       	;MOV	R5, R2			; Backup za provjeru jer LCDWR unisti R3 
                        
00000064  01 40 84 E2  PRINTZ	ADD	R4, R4, #1 
00000068  04 44 44 E2  	SUB	R4, R4, #4<8 
0000006C  9C 44 8F E5  	STR	R4, INDEX 
00000070  15 00 00 EB  	BL	LCDWR 
                        
00000074  98 34 9F E5  MANJI 	LDR	R3, CUNT 
00000078  9C 24 9F E5  	LDR	R2, MANJE 
0000007C  12 00 00 EB  PRINT2	BL	LCDWR 
00000080  01 30 53 E2  	SUBS	R3, R3, #1 
00000084  FE FF FF 1A  	BNE	PRINT2 
                        
00000088  0A 20 A0 E3  	MOV	R2, #0A 		; Ispis znaka na zaslonu LCD-a (hint: 0D i
0000008C  0E 00 00 EB  	BL	LCDWR 
                        
                        
                       	;SUB	R4, R4, #4<8		; INDEX - ORG 400 
                       	;CMP	R5, #0 
                       	;ADDNE	R4, R4, #1 		; Povecaj INDEX (odmak) jos nije zad
                       	;MOVEQ	R4, #0			; Resetiraj, doslo je do kraja 
                       	;STR	R4, INDEX 
                        
                        
00000090  3C 40 BD E8  	LDMFD	R13!, {R2,R3,R4,R5,R14}	; Obnavljanje konteksta 
00000094  04 F0 5E E2  	SUBS	PC, LR, #4		; Kraj prekidnog programa 
                       					; Izlaz 
                        
                        
                        
                        
                        
00000098  01 D8 A0 E3  GLAVNI	MOV	R13, #1<16		; Inicijalizacija stoga  
0000009C  00 00 0F E1  	MRS	R0, CPSR		; procitaj CPSR 
000000A0  80 00 C0 E3  	BIC	R0, R0, #80		; Na mjestu bita I stavlja se nula 
000000A4  00 F0 21 E1  	MSR	CPSR_c, R0		; Zapisi promjene u CPSR 
                        
000000A8  05 24 A0 E3  	MOV	R2, #5<8		; Na adresi 500 se nalaze adrese RTC i GPI
000000AC  03 00 B2 E8  	LDMIA	R2!, {R0, R1} 		; R0 = RTC, R1 = GPIO (load memory
                        
000000B0  01 24 A0 E3  	MOV	R2, #1<8		; 100 hex = 256 Hz 
000000B4  04 20 80 E5  	STR	R2, [R0, #4]		; Napuni RTCMR (brojac) 
                        
000000B8  01 20 A0 E3  	MOV	R2, #1			; Omoguci prekid na RTCCR 
000000BC  10 20 80 E5  	STR	R2, [R0, #10] 
                        
000000C0  00 00 00 EA  PETLJA	B	PETLJA			; Prazna petlja 
                        
                        
                        
                        
                        
000000C4  04 00 2D E9  LCDWR	STMFD	R13!, {R2} 		; Spremanje konteksta 
                       						; R1: GPIO adresa 
                       						; R2: ASCII vrijednost znaka koji se ispisuje 
                        
000000C8  7F 20 02 E2  	AND	R2, R2, #7F		; Postaviti bit 7 u nulu (za svaki sluc
000000CC  04 20 C1 E5  	STRB	R2, [R1, #4] 
000000D0  80 20 82 E3  	ORR	R2, R2, #80		; Postaviti bit 7 u jedan (podigni impu
000000D4  04 20 C1 E5  	STRB	R2, [R1, #4] 
000000D8  7F 20 02 E2  	AND	R2, R2, #7F 		; Postaviti bit 7 u nulu (spusti impul
000000DC  04 20 C1 E5  	STRB	R2, [R1, #4] 
                        
000000E0  04 00 BD E8  	LDMFD	R13!, {R2} 		; Obnavljanje konteksta 
000000E4  0E F0 A0 E1  	MOV	PC, LR			; Kraj prekidnog programa 
                        
                        
                        
                        
                        
                       `ORG 400 
00000400  49 6E 74 65  SLOVA `DW 49,6E,74,65,72,6E,61,74,69,6F,6E,61,6C,69,73,61
          72 6E 61 74  
          69 6F 6E 61  
          6C 69 73 61  
          74 69 6F 6E  
          00           
                        
                        
                        
                       `ORG 500 
00000500  00 FE FF FF  RTC `DW 00,FE,FF,FF ; Adresa RTC-a  
00000504  00 FF FF FF  GPIO `DW 00,FF,FF,FF ; Adresa GPIO-a  
00000508  00 00 00 00  INDEX `DW 00,00,00,00 ; Trenutno slovo counter  
0000050C  03 00 00 00  CUNT `DW 03,00,00,00 ; Tri puta manje / vece brojac  
00000510  3E 00 00 00  VECE `DW 3E,00,00,00 
00000514  3C 00 00 00  MANJE `DW 3C,00,00,00 
                        
