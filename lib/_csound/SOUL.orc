; ========================
; *** MAIN OUT
; ========================
	instr 950
	out gaouts
	endin
	schedule 950, 0, -1

; ========================
; *** MNEMOSINE, instrument for recording session
; ========================
	instr 955
gSout	init p4
	fout gSout, -1, gaouts
	endin

; ========================
; *** CLEAR
; ========================
	instr 975
	clear gaouts
	endin
	schedule 975, 0, -1

