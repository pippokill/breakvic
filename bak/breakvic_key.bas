10 pO36878,15:pO36879,12:?"{clear}{white}":x=10:y=21:dx=-1:dy=-1:bx=10:c=7727:p=38447:v=1
20 t=300:m=75:fori=1to15:pOc+i,102:pOp+i,3:nexti:c=c+44:p=p+44:ifc<7944goto20 
30 poke8164+bx,160:poke8164+bx+1,160:poke7680+y*22+x,32
40 getb$:ifb$="z"andbx>0thengoto110
50 ifb$="x"and bx<20 thengoto120
60 poke36874,0:x=x+dx*v:y=y+dy:ifx<=0orx>=21orpeek(7680+y*22+x)=102thendx=-dx
80 poke36875,0:ify=0ory=21orpeek(7680+y*22+x)=102thendy=-dy
90 ifx<0thenx=0
91 ifx>21thenx=21
92 ify=21andx>bx-2andx<bx+3thengosub140
93 ifpeek(7680+y*22+x)=102thengosub130
94 ify=21andnot(peek(7680+(y+1)*22+x))=160thent=t-100
97 ifm=0thengosub150
100 poke7680+y*22+x,81:goto30
110 poke8164+bx,32:poke8164+bx+1,32:bx=bx-1:goto60
120 poke8164+bx,32:poke8164+bx+1,32:bx=bx+1:goto60
130 poke36874,135:v=1:t=t+100:m=m-1:return
140 poke36875,135:v=2:return
150 poke36878,0:?"{clear}{white}{down*9}{right*5}game over{down*2}{left*9}score: ";t:end