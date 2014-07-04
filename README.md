# wikiscript - scripts for wikipedia (get wikitext for page etc.)

* home  :: [github.com/wikiscript/wikiscript.ruby](https://github.com/wikiscript/wikiscript.ruby)
* bugs  :: [github.com/wikiscript/wikiscript.ruby/issues](https://github.com/wikiscript/wikiscript.ruby/issues)
* gem   :: [rubygems.org/gems/wikiscript](https://rubygems.org/gems/wikiscript)
* rdoc  :: [rubydoc.info/gems/wikiscript](http://rubydoc.info/gems/wikiscript)


## Usage

Read-only access to wikikpedia pages.
Example - Get wikitext source (via `en.wikipedia.org/w/index.php?action=raw&title=<title>`):


    >> page = Wikiscript::Page.new( '2014_FIFA_World_Cup_squads' )
    >> page.text
    
    The [[2014 FIFA World Cup]] is an international [[association football|football]]
    tournament which is currently being held in Brazil from 12 June to 13 July 2014.
    The 32 national teams involved in the tournament were required to register
    a squad of 23 players, including three goalkeepers...


## Install

Just install the gem:

    $ gem install wikiscript


## Alternatives

TBD


## License

The `wikiscript` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
