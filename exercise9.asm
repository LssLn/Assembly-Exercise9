.data
ST: .space 16 ;# NUMERO[16]
stack: .space 32

msg1: .asciiz "Inserisci una str di soli num\n"
msg2: .asciiz "Valore : %d\n" ;# val 1° arg msg2

p1sys5: .space 8
val: .space 8 ;# 1° arg msg2

p1sys3: .word 0 ;#fd null
ind: .space 8
dim: .word 16 ;# numbyte da leggere <= ST

.code
;# init stack
daddi $sp,$0,stack
daddi $sp,$sp,32

daddi $s0,$0,0 ;# i=0
;# for(i=0;i<4;i++) {
for:    
    slti $t0,$s0,4 ;# $t0=0 quando $s0(i) >= 4
    beq $t0,$0,exit ;# exit fine for quando $t0=0

    ;# printf msg1
    daddi $t0,$0,msg1
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# scanf %s ST
    daddi $t0,$0,ST
    sd $t0,ind($0)
    daddi r14,$0,p1sys3
    syscall 3
    ;# preparazione argomenti funzione
    move $a1,r1         ;# $a1 = r1 = strlen
    daddi $a0,$0,ST     ;#$a0 = ST
    ;# ramo if-else; entrambi alla fine vanno alla printf finale quindi j p_msg2 
        ;# if(strlen(NUMERO)<2)
    slti $t0,$a1,2      ;# $t0=0 quando $a1 >= 2, ramo if
    bne $t0,$0,ramo_if  ;# ramo if quando $t0!=0, ovvero $a1 < 2
    beq $t0,$0,ramo_else
;# if(...) val=NUMERO[0]-48;
ramo_if: 
    dadd $t0,$a0,$0 ;# $t0 = &st[0] = st ($a0) + 0
    lbu $t1,0($t0)  ;# $t1 = st[0]
    daddi $t1,$t1,-48   ;# st[0] - 48
    sd $t1,val($0)  ;# val = st[0] - 48
    j pmsg2
;# else val=processa(NUMERO,strlen(NUMERO));
ramo_else: 
    ;# $a0 = ST         $a1 = strlen
    jal processa
    sd r1,val($0) ;# val = return function
    j pmsg2
;# printf msg2       ;# val ha somma di processa, 1° arg 
pmsg2: 
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# dopo aver stampato, continuo il for : c'è incremento e j
    daddi $s0,$s0,1 ;# i++
    j for
;# int processa(char *num, int d)
processa:
    daddi $sp,$sp,-16 ;#8x2, i e somma
    sd $s1,0($sp) ;# i
    sd $s2,8($sp) ;# somma
    daddi $s1,$0,0 ;# i=0
    daddi $s2,$0,0 ;# somma=0

for_f:
    slt $t0,$s1,$a1  ;# $t0=0  quando $s1 (i) >= $a1 (strlen(=d))
    beq $t0,$0,return ;# return quando $t0=0
    ;# somma=somma+ num[i]-48;
    dadd $t0,$a0,$s1 ;# $t0 = & st [i] = $a0 (st) + $s1 (i)
    lbu $t1,0($t0) ;# st[i]
    daddi $t1,$t1,-48  ;# $t1-48 
    dadd $s2,$s2,$t1   ;# $s1+= $t1 (somma+= st[i]-48)
    ;# i++ e j for_f
    daddi $s1,$s1,1 ;# i++
    j for_f
return:
    return:
    move r1,$s2 ;# r1 = somma
    ld $s1,0($sp)
    ld $s2,8($sp)
    daddi $sp,$sp,-16
    jr $ra
exit:
    syscall 0
