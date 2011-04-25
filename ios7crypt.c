/* Andrew Pennebaker
	Copyright 2005 Andrew Pennebaker */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

int xlat[]={
	0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
	0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
	0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
	0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
	0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
	0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
	0x3b, 0x66, 0x67, 0x38, 0x37
};

int XLAT_SIZE=53;

void usage(char *program) {
	printf("Usage: %s [options]\n\n", program);
	printf("-e <passwords>\n");
	printf("-d <hashes>\n");

	exit(0);
}

int htoi(char x) {
	if(isdigit(x))
		return x-'0';
	else
		return toupper(x)-'A'+10;
}

char *encrypt(char *password) {
	char *hash="";

	if (password!=NULL && strlen(password)>0) {
		if (strlen(password)>11) {
			char *temp=(char*) malloc(12);
			strncpy(temp, password, 11);
			password=temp;
		}

		int password_length=strlen(password);

		hash=(char*) malloc(password_length*2+3);

		int seed=rand()%16;

		sprintf(hash, "%02d", seed);

		char *temp=(char*) malloc(3);

		int i;
		for (i=0; i<password_length; i++) {
			sprintf(temp, "%02x", ((int) password[i])^xlat[(seed++)%XLAT_SIZE]);
			strcat(hash, temp);
		}
	}

	return hash;
}

char *decrypt(char *hash) {
	char *password="";

	if (hash!=NULL && strlen(hash)>3) {
		password=(char*) malloc(strlen(hash)/2);

		int seed=htoi(hash[0])*10+htoi(hash[1]);

		int index=0;

		int i;
		for (i=2; i<strlen(hash); i+=2) {
			int c=htoi(hash[i])*16+htoi(hash[i+1]);
			password[index++]=(char) c^xlat[(seed++)%XLAT_SIZE];
		}
	}

	return password;
}

int main(int argc, char **argv) {
	srand(time(NULL));

	int i;

	if (argc<3) {
		usage(argv[0]);
	}
	else if (strcmp(argv[1], "-e")==0) {
		for (i=2; i<argc; i++) {
			printf("%s\n", encrypt(argv[i]));
		}
	}
	else if (strcmp(argv[1], "-d")==0) {
		for (i=2; i<argc; i++) {
			printf("%s\n", decrypt(argv[i]));
		}
	}
	else {
		usage(argv[0]);
	}

	return 0;
}