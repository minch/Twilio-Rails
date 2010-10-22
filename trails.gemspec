Gem::Specification.new do |s|
  s.name        = "trails"
  s.version     = Bundler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Hemant Bhanoo", "Adam Weller"]
  s.email       = ["hbanoo@github.com"]
  s.homepage    = "http://github.com/hbhanoo/Twilio-Rails"
  s.summary     = "Code to make it super-clean to develop twilio apps on rails."
  s.description = "Code to make it super-clean to develop twilio apps on rails."
  s.required_rubygems_version = ">= 1.3.6"
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.require_path = 'lib'
end
