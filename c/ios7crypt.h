extern int xlat[];
extern int XLAT_SIZE;

void usage(char* const program);
void encrypt(char* const password, char* hash);
void decrypt(char* const hash, char* password);
bool reversible(void* const data);
