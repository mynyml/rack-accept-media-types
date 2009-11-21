require 'pathname'
require 'minitest/autorun'
require 'rack'
begin
  require 'phocus'
  require 'redgreen' #http://gemcutter.org/gems/mynyml-redgreen
  require 'ruby-debug'
rescue LoadError, RuntimeError
end

root = Pathname(__FILE__).dirname.parent.expand_path
$:.unshift(root.join('lib'))

require 'rack/accept_media_types'

class MiniTest::Unit::TestCase
  def self.test(name, &block)
    name = :"test_#{name.gsub(/\s/,'_')}"
    define_method(name, &block)
  end
end

