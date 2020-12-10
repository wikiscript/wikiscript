module Wikiscript

  ##  todo/fix: move helpers to wikiscript gem (out of parser!!!)
  class Infobox
     include SanitizeHelper    # pulls in sanitize( text ) helper

    def initialize( node )
      @node = node
    end

    def to_json   ## note: returns a data hash (NOT a serialized string)
      infobox = @node
      puts "#{infobox.name} - #{infobox.params.size} param(s):"

      data = {}
      ## note: add name of template as first virtual/auto para!!!!
      ##  might be Infobox country/dependency/settlement etc.
      data['template'] = infobox.name.downcase


      infobox.params.each_with_index do |param,i|
        puts "  [#{i+1}] #{param.name}:"
        puts "text: #{param.to_text}"
        puts "source: #{param.to_wiki}"
        puts

        data[ param.name ] = sanitize( param.to_text )
      end

      ## data filter - remove empty items
      data = data.reduce({}) do |h,(name,value)|
                                  if value.empty?
                                    puts "  skipping/removing >#{name}< - empty"
                                  else
                                    h[name] = value
                                  end
                                  h
                              end
      data
    end
  end # class Infobox

end  ## module Wikiscript
