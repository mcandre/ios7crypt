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
  private JLabel passwordLabel;
  private JTextField passwordField;
  private JLabel hashLabel;
  private JTextField hashField;

  /** Construct GUI */
  public IOS7CryptGUI() {
    super(new BorderLayout());

    passwordLabel = new JLabel("Password");
    passwordLabel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
    passwordField = new JTextField("", 10);
    passwordLabel.setLabelFor(passwordField);
    passwordField.addActionListener(this);

    hashLabel = new JLabel("Hash");
    hashLabel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
    hashField = new JTextField("", 10);
    hashLabel.setLabelFor(hashField);
    hashField.addActionListener(this);

    JPanel passwordPanel = new JPanel(new BorderLayout());
    passwordPanel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
    passwordPanel.add(passwordLabel, BorderLayout.WEST);
    passwordPanel.add(passwordField, BorderLayout.EAST);

    JPanel hashPanel = new JPanel(new BorderLayout());
    hashPanel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
    hashPanel.add(hashLabel, BorderLayout.WEST);
    hashPanel.add(hashField, BorderLayout.EAST);

    add(passwordPanel, BorderLayout.NORTH);
    add(hashPanel, BorderLayout.SOUTH);
  }

  /**
     <p>Respond to GUI event</p>
     @param e GUI event
  */
  public final void actionPerformed(final ActionEvent e) {
    if (e.getSource() == passwordField) {
      hashField.setText(IOS7Crypt.encrypt(passwordField.getText()));
    } else if (e.getSource() == hashField) {
      passwordField.setText(IOS7Crypt.decrypt(hashField.getText()));
    }
  }

  /**
     <p>Launch GUI app</p>
     @param args CLI arguments
  */
  public static void main(final String[] args) {
    JFrame.setDefaultLookAndFeelDecorated(true);
    JDialog.setDefaultLookAndFeelDecorated(true);

    JFrame frame = new JFrame("IOS7Crypt");
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.setResizable(false);
    frame.setContentPane(new IOS7CryptGUI());

    frame.pack();
    Windows.centerOnScreen(frame);
    frame.setVisible(true);
  }
}
