/****************************************************************************
**
**    pcarith.h                       PC                       Werner Nickel
**                                         nickel@mathematik.tu-darmstadt.de
*/


extern  void    WordCopyExpVec(expvec ev, word w );
extern  word    WordExpVec(expvec ev);
extern  expvec  ExpVecWord(word w);
extern  int     WordCmp(word u, word w);
extern  void    WordCopy(word u, word w);
extern  int     WordLength(word w);
extern  word    WordGen(gen g);
extern  word    WordMult(word u, word w);
extern  word    WordPow(word w, int * pn);
extern  word    WordConj(word u, word w);
extern  word    WordComm(word u, word w);
extern  word    WordRel(word u, word w);
extern  void    WordInit( word (*generator)() );
extern  void    WordPrint(word gs);
