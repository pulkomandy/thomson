FTRACK EQU    01      premi�re piste
LTRACK EQU    04      derni�re piste
SECTOR EQU    10      secteurs par piste
SIZE   EQU    2       256oct par secteur
LACE   EQU    1       entrelacement

       ORG    $9800
FORMAT PSHS   CC,A,B,DP,X,Y,U
       ORCC   #$50
       JSR    >$E09D  init  DP, X et <4E
       JSR    >$E0A7  allume la LED
       LDA    #FTRACK
       STA    <$4B
       JSR    >$E45A  lance le moteur
       BCS    RETURN
       JSR    >$E134  positionne piste 0
       BCS    RETURN
       JSR    >$E521  attente
       BCS    RETURN
        JSR   >$E452  avance jusqu'� la
        BCS   RETURN   piste de d�part

       BSR    SECLST  liste secteurs
NXTTRK BSR    IDENTF
       LDX    #$E7D0
       JSR    >$E45A
       BSR    ONETRK  formate une piste
       LDA    <$4B
       INCA
       STA    <$4B
       CMPA   #LTRACK+1
       BEQ    RETURN
       JSR    >$E47A
       BRA    NXTTRK
RETURN JMP    >$E08A

SECLST LDX    #BUFFER     construit la
       LDB    #SECTOR liste des secteurs
       CLR    ,X+      sur chaque piste
       DECB           d'apr�s la valeur
       BNE    *-3     de l'entrelacement

       LDX    #BUFFER
       LDA    #1      secteur courant
       LDB    #LACE
INSSEC STA    ,X      ins�re le secteur
       LEAX   B,X       dans la liste
       INCA
       CMPA   #SECTOR cas� tous secteurs
       BHI    LISTOK  => fin du parcours
NXTNOD CMPX   #BUFFER+SECTOR
       BLO    NOMODU
       LEAX   -SECTOR,X    modulo SECTOR
NOMODU TST    ,X      place libre dans
       BEQ    INSSEC  la liste => case !
       LEAX   1,X
       BRA    NXTNOD  ...cherche place
LISTOK RTS


IDENTF LDX    #BUFFER pr�pare les champs
       LDU    #BUFFER+SECTOR
IDNSEC LDB    ,X+      d'identification
       BEQ    IDEND
       LDA    <$4B
       STA    ,U      num�ro de piste
       LDA    <$49
       ANDA   #1
       STA    1,U     num�ro de face
       STB    2,U     num�ro de secteur
       LDY    #4
       LDA    #SIZE
       STA    3,U     longueur secteur
       LDD    #$B230
       JSR    >$E364
       STD    ,U++    contr�le CRC
       BRA    IDNSEC
IDEND  RTS


******** Champ d'identification ********

ONETRK LDA    #SECTOR
       PSHS   A
       LDU    #BUFFER+SECTOR
       JSR    >$E341
INDEX  LDB    1,X
       BITB   #$40    d�tection d'index
       BEQ    INDEX
       LDB    3,X     lecture en RDATA
       LDB    ,X
       BPL    *-4
       LDB    ,X
       BPL    *-2
       LDD    #$48FF   configuration =
       STD    3,X     mots de donn�es 48
       LDB    #4
       STB    ,X      autorisation Write

       LDA    #22
H22X48 LDB    ,X
       BPL    *-2
       LDB    #$48    �crit 22 fois $48
       STB    3,X
       DECA
       BNE    H22X48    (@ ESPACES)

ONESEC
       LDA    #12
I12X00 LDB    ,X
       BPL    *-2
       CLR    3,X     �crit 12 fois $00
       DECA
       BNE    I12X00   (@ SYNCRO BITS)

       LDB    ,X
       BPL    *-2
       LDD    #$A10A  configuration =
       STD    3,X     mots de syncro A1
       LDB    ,X
       BPL    *-2
       STA    3,X     �crit 3 fois $A1
       LDB    ,X
       BPL    *-2
       STA    3,X     (@ SYNCRO CARACTR)

       LDB    ,X
       BPL    *-2
       LDD    #$FEFF  configuration =
       STD    3,X     mots de donn�es FE
       LDA    #6
WIDENT LDB    ,X       �crit $FE et les
       BPL    *-2     6 octets du champs
       LDB    ,U+      identification
       STB    3,X     (num�ro piste,face
       DECA            secteur,longueur,
       BNE    WIDENT   contr�le CRC)

       LDA    #22
C22X43 LDB    ,X
       BPL    *-2
       LDB    #$43    �crit 22 fois $43
       STB    3,X
       DECA
       BNE    C22X43     (@ ESPACES)


*********** Champ de donn�es ***********

       LDA    #12
D12X00 LDB    ,X
       BPL    *-2
       CLR    3,X     �crit 12 fois $00
       DECA
       BNE    D12X00   (@ SYNCRO BITS)

       LDB    ,X
       BPL    *-2
       LDD    #$A10A  configuration =
       STD    3,X     mots de syncro A1
       LDB    ,X
       BPL    *-2
       STA    3,X     �crit 3 fois $A1
       LDB    ,X
       BPL    *-2
       STA    3,X
       LDB    ,X
       BPL    *-2     (@ SYNCRO CARACTR)

       LDD    #$72FF  configuration =
       STD    3,X     mots de donn�es 72
*                     (@ ADR DEBUT DONN)
       LDY    #SIZE*256
       PSHS   U
       LDU    >DATAS
FILLSC LDB    ,X
       BPL    *-2
       LDA    ,U+
       STA    3,X     remplit le secteur
       LEAY   -1,Y
       BNE    FILLSC     (@ DONNEES)
       CMPU   #$E000
       BNE    *+5
       LDU    #$4000
       STU    >DATAS
       PULS   U

       LDB    ,X
       BPL    *-2
       LDB    #'L       �crit $2B
       STB    3,X
       LDB    ,X
       BPL    *-2       �crit $F6
       LDB    #'o
       STB    3,X      (@ CONTROLE CRC)

       LDA    #23
L22X4C LDB    ,X
       BPL    *-2
       LDB    #$4C    �crit 22 fois $4C
       STB    3,X
       DECA
       BNE    L22X4C    (@ ESPACES)



       DEC    ,S
       LBNE   ONESEC  secteur suivant

INDEXF LDA    1,X     d�tection d'index
       BITA   #$40
       BNE    ENDTRK  -> piste suivante
       LDA    ,X
       BPL    *-2     remplit de $4E
       STB    3,X     jusqu'� la fin de
       BRA    INDEXF  la piste
ENDTRK PULS   A
       CLR    ,X      op�ration = RESET
       RTS

DATAS  FDB    $A000

BUFFER RMB    SECTOR
       RMB    6*SECTOR

       END
