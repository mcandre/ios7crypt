package us.yellosoft.ios7crypt;

import android.os.Bundle;

public class Main extends org.ruboto.EntryPointActivity {
  public void onCreate(Bundle bundle) {
    getScriptInfo().setRubyClassName(getClass().getSimpleName());
    super.onCreate(bundle);
  }
}
