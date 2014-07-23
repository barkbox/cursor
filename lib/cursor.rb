module Cursor
end

# load Rails/Railtie
begin
  require 'rails'
rescue LoadError
  #do nothing
end

$stderr.puts <<-EOC if !defined?(Rails)
warning: no framework detected.

Your Gemfile might not be configured properly.
---- e.g. ----
Rails:
    gem 'cursor'

Sinatra/Padrino:
    gem 'cursor', :require => 'cursor/sinatra'

Grape:
    gem 'cursor', :require => 'cursor/grape'

EOC

# load Cursor components
require 'cursor/config'
require 'cursor/models/page_scope_methods'
require 'cursor/models/configuration_methods'
require 'cursor/hooks'

# if not using Railtie, call `Cursor::Hooks.init` directly
if defined? Rails
  require 'cursor/railtie'
  require 'cursor/engine'
end
