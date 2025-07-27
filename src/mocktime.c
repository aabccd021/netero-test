#define _GNU_SOURCE
#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <errno.h>
#include <sys/time.h>
#include <string.h>

static int read_time_from_file(time_t *t_out) {
    if (!t_out) {
        errno = EINVAL;
        return 0;
    }

    const char *netero_state = getenv("NETERO_STATE");
    if (!netero_state) {
        errno = ENOENT;
        return 0;
    }

    char path[PATH_MAX];
    if (snprintf(path, sizeof(path), "%s/now.txt", netero_state) >= (int)sizeof(path)) {
        errno = ENAMETOOLONG;
        return 0;
    }

    FILE *f = fopen(path, "r");
    if (!f) {
        return 0;
    }

    char buf[64];
    if (!fgets(buf, sizeof(buf), f)) {
        fclose(f);
        errno = EIO;
        return 0;
    }
    fclose(f);

    char *endptr;
    errno = 0;
    long long val = strtoll(buf, &endptr, 10);
    if (errno != 0 || endptr == buf || (*endptr && *endptr != '\n')) {
        errno = EINVAL;
        return 0;
    }

    *t_out = (time_t)val;
    return 1;
}

time_t time(time_t *tloc) {
    time_t t = (time_t)-1;
    if (!read_time_from_file(&t)) {
        // errno already set
        return (time_t)-1;
    }
    if (tloc)
        *tloc = t;
    return t;
}

int gettimeofday(struct timeval *tv, void *tz) {
    if (!tv) {
        errno = EINVAL;
        return -1;
    }
    time_t t;
    if (!read_time_from_file(&t)) {
        // errno already set
        return -1;
    }
    tv->tv_sec = t;
    tv->tv_usec = 0;
    if (tz) {
        struct timezone *ptz = (struct timezone *)tz;
        ptz->tz_minuteswest = 0;
        ptz->tz_dsttime = 0;
    }
    return 0;
}

int clock_gettime(clockid_t clk_id, struct timespec *ts) {
    if (!ts) {
        errno = EINVAL;
        return -1;
    }
    if (clk_id != CLOCK_REALTIME) {
        errno = EINVAL;
        return -1;
    }
    time_t t;
    if (!read_time_from_file(&t)) {
        // errno already set
        return -1;
    }
    ts->tv_sec = t;
    ts->tv_nsec = 0;
    return 0;
}
