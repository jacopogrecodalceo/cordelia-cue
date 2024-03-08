gidyn init 1
gibeatf 	init 1
gibeats 	init 1
gkbeatf		init 1
gkbeats		init 1
ginchnls	init nchnls
gioffch		init 0

gimainclock_ch init 5
giquarterclock_ch init 6

gisend_freq1_ch	init 7 
gisend_freq2_ch	init 8

gieva_memories init 0

#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/1-character/1-MACRO.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/1-character/2-GLOBAL_VAR.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/1-polar/asaw.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/1-polar/asine.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/1-polar/asquare.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/1-polar/atri.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/2-bipolar/saw.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/2-bipolar/sine.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/2-bipolar/square.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/2-bipolar/tri.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/3-window/hamming.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/2-head/GEN/3-window/hanning.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/basic/approx.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/basic/each.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/basic/envgen.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/basic/envgenk.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/basic/start.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/basic/turnoff_everything.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/freq/cedonoi.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/freq/cpstun_render.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/freq/edo.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia/3-body/2-OP/util/pump.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_GEN/_books/regular/hader.orc"
#include "/Users/j/Documents/PROJECTs/CORDELIA/_GEN/likearev.orc"



						
#define eva_kSk_kcps(kcps) #
if $kcps > 0 && $kcps < 20000 then
	
	if kch == 0 then
		kch = 1
		until kch > ginchnls do
			schedulek Sinstr, 0, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
		kch = 0
	elseif kch % 1 > 0 then
		kch_jit = kch
		kch = 1
		until kch > ginchnls do
			kdec abs random(0, kch_jit % 1)
			schedulek Sinstr, kdec, kdur, kamp, kenv, $kcps, int(kch)
			kch += 1
		od
		kch = kch_jit
	else
		kch_i = ((kch-1)%ginchnls)+1
		schedulek Sinstr, 0, kdur, kamp, kenv, $kcps, kch_i
	endif
endif
#

	opcode	eva, 0, kSkkkkOOOO
kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

/*
printk2 kch
printk2 kdur
printk2 kamp
printk2 kenv
printk2 kcps1
printk2 kcps2
printk2 kcps3
printk2 kcps4
printk2 kcps5
*/

if	kdur > giminnote && kamp > 0 then

	;LIMIT kdur TO gimax_note
	if kdur > gimaxnote then
		printsk "LOOK! YOU WANTED MORE THAN %is, ARE U SHURE?\n", gimaxnote
	endif

	kdur	limit	kdur, 0, gimaxnote

	;AMPLITUDE DEPENDS ON HOW MANY NOTES
	if	(kcps1 != 0 && kcps2 == 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
		$eva_kSk_kcps(kcps1)
	elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
		kamp *= ampdb(-5)
		$eva_kSk_kcps(kcps1)
		$eva_kSk_kcps(kcps2)
	elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 != 0 && kcps4 == 0 && kcps5 == 0) then
		kamp *= ampdb(-7)
		$eva_kSk_kcps(kcps1)
		$eva_kSk_kcps(kcps2)
		$eva_kSk_kcps(kcps3)
	elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 == 0) then
		kamp *= ampdb(-9)
		$eva_kSk_kcps(kcps1)
		$eva_kSk_kcps(kcps2)
		$eva_kSk_kcps(kcps3)
		$eva_kSk_kcps(kcps4)
	elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 != 0) then
		kamp *= ampdb(-11)
		$eva_kSk_kcps(kcps1)
		$eva_kSk_kcps(kcps2)
		$eva_kSk_kcps(kcps3)
		$eva_kSk_kcps(kcps4)
		$eva_kSk_kcps(kcps5)
	endif

	$eva_showmek

endif

	endop

#define end_instr #
	$env_gen
	;outch ich, aout
	gaouts[ich-1] = aout
	endin
#

giorg2_val[] fillarray 6, 3, 4, 1, 1.5

	$start_instr(org2)

ilen	int random:i(4, 8)
ival[]	init ilen

indx init 0
while indx < ilen do
	ival[indx] = giorg2_val[random:i(0, lenarray(giorg2_val))]
	indx += 1
od

kc1	cosseg 5, idur, 7.5
kc2	= 5-jitter(3.5, .125/idur, 1/idur) 
kvrate	= gkbeatf*ival[cosseg(0, idur, ilen-1)]
kvdpth	cosseg 0, idur, .075

aout	fmb3 $dyn_var, icps, kc1, kc2, kvdpth, kvrate
aout /= 2
	$dur_var(10)
	$end_instr

gScai[] fillarray\
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/caillou/caillou-001.wav",\
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/caillou/caillou-002.wav",\
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/caillou/caillou-003.wav",\
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/caillou/caillou-004.wav",\
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/caillou/caillou-005.wav"

gSpas[] fillarray\
	"./_pas/zephire_pas-001.wav", \
	"./_pas/zephire_pas-002.wav", \
	"./_pas/zephire_pas-003.wav", \
	"./_pas/zephire_pas-004.wav", \
	"./_pas/zephire_pas-005.wav", \
	"./_pas/zephire_pas-006.wav", \
	"./_pas/zephire_pas-007.wav"

	$start_instr(pas)

gSfile = gSpas[random:i(0, lenarray(gScai))]

if random:i(0, 24) > 23 then
	p3 init p3*4
endif

aouts[] init filenchnls(gSfile)

aouts	diskin gSfile, random:i(1/4, 1)
aout	balance2 aouts[ich-1], oscili:a(cosseg(1/6, p3, 0), 400)

;		REVERB
irev_time		init idur/16
arev			reverb aout, irev_time

ivib[]		fillarray .5, 1, 2, 3
ivibt		init ivib[int(random(0, lenarray(ivib)))]\

arev			*= 1-(oscili:a(1, gkbeatf*(ivibt+random:i(-.05, 05)), giasine)*cosseg:a(0, idur*.95, 1, idur*.05, 1))

aout			= (aout + arev)/2

	$dur_var(10)
	$end_instr


	$start_instr(ixland)
	
ipanfreq	random -.25, .25

ifn		init 0

ichoose[]	fillarray 1, 3
imeth		init ichoose[int(random(0, lenarray(ichoose)))]

ap		pluck $dyn_var, icps + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

;		RESONANCE

ap_res1		pluck $dyn_var, (icps*4) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res2		pluck $dyn_var, (icps*6) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res3		pluck $dyn_var, (icps*7) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

ap_resum	= ap_res1 + ap_res2 + ap_res3

ao_res1		oscil3 $dyn_var, icps, gitri
ao_res2		oscil3 $dyn_var, icps*3, gisine
ao_res3		oscil3 $dyn_var, icps*5, gitri
ao_res4		oscil3 $dyn_var, icps+(icps*21/9), gitri

ao_resum	= ao_res1 + ao_res2 + (ao_res3/4) + (ao_res4/6)

;		REVERB

irvt		init idur/24
arev		reverb (ap_resum/4)+(ao_resum/8), irvt

ivib[]		fillarray .5, 1, 2, 3
ivibt		init ivib[int(random(0, lenarray(ivib)))]

arev		*= 1-(oscili:a(1, gkbeatf*(ivibt+random:i(-.05, 05)), giasine)*cosseg:a(0, idur*.95, 1, idur*.05, 1))

aout		= ap + arev	
aout		dcblock2 aout

	$dur_var(10)
	$end_instr

	$start_instr(ixland_begin)
	
ipanfreq	random -.25, .25

ifn		init 0

ichoose[]	fillarray 1, 3
imeth		init ichoose[int(random(0, lenarray(ichoose)))]

ap		pluck $dyn_var, icps, icps, ifn, imeth

;		RESONANCE

ap_res1		pluck $dyn_var, (icps*4), icps, ifn, imeth
ap_res2		pluck $dyn_var, (icps*6), icps, ifn, imeth
ap_res3		pluck $dyn_var, (icps*7), icps, ifn, imeth

ap_resum	= ap_res1 + ap_res2 + ap_res3

ao_res1		oscil3 $dyn_var, icps, gitri
ao_res2		oscil3 $dyn_var, icps*3, gisine
ao_res3		oscil3 $dyn_var, icps*5, gisine

ao_resum	= ao_res1 + ao_res2 + (ao_res3/4); + (ao_res4/6)

;		REVERB
irvt		init idur/12
arev		reverb (ap_resum/4)+(ao_resum/8), irvt

ivib[]		fillarray .5, 1, 2, 3
ivibt		init ivib[int(random(0, lenarray(ivib)))]

arev		*= 1-(oscili:a(1, 3/idur*(ivibt+random:i(-.05, 05)), giasine)*cosseg:a(0, idur*.95, 1, idur*.05, 1))

aout		= ap + arev	+ ao_resum/16
aout		dcblock2 aout

	$dur_var(10)
	$end_instr

	$start_instr(ixland_begin2)
	
ipanfreq	random -.25, .25

ifn		init 0
icps init 16/9
ichoose[]	fillarray 1, 3
imeth		init ichoose[int(random(0, lenarray(ichoose)))]

;		RESONANCE

ap_res1		pluck $dyn_var, (icps*4), icps, ifn, imeth
ap_res2		pluck $dyn_var, (icps*6), icps, ifn, imeth
ap_res3		pluck $dyn_var, (icps*7), icps, ifn, imeth

ap_resum	= ap_res1 + ap_res2 + ap_res3

ao_res1		oscil3 $dyn_var, icps, gitri
ao_res2		oscil3 $dyn_var, icps*3, gisine
ao_res3		oscil3 $dyn_var, icps*5, gisquare

ao_resum	= ao_res1 + ao_res2 + (ao_res3/4); + (ao_res4/6)

;		REVERB
irvt		init idur/6
arev		reverb (ap_resum/4)+(ao_resum/8), irvt

ivib[]		fillarray .5, 1, 2, 3
ivibt		init ivib[int(random(0, lenarray(ivib)))]

arev		*= 1-(oscili:a(1, 3/idur*(ivibt+random:i(-.05, 05)), giasine)*cosseg:a(0, idur*.95, 1, idur*.05, 1))

aout		= arev	+ ao_resum/6
aout		dcblock2 aout

	$dur_var(10)
	$end_instr


	instr direct

	prints "direct is alive, %.02f\n", p1

i_inch		init p4
idyn		init p5
i_outch		init p6

ifade_in	init p7
ifade_out	init p8

ain			inch i_inch

			xtratim ifade_out
krel		release

afade		cosseg 0, ifade_in, 1
if krel == 1 then
	afade *= cosseg(1, ifade_out, 0)
endif

; START COMPRESS---
kthreshold	ampdbfs -15
icomp1		init .65
icomp2		init .25
irtime		init 0.015
iftime		init 0.125
aout		dam ain, kthreshold, icomp1, icomp2, irtime, iftime
; ---END COMPRESS

ilimit		init .85
aout		limit aout, -ilimit, ilimit
aout		= aout*afade

if i_outch == 0 then
	outall aout*idyn
else
	outch i_outch, aout*idyn
endif
	endin

; ===========================================================================
; *** GLOBAL VARIABLEs ***
; ===========================================================================
giseq_step init 0

#define init_rule#
Sinstr		init p4
ionset		init p5
idur		init p6
idyn		init p7
ienv		init p8
ifreq		init p9
ich			init p10
iroot		init p11
ituning		init p12
iseq		init p13
#

#define schedule_rule(onset)#
if ich == 0 then
	indx init 1
	until indx > nchnls do
		schedule Sinstr, $onset, idur, idyn, ienv, icps, indx
		indx += 1
	od
else
	schedule Sinstr, 0, idur, idyn, ienv, icps, ich
endif
#

; ===========================================================================
; 	schedule "method_seq", 0, 0,\
;		Sinstr, ionset, idur, idyn, ienv, ich, iroot, ituning, iseq
	instr method_seq
	$init_rule

idur		random idur, idur*2

ilen		ftlen iseq
icps		cpstuni iroot+table(giseq_step%ilen, iseq), ituning
icps		*= ifreq

giseq_step	+= 1

	$schedule_rule(ionset)

	endin

; ===========================================================================
; 	schedule "method_seq", 0, 0,\
;		Sinstr, ionset, idur, idyn, ienv, ich, iroot, ituning, iseq
	instr method_seq_begin
	$init_rule

idur		random idur, idur*2

ilen		ftlen iseq
icps		cpstuni iroot+table(giseq_step%ilen, iseq), ituning
icps		*= ifreq

giseq_step	+= 1

	$schedule_rule(ionset)

	endin
; ===========================================================================
; 	schedule "method_tempest", 0, 0,\
;		Sinstr, ionset, idur, idyn, ienv, ich, iroot, ituning, iseq
	instr method_tempest
	$init_rule


ilen		ftlen iseq
icps		cpstuni iroot+table(giseq_step%ilen, iseq), ituning
icps		*= ifreq

until icps < 500 do
	icps /= 2
od

until icps > 20 do
	icps *= 2
od

giseq_step	+= 1

if ich == 0 then
	indx_instr init 0
	until indx_instr > random:i(10, 25) do
		indx init 1
		idur random idur/4, idur*2
		idur limit idur, .25, 5
		until indx > nchnls do
			if random(0, 1) > .995 then
				icps *= 2
			endif
			;icps		+= random:i(-10, 10)
			schedule Sinstr, ionset+random:i(0, .25), idur, idyn*random:i(0, 1), ienv+random:i(.005, .015), icps+random:i(-10, 10), int(random(1, 3))
			indx += 1
		od
		indx_instr += 1
	od
endif

	endin


	instr 1

	prints "trigger is alive, %.02f\n", p1

in_ch		init p4
Swhere		init p5
kthreshold	ampdbfs gkcontrol_1
igate_sec	init p7

Sinstr		init p8
ionset		init p9
idur		init p10
idyn		init p11
ienv		init p12
ifreq		init p13
ich			init p14
iroot		init p15
ituning		init p16
iseq		init p17

ain			inch in_ch

/*
itime		init ksmps /sr
aenv_follow	follow ain, itime
kenv_follow	k aenv_follow
*/

/* 
kenv_follow	abs k(ain)
*/

ifollow_atk	init .005
ifollow_dec	init igate_sec
aenv_follow	follow2 ain, ifollow_atk, ifollow_dec
kenv_follow	k aenv_follow

kgate		init 0
ksec		init 0

	printf "---------------trigger %.02f: %s\n", kgate, p1, Sinstr
	;printk2 kgate
	;printk2 gkcontrol_1
if kgate == 0 && kenv_follow > kthreshold then

	kdyn	limit kenv_follow, .35, .75
	printf "---------------trigger %.02f: %f / %f\n", kdyn, p1, kdyn, kthreshold
	schedulek Swhere, 0, 0, Sinstr, ionset, idur, kdyn*idyn, ienv, ifreq, ich, iroot, ituning, iseq
	kgate = 1
endif

if kgate == 1 then
	ksec += 1

	if ksec > (igate_sec*sr)/ksmps then
		ksec	= 0
		kgate	= 0
	endif
endif

	endin




; ===========================================================================
; *** TUNINGs ***
; ===========================================================================
gSbase init "4A"
giarch_enht5 ftgen 0, 0, 0, -2, 7, 2/1, ntof(gSbase), ntom(gSbase), 1, 245/243, 28/27, 16/15, 35/27, 4/3, 35/18, 2/1

gidyn   init 1/2

; ===========================================================================
; *** CHANNEL 1 ***
; ===========================================================================
; GRAND
; ===========================================================================

i_inch		init 1
idyn		init 1*gidyn
i_outch		init 0
;schedule nstrnum("direct")+(i_inch/100), 0, -1, i_inch, idyn, i_outch

; ===========================================================================
; *** CHANNEL 2 ***
; ===========================================================================
; PETIT
; ===========================================================================


#define start_tempest#
ich_in		init 1
ithreshold	init ampdbfs(-15)
igate_sec	init 1/3

Sinstr		init "ixland"

ionset		init 0
idur		init 7
idyn		init 1*gidyn

iatk		init .005
ienv		init gihader+iatk

ifreq		init 1/4
ich			init 0
iroot		init 0
ituning		init giarch_enht5
iseq		init giseq_chord3

schedule\
	1+(ich_in/100), 0, -1, \
	ich_in, "method_tempest", ithreshold, igate_sec,\
	Sinstr, ionset, idur, idyn, ienv, ifreq, ich,\
	iroot, ituning, iseq
#

#define end_tempest #
turnoff2_i 1, 0, 0
#


#define zephire_run_start #
if nchnls_i < 2 then
	ich_in		init 1
else
	ich_in		init 2
endif
ithreshold	init ampdbfs(-25)
igate_sec	init 1/6

Sinstr		init "pas"

ionset		init 0
idur		init 1
idyn		init 1*gidyn

iatk		init .005
ienv		init gilikearev+iatk

ifreq		init 1/12
ich			init 0
iroot		init 0
ituning		init giarch_enht5
iseq		init giseq_chord3

schedule\
	1+(ich_in/100), 0, -1, \
	ich_in, "method_seq", ithreshold, igate_sec,\
	Sinstr, ionset, idur, idyn, ienv, ifreq, ich,\
	iroot, ituning, iseq
#

#define zephire_run_end #
turnoff2_i 1, 0, 0
#


#define prestrophe_insert_start #
ich_in		init 1
ithreshold	init ampdbfs(-27)
igate_sec	init 1/3

Sinstr		init "org2"

ionset		init 0
idur		init 1
idyn		init 1*gidyn

iatk		init .005
ienv		init gihader+iatk

ifreq		init 11/10
ich			init 0
iroot		init 0
ituning		init giarch_enht5
iseq		init giseq_strophe

schedule\
	1+(ich_in/100), 0, -1, \
	ich_in, "method_seq", ithreshold, igate_sec,\
	Sinstr, ionset, idur, idyn, ienv, ifreq, ich,\
	iroot, ituning, iseq
#

#define prestrophe_insert_end #
turnoff2_i 1, 0, 0
#

#define aphrodite_start #
if nchnls_i < 2 then
	ich_in		init 1
else
	ich_in		init 2
endif

ithreshold	init ampdbfs(-25)
igate_sec	init 1/3

Sinstr		init "ixland_begin"

ionset		init 0
idur		init 9
idyn		init 1*gidyn

iatk		init .005
ienv		init gilikearev+iatk

ifreq		init 2
ich			init 0
iroot		init 0
ituning		init giarch_enht5
iseq		init giseq_strophe

schedule\
	1+(ich_in/100), 0, -1, \
	ich_in, "method_seq_begin", ithreshold, igate_sec,\
	Sinstr, ionset, idur, idyn, ienv, ifreq, ich,\
	iroot, ituning, iseq

#

#define aphrodite_end #
turnoff2_i 1, 0, 0
#


