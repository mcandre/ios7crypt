require "ios7crypt"

require "ruboto/widget"
require "ruboto/util/toast"

ruboto_import_widgets :Button, :EditText, :LinearLayout, :TextView

class Main
	def on_create(bundle)
		super

		set_title "IOS7Crypt"

		password = "monkey"
		hash = "060b002f474b10"

		password = bundle.getString("password", "monkey") unless bundle.nil?
		hash = bundle.getString("hash", "060b002f474b10") unless bundle.nil?

		self.content_view =
			linear_layout(:orientation => :vertical) do
				linear_layout(:orientation => :vertical) do
					text_view :text => "Password:", :text_size => 24.0

					@password = edit_text :single_line => true, :text => password,
						:width => :match_parent, :gravity => :center, :text_size => 24.0

					button :text => "Encrypt", :text_size => 24.0,
						:on_click_listener => proc { android_encrypt }
				end

				linear_layout(:orientation => :vertical) do
					text_view :text => "Hash", :text_size => 24.0

					@hash = edit_text :single_line => true, :text => hash,
						:width => :match_parent, :gravity => :center, :text_size => 24.0

					button :text => "Decrypt", :text_size => 24.0,
						:on_click_listener => proc { android_decrypt }
				end
			end

		self.on_save_instance_state(proc { save_state })
	rescue
		puts "Exception creating activity: #{$!}"
		puts $!.backtrace.join("\n")
	end

	private

	def android_encrypt
		@hash.text = @password.text.to_string.encrypt
	end

	def android_decrypt
		@password.text = @hash.text.to_string.decrypt
	end

	def save_state(bundle)
		bundle.putString("password", @password.text.to_string)
		bundle.putString("hash", @hash.text.to_string)
	end
end