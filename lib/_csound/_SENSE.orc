; ========================
; *** Sense keyboard
; ========================
	instr sense_keyboard

iesc	init 27
;ispace	init 32

kascii, kpress sensekey

if kascii == iesc && kpress == 1 then
	printks "\n🌊 STOP! 🌊\n", 1
	turnoff2 100, 2, 1-gkrehearsal
endif

	endin
	schedule "sense_keyboard", 0, -1

gkcontrol_1 init 0

	instr midi_control

kdest	ctrl7 1, p4, -60, 0
gkcontrol_1 = kdest
		printk2 gkcontrol_1

	endin
	schedule "midi_control", 0, -1, 35

/* ;giSPACE	init 32

; ========================
; 	Sense ESC
; ========================
giESC	init 27
gkESC	init 0
	instr sense_ESC
kascii, kpress sensekey
if kascii == giESC && kpress == 1 then
	gkESC = 1
endif
	endin
	schedule "sense_ESC", 0, -1

; ========================
; 	Sense CMD
; ========================
giCMD	init 231
gkCMD	init 0
	instr sense_CMD
kascii, kpress sensekey
if kascii == giCMD && kpress == 1 then
	gkCMD = 1
endif
	endin
	schedule "sense_CMD", 0, -1

; ========================
; 	Sense IF
; ========================
	instr sense_IF

if gkCMD == 1 && gkESC == 1 then
	printks "\n🌊 STOP! 🌊\n", 1
	event_i "e", 0, ksmps/sr
elseif gkCMD == 1 then
	printks "cmd", 1
elseif gkESC == 1 then
	printks "\n🌊 STOP! 🌊\n", 1
	turnoff2 100, 0, 1-gkrehearsal
endif

	endin
	schedule "sense_IF", 0, -1

 */


 