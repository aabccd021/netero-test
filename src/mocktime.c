#define _GNU_SOURCE
#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <errno.h>
#include <string.h>
#include <sys/time.h>

static time_t read_time_from_file(void) {
    const char *netero_state = getenv("NETERO_STATE");
    if (!netero_state) {
        fprintf(stderr, "NETERO_STATE environment variable is not set\n");
        exit(EXIT_FAILURE);
    }

    char *path = NULL;
    if (asprintf(&path, "%s/now.txt", netero_state) == -1 || !path) {
        fprintf(stderr, "Failed to allocate memory for path: %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }

    FILE *f = fopen(path, "r");
    if (!f) {
        fprintf(stderr, "Failed to open %s: %s (errno: %d)\n", path, strerror(errno), errno);
        free(path);
        exit(EXIT_FAILURE);
    }

    time_t t = 0;
    if (fscanf(f, "%ld", &t) != 1) {
        fprintf(stderr, "Failed to read time value from %s: %s (errno: %d)\n", path, strerror(errno), errno);
        fclose(f);
        free(path);
        exit(EXIT_FAILURE);
    }
    fclose(f);
    free(path);
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
    return 0;
}

int clock_gettime(clockid_t clk_id, struct timespec *tp) {
    if (!tp) {
        errno = EINVAL;
        return -1;
    }

    if (clk_id == CLOCK_REALTIME || clk_id == CLOCK_MONOTONIC) {
        time_t t = read_time_from_file();
        tp->tv_sec = t;
        tp->tv_nsec = 0;
        return 0;
    } else {
        errno = EINVAL;
        return -1;
    }
}
