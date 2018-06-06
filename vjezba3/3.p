                       					; Vanjske jedinice 
                       BVJ1 `EQU 0FFFF1000 
                        
                       UVJ2 `EQU 0FFFF2000 
                       UVJ2BS `EQU 0FFFF2004 
                        
                       PVJ3 `EQU 0FFFF3000 
                       PVJ3ACK `EQU 0FFFF3004 
                       PVJ3END `EQU 0FFFF3008 
                       PVJ3KIL `EQU 0FFFF300C 
                        
                        
                        
                        
                        
                        
                       `ORG 0 
                        
00000000  00 00 81 07  	MOVE	10000, SP		; Inicijalizacija stoga 
00000004  0C 00 00 C4  	JP	GLAVNI 
                        
                       `ORG 8 
00000008  00 02 00 00  `DW 00,02,00,00 ; Ovdje je VJ3 (prekidna)  
                        
                        
                        
                        
                        
                        
                        
                       					; Ovo je sad glavni program 
0000000C  10 00 10 04  GLAVNI	MOVE	%B 10000, SR		; Dozvoli prekide 
00000010  01 00 00 04  	MOVE	1, R0 
00000014  0C 30 0F B8  	STORE	R0, (PVJ3KIL) 
                        
                        
                        
                       					; Provjeri VJ2 
00000018  04 20 0F B0  CHKMAIN	LOAD	R0, (UVJ2BS) 		; Ucitaj bistabil stanja, vid
0000001C  01 00 00 6C  	CMP	R0, 1 
00000020  18 00 00 D6  	JR_NE	CHKSTOP			; Nema nista novo 
                        
                       					; Ima nesto novo 
00000024  6C 02 00 B0  	LOAD	R0, (BROJ)		; Ucitaj podatak i javi to jedinici 
00000028  04 20 0F B8  	STORE	R0, (UVJ2BS) 
0000002C  00 20 0F B8  	STORE 	R0, (UVJ2) 
                        
00000030  70 02 00 B0  	LOAD	R0, (UKUPNO) 		; Broji koliko ih je ukupno poslano 
00000034  01 00 00 24  	ADD	R0, 1, R0 
00000038  70 02 00 B8  	STORE	R0, (UKUPNO)  
                        
                        
                       					; Provjeri STOP 
0000003C  74 02 00 B0  CHKSTOP	LOAD	R0, (STOP) 
00000040  01 00 00 6C  	CMP	R0, 1 
00000044  D0 FF 0F D6  	JR_NE	CHKMAIN			; Ne treba udunut, vrati se u petlju 
                        
                        
                        
                        
                       					; Prekid postavljen 
00000048  00 00 10 04  UDUNI	MOVE	0, SR			; Onemoguci prekide i ugasi 
0000004C  00 00 00 04  	MOVE 	0, R0			 
00000050  0C 30 0F B8  	STORE	R0, (PVJ3KIL) 
00000054  00 00 00 F8  	HALT 
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                       					; Prekidni potprogram odavde 
                       					; INT 0 MASKIRAJUCI prekid 
                       `ORG 200 
00000200  00 00 00 88  PREKID	PUSH	R0 			; Spremi registre 
00000204  00 00 20 00  	MOVE	SR, R0 
00000208  00 00 00 88  	PUSH	R0 
                        
0000020C  04 30 0F B8  	STORE	R0, (PVJ3ACK)		; Javi da je prihvaceno 
                        
                        
                        
00000210  00 10 0F B0  	LOAD	R0, (BVJ1)		; Ucitaj s bezuvjetne vanjske jedinice 
00000214  00 00 00 0C  	OR	R0, 0, R0		; Ugasi ako je negativan ucitan 
00000218  0C 00 80 D4  	JR_P	DOBAR 
                        
0000021C  01 00 00 04  NEDOBAR	MOVE	1, R0 			; Global stop postavi 
00000220  74 02 00 B8  	STORE	R0, (STOP) 
00000224  18 00 00 D4  	JR	IZADI 
                        
00000228  00 00 00 88  DOBAR	PUSH 	R0			; Baci to na stog za potprogramu 
0000022C  54 02 00 CC  	CALL	OBRADI 
00000230  04 00 F0 27  	ADD	SP, 4, SP		; Zato jer je gore push, a NO POP 
00000234  6C 02 00 B8  	STORE	R0, (BROJ)		; Rezultat potprograma na lokaciju BRO
                        
00000238  70 02 00 B0  	LOAD	R0, (UKUPNO)		; Ukupno posalji na VJ3 
0000023C  00 30 0F B8  	STORE	R0, (PVJ3)		; To posalji na ovu jedinicu  
                        
                        
                        
00000240  08 30 0F B8  IZADI	STORE	R0, (PVJ3END)		; Javi da je gotovo 
                        
00000244  00 00 00 80  	POP	R0			; Vrati registre 
00000248  00 00 10 00  	MOVE	R0, SR 
0000024C  00 00 00 80  	POP	R0 
                        
00000250  01 00 00 D8  	RETI 
                       					; Prekidni potprogram dovde 
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                       					; Ovaj potprogram koristi PREKIDNA VJ 
                       					; Uzmi broj sa stoga i vrati preko R0 
                       					; Sve su pozitivni brojevi, ne treba nista provjerav
00000254  00 00 80 88  OBRADI 	PUSH	R1 
00000258  08 00 F0 B4  	LOAD	R1, (SP+8) 
                        
0000025C  01 00 00 04  	MOVE	1, R0 
00000260  00 00 02 40  	ROTL	R0, R1, R0 
                        
00000264  00 00 80 80  	POP	R1 
00000268  00 00 00 D8  	RET 
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
0000026C  00 00 00 00  BROJ `DW 00,00,00,00 ; Tako je zadano  
00000270  00 00 00 00  UKUPNO `DW 00,00,00,00 ; Spremi koliko je podataka poslan
00000274  00 00 00 00  STOP `DW 00,00,00,00 ; Global treba li udunuti sve  
