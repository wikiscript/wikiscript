
module Wikiscript
module Module
module Tree
  VERSION = '0.0.1'

   def self.banner
     "wikitree/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
   end

   def self.root
     File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
   end

end # module Tree
end # module Module
end # module Wikiscript
