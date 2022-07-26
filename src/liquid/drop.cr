require "./any"

module Liquid
  abstract class Drop
    macro inherited
      {% verbatim do %}
      macro finished
        def call(method : String) : Any
          case method
          {% for method in @type.methods %}
            {% if method.args.size == 0 && method.visibility == :public %}
              when {{ method.name.stringify }}
                ret = {{ method.name.id }}
                ret.is_a?(Any) ? ret : Any.new(ret)
            {% end %}
          {% end %}
          else
            super
          end
        end
      end
      {% end %}
    end

    # Called by `StackMachine` to call a method from this `Drop`.
    # Only public methods without parameters can be called here
    def call(method : String) : Any
      raise Exception.new("Method #{method} not found for #{self.class.name}.")
    end
  end
end
