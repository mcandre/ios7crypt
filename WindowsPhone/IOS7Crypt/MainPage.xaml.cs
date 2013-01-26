using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;

namespace IOS7Crypt {
    public partial class MainPage : PhoneApplicationPage {
        // Constructor
        public MainPage() {
            InitializeComponent();
        }

        public void Encrypt(object sender, EventArgs e) {
            String password = PasswordBox.Text;
            String hash = ""; // ...
            HashBox.Text = hash;
        }

        public void Decrypt(object sender, EventArgs e) {
            String hash = HashBox.Text;
            String password = ""; // ...
            PasswordBox.Text = password;
        }
    }
}