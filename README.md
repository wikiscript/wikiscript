# wikiscript - scripts for wikipedia (get wikitext for page etc.)

* home  :: [github.com/wikiscript/wikiscript](https://github.com/wikiscript/wikiscript)
* bugs  :: [github.com/wikiscript/wikiscript/issues](https://github.com/wikiscript/wikiscript/issues)
* gem   :: [rubygems.org/gems/wikiscript](https://rubygems.org/gems/wikiscript)
* rdoc  :: [rubydoc.info/gems/wikiscript](http://rubydoc.info/gems/wikiscript)


## Usage

Read-only access to wikikpedia pages.
Example - Get wikitext source (via `en.wikipedia.org/w/index.php?action=raw&title=<title>`):


``` ruby
page = Wikiscript::Page.get( '2014_FIFA_World_Cup_squads' )  # same as Wikiscript.get
page.text
```

prints

```
The [[2014 FIFA World Cup]] is an international [[association football|football]]
tournament which is currently being held in Brazil from 12 June to 13 July 2014.
The 32 national teams involved in the tournament were required to register
a squad of 23 players, including three goalkeepers...
```

Or build your own page from scratch (no download):

``` ruby
page = Wikiscript::Page.new( <<TXT, title: '2014_FIFA_World_Cup_squads' )
The [[2014 FIFA World Cup]] is an international [[association football|football]]
tournament which is currently being held in Brazil from 12 June to 13 July 2014.
The 32 national teams involved in the tournament were required to register
a squad of 23 players, including three goalkeepers...
TXT
page.text
```

prints

```
The [[2014 FIFA World Cup]] is an international [[association football|football]]
tournament which is currently being held in Brazil from 12 June to 13 July 2014.
The 32 national teams involved in the tournament were required to register
a squad of 23 players, including three goalkeepers...
```



## Install

Just install the gem:

    $ gem install wikiscript


## License

The `wikiscript` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
