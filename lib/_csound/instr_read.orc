; ========================
; *** START SEQ
; ========================
	instr start_seq

inum_this_instr init 100
inum_seq		init p4
Sfile           init p5
istart_instr    init p6
istart_seq		init p7
iloop           init p8
idyn            init p9

ifade_in         init p10
ifade_in_mode    init p11
ifade_out        init p12
ifade_out_mode   init p13

schedule inum_this_instr + (inum_seq/1000), istart_instr, 1, \
		Sfile,\
		istart_seq,\
		iloop,\
		idyn,\
		ifade_in,\
		ifade_in_mode,\
		ifade_out,\
		ifade_out_mode

	endin

; ========================
; *** END SEQ
; ========================
	instr end_seq

inum_this_instr	init 110
inum_instr		init 100
inum_seq		init p4
istart_instr	init p5

schedule inum_this_instr, istart_instr, 0, \
	inum_instr + (inum_seq/1000)

	endin


; ========================
; *** INSTR TO PLAY
; ========================
    instr 100

Sfile           init p4
istart          init p5
iloop           init p6
idyn            init p7

ifade_in         init p8
ifade_in_mode    init p9
ifade_out        init p10
ifade_out_mode   init p11

$convert_mode_string

ilen            filelen Sfile   ;length of the file in seconds
idur            init ilen

                xtratim ifade_out
krel    		init 0
krel	    	release

$print_params
$if_loop

aout_file[]     diskin Sfile, 1, istart, iloop ;istart is in seconds
ich_file		lenarray aout_file

$make_fade_in
$if_krel
gaouts += aout_file * idyn * .5

	endin

; ========================
; *** INSTR TO TURNOFF
; ========================
	instr 110
inum	init p4
turnoff2_i inum, 4, 1
	endin


