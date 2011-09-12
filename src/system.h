/****************************************************************************
**
**    system.h                        NQ                       Werner Nickel
*/

#ifndef SYSTEM_H
#define SYSTEM_H

extern void SetTimeOut(int nsec);
extern void TimeOutOn(void);
extern void TimeOutOff(void);
extern void CatchSignals(void);
extern int RunTime(void);

#endif
