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

using System.Reflection;
using Microsoft.Scripting;
using Microsoft.Scripting.Hosting;
using IronRuby;

namespace IOS7Crypt {
    public partial class MainPage : PhoneApplicationPage {
        private ScriptEngine engine;
        private dynamic ios7crypt;

        // Constructor
        public MainPage() {
            InitializeComponent();
            engine = IronRuby.Ruby.CreateRuntime();
            ios7crypt = engine.RequireFile(@"ios7crypt.rb");
        }

        public void Encrypt(object sender, EventArgs e) {
            String password = PasswordBox.Text;
            String hash = ios7crypt.encrypt(password);
            HashBox.Text = hash;
        }

        public void Decrypt(object sender, EventArgs e) {
            String hash = HashBox.Text;
            String password = ios7crypt.decrypt(hash);
            PasswordBox.Text = password;
        }
    }
}