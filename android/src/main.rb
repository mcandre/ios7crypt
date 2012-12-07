require "ruboto/widget"
require "ruboto/util/toast"

ruboto_import_widgets :EditText, :Button, :LinearLayout, :TextView

class Main
	def on_create(bundle)
		super

		set_title "IOS7Crypt"

		self.content_view =
			linear_layout :orientation => :vertical do
				@password = edit_text :text => "monkey", :id => 42, :width => :match_parent,
					:gravity => :center, :text_size => 48.0, :on_change_listener => proc { android_encrypt }
				@hash = edit_text :text => "04560408042455", :id => 43, :width => :match_parent,
					:gravity => :center, :text_size => 48.0, :on_change_listener => proc { android_decrypt }
			end
	rescue
		puts "Exception creating activity: #{$!}"
		puts $!.backtrace.join("\n")
	end

	private

	def android_encrypt
		@hash.text = @password.text.encrypt
		toast "Encrypted"
	end

	def android_decrypt
		@password.text = @hash.text.decrypt
		toast "Decrypted"
	end
end