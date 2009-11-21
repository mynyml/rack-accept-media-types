require 'test/test_helper'

Accept = Rack::AcceptMediaTypes

class AcceptMediaTypesTest < MiniTest::Unit::TestCase

  test "media type list" do
    header = 'text/html,text/plain'
    assert_equal %w( text/html text/plain ).to_set, Accept.new(header).to_set
  end

  test "ordered by quality value (highest first)" do
    header = 'text/html;q=0.5,text/plain;q=0.9'
    assert_equal %w( text/plain text/html ), Accept.new(header)
  end

  test "default quality value is 1" do
    header = 'text/plain;q=0.1,text/html'
    assert_equal %w( text/html text/plain ), Accept.new(header)
  end

  test "equal quality types keep original order" do
    header = 'text/html,text/plain;q=0.9,application/xml'
    assert_equal %w( text/html application/xml text/plain ), Accept.new(header)
  end

  test "prefered type" do
    header = 'text/html;q=0.2,text/plain;q=0.5'
    assert_equal 'text/plain', Accept.new(header).prefered
  end

  test "types with out of range quality values are ignored" do
    header = 'text/html,text/plain;q=1.1'
    assert_equal %w( text/html ), Accept.new(header)

    header = 'text/html,text/plain;q=0'
    assert_equal %w( text/html ), Accept.new(header)
  end

  test "custom media types are NOT ignored" do
    # verifying that the media types exist in Rack::Mime::MIME_TYPES is
    # explicitly outside the scope of this library.
    header = 'application/x-custom'
    assert_equal %w( application/x-custom ), Accept.new(header)
  end

  test "media-range parameters are discarted" do
    header = 'text/html;version=5;q=0.5,text/plain'
    assert_equal %w( text/plain text/html ), Accept.new(header)
  end

  test "accept-extension parameters are discarted" do
    header = 'text/html;q=0.5;token=value,text/plain'
    assert_equal %w( text/plain text/html ), Accept.new(header)
  end

  test "nil accept header" do
    header = nil
    assert_equal %w( */* ), Accept.new(header)
  end

  test "empty accept header" do
    header = ''
    assert_equal [], Accept.new(header)
  end

  test "all accepted types are invalid" do
    header = 'text/html;q=2,application/xml;q=0'
    assert_equal [], Accept.new(header)
  end
end

__END__
http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
14.1 Accept

  Accept         = "Accept" ":"
                  #( media-range [ accept-params ] )

  media-range    = ( "*/*"
                  | ( type "/" "*" )
                  | ( type "/" subtype )
                  ) *( ";" parameter )
  accept-params  = ";" "q" "=" qvalue *( accept-extension )
  accept-extension = ";" token [ "=" ( token | quoted-string ) ]

http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.9
3.9 Quality Values

  qvalue = ( "0" [ "." 0*3DIGIT ] )
         | ( "1" [ "." 0*3("0") ] )
