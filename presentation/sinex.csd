<CsoundSynthesizer>
;<CsOptions>
;</CsOptions>
; ==============================================
<CsInstruments>

sr	=	44100
ksmps	=   1	
;nchnls	=	2
0dbfs	=	1

giSine ftgen 0, 0, 2^10, 10, 1

    instr 1	
ibasefreq = cpspch(p4)
ibaseamp = ampdbfs(p5)
aOsc poscil ibaseamp, ibasefreq, giSine
kenv linen 1, p3/4, p3, p3/4
outs aOsc*kenv
    endin

</CsInstruments>
; ==============================================
<CsScore>

i 1 0 5 8.00 -10
i 1 0 5 3.00 -11

</CsScore>
</CsoundSynthesizer>

