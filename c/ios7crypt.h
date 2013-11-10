extern int xlat[];
extern int XLAT_SIZE;

static void usage(char *program);
void encrypt(char *password, char *hash);
void decrypt(char *hash, char *password);
bool reversible(void *data);
