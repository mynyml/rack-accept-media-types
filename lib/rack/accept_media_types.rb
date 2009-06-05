module Rack

  # AcceptMediaTypes is intended for wrapping env['HTTP_ACCEPT'].
  #
  # It allows ordering of its values (accepted media types) according to their
  # "quality" (preference level).
  #
  # This wrapper is typically used to determine the request's prefered media
  # type (see example below).
  #
  # ===== Examples
  #
  #   env['HTTP_ACCEPT']  #=> 'text/html,application/xml;q=0.8,text/plain;0.9'
  #
  #   types = Rack::AcceptMediaTypes.new(env['HTTP_ACCEPT'])
  #   types               #=> ['text/html', 'text/plain', 'application/xml']
  #   types.prefered      #=>  'text/html'
  #
  # ===== Notes
  #
  # For simplicity, media type parameters are striped, as they are seldom used
  # in practice. Users who need them are excepted to parse the Accept header
  # manually.
  #
  # ===== References
  #
  # HTTP 1.1 Specs:
  # * http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
  # * http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.9
  #
  class AcceptMediaTypes < Array

    def initialize(header)
      replace(order(header.split(',')))
    end

    # The client's prefered media type.
    def prefered
      first
    end

    private

    # Order media types by quality values, remove invalid types, and return media ranges.
    #
    def order(types) #:nodoc:
      types.map {|type| AcceptMediaType.new(type) }.reverse.sort.reverse.select {|type| type.valid? }.map {|type| type.range }
    end

    # http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    #
    class AcceptMediaType #:nodoc:
      include Comparable

      # media-range = ( "*/*"
      #               | ( type "/" "*" )
      #               | ( type "/" subtype )
      #               ) *( ";" parameter )
      attr_accessor :range

      # qvalue = ( "0" [ "." 0*3DIGIT ] )
      #        | ( "1" [ "." 0*3("0") ] )
      attr_accessor :quality

      def initialize(type)
        self.range, *params = type.split(';')
        self.quality = extract_quality(params)
      end

      def <=>(type)
        self.quality <=> type.quality
      end

      # "A weight is normalized to a real number in the range 0 through 1,
      # where 0 is the minimum and 1 the maximum value. If a parameter has a
      # quality value of 0, then content with this parameter is `not
      # acceptable' for the client."
      #
      def valid?
        self.quality.between?(0.1, 1)
      end

      private
        # Extract value from 'q=FLOAT' parameter if present, otherwise assume 1
        #
        # "The default value is q=1."
        #
        def extract_quality(params)
          q = params.detect {|p| p.match(/q=\d\.?\d{0,3}/) }
          q ? q.split('=').last.to_f : 1.0
        end
    end
  end
end