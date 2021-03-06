****************************************
*           FAB Monitor v3.1           *
****************************************
** Fichier des d�finitions d'EQUates. **

PCRTAD EQU    $5FFC   retour indirection
SCREEN EQU    $4078   m�moire �cran
MYGETC EQU    $5FE9   indirection source
FONTS  EQU    $3300   police caract�res
GETC   EQU    $4B55   lecture caract�re
CODE   EQU    $0000   d�but du programme
F1F5BF EQU    $36B0   m�moires de INPUT
FAT    EQU    $3700   buffer disque FAT
CATALG EQU    $3800   buffer disque DIR
IOZONE EQU    $3900   buffer disque DATA
MNEMO1 EQU    $3A00   commandes simples
MNEMO2 EQU    $3D7E     "" complexes(10)
MNEMO3 EQU    $3E24     "" complexes(11)
LINE   EQU    $3E44   la ligne courante
DIR    EQU    $3F     page directe pour
Z      EQU    0       pile et variables
CMPT   EQU    Z       compteur standard
XPOS   EQU    Z+2      abscisse curseur
CLIGNO EQU    Z+3     =$FF si curseur ON
CURSOR EQU    Z+4     position � l'�cran
WRKCSR EQU    Z+6     curseur grande fen
BOTTOM EQU    Z+8     bas de la fen�tre
DMPBYT EQU    Z+10    d�but du DUMP hexa
FIRBYT EQU    Z+12    d�bt d�sassemblage
REGIST EQU    Z+28+1  15 o:les registres

DKOPC  EQU    Z+29    code op�ration DSK
DKDRV  EQU    Z+30    face du disk (0/1)
DKTRK  EQU    Z+31    piste
DKSEC  EQU    Z+32    secteur
DKBUF  EQU    Z+33    adresse buffer DSK
TRACK  EQU    Z+35    position t�te disk
DKTMP  EQU    Z+36    registre tampon

* lecture d'une cha�ne:
NBDGIT EQU    Z+36    nbre max de digits
NBDGRL EQU    Z+37    nb digits utilis�s
INPCHK EQU    Z+38    &(test CHR valide)
INPVAL EQU    Z+40    &(calcul Val-Ret)
CODCDD EQU    Z+42    mode d'affichage*3
C3E4   EQU    Z+45    registres E7C3/E4
* d�sassemblage et dump:
CURBYT EQU    Z+128   l'octet � traiter
OPCODE EQU    Z+130   code instruction
ADRMOD EQU    Z+132   mode d'adressage
* remplissage/copie m�moire:
FILBEG EQU    Z+128   d�but de la zone
FILEND EQU    Z+130   fin zone � remplir
COPBEG EQU    Z+128   d�but zone source
COPEND EQU    Z+130   fin zone source
* ex�cution sous-routine:
STKBAK EQU    Z+128   sauvegarde la pile
SUBADR EQU    Z+130   adresse ex�cution
* recherche:
SRLEN  EQU    Z+128   longueur de cha�ne
* sauvegarde d'une image au format PPM:
IMABNK EQU    Z+138   bank courante
IS4080 EQU    Z+139   flag =0 si 40 cols
CMPTLH EQU    Z+140   compteurs Lrg/Haut
HIGADR EQU    Z+142   adresse �cran lig0
* fichiers sur disquette:
LSHIFT EQU    Z+128   d�calage � la lect
LASTBK EQU    Z+130   flag: dernier bloc
LASTSC EQU    Z+131   flag:  ""  secteur
BYLASE EQU    Z+132   nb octets du der."

BEGADR EQU    Z+130   adresse d�but ""
EXEADR EQU    Z+132   adresse ex�cution
FATPTR EQU    Z+134   0-159:bloc cour.+1
DIRSEC EQU    Z+135   secteur � modifier
DIRPTR EQU    Z+136   entr�e dans CATALG
FILETY EQU    Z+144   type du fichier
DATATY EQU    Z+145   type des donn�es
FILSIZ EQU    Z+146    taille du fichier
* affichage du catalogue:
VIWTMP EQU    Z+128   tampons pour les
VWTMP2 EQU    Z+130   calculs > 16 bits.
FILEN  EQU    Z+132   Nb blocs utilis�s



       ORG    DIR*256+XPOS
       FDB    0,SCREEN,SCREEN
       FDB    SCREEN+24*320,G,G
       FCB    9
       ORG    DIR*256+INPCHK
       FDB    CHKHEX,VALHEX
       ORG    F1F5BF
       FDB    0,0,0,0,0,0,0,0
       FDB    0,0,0,0,0,0,0,0
       FDB    0,0,0,0,0,0,0,0
       FDB    0,0,0,0,0,0,0,0
       FDB    0,0,0,0,0,0,0,0
