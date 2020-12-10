## stdlibs
require 'strscan'


## 3rd party gems/libs
require 'wikitree'

# our own code
require 'wikiscript-parser/version' # let it always go first
require 'wikiscript-parser/parser'
require 'wikiscript-parser/infobox'


require 'wikiscript-parser/helpers/sanitize'
require 'wikiscript-parser/helpers/references'
require 'wikiscript-parser/helpers/infobox'



####
# convenience all-in-one parse helper - add - why? why not?
module Wikiscript
  def self.parse( text )        Parser.new( text ).parse; end
  def self.find_infobox( text ) Parser.new( text ).find_infobox; end
end


puts Wikiscript::Module::Parser.banner