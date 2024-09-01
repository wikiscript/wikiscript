
# templates in use:
# https://en.wikipedia.org/wiki/Template:Fbaicon
#  ...

module TemplateHelper
  ### add "built-in" template functions

  ## {{small | Note: Although Belgium is located in Western European Time / UTC (Z) zone, since 25 February 1940, upon WW2 German occupation , Central European Time / UTC+01:00 was enforced as standard time, with a +0:42:30 offset (and +1:42:30 during DST ) from Brussels LMT (UTC+0:17:30).}}
  def _small( txt )
    " #{txt} "
  end

  def _fbaicon( txt )  # football association (aka country) icon
    " (#{txt}) "
  end

  ###
  ##  see https://en.wikipedia.org/wiki/Template:Start_date
  def _start_date( year, month, day, **kwargs )
    ## note - ignore df=y for now
    " #{year}-#{month}-#{day} "
  end
end



module Wikitree
  class Template
    include TemplateHelper
  end # class Template
end # module Wikitree



module Wikiscript

    ##  todo/fix: move helpers to wikiscript gem (out of parser!!!)
    class Footballbox
   #    include SanitizeHelper    # pulls in sanitize( text ) helper

      def initialize( node )
        @node = node
      end

      def to_json   ## note: returns a data hash (NOT a serialized string)
        box = @node
        puts "#{box.name} - #{box.params.size} param(s):"

        data = {}
        ## note: add name of template as first virtual/auto para!!!!
        ##  might be Infobox country/dependency/settlement etc.
        data['template'] = box.name.downcase

        box.params.each_with_index do |param,i|

           if ['team1', 'team2',
               'goals1', 'goals2'].include?( param.name )
              ## use long (wiki page) name for teams and
              ##              players
              Wikitree.alt_text = false
              puts "[debug] change alt_text to false"
              pp Wikitree.alt_text?
              pp param
           end

          puts "  [#{i+1}] #{param.name}:"
          puts "text: #{param.to_text}"
          puts "source: #{param.to_wiki}"
          puts

          data[ param.name ] = {
              'text'   => param.to_text,  ##sanitize( param.to_text )
              'source' => param.to_wiki }
          Wikitree.alt_text = true ## always switch back
        end

=begin
        ## data filter - remove empty items
        data = data.reduce({}) do |h,(name,value)|
                                    if value.empty?
                                      puts "  skipping/removing >#{name}< - empty"
                                    else
                                      h[name] = value
                                    end
                                    h
                                end
=end
        data
      end
  end # class Footballbox

end  ## module Wikiscript
