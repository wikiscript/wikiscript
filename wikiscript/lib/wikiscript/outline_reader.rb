
module Wikiscript

class OutlineReader

  def self.read( path )
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    new( txt ).parse
  end

  def initialize( txt )
    @txt = txt
  end


 HEADING_RE = %r{\A
                  (?<marker>={1,})       ## 1. leading ======
                    [ ]*
                  (?<text>[^=]+?)        ## 2. text  (note: for now no "inline" = allowed)
                    [ ]*
                    =*                   ## 3. (optional) trailing ====
                  \z}x

  def parse
    outline = []   ## outline / page structure

    start_para = true      ## start new para(graph) on new text line?

    @txt.each_line do |line|

##
##  (auto-)sanitize first
##    -  &nbsp;   =>  "vanilla" space
##    -  1–2      => 1-2  - "vanilla" dash
##    todo - move up into txt!!!
        line = line.gsub( '&nbsp;', ' ' )
        line = line.gsub( /[–]/, '-' )


        line = line.strip      ## todo/fix: keep leading and trailing spaces - why? why not?

        if line.empty?    ## todo/fix: keep blank line nodes?? and just remove comments and process headings?! - why? why not?
          start_para = true
          next
        end

        break if line == '__END__'

        next if line.start_with?( '#' )   ## skip comments too
        ## strip inline (until end-of-line) comments too
        ##  e.g Eupen | KAS Eupen ## [de]
        ##   => Eupen | KAS Eupen
        ##  e.g bq   Bonaire,  BOE        # CONCACAF
        ##   => bq   Bonaire,  BOE
        line = line.sub( /#.*/, '' ).strip

         ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
        if m=HEADING_RE.match( line )
           start_para = true

           heading_marker = m[:marker]
           heading_level  = heading_marker.length   ## count number of = for heading level
           heading        = m[:text].strip

           outline << [:"h#{heading_level}", heading]
        elsif line == '----'   ## make more generic/flexible - why? why not?
            start_para = true
            outline << [:hr]
 ## The horizontal rule represents a paragraph-level thematic break. Do not use in article content,
 ##  as rules are used only after main sections, and this is automatic.
 ## HTML equivalent: <hr /> (which can be indented,
 ##  whereas ---- always starts at the left margin.)
        else    ## assume it's a (plain/regular) text line
           if start_para
             outline << [:p, [line]]
             start_para = false
           else
             node = outline[-1]    ## get last entry
             if node[0] == :p      ##  assert it's a p(aragraph) node!!!
                node[1] << line    ## add line to p(aragraph)
             else
               puts "!! ERROR - invalid outline state / format - expected p(aragraph) node; got:"
               pp node
               exit 1
             end
           end
        end
    end
    outline
  end # method parse
end # class OutlineReader

end # module Wikiscript
