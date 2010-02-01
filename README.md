Summary
-------

Rack convenience middleware to simplify handling of Accept header
`env['HTTP_ACCEPT']`. Allows ordering of its values (accepted media types)
according to their "quality" (preference level).

This wrapper is typically used to determine the request's prefered media type.

Install
-------

    gem install rack-accept-media-types

Example
-------

    require 'rack/accept_media_types'

    env['HTTP_ACCEPT'] #=> 'application/xml;q=0.8,text/html,text/plain;q=0.9'

    req = Rack::Request.new(env)
    req.accept_media_types          #=> ['text/html', 'text/plain', 'application/xml']
    req.accept_media_types.prefered #=>  'text/html'

Links
-----

* code: <http://github.com/mynyml/rack-accept-media-types>
* docs: <http://docs.github.com/mynyml/rack-accept-media-types>
* wiki: <http://wiki.github.com/mynyml/rack-accept-media-types>
* bugs: <http://github.com/mynyml/rack-accept-media-types/issues>
