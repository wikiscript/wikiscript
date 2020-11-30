require 'pp'
require 'json'


# our own code
require 'wikitree/version' # let it always go first
require 'wikitree/nodes'      # core/basic nodes
require 'wikitree/template'   # core/basic nodes



## add camelcase alias
WikiTree   = Wikitree
WikiScript = Wikiscript


puts Wikiscript::Module::Tree.banner
