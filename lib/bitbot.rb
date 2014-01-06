require_relative 'models'
require_relative 'utility'

module BitBot
  extend self

  def definitions
    @definitions ||= {}
  end

  def define(name, mod=nil, &block)
    definition_module = Module.new
    definition_module.send(:include, mod) unless mod.nil?
    definition_module.send(:include, Module.new(&block)) if block_given?
    adapters.delete(name.to_sym)
    definitions[name.to_sym] = definition_module
  end

  def adapters
    @adapters ||= {}
  end

  def [](name)
    adapters[name.to_sym] ||= get_adapter_instance(name)
  end

  private
  def get_adapter_instance(name)
    Class.new do
      #attr_reader :client, :options

      def initialize(options = {})
        @key = ENV["#{name}_key"]
        @secret = ENV["#{name}_secret"]
        @options = options
      end

      include BitBot.definitions[name.to_sym]

      def eql?(other)
        self.class.eql?(other.class) && client == other.client
      end
      alias == eql?

      ### Avoid to output key and secret to log files uncarefully
      def to_s
        "[BitBot:#{name}]"
      end
      def inspect
        to_s
      end

      class_eval "def name; :#{name} end"

      include BitBot::Utility
    end
  end
end
