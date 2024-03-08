
#define if_krel #
if krel == 1 then

	if ifade_out_mode == 0 && ifade_out > 0 then
		aout_file       *= cosseg(1, ifade_out, 0)
	elseif ifade_out_mode == 1 && ifade_out > 0 then
		aout_file       *= linseg(1, ifade_out, 0)
	elseif ifade_in_mode == 2 && ifade_out > 0 then
		aout_file       *= expseg(2, ifade_out, 1)-1
	endif

	printks2 "\n---\n%.03f - RELEASE PHASE\n", p1
	printks2 "FADE_OUT:\t\t%.02fs\n---\n", ifade_out

endif
#

#define convert_mode_string #
if ifade_in_mode == 0 then
    Sfade_in     init "COS"
elseif ifade_in_mode == 1 then
    Sfade_in     init "LIN"
elseif ifade_in_mode == 2 then
    Sfade_in     init "EXP"
endif

if ifade_out_mode == 0 then
    Sfade_out     init "COS"
elseif ifade_in_mode == 1 then
    Sfade_out     init "LIN"
elseif ifade_in_mode == 2 then
    Sfade_out     init "EXP"
endif
#

#define print_params #
prints "\n---\n"
prints "INSTR:\t\t%.003f\n", p1
prints "FILE:\t\t%s\n", Sfile
prints "LENGTH:\t\t%.02fs\n", idur
prints "START AT:\t%ds\n", istart
prints "LOOP:\t\t%s\n", iloop == 1 ? "ON" : "OFF"
prints "FADE_IN:\t%s, %is\n", Sfade_in, ifade_in
prints "FADE_OUT:\t%s, %is\n", Sfade_out, ifade_out
prints "---\n"
#

#define if_loop #
if iloop == 0 then

	ksec        init idur
	ksec_rel    init ifade_out
	if metro:k(1) == 1 then
	    if krel == 0 then
		ksec -= 1
		printsk "%s", Sfile
	    elseif krel == 1 then
		ksec_rel -= 1
		printsk "%s---RELEASING", Sfile
	    endif
	endif

	p3  init idur-ifade_out
	if krel == 0 then
	    printks2 ":	%ds left // ", ksec
	    printks2 "%.02f%%\n", (ksec*100)/idur 

	elseif krel == 1 then
	    ;ksec init ifade_out
	    printks2 ":	%ds left // ", ksec_rel
	    printks2 "%.02f%%\n", (ksec_rel*100)/ifade_out     
	endif        

elseif iloop == 1 then

	ksec        init 0
	ksec_rel    init ifade_out
	if metro:k(1) == 1 then
	    if krel == 0 then
		ksec += 1
		printsk "%s", Sfile
	    elseif krel == 1 then
		ksec_rel -= 1
		printsk "%s---RELEASING", Sfile
	    endif
	endif

	p3  init -1
	if krel == 0 then
	    printks2 ":	in loop, %ds\n", ksec
	elseif krel == 1 then
	    printks2 ":	%ds left // ", ksec_rel
	    printks2 "%.02f%%\n", (ksec_rel*100)/ifade_out     
	endif   
endif
#

#define make_fade_in #
if ifade_in_mode == 0 && ifade_in > 0 then
	aout_file       *= cosseg(0, ifade_in, 1)
elseif ifade_in_mode == 1 && ifade_in > 0 then
	aout_file       *= linseg(0, ifade_in, 1)
elseif ifade_in_mode == 2 && ifade_in > 0 then
	aout_file       *= expseg(1, ifade_in, 2)-1
endif
#



