require 'hoe'
require './lib/wikiscript/version.rb'

Hoe.spec 'wikiscript' do

  self.version = Wikiscript::VERSION

  self.summary = 'wikiscript - scripts for wikipedia (get wikitext for page etc.)'
  self.description = summary

  self.urls = ['https://github.com/wikiscript/wikiscript.ruby']

  self.author = 'Gerald Bauer'
  self.email = 'opensport@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['logutils' ]
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 1.9.2'
  }

end
