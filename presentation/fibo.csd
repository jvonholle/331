<CsoundSynthesizer>
;<CsOptions>
;</CsOptions>
; ==============================================
<CsInstruments>

sr	=	44100
ksmps	=   958	
;nchnls	=	2
0dbfs	=	1

instr Fibo
kount init 1
knum init 0
koldnum init 1
ktemp init 1
ktemp = knum
knum = knum + koldnum
koldnum = ktemp
;if kount <= 46 then
    printks "fibo(%f) = %d \n",  0,kount, knum
;endif
kount = kount + 1
endin

</CsInstruments>
; ==============================================
<CsScore>

i 1 0 1


</CsScore>
</CsoundSynthesizer>

