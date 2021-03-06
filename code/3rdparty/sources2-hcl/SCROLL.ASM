****************************************
*      E A S Y   S C R O L L E R       *
* (c) Doctor L� of HCL for Micro-News  *
****************************************

TEXTE  EQU    $DF30   Le d�but du texte
SCREEN EQU    $5E00   Position � l'�cran
VARPGE EQU    $DF     Page des variables
FONT76 EQU    $F4     Les 8 lignes de la
FONT54 EQU    $F6      lettre courante
FONT32 EQU    $F8     (lue � l'envers->
FONT10 EQU    $FA     ligne 7 � ligne 0)
NBPASS EQU    $FC     compteur passages
SPEED  EQU    $FD     vitesse (de 1 � 8)
COLUMN EQU    $FE     compteur colonnes


       ORG    $DF30
G      PSHS   U,Y,X,DP,B,A,CC Sauve regs
       ORCC   #80     Interruptions OFF
       LDA    $E7C3   Partie "points" de
       ORA    #1       la m�moire �cran
       STA    $E7C3    s�lectionn�e
       LDB    #VARPGE Pour acc�s direct
       TFR    B,DP     aux "variables"
       LDY    #TEXTE  A faire d�filer

SYNCRO LDA    $E7E7    Boucle tant que
       BPL    *-3     spot dans le bord
       LDA    $E7E7    Boucle tant que
       BMI    *-3     spot dans l'�cran

       LDB    <SPEED   Vitesse du scroll
       STB    <NBPASS ->nombre de passes
SCROLL LDX    #SCREEN+20  Position �cran
       LDU    #VARPGE*256+FONT10+2  CHR$
       LDA    #8      Hauteur du scroll
DOLINE ASL    ,-U     D�calage ds buffer
       ROL    19,X    D�calage � l'�cran
       ROL    18,X    des 40 octets qui
       ROL    17,X    forment une ligne.
       ROL    16,X     Il est beaucoup
       ROL    15,X    plus rapide de
       ROL    14,X    faire comme ici 40
       ROL    13,X    d�calages index�s
       ROL    12,X    par rapport au
       ROL    11,X    centre de la ligne
       ROL    10,X    courante, que de
       ROL    9,X     faire une boucle
       ROL    8,X     avec un compteur
       ROL    7,X     d�cr�ment� 40 fois
       ROL    6,X     qui r�p�terait
       ROL    5,X     une instruction de
       ROL    4,X     d�calage avec pr�-
       ROL    3,X     d�cr�mentation du
       ROL    2,X     registre d'index :
       ROL    1,X       { LDB    #40
       ROL    ,X          ROL    ,-X
       ROL    -1,X        DECB
       ROL    -2,X        BNE    *-3 }
       ROL    -3,X    =562 microsecondes
       ROL    -4,X    tandis que la
       ROL    -5,X    m�thode ci-contre
       ROL    -6,X    n'utilise que
       ROL    -7,X    279 microsecondes!
       ROL    -8,X
       ROL    -9,X    Evidemment,le code
       ROL    -10,X   s'en trouve bien
       ROL    -11,X   rallong�, mais ne
       ROL    -12,X   sacrifierait-on
       ROL    -13,X   pas volontiers
       ROL    -14,X   quelques octets
       ROL    -15,X   � une routine
       ROL    -16,X   permettant une
       ROL    -17,X   animation 2 fois
       ROL    -18,X   plus rapide ?!
       ROL    -19,X    - Oh YES!, Doc' !
       ROL    -20,X
       LEAX   40,X    Descend d'1 ligne
       DECA           8 lignes d�cal�es?
       BNE    DOLINE  Non: on continue !


       DEC    <COLUMN 8 colonnes pass�es
       BNE    EOPASS  Non: fin de passe
       LDA    #8      R�-initialise le
       STA    <COLUMN compteur � 8 cols.
NXTCHR LDB    ,-Y      Lettre suivante
       BPL    CHAROK  >0: lettre normale
       COMB           <0: code=255-code
       BNE    NEWSPD  >0: pas "The_End"
       LDY    #TEXTE  Recommence au tout
       BRA    NXTCHR   d�but du texte...

NEWSPD STB    <SPEED  -> consid�re comme
       BRA    NXTCHR  nouvelle vitesse !

CHAROK MUL            Offset=(ASC-32)*8
       LDU    >$60CF  D�but des fontes
       LEAU   D,U      + offset du CHR$
       PULU   D,X     Copie du graphisme
       STD    <FONT76  de notre lettre
       STX    <FONT54  dans le buffer,
       PULU   D,X     o� il sera d�cal�
       STD    <FONT32 huit fois vers la
       STX    <FONT10 gauche.


EOPASS DEC    <NBPASS Vitesse atteinte ?
       LBNE   SCROLL  Non: autre passage
       LDA    $E7C8   touche frapp�e ?
       LBEQ   SYNCRO  Non: continue...
       PULS   CC,A,B,DP,X,Y,U,PC   *FIN*

       ORG    VARPGE*256+FONT76
       FDB    0,0,0,0 lettre courante
       FCB    0,6,1,0 *,vitesse,colonnes

       END
