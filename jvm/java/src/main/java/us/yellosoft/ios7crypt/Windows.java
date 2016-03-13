package us.yellosoft.ios7crypt;

import java.awt.Window;
import java.awt.Dimension;
import java.awt.Toolkit;

/** Window-centering */
public final class Windows {
  /** Utility class */
  private Windows() {}

  /** Center a Window widget in the center of a monitor
      @param window the Window to center
   */
  public static void centerOnScreen(final Window window) {
    Dimension dimension = Toolkit.getDefaultToolkit().getScreenSize();
    window.setLocation(
      (dimension.width - window.getSize().width) / 2,
      (dimension.height - window.getSize().height) / 2
    );
  }
}
