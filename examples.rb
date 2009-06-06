require 'pathname'
require 'rubygems'
require 'rack'
require 'simple_example' # gem install mynyml-simple_example

root = Pathname(__FILE__).dirname.expand_path
require root + 'lib/rack/accept_media_types'

include SimpleExample
puts SimpleExample::Format.separator = '-'*10


# simple
env = {'HTTP_ACCEPT' => 'text/html,text/plain'}
example do
  types = Rack::AcceptMediaTypes.new(env['HTTP_ACCEPT'])
  #=> ["text/html", "text/plain"]
  types.prefered
  #=> "text/html"
end

# with quality values
env = {'HTTP_ACCEPT' => 'text/html;q=0.5,text/plain;q=0.9'}
example do
  types = Rack::AcceptMediaTypes.new(env['HTTP_ACCEPT'])
  #=> ["text/plain", "text/html"]
  types.prefered
  #=> "text/plain"
end

# rejects types with invalid quality values
env = {'HTTP_ACCEPT' => 'text/html;q=0,text/plain;q=1.1,application/xml'}
example do
  types = Rack::AcceptMediaTypes.new(env['HTTP_ACCEPT'])
  #=> ["application/xml"]
  types.prefered
  #=> "application/xml"
end
