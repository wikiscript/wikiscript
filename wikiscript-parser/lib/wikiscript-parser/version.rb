
module Wikiscript
module Module
module Parser
  VERSION = '0.0.1'

   def self.banner
     "wikiscript-parser/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
   end

   def self.root
     File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
   end

end # module Parser
end # module Module
end # module Wikiscript
