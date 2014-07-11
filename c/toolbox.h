#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

// Safer alternative to system() using pipe
int syspipe(char* cmd)
{
  FILE *pipe = popen(cmd,"w");
  if (!pipe){
		fprintf(stderr, "%s\n", strerror(errno));
		return errno;
	}else{
		pclose(pipe);
		return 0;
	}
}

// Print to hex 
void printh(char* str)
{
    int i = 0;
    char cur = str[0];
    while(cur != '\0'){
        cur = str[i];
        printf("%.2X ",cur);
        if( !(i % 8) )
            {printf("\n");}
        i++;
     }
}