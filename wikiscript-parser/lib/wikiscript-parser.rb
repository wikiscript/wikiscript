## stdlibs
require 'strscan'


## 3rd party gems/libs
require 'wikitree'

# our own code
require 'wikiscript-parser/version' # let it always go first
require 'wikiscript-parser/parser'




####
# convenience all-in-one parse helper - add - why? why not?
module Wikiscript
  def self.parse( text )
     Parser.new( text ).parse
  end
end



puts Wikiscript::Module::Parser.banner