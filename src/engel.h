/****************************************************************************
**
**    engel.h                         NQ                       Werner Nickel
**                                         nickel@mathematik.tu-darmstadt.de
*/


#define NONE 0
#define ENGEL 1
#define LEFT 2
#define RIGHT 3
#define LEFTRIGHT 4

extern int SemigroupOnly;
extern int SemigroupFirst;
extern int CheckFewInstances;
extern int ReverseOrder;

extern word EngelCommutator(word v, word w, int engel);

extern void EvalEngel(void);
extern void InitEngel(int l, int r, int v, int e, int n);
