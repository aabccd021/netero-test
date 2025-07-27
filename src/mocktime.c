#define _GNU_SOURCE
#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <errno.h>
#include <sys/time.h>

time_t read_time_from_file() {
    const char *netero_state = getenv("NETERO_STATE");
    if (!netero_state) {
        fprintf(stderr, "NETERO_STATE environment variable is not set\n");
        exit(1);
    }

    char path[PATH_MAX];
    snprintf(path, sizeof(path), "%s/now.txt", netero_state);

    FILE *f = fopen(path, "r");
    if (!f) {
        fprintf(stderr, "Failed to open %s\n", path);
        exit(1);
    }

    time_t t = 0;
    if (fscanf(f, "%ld", &t) != 1) {
        fprintf(stderr, "Failed to read time value from %s\n", path);
        fclose(f);
        exit(1);
    }
    fclose(f);
    return t;
}

time_t time(time_t *tloc) {
    time_t t = read_time_from_file();
    if (tloc) {
      *tloc = t;
    }
    return t;
}

int gettimeofday(struct timeval *tv, void *tz) {
    time_t t = read_time_from_file();
    if (tv) {
        tv->tv_sec = t;
        tv->tv_usec = 0;
    }
    if (tz) {
        struct timezone *ptz = (struct timezone *)tz;
        ptz->tz_minuteswest = 0;
        ptz->tz_dsttime = 0;
    }
    return 0;
}

int clock_gettime(clockid_t clk_id, struct timespec *tp) {
    if (!tp) {
        errno = EINVAL;
        return -1;
    }

    switch (clk_id) {
        case CLOCK_REALTIME:
        case CLOCK_MONOTONIC:
            {
                time_t t = read_time_from_file();
                tp->tv_sec = t;
                tp->tv_nsec = 0;
                return 0;
            }
        default:
            errno = EINVAL;
            return -1;
    }
}
