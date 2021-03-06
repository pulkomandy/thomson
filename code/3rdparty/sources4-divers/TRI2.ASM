


****************************************
*                                      *
*              T R I 2                 *
*                                      *
****************************************
*                                      *
* Programme de tri en m�moire centrale *
* appel par le BASIC par USR(0)        *
*--------------------------------------*
*                                      *
*   Programmation en assembleur TO7    *
*         Sybex Fagot-Barraly          *
*         Annexe 2  page 165
*                                      *
****************************************


       ORG    $7FBD

       LDA    #100    Nb d'�l�ments �
       LDB    #100    trier = 100 seront
* contenus dans les accumulateurs A et B

       LDY    2,X     Le param�tre trans
* mis au langage machine est plac� dans
* les 2 octets apr�s l'adresse contenue
* dans X.Y va contenir VARPTR(A(0)).Le
* programme d�marre avec Y pointant sur
* le 1er �l�ment A(0) du tableau A(I).

SUITE2 PSHS   D       Sauvegarde de D

       LEAX   2,Y     On commande � X de
* pointer sur le 2�me �l�ment du tableau
* soit A(1), noter que les entiers sont
* rang�s en m�moire sur 2 octets.

SUITE1 DEC    ,S      D�cr�mente l'octet
* au sommet de la pile.Celui-ci �quivaut
* au nombre de passages dans la boucle
* SUITE1.

       BEQ    PASSE   (+21)On compare le
       LDD    ,X++    2nd �lem. de A(I)
*                     point� par X et le
       CMPD   ,Y      1er (point� par Y)
       BHS    SUITE1  (-11)Oui si le 2nd
* > ou = au 1er alors retour � SUITE1
* pour comparer le 3�me et le 1er.

       PSHS   D       Si non (2nd<1er)
       LDD    ,Y      on proc�de � leur
       STD    ,--X    �change.Nous avons
       PULS   D       la certitude � la
       STD    ,Y      fin de la boucle
       LEAX   2,X     SUITE1 que A(0)
       BRA    SUITE1  (-25)est l'�l�ment
*                     minimum de A(I).

PASSE  LEAY   2,Y     Y va contenir l'
       PULS   D       adresse de A(1) et
       DECB           un retour � SUITE2
       TFR    B,A     est programm�.Pour
       CMPB   #1      comparer A(1) avec
       BNE    SUITE2  (-40)les �l�ments
* suivants; un �change sera effectu� �
* chaque fois que l'on aura trouv� un
* �l�ment plus petit que A(1).

       RTS
       END

* Ainsi apr�s deux passages de la boucle
* SUITE2, A(0) et A(1) contiendront les
* deux plus petites valeurs de A(I), et
* ceci dans l'ordre croissant.
* Quand le programme arrivera � la fin,
* les 100 �l�ments seront rang�s et la
* ligne BASIC 60 nous en donnera la
* confirmation.
* NB: La variable Z est une var. fictive
* dont la valeur est sans importance
* puisque l'assembleur n'a aucun para-
* m�tre � retourner au BASIC.
