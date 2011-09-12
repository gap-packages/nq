/****************************************************************************
**
**    presentation.h           Presentation                    Werner Nickel
**                                         nickel@mathematik.tu-darmstadt.de
*/


#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "mem.h"
#include "genexp.h"

/*
**    The following data structure will represent a node in an expression
**    tree. The component type can indicate 3 basic objects : numbers,
**    generators and binary operators. There are currently 5 binary
**    operations.  There is now place to also hold a ternary operation: Engel
**    commutators.
*/
struct _node {
	int     type;
	union {
		int     n;                          /* stores numbers      */
		gen     g;                          /* stores generators   */
		struct {
			struct _node *l, *r;       /* stores bin ops      */
			struct _node *e;
		} op;     /* and Engel relations */
	} cont;
};

typedef struct _node node;

/*
**    The following macros are used as first argument to the function
**    SetEvalFunction().
*/
#define TNUM   1
#define TGEN   2

#define TMULT  3
#define TPOW   4
#define TCONJ  5
#define TCOMM  6
#define TREL   7
#define TDRELL 8
#define TDRELR 9
#define TENGEL 10
#define TLAST  11

typedef void *(*EvalFunc)();


extern void     PrintGen(gen g);
extern void     PrintPresentation(FILE *fp);
extern void     Presentation(FILE *fp, char *filename);
extern node     *ReadWord();
extern node     *Word();

extern char     *GenName(gen g);
extern int      NumberOfAbstractGens();
extern int      NumberOfIdenticalGens();
extern int      NumberOfGens();
extern int      NumberOfRels();
extern node     *FirstRelation();
extern node     *NextRelation();
extern node     *CurrentRelation();
extern node     *NthRelation(int n);

extern void     SetEvalFunc(int type, EvalFunc function);
extern void     **EvalRelations();
extern void     *EvalNode(node *n);
extern void     FreeNode(node *n);
extern void     PrintNode(node *n);
extern void     InitPrint(FILE *);

extern int      NrIdenticalGensNode;
extern gen      *IdenticalGenNumberNode;
extern int      NumberOfIdenticalGensNode();

