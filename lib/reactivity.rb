require 'sprockets/es6'

require "reactivity/channel"
require "reactivity/hooks"
require "reactivity/rails"
require "reactivity/subscription"
require "reactivity/version"

module Reactivity

  # Exceptions streamed to client
  mattr_accessor :stream_exceptions
  @@stream_exceptions = false

  # Logger
  mattr_accessor :logger
  @@logger = Logger.new('/dev/null')

end
