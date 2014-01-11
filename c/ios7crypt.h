extern int xlat[];
extern int XLAT_SIZE;

static void usage(char *program);
void encrypt(const char *password, char *hash);
void decrypt(const char *hash, char *password);
bool reversible(void *data);
