require 'pp'
require 'json'


# our own code
require 'wikitree/version' # let it always go first
require 'wikitree/nodes'      # core/basic nodes
require 'wikitree/page'
require 'wikitree/link'
require 'wikitree/param'
require 'wikitree/template'
require 'wikitree/file'
require 'wikitree/ref'


## add camelcase alias
WikiTree   = Wikitree
WikiScript = Wikiscript


puts Wikiscript::Module::Tree.banner
