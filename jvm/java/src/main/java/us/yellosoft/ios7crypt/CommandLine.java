package us.yellosoft.ios7crypt;

import org.docopt.Docopt;

/** CLI for IOS7Crypt */
public final class CommandLine {
    /** DocOpt usage spec */
    public static final String DOC =
    "Usage:\n" +
    "  ios7crypt --encrypt=<password>\n" +
    "  ios7crypt --decrypt=<hash>\n" +
    "  ios7crypt --help\n" +
    "Options:\n" +
    "  -e --encrypt=<password>  Encrypt a password\n" +
    "  -d --decrypt=<hash>      Decrypt a hash\n" +
    "  -h --help                Print usage information";

    /** Utility class */
    private CommandLine() {}

    /**
        * Execute CLI
        * @param args CLI flags
        */
    public static void main(final String[] args) {
        final var options = new Docopt(DOC).withVersion("0.0.1").parse(args);

        if ((String) options.get("--encrypt") != null) {
            System.out.println(IOS7CryptUtil.encrypt((String) options.get("--encrypt")));
        } else if ((String) options.get("--decrypt") != null) {
            System.out.println(IOS7CryptUtil.decrypt((String) options.get("--decrypt")));
        }
    }
}
