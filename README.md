## RailsLite

A simple web application framework modeled on Ruby on Rails. Supplies a ControllerBase class for controllers to inherit generic methods from, parses URL params, and can store session data in a WEBrick::Cookie. The core code is in the lib/rails_lite directory.

### Features

* A ControllerBase class to store methods for Controllers to inherit.
* Template rendering with ERB.
* Session-storing cookie functionality.
* URL, query string, and request body param parsing.
* HTTP request routing.

### Tests
The tests directory contains simple server tests to demo functionality. Run them and navigate to localhost:3000 in your browser to try them out.

1. Starts a basic WEBrick server that will render the request path on the webpage; for example, navigating to localhost:3000/test/1/2/3/ will render “/test/1/2/3”.
2. Demos redirect capabilities; will always redirect to /foobar no matter what path is requested.
3. Demos ERB functionality by rendering some evaluated ruby code.
4. Increments a counter on refresh, demonstrating session management via the WEBrick::Cookie.
5. Demos basic params management. Navigate to localhost:3000/cats to make a GET request for all of the cats, and then click the link to make a GET request for the /cats/new path, providing a form which upon completion will make a POST request to the /cats path.
6. Demos routing capability. Navigate to the /cats path to see all of the cats, then navigate to the /cats/2/statuses path to see the statuses of the cat with id 2.
