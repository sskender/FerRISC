                       `ORG 0 
00000000  00 05 00 B0  	LOAD 	R0, (500)		; Broj podataka u bloku (32 bit podatak
00000004  04 05 80 04  	MOVE 	504, R1			; Sljedeci je za 4 boj je 32 bit, to je 
00000008  00 10 00 05  	MOVE 	1000, R2		; Pointer na izlaznu listu (ide na ovaj 
                        
                        
0000000C  01 00 90 95  LOOP	LOADB 	R3, (R1+1)		; Ucita se 1B za usporedbe (R3 je
                        
00000010  80 00 30 6C  	CMP	R3, 80			; 80 hex: prvi bit 1, ostali 0 pa se gleda 
00000014  1C 00 00 C6  	JP_NZ	CHECK			; Not zero, znaci ne treba komplement, pro
00000018  2C 00 00 C4  	JP	NEG			; Inace je negativan, preskoci check i odi rije
                        
0000001C  00 00 30 6C  CHECK	CMP	R3, 00			; Provjeri opseg 
00000020  40 00 C0 C5  	JP_Z	FILL			; Dodaj prvo cijeli broj u registar onda spr
00000024  80 00 80 05  	MOVE	80, R3			; Inace ubaci 80 i spremi (ne treba vise n
00000028  44 00 00 C4  	JP	SAVE			; Odi spremi 
                        
0000002C  00 00 90 95  NEG 	LOADB	R3, (R1)		; Cijeli sad unesi u registar (dosad
00000030  FF FF B0 15  	AND	R3, 0FFFF, R3		; Maska: brise bitove na pocetku (s n
00000034  FF FF B0 1D  	XOR	R3, 0FFFF, R3 		; Komplement preostalih nizih bitova
00000038  01 00 B0 25  	ADD	R3, 1, R3		; Dodati jedan boj tako treba u mrtvom ko
0000003C  44 00 00 C4  	JP	SAVE			; Sad je sve dobro, odi spremi 
                        
00000040  00 00 90 95  FILL	LOADB	R3, (R1)		; Cijeli sad unesi u registar (dosad
00000044  00 00 A0 9D  SAVE	STOREB 	R3, (R2)		; Spremi trenutni R3 (i-ti) u izla
00000048  02 00 90 24  	ADD	R1, 2, R1		; 16 bitni ulazni podaci u listi pa pomak
0000004C  01 00 20 25  	ADD	R2, 1, R2		; 8 bitni pa se pomice pointer za 1 
00000050  01 00 00 34  	SUB 	R0, 1, R0		; R0 je broj podataka (brojac) pa se uma
00000054  0C 00 00 C6  	JP_NZ	LOOP			; Ako nisu prosli svi brojevi vrati se gore
                        
                        
00000058  00 00 00 F8  UDUNI	HALT 
                        
                        
                       `ORG 500 ; Ovo oznacuje sto R0 uzima  
00000500  06 00 00 00  `DW 06,00,00,00 ; Ovo je taj brojac sto ide u R0 (boj je 
00000504  01 80 02 00  `DW 01,80,02,00,23,01,25,00,BC,82,21,80 
          23 01 25 00  
          BC 82 21 80  
                        
                       `ORG 1000 ; Ovo oznacuje sto R2 uzima kao izlaznu listu  
                       `DS %D 6 ; Dodijeli 6 boj isto toliko ima i ulaza  
