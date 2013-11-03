import java.util.ArrayList;

import gnu.getopt.Getopt;
import gnu.getopt.LongOpt;

public final class CommandLine {
  private CommandLine() {}

  public static void usage() {
    System.out.println(
      "Usage: CommandLine [OPTIONS]\n" +
      "--help, -h:\n" +
      "    show help\n" +
      "--encrypt, -e <password1> <password2> <password3> ...:\n" +
      "    prints out the encrypted passwords as hashes\n" +
      "--decrypt, -d <hash1> <hash2> <hash3> ...:\n" +
      "    prints out the decrypted hashes as passwords"
    );

    System.exit(0);
  }

  public static void main(final String[] args) {
    String mode = "encrypt";
    String password = "";
    String hash = "";

    if (args.length < 1) {
      usage();
    }

    StringBuffer valueBuffer = new StringBuffer();

    LongOpt[] longOpts = {
      new LongOpt("help", LongOpt.NO_ARGUMENT, null, 'h'),
      new LongOpt("encrypt", LongOpt.REQUIRED_ARGUMENT, null, 'e'),
      new LongOpt("decrypt", LongOpt.REQUIRED_ARGUMENT, null, 'd')
    };

    Getopt g = new Getopt("CommandLine", args, "he:d:", longOpts);
    g.setOpterr(false);

    int c = g.getopt();
    while (c != -1) {
      switch(c) {
        case 'e':
          mode = "encrypt";
          password = g.getOptarg();
          break;
        case 'd':
          mode = "decrypt";
          hash = g.getOptarg();
          break;
        default:
          usage();
          break;
      }

      c = g.getopt();
    }

    ArrayList<String> leftoverArgs = new ArrayList<String>();

    for (int i = g.getOptind(); i < args.length; i++) {
      leftoverArgs.add(args[i]);
    }

    if (mode == "encrypt") {
      System.out.println(IOS7Crypt.encrypt(password));

      for (String arg:leftoverArgs) {
        System.out.println(IOS7Crypt.encrypt(arg));
      }
    }
    else if (mode == "decrypt") {
      System.out.println(IOS7Crypt.decrypt(hash));

      for (String arg:leftoverArgs) {
        System.out.println(IOS7Crypt.decrypt(arg));
      }
    }
  }
}
