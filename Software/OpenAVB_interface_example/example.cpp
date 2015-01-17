#include <stdint.h>
#include <ipcdef.hpp>
#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#include <sys/mman.h>
#include <fcntl.h>    

// This application prints the current time in terms of 802.1AS master once
// per second

#define TIMESPEC_TO_U64(ts) ((ts).tv_nsec + (ts.tv_sec*1000000000ULL))
#define GPTP_UPDATE_TIME_SYSTEM(td) ((td).local_time+(td).ls_phoffset)
#define GPTP_UPDATE_TIME_MASTER(td) ((td).local_time-(td).ml_phoffset)

int main() {
	int shm_fd;
	pthread_mutex_t *lock;
	gPtpTimeData *time_data;

	// Open shared memory segment
	// Write permission is required to lock the memory segment
	shm_fd = shm_open( SHM_NAME, O_RDWR, 0 );
	if( shm_fd == -1 ) {
		printf
			( "Failed to open shared memory segment %s: %s\n",
			  SHM_NAME, strerror(errno) );
		return -1;
	}
	lock = (pthread_mutex_t *) mmap
		( NULL, SHM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd,
		  0 );
	if( lock == (pthread_mutex_t *)-1 ) {
		printf
			( "Failed to mmap shared memory segment %s: %s\n",
			  SHM_NAME, strerror(errno) );
		return -1;
	}

	time_data = (gPtpTimeData *)(lock+1);

	while( 1 ) {
		struct timespec now_ts;
		uint32_t delta;
		uint64_t now_master;

		pthread_mutex_lock(lock);

		clock_gettime( CLOCK_REALTIME, &now_ts );
		delta =
			TIMESPEC_TO_U64(now_ts)-
			GPTP_UPDATE_TIME_SYSTEM(*time_data);
		delta *= time_data->ls_freqoffset*time_data->ml_freqoffset;
		now_master = delta + GPTP_UPDATE_TIME_MASTER(*time_data);
		
		pthread_mutex_unlock(lock);
		printf( "Master time now: %lu\n", now_master );

		sleep(1);
	}
	
	return 0;
}

