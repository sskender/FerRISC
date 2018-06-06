                       `ORG 0 
00000000  44 00 80 04  	MOVE	DATA, R1		; R1 pointer na ulazne podatke (dolje iz 
00000004  00 10 80 07  	MOVE	1000, R7		; Backup podataka (boj se uniste s rotaci
                        
                        
                        
00000008  00 00 10 A5  LOOP	LOADH	R2, (R1)		; i-ti podatak iz R1 
0000000C  02 00 90 A5  	LOADH	R3, (R1+2)		; i-ti + 1 podatak iz R1 (16bit pa se 
                        
                        
00000010  00 80 20 6C  CHECK1	CMP	R2, 8000		; Vidi prvi 
00000014  04 00 C0 D5  	JR_EQ	CHECK2			; Prvi je, vidi za drugi 
00000018  28 00 00 C4  	JP	SKIP 			; Prvi nije, preskoci provjere 
0000001C  00 80 30 6C  CHECK2	CMP	R3, 8000		; Vidi sad drugi 
00000020  1C 00 C0 D5  	JR_EQ	EXIT			; I drugi je, uduni 
00000024  28 00 00 C4  	JP SKIP				; Drugi nije, preskoci halt 
                        
                        
                       SKIP					; Dobri su podaci, nije izasao program, obradi i
00000028  00 00 00 89  	PUSH R2 			; Baci ovo na stog da potprogram moze uhvatit
0000002C  00 00 80 89  	PUSH R3				; Baci i ovo na stog da potprogram moze uhvat
                        
00000030  5C 00 00 CC  	CALL	VISE_1			; Kad je sve fino namjesteno zovi covika 
                       	 
00000034  00 00 10 BC  	STORE	R0, (R1)		; Stavi ovo sto je covik donio u R1 (tre
00000038  04 00 90 24  	ADD	R1, 4, R1		; Sad su 32 bit u R0, a ne 16 bit pa treb
                       	 
0000003C  08 00 00 C4  	JP	LOOP			; Ovo usporedjeno, nastavi dalje 
                        
                        
                        
                        
00000040  00 00 00 F8  EXIT 	HALT				; Uduni (ovdje bi trebali pisati izlazi) 
00000044  34 12 FF 00  DATA `DW 34,12,FF,00,FF,00,01,FF,01,00,FF,FF,2A,00,0A,02,
          FF 00 01 FF  
          01 00 FF FF  
          2A 00 0A 02  
          56 04 23 01  
          00 80 00 80  
                        
                        
                        
                        
                       VISE_1  				; Potpogram 
                       					; R2 i R3 su na stogu gore stavljeni (to hvata vamo)
                       					; Vraca preko R0 (to poslije spremiti negdje gore) 
0000005C  08 00 70 B5  	LOAD	R2, (R7+8) 
00000060  04 00 F0 B5  	LOAD	R3, (R7+4) 
00000064  00 00 00 06  	MOVE	0, R4			; Broj jedinica od prvog (R2) 
00000068  00 00 80 06  	MOVE	0, R5			; Broj jedinica od drugog (R3) 
0000006C  16 00 00 07  	MOVE	16, R6			; Len podatka (ima 16 bit pa treba znati k
                        
                        
                       COUNT					; For i in each bit u R2 i R3 
00000070  01 00 20 4D  FIRST	ROTR	R2, 1, R2		; Rotiraj PRVI da bit padne u carry
00000074  04 00 00 D5  	JR_NC	SECOND			; Nema 1 u prvom, preskoci povecanje jedi
00000078  01 00 40 26  	ADD	R4, 1, R4		; Ima 1 u prvom, povecaj brojac jedinica 
                        
0000007C  01 00 B0 4D  SECOND	ROTR	R3, 1, R3		; Rotiraj DRUGI da bit padne u car
00000080  04 00 00 D5  	JR_NC	LESS			; Nema 1 u prvom, preskoci povecanje jedini
00000084  01 00 D0 26  	ADD	R5, 1, R5		; Ima 1 u drugom, povecaj brojac jedinica
                        
00000088  01 00 60 37  LESS	SUB	R6, 1, R6		; Oduzmi broj preostalih bitova (len 
0000008C  E0 FF 0F D6  	JR_NZ	COUNT			; Nije proslo kroz svih 16 bit, continue 
                        
                        
00000090  00 00 4A 68  	CMP	R4, R5			; Usporedi brojace jedinica gdje ima vise 
00000094  08 00 80 D6  	JR_UGT	RET1			; Prvi je veci, vrati taj 
00000098  0C 00 00 D5  	JR_ULT	RET2			; Drugi je veci, vrati taj 
0000009C  20 00 00 D4  	JR	RET_CON			; Isti su, vrati onu konstantu 
                        
                        
000000A0  08 00 70 A4  RET1 	LOADH	R0, (R7+8)		; Spremi prvi iz backupa u R0 koj
000000A4  AC 00 00 C4  	JP	EXPAND			; Da se ne prebrise s drugim 
000000A8  04 00 70 A4  RET2	LOADH	R0, (R7+4)		; Spremi drugi iz backupaa u R0 ko
                        
                       					; Sad napravi prosirivanje (16 -> 32), 70.str zbirka
000000AC  10 00 00 44  EXPAND	ROTL	R0, 10, R0		; Pomaknuti ulijevo za 16bit da s
000000B0  04 00 80 D4  	JR_P	PLUS			; Pozitivan je (nema 1 na pocetku) bmk 
000000B4  FF FF 00 0C  NEG	OR	R0, 0FFFF, R0		; Zato jer ovako pise u zbirci, ist
000000B8  10 00 00 4C  PLUS	ROTR	R0, 10, R0		; Sad ga vrati nazad kako je bilo p
000000BC  00 00 00 D8  	RET				; Vrati R0 
                        
                       	 
000000C0  00 80 00 04  RET_CON	MOVE	8000, R0 		; Ubaci konstantu 
000000C4  10 00 00 54  	SHL	R0, 10, R0		; Pomakni jer smece ne moze procitati ka
000000C8  00 00 00 D8  	RET				; Vrati R0 
                        
