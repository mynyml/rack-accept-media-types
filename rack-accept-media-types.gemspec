Gem::Specification.new do |s|
  s.name                = 'rack-accept-media-types'
  s.version             = "0.6"
  s.summary             = "Rack middleware for simplified handling of Accept header"
  s.description         = "Rack middleware for simplified handling of Accept header. Accept header parser."
  s.author              = "mynyml"
  s.email               = "mynyml@gmail.com"
  s.homepage            = "http://github.com/mynyml/rack-accept-media-types"
  s.rubyforge_project   = "rack-accept-media-types"
  s.has_rdoc            =  false
  s.require_path        = "lib"
  s.files               =  File.read("Manifest").strip.split("\n")

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rack'
end
