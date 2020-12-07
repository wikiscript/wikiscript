module Wikiscript

##########
### more helpers:
##   - add some infobox helpers to parser
class Parser
  ####
  # convenience all-in-one parse helper
  def self.find_infobox( text )
    new( text ).find_infobox
  end


  ##########
  ## find (and return text of) first infobox in page source
  def find_infobox
    ## parse templates only e.g {{}}
    ##  until we find Infobox country or dependency!!!!

    text = sanitize( @text )   ## remove html comments, noinclude blocks, etc.

    input = StringScanner.new( text )

    infobox_text = nil   ## text of infobox

    i = 0
    loop do
      skip_whitespaces( input )
      break if input.eos?

      ## check for expected {{ template begin!!!!
      if input.check( TEMPLATE_BEGIN_RE )
        ## note: pos(itions) are BYTE positions (NOT characters!!!)
        ## note: track input pos for (original/verbatim) template source
        ##               (instead of regenerate from ast) - why? why not?
        pos_begin = input.pos
        node      = parse_template( input )
        pos_end   = input.pos

        puts "#{[i+1]} (#{pos_begin},#{pos_end}) >#{node.name}<"
        if node.name.downcase.start_with?( 'infobox' )
          puts "!! bingo - cut off at:"
          puts ">#{input.peek( 100 )}< ..."

          ## note: pos(itions) are BYTE positions (not charachters!!!)
          ## hack: change to BINARY encoding (ASCII-8BIT) and back to UTF-8
          text.force_encoding( Encoding::BINARY )
          infobox_text = text[pos_begin..pos_end]
          infobox_text.force_encoding( Encoding::UTF_8 ) ## change back to UTF-8
          text.force_encoding( Encoding::UTF_8 )
          break
        end
        i += 1
      else  ## syntax error
        puts " !! SYNTAX ERROR: expected template {{ - got unknown content type:"
        puts input.peek( 100 )
        exit 1
      end
    end  # loop

    infobox_text   ## note: return nil if no infobox found
  end # method find_infobox


end # class Parser
end # module Wikiscript