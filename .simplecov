# frozen_string_literal: true

SimpleCov.start do
  root ENV["ENGINE_ROOT"]

  add_filter "lib/decidim/petitions/version.rb"
  add_filter "/spec/decidim_dummy_app/"
  add_filter "/vendor/"
end

SimpleCov.command_name ENV["COMMAND_NAME"] || File.basename(Dir.pwd)

SimpleCov.merge_timeout 1800
