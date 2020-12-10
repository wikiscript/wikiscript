module Wikiscript
 ##  todo/fix: move helpers to wikiscript gem (out of parser!!!)
module SanitizeHelper

  def sanitize( txt )
    puts "  [debug] sanitize"

    ## <div style=\"display:inline-block;margin-top:0.4em;\"> center </div>
    txt = txt.gsub( /<div[^\/>]*>
                 ([^\<]*)
               <\/div>/xim ) do |m|
            puts "  remove div container: #{m}"
            $1  # remove enclosing div; keep content!!
          end
    ## <sup>2</sup>
    txt = txt.gsub( /<sup>
                       ([^\<]*)
                     <\/sup/xim ) do |m|
                        $1  # remove sup; keep content!!
                     end

    ## replace br(reaks) with ++ (NOT space) for now - why? why not?
    ##  <br/>
    txt = txt.gsub(  /<br[ ]*\/>/i ) do |_|
               ' ++ '
          end

    ## remove emphasis/bold
    txt = txt.gsub( /'{2,}/, '' )

    ## squish
    ##  add non-breaking space too (if ever present) ??
    txt = txt.gsub( /[ \t\n\r]{2,}/, ' ' )
    txt.strip
  end

end # module SanitizeHelper
end # module Wikiscript