lib = 'medium_sdk'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = $1

Gem::Specification.new do |s|
  s.name        = lib
  s.version     = version
  s.date        = '2016-08-09'
  s.summary     = 'Medium SDK - Ruby SDK for the Medium.com API'
  s.description = 'A Ruby SDK for the Medium.com API with OAuth 2 support'
  s.authors     = ['John Wang']
  s.email       = 'johncwang@gmail.com'
  s.homepage    = 'https://github.com/grokify/'
  s.licenses    = ['MIT']
  s.files       = Dir['lib/**/**/*'] # + Dir['bin/*']
  s.files      += Dir['[A-Z]*']    + Dir['test/**/*']
  # s.files.reject! { |fn| fn.include? "CVS" }
  # s.required_ruby_version = '>= 1.8.7' # 1.8.7+ is tested
  s.add_runtime_dependency 'faraday', '~> 0.9', '>= 0.9'
  s.add_runtime_dependency 'faraday_middleware', '~> 0', '>= 0'
  s.add_runtime_dependency 'faraday_middleware-oauth2_refresh', '~> 0'
  s.add_runtime_dependency 'multi_json', '~> 1.3'
  s.add_runtime_dependency 'oauth2', '~> 1.0', '>= 1.0.0'

  s.add_development_dependency 'coveralls', '~> 0'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'test-unit', '>= 0'
end
