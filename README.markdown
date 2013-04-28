# Interactive Couchbase

This small library provides simple command line interface to Couchbase
Cluster.

## Installation

Make sure you are using once of the [recent rubies (1.9+)][1]. Then
use rubygems to install the package (you should have libcouchbase
installed, see [notes in couchbase gem repository][2]:

    $ gem install icouchbase

## Usage

The tool is supposed to be intuitive:

    $ icouchbase -?
    $ icouchbase
    couchbase> set foo bar
    17355237111359471616
    couchbase> get foo
    bar

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]: http://www.ruby-lang.org/en/downloads/
[2]: https://github.com/couchbase/couchbase-ruby-client#install
