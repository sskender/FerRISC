                       CT_CR `EQU 0FFFF0000 
                       CT_LR `EQU 0FFFF0004 
                       CT_ACK `EQU 0FFFF0008 
                       CT_END `EQU 0FFFF000C 
                        
                       DMA_SRC `EQU 0FFFF1000 
                       DMA_DEST `EQU 0FFFF1004 
                       DMA_SIZE `EQU 0FFFF1008 
                       DMA_CTRL `EQU 0FFFF100C 
                       DMA_START `EQU 0FFFF1010 
                       DMA_BS `EQU 0FFFF1014 
                        
                       BVJ `EQU 0FFFFFFFC 
                        
                        
                        
                        
                       `ORG 0 
                       	 
00000000  00 00 81 07  	MOVE	10000, SP 
00000004  54 00 00 C4  	JP	GLAVNI 
                        
                        
                        
                        
                       ; Potprogram DMA NMI 
                        
                       `ORG 0C 
                        
0000000C  00 00 00 88  	PUSH	R0 
00000010  00 00 20 00  	MOVE	SR, R0  
00000014  00 00 00 88  	PUSH	R0 
00000018  00 00 80 88  	PUSH	R1 
                        
0000001C  14 10 0F B8  	STORE	R0, (DMA_BS)			; Dojava o prihvatu  
                       	 
00000020  D4 00 00 B0  	LOAD	R0, (BLOKOVI) 			; Count blokova ++ (na 5 prekida) 
00000024  01 00 00 24  	ADD	R0, 1, R0 
00000028  D4 00 00 B8  	STORE	R0, (BLOKOVI) 
                        
0000002C  D8 00 00 B0  	LOAD	R0, (BLOKPRVI) 			; Dodati -1 na kraj bloka 
00000030  FF FF 8F 04  	MOVE	%D -1, R1 
00000034  00 00 80 BC  	STORE	R1, (R0) 
00000038  04 00 00 24  	ADD	R0, 4, R0 
0000003C  D8 00 00 B8  	STORE	R0, (BLOKPRVI) 
                        
00000040  00 00 80 80  	POP	R1 
00000044  00 00 00 80  	POP	R0 
00000048  00 00 10 00  	MOVE	R0, SR 
0000004C  00 00 00 80  	POP	R0 
                        
00000050  03 00 00 D8  	RETN 
                        
                        
                        
                        
                        
00000054  D4 00 00 B0  GLAVNI	LOAD	R0, (BLOKOVI)			; nakon 5 uduni 
00000058  05 00 00 6C  	CMP	R0, 5 
0000005C  64 00 C0 D5  	JR_EQ	KRAJ 
                        
                        
                       						; CT brojac 
00000060  E8 03 00 04  SET_CT	MOVE	%D 1000, R0 			; 1 ms = 10 000 (10^-3 s)  
00000064  04 00 0F B8  	STORE	R0, (CT_LR) 
                       						; CT kontroler 
00000068  01 00 00 04  	MOVE	%D 01, R0			; Vrsta INT   INT da/ne    broji da/ne 
0000006C  00 00 0F B8  	STORE	R0, (CT_CR)			 
                        
                        
                        
00000070  08 00 0F B0  CHK_CT	LOAD	R0, (CT_ACK)			; Provjera spremnosti CT-a 
00000074  01 00 00 6C  	CMP	R0, 1 
00000078  F4 FF 0F D6  	JR_NE	CHK_CT 
                        
                        
0000007C  08 10 0F B0  CHK_DMA	LOAD	R0, (DMA_SIZE)			; Provjera je li broj podat
00000080  00 00 00 6C  	CMP	R0, 0 
00000084  F4 FF 0F D6  	JR_NE	CHK_DMA 
                        
                        
00000088  00 00 00 04  	MOVE	0, R0				; Sve je spremno, ugasi sad CT 
0000008C  0C 00 0F B8  	STORE 	R0, (CT_END) 
                        
                        
                        
00000090  FC FF 0F B0  SET_DMA	LOAD	R0, (BVJ) 			; source 
00000094  00 10 0F B8  	STORE	R0, (DMA_SRC) 
                        
00000098  D8 00 00 B0  	LOAD	R0, (BLOKPRVI) 			; destination (treba pomicati) 
0000009C  04 10 0F B8  	STORE	R0, (DMA_DEST) 
000000A0  24 00 00 24  	ADD	R0, %D 36, R0 
000000A4  D8 00 00 B8  	STORE	R0, (BLOKPRVI) 
                        
000000A8  09 00 00 04  	MOVE	%D 9, R0 			; velicina (blok je 9) 
000000AC  08 10 0F B8  	STORE	R0, (DMA_SIZE) 
                        
000000B0  07 00 00 04  	MOVE	%B 0111, R0			; DEST (0 mem) SRC (1 vj) MOD (1 krac
000000B4  0C 10 0F B8  	STORE	R0, (DMA_CTRL) 
                        
000000B8  10 00 10 04  	MOVE	%B 10000, SR			; Omoguci prekide 
000000BC  10 10 0F B8  	STORE	R0, (DMA_START) 
                        
                        
000000C0  54 00 00 C4  	JP	GLAVNI 
                        
                        
                        
                        
                        
000000C4  00 00 00 04  KRAJ	MOVE	0, R0				; 0 na CTRL od DMA i CT 
000000C8  00 00 0F B8  	STORE	R0, (CT_CR) 
000000CC  0C 10 0F B8  	STORE	R0, (DMA_CTRL) 
000000D0  00 00 00 F8  	HALT 
                        
                        
                        
                        
                        
000000D4  00 00 00 00  BLOKOVI `DW 00,00,00,00 
000000D8  00 10 00 00  BLOKPRVI `DW 00,10,00,00 
                        
