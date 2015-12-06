In `spec_helper.rb` add:

```ruby
require 'crapidocs'
at_exit { CrapiDocs.done if CrapiDocs.on? }
```
