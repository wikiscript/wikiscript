module Wikiscript


class Parser
  ####
  # convenience all-in-one parse helper
  def self.parse( text )
    new( text ).parse
  end


  def initialize( text )
    @text = text
  end

  def parse
    parse_lines( @text )
  end




  def skip_whitespaces( input )  ## incl. multiple newlines
    return 0   if input.eos?

    input.scan( /[ \t\r\n]*/ )
  end

  def skip_comments( input )
    return 0   if input.eos?

    while input.scan( /<!--/ ) do
      comment = input.scan_until( /.+?(?=-->)/ ) ## note: use possitive lookahead
      puts "  skip comment >#{comment.strip}<"
      input.scan( /-->/ )
      skip_whitespaces( input )
    end
  end


  #
  # Whereas MediaWiki variable names are all uppercase,
  # template names have the same basic features and limitations as all page names:
  # they are case-sensitive (except for the first character);
  # underscores are parsed as spaces;
  # and they cannot contain any of these characters: # < > [ ] | { }.
  # This is because those are reserved for wiki markup and HTML.

  TEMPLATE_BEGIN_RE = /\{\{/  ## e.g  {{
  TEMPLATE_END_RE   = /\}\}/  ## e.g. }}

  ## todo/fix: check how to add # too!!!
  ##  todo: check what chars to escape in character class
  ##  change to something line [^|<>\[\]{}]+ ]
  TEMPLATE_NAME_RE = %r{[a-z0-9!/\\()*:#," _-]+}i


  ## note: is an allowed template too!!
  ##  - {{Canadian monarch, current|nameonly=~}}
  ##  - {{!}}                            - see in Bulgaria infobox
  ##  - {{\}}                            - see in Republic of Ireland infobox
  ##  - {{-"}}                           - see in Bonaire infobox
  ##
  ##  - {{#expr:9769526/93030 round 0}}  - see in Hungary infobox
  ##  - {{#expr:(37583962/63182178)*100 round 1}} - see in United Kingdom infobox
  ##
  ##  for #expr, see https://www.mediawiki.org/wiki/Help:Extension:ParserFunctions


  def parse_template( input )
    input.scan( TEMPLATE_BEGIN_RE ) ## e.g.{{
    skip_whitespaces( input )

    name = input.scan( TEMPLATE_NAME_RE )
    name = name.strip  ## strip trailing spaces?
    puts "==> (begin) template >#{name}<"
    skip_whitespaces( input )

    params = []
    loop do
       skip_comments( input )  if input.check( /<!--/ )  ## note: eat-up inline comments for now

       if input.check( TEMPLATE_END_RE ) ## e.g. }}
         input.scan( TEMPLATE_END_RE )
         puts "<== (end) template >#{name}<"
         ## puts "  params:"
         ## pp params
         return Wikitree::Template.new( name, params )
       elsif input.check( /\|/ )  ## e.g. |
         puts "      param #{params.size+1} (#{name}):"
         param_name, param_value = parse_param( input )
         params << [param_name, param_value]
       else
         puts "!! SYNTAX ERROR: expected closing }} or para | in template:"
         puts input.peek( 100 )
         exit 1
       end
    end
  end



  def parse_param( input )
    input.scan( /\|/ )
    skip_whitespaces( input )
    skip_comments( input )  if input.check( /<!--/ )

    name  = nil
    value = []    # note: value is an array of ast nodes!!!

    ## check for named param e.g. hello=
    ##  otherwise assume content
    if input.check( /[a-z0-9 _-]+(?==)/i )  ## note: use positive lookhead (=)
      name = input.scan( /[a-z0-9 _-]+/i )
      name = name.strip  ## strip trailing spaces?
      puts "        param name >#{name}<"
      input.scan( /=/ )
      skip_whitespaces( input )
      skip_comments( input )  if input.check( /<!--/ )

      if input.check( /\|/ ) ||
         input.check( /\}/ )  ## add/allow }} too? - why? why not?
        ## allow empty value!!!
        puts "!! WARN: empty value for param >#{name}<"
      else
        value = parse_param_value( input )  ## get keyed param value
        puts "        param value >#{value}<"
      end
    else
      if input.check( /\|/ ) ||   ## add/allow }} too? - why? why not?
         input.check( /\}/ )
        ## allow empty value here too - why? why not?
        puts "!! WARN: empty value for (unnamed/positioned) param"
      else
        value = parse_param_value( input )  ## get (unnamed) param value
        puts "        param value >#{value}<"
      end
    end
    [name, value]
  end


  def parse_param_value( input ) ## todo: change to parse_param_value_nodes or such - why? why not??
    # puts "     [debug] parse_param_value >#{input.peek(10)}...<"

    values = []  ## todo - change/rename to nodes??
    loop do
      values << parse_node( input )
      skip_whitespaces( input )
      skip_comments( input )  if input.check( /<!--/ )


      ## puts "      [debug] peek >#{input.peek(10)}...<"
      if input.check( /\|/ ) || input.check( /\}\}/ )
        ## puts "        [debug] break param_value"
        break
      end

      if input.eos?
        puts "!! SYNTAX ERROR: unexpected end of string in param value; expected ending w/ | or }}"
        exit 1
      end
    end

    values
  end

  def parse_weblink( input )
    ## [https://ec.europa.eu/commfrontoffice/publicopinion/index.cfm/Survey/getSurveyDetail/instruments/SPECIAL/surveyKy/2251 Special Eurobarometer 493, European Union: European Commission, September 2019, pages 229-230]
    input.scan( /\[/ )  ## eatup opening [

    href = input.scan( /[^ \]]+/ ).strip ## note: breaks on SPACE or ]
    skip_whitespaces( input )

    alt_text = if input.check( /\]/ )
                    nil
               else  ## note: has move optional alternate/display text
                   input.scan( /[^\]]+/ ).strip
               end

    input.scan( /\]/ )  ## eatup closing ]
    skip_whitespaces( input )

    Wikitree::Weblink.new( href, alt_text )
  end


  def parse_pagelink( input )    ## todo/fix: change to parse_page/parse_link - why? why not?
    input.scan( /\[\[/ )

    ## page name
    name     = input.scan( /[^|\]]+/ ).strip

    alt_text = if input.check( /\|/ )  ## optional alternate/display text
                  input.scan( /\|/ )  ## eat up |
                  input.scan( /[^\]]+/ ).strip
               else
                  nil
               end

    input.scan( /\]\]/ )  ## eatup ]]
    skip_whitespaces( input )

    if alt_text
      puts " @page<#{name} | #{alt_text}>"
    else
      puts " @page<#{name}>"
    end

    Wikitree::Page.new( name, alt_text )
  end






  def parse_text( input )
    run = String.new('')

    loop do
      skip_comments( input )  if input.check( /<!--/ )

      if input.check( /[^|{}\[\]<>]+/ )    ## check for rawtext run for now
         run << input.scan( /[^|{}\[\]<>]+/ )
         # puts "   text run=>#{run}<"
      elsif input.check( /[|]/)    ||
            input.check( /\[\[/ )  ||  # note: must be doubled up
            input.check( /\]\]/ )  ||
            input.check( /\{\{/ )  ||
            input.check( /\}\}/ )  ||
            input.check( /\[(?=https?:)/ ) ||  ## note: use POSITIVE lookahead
            input.check( %r{<ref[^>]*/>}i ) ||  ## e.g. <ref group="N" name="denonly group=N" />
            input.check( %r{<ref[^>]*>}i ) ||   ## e.g. <ref name="UNHDR">
            input.check( %r{</ref>}i ) ||
            input.eos?
         break
      elsif input.check( /\[(?!https?:)/ )  ## note: use NEGATIVE lookahead
        run << input.scan( /\[/ )  ## eat "plain /verbatim" opening bracket
                                   ## e.g. allows [1], [a], etc. or such
      elsif input.check( /\]/ )
        run << input.scan( /\]/ )  ## eat "plain /verbatim" closing bracket
      elsif input.check( /\{/ )
        run << input.scan( /\{/ )  ## e.g. allows {1} or such
      elsif input.check( /\}/ )
        run << input.scan( /\}/ )
      elsif input.check( /</ )   ## note: eat-up html tags too (unless specified otherwise!!!)
        run << input.scan( /</ )
      elsif input.check( />/ )
        run << input.scan( />/ )
      else
        puts " !! SYNTAX ERROR: unknown content type (in text run >#{run}<):"
        puts input.peek( 100 )
        exit 1
      end
    end

    Wikitree::Text.new( run.strip )
 end



  def parse_ref( input )
    puts "--> parse_ref:"
    puts input.peek( 100 )

    ## todo/fix: parse ref attributes too!!! name, group, ???
    if input.check( %r{<ref[^>]*/>}i )  ## e.g. <ref group="N" name="denonly group=N" />
      input.scan(  %r{<ref[^>]*/>}i )
      skip_whitespaces( input )   ## todo/fix: remove skip_whitespace here? really needed?
      return Wikitree::Ref.new
    elsif input.check( %r{<ref[^>]*>}i )  ## e.g. <ref name="UNHDR">
      input.scan( %r{<ref[^>]*>}i )
      puts "==> (begin) ref"

      skip_whitespaces( input )
      nodes = []
      loop do
         skip_comments( input )  if input.check( /<!--/ )  ## note: eat-up inline comments for now

         if input.check( %r{</ref>}i )
           input.scan( %r{</ref>}i )
           puts "<== (end) ref"
           # puts "  nodes:"
           # pp nodes
           return Wikitree::Ref.new( nodes )
         else
           # puts " add node to ref:"
           nodes << parse_node( input )
         end
       end
    else
      puts " !! SYNTAX ERROR: unknown ref syntax:"
      puts input.peek( 100 )
      exit 1
    end
  end


  def parse_node( input )
    ## puts "  [debug] parse >#{input.peek(10)}...<"
    if input.check( TEMPLATE_BEGIN_RE )
      parse_template( input )
    elsif input.check( /\[\[/ )
      parse_pagelink( input )
    ## note:  [http:// or https:// ...] - other [] cases get handled like text!!!
    elsif input.check( /\[(?=https?:)/ )  ## fix: add positive lookahead for http(s)://
      parse_weblink( input )
    elsif input.check( %r{<ref[^>]*/>}i ) ||  ## e.g. <ref group="N" name="denonly group=N" />
          input.check( %r{<ref[^>]*>}i )      ## e.g. <ref name="UNHDR">
      parse_ref( input )
    else
      parse_text( input )
    end
  end



  ####
  ## e.g.
  ##   <!--increase/decrease/steady-->
  COMMENT_RE = %r{<!--
                   .+?     ## note: use .+? (non-greedy match)
                   -->}xm

  ######
  ## e.g.
  ##   <noinclude>{{pp-vandalism|small=yes}}</noinclude>
  NOINCLUDE_RE = %r{<noinclude>
                     .+?     ## note: use .+? (non-greedy match)
                    </noinclude>}xmi

  def sanitize( text )  ## todo/check: rename to cleanup or such - why? why not?
    ## note: remove all html comments for now - why? why not?
    ## <!-- Area rank should match .. -->

    # text = text.gsub( COMMENT_RE ) do |m|
    #  # puts " removing comment >#{m}<"
    #  ''
    # end

    ## <noinclude>..</noinclude>
    text = text.gsub( NOINCLUDE_RE ) do |m|
      puts "  removing noinclude block >#{m}<"
      ''
    end

    text
  end



  def parse_lines( text )
    text = sanitize( text )  ## remove html comments, noinclude blocks, etc.

    input = StringScanner.new( text )

    nodes = []
    loop do
      skip_whitespaces( input )
      ## note: skip comments for now (that is, do NOT create a ast node for it
      #            BUT do NOT delete text from input string - lets you use pos_begin, pos_end etc.)
      skip_comments( input )  if input.check( /<!--/ )
      break if input.eos?

      nodes << parse_node( input )
   end
   nodes
  end

end # class Parser
end # module Wikiscript