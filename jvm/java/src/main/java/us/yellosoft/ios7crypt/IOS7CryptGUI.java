package us.yellosoft.ios7crypt;

import java.awt.BorderLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JPanel;
import javax.swing.JFrame;
import javax.swing.JDialog;
import javax.swing.JTextField;
import javax.swing.JLabel;
import javax.swing.BorderFactory;

/** IOS7Crypt GUI */
@SuppressWarnings("serial")
public class IOS7CryptGUI extends JPanel implements ActionListener {
    private final JTextField passwordField;
    private final JTextField hashField;

    /** Construct GUI */
    public IOS7CryptGUI() {
        super(new BorderLayout());

        final var passwordLabel = new JLabel("Password");
        passwordLabel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        passwordField = new JTextField("", 10);
        passwordLabel.setLabelFor(passwordField);
        passwordField.addActionListener(this);

        final var hashLabel = new JLabel("Hash");
        hashLabel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        hashField = new JTextField("", 10);
        hashLabel.setLabelFor(hashField);
        hashField.addActionListener(this);

        final var passwordPanel = new JPanel(new BorderLayout());
        passwordPanel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        passwordPanel.add(passwordLabel, BorderLayout.WEST);
        passwordPanel.add(passwordField, BorderLayout.EAST);

        final var hashPanel = new JPanel(new BorderLayout());
        hashPanel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        hashPanel.add(hashLabel, BorderLayout.WEST);
        hashPanel.add(hashField, BorderLayout.EAST);

        add(passwordPanel, BorderLayout.NORTH);
        add(hashPanel, BorderLayout.SOUTH);
    }

    @Override
    public final void actionPerformed(final ActionEvent e) {
        if (e.getSource() == passwordField) {
            hashField.setText(IOS7CryptUtil.encrypt(passwordField.getText()));
        } else if (e.getSource() == hashField) {
            passwordField.setText(IOS7CryptUtil.decrypt(hashField.getText()));
        }
    }

    /**
     * <p>Launch GUI app</p>
     *
     * @param args CLI arguments
     */
    public static void main(final String[] args) {
        JFrame.setDefaultLookAndFeelDecorated(true);
        JDialog.setDefaultLookAndFeelDecorated(true);

        final var frame = new JFrame("IOS7Crypt");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setResizable(false);
        frame.setContentPane(new IOS7CryptGUI());

        frame.pack();
        WindowsUtil.centerOnScreen(frame);
        frame.setVisible(true);
    }
}
