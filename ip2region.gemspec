# frozen_string_literal: true

require_relative "lib/ip2region_ext/version"

Gem::Specification.new do |spec|
  spec.name = "ip2region_ext"
  spec.version = Ip2regionExt::VERSION
  spec.authors = ["songgz"]
  spec.email = ["sgzhe@163.com"]

  spec.summary = "Write a short summary, because RubyGems requires one."
  spec.description = "Write a longer description or delete this line."
  spec.homepage = "https://github.com"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com"
  spec.metadata["changelog_uri"] = "https://github.com"

  spec.extensions = Dir.glob("ext/**/extconf.rb")
  spec.platform = Gem::Platform::RUBY
  spec.files = Dir.glob("ext/**/*.{c,h}")

  # 根据平台选择要编译的文件
  # if RUBY_PLATFORM =~ /darwin/  # macOS
  #   spec.files = Dir.glob("ext/**/*.{c,h}").reject { |f| f =~ /linux/ }
  # elsif RUBY_PLATFORM =~ /linux/  # Linux
  #   spec.files = Dir.glob("ext/**/*.{c,h}").reject { |f| f =~ /darwin/ }
  # else  # 其他平台
  #   spec.files = Dir.glob("ext/**/*.{c,h}")
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "ffi"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
