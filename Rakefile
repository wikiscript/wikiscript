require 'hoe'
require './lib/wikiscript/version.rb'

Hoe.spec 'wikiscript' do

  self.version = Wikiscript::VERSION

  self.summary = "wikiscript - scripts for wikipedia (get wikitext for page, parse tables 'n' links, etc.)"
  self.description = summary

  self.urls = ['https://github.com/wikiscript/wikiscript']

  self.author = 'Gerald Bauer'
  self.email = 'opensport@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'CHANGELOG.md'

  self.extra_deps = [
    ['logutils' ],
    ['fetcher']
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 2.2.2'
  }
end
