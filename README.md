# CrapiDocs

Crazy RSpec API Docs

## About

CrapiDocs generates API documentation automagically using. It requires _zero_ annotations,
declarations or custom comments. Simply add the below code to your tests and the documentation will
appear before your eyes (don't forget to run your tests first).

## Usage

In `spec_helper.rb` (or somewhere else) add:

```ruby
require 'crapidocs'
CrapiDocs.start path_filter # See below note
```

<small>Note: `path_filter` is a regular expression which tells CrapiDocs which paths should be
included in the generated docs. Examples: `%r{/}`, `%r{/api/v1}`, etc.</small>

That's it! A `doc/api.md` file will be generated after your tests complete!

## Features

* Generates **pretty good quality** API documentation for `Rack::Test`-based tests
* Specify a custom URI path pattern to **capture only relevant endpoints**
* **Merges request parameters** from multiple tests to determine parameter options

## Example

![Example](http://i.imgur.com/X5spkte.jpg)

Check out the [examples](/example) directory for example output and working tests.

