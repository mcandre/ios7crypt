require "ios7crypt"

require "ruboto/widget"
require "ruboto/util/toast"

ruboto_import_widgets :Button, :EditText, :LinearLayout, :TextView

class Main
	def on_create(bundle)
		super

		set_title "IOS7Crypt"

		self.content_view =
			linear_layout(:orientation => :vertical) do
				linear_layout(:orientation => :vertical) do
					text_view :text => "Password:", :text_size => 24.0
					@password = edit_text :single_line => true, :text => "monkey",
						:width => :match_parent, :gravity => :center, :text_size => 24.0
					button :text => "Encrypt", :text_size => 24.0,
						:on_click_listener => proc { android_encrypt }
				end

				linear_layout(:orientation => :vertical) do
					text_view :text => "Hash", :text_size => 24.0
					@hash = edit_text :single_line => true, :text => "04560408042455",
						:width => :match_parent, :gravity => :center, :text_size => 24.0
					button :text => "Decrypt", :text_size => 24.0,
						:on_click_listener => proc { android_decrypt }
				end
			end
	rescue
		puts "Exception creating activity: #{$!}"
		puts $!.backtrace.join("\n")
	end

	private

	def android_encrypt
		password = @password.text.to_string

		hash = password.encrypt

		@hash.text = hash
	end

	def android_decrypt
		hash = @hash.text.to_string

		password = hash.decrypt

		@password.text = password
	end
end