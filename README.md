# FitParser

[![Build Status](https://travis-ci.com/dimameshcharakou/fit_parser.svg?branch=master)](https://travis-ci.com/dimameshcharakou/fit_parser)

## Example usage

```ruby
require 'fit_parser'

fit_file = FitParser.load_file(ARGV[0])

records = fit_file.records.select{ |r| r.content.record_type != :definition }.map{ |r| r.content }
```
