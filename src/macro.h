/*****************************************************************************
**
**    macro.h                         NQ                       Werner Nickel
**                                         Werner.Nickel@math.rwth-aachen.de
*/

/*
**    Some macros.
*/
#define abs(x)    ((x) >  0  ? (x) : -(x))
#define sgn(x)    ((x) >  0  ?  1  :  -1 )
#define min(x,y)  ((x) > (y) ? (y) :  (x))
#define max(x,y)  ((x) < (y) ? (y) :  (x))
