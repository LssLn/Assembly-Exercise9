int processa(char *num, int d){ 
  int i,somma, p;
  somma=0;
  for(i=0;i<d;i++)
    somma=somma+ num[i]-48;
  return somma;
}

main() {
  char NUMERO[16];
  int i,val;
  for(i=0;i<4;i++) {
    printf("Inserisci una stringa con soli numeri\n");
    scanf("%s",NUMERO);
    if(strlen(NUMERO)<2)
      val=NUMERO[0]-48;
    else 
      val=processa(NUMERO,strlen(NUMERO));
    printf(" Valore= %d \n",val);
  }
}
