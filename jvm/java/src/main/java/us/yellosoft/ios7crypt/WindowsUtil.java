package us.yellosoft.ios7crypt;

import java.awt.Window;
import java.awt.Toolkit;

/** Window-centering */
public final class WindowsUtil {
    /** Utility class */
    private WindowsUtil() {}

    /**
        * Center a Window widget in the center of a monitor
        * @param window the Window to center
        */
    public static void centerOnScreen(final Window window) {
        final var dimension = Toolkit.getDefaultToolkit().getScreenSize();
        window.setLocation(
            (dimension.width - window.getSize().width) / 2,
            (dimension.height - window.getSize().height) / 2
        );
    }
}
