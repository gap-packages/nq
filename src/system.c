/****************************************************************************
**
**    system.c                        NQ                       Werner Nickel
**                                         nickel@mathematik.tu-darmstadt.de
*/

#include <stdio.h>
#include <signal.h>
#include <sys/time.h>
#include <unistd.h>

#include "config.h"

#include "nq.h"

static
const char	*SignalName[] = { "",
                              "Hangup (1)",
                              "Interrupt (2)",
                              "Quit (3)",
                              "Illegal instruction (4)",
                              "(5)",
                              "Abort (6)",
                              "(7)",
                              "Arithmetic exception (8)",
                              "(9)",
                              "Bus error (10)",
                              "Segmentation violation (11)",
                              "(12)",
                              "(13)",
                              "Alarm clock (14)",
                              "User termination (15)",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "Virtual alarm (26)"
                           };

static void handler(int sig) {
	fprintf(stderr, "\n\n# Process terminating with signal");
	fprintf(stderr, " %s.\n\n", SignalName[sig]);

	if (Gap) printf("];\n");
	fflush(stdout);

	signal(sig, SIG_DFL);
	raise(sig);
}

static int TimeOutReached = 0;
static int DoTimeOut = 1;

/*
**    Set the alarm.
*/
void SetTimeOut(int nsec) {
#ifndef ITIMER_VIRTUAL
	printf("#\n#    Timeouts are not available on this system.\n");
#else
	struct itimerval  si;

	if (nsec > 0) {
		printf("#\n#    Time out after %d seconds.\n", nsec);
		/* Set time after which timer expires. */
		si.it_value.tv_sec  = nsec;    /*  sec */
		si.it_value.tv_usec = 0;       /* msec */
		/* The timer is not going to be reset. */
		si.it_interval.tv_sec  = 0;
		si.it_interval.tv_usec = 0;

		if (setitimer(ITIMER_VIRTUAL, &si, (struct itimerval*)0) == -1) {
			perror("");
		}
		TimeOutReached = 0;
		DoTimeOut = 1;
		return;
	} else
		printf("SetTimeOut(): argument negative, timeout not set.\n");
#endif
}

/*
**    Switch on the time out mechanism. Check if the program has timed
**    out in the mean time and if so terminate.
*/
void TimeOutOn(void) {
	if (TimeOutReached) {
		printf("#\n#    Process has timed out.\n#\n");

		if (Gap) printf("];\n");
		exit(0);
	} else
		DoTimeOut = 1;
}

/*
**    Switch off the time out mechanism.
*/
void TimeOutOff(void) {
	DoTimeOut = 0;
}

#ifdef SIGVTALRM
static void alarmClock(int sig) {
	TimeOutReached = 1;

	if (DoTimeOut)
		TimeOutOn();
}
#endif

void CatchSignals(void) {

	/*
	**    Catch the following signal in order to exit gracefully
	**    if the process is killed.
	*/
#ifdef SIGHUP
	signal(SIGHUP,  handler);
#endif
	signal(SIGINT,  handler);
#ifdef SIGQUIT
	signal(SIGQUIT, handler);
#endif
	signal(SIGABRT, handler);
	signal(SIGTERM, handler);
	/*
	**    Catch the following signals to exit gracefully if the
	**    process crashes.
	*/
	signal(SIGILL,  handler);
	signal(SIGFPE,  handler);
#ifdef SIGBUS
	signal(SIGBUS,  handler);
#endif
	signal(SIGSEGV, handler);
	/*
	**    Catch the virtual alarm signal so that the process can time out.
	*/
#ifdef SIGVTALRM
	signal(SIGVTALRM, alarmClock);
#endif
}

/*
**    return the cpu time in milli seconds
*/
#ifdef HAVE_GETRUSAGE

#include <sys/time.h>
#include <sys/resource.h>

long RunTime(void) {

	struct	rusage	buf;

	if (getrusage(RUSAGE_SELF, &buf)) {
		perror("couldn't obtain timing");
		exit(1);
	}
	return buf.ru_utime.tv_sec * 1000 + buf.ru_utime.tv_usec / 1000;
}

#elif defined(_WIN32)

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

/* nq has a src/time.h of its own, which shadows the system header, so
   clock() is out of reach here; GetProcessTimes is the better source of
   CPU time anyway. */
long RunTime(void) {
	FILETIME creation, exit, kernel, user;
	ULARGE_INTEGER t;

	GetProcessTimes(GetCurrentProcess(), &creation, &exit, &kernel, &user);
	t.LowPart = user.dwLowDateTime;
	t.HighPart = user.dwHighDateTime;
	/* FILETIME counts 100ns intervals */
	return (long)(t.QuadPart / 10000);
}

#else

#include <sys/types.h>
#include <sys/times.h>

long RunTime(void) {
	struct tms buf;

	times(&buf);
	return (buf.tms_utime * 50 / 3);
}

#endif
