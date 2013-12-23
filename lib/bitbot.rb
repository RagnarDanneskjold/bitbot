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
      attr_reader :client, :options

      def initialize(client, options={})
        @client = client
        @options = options
      end

      include BitBot.definitions[name.to_sym]

      def eql?(other)
        self.class.eql?(other.class) && client == other.client
      end
      alias == eql?

      class_eval "def name; :#{name} end"
    end
  end
end
