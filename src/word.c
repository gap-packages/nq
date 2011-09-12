/*****************************************************************************
**
**    word.c                          NQ                       Werner Nickel
**                                         nickel@mathematik.tu-darmstadt.de
*/


#include "nq.h"

void    printGen(gen g, char c) {
	putchar(c + (g - 1) % 26);
	if ((g - 1) / 26 != 0)
		printf("%d", (g - 1) / 26);
}

void    printWord(word w, char c) {
	if (w == (word)0 || w->g == EOW) {
		printf("Id");
		return;
	}

	while (w->g != EOW) {
		if (w->g > 0) {
			printGen(w->g, c);
			if (w->e != (exp)1)
#ifdef HAVE_LONG_LONG_INT
				printf("^%lld", w->e);
#else
				printf("^%d", w->e);
#endif
		} else {
			printGen(-w->g, c);
#ifdef HAVE_LONG_LONG_INT
			printf("^%lld", -w->e);
#else
			printf("^%d", -w->e);
#endif
		}
		w++;
		if (w->g != EOW) putchar('*');
	}
}
