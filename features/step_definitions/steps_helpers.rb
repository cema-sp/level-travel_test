module StepsHelpers
  def set_param(key, value)
    @params = {} unless defined?(@params)
    @params[key.to_s.parameterize('_').to_sym] = value
  end
end

# Configure usage with Cucumber
World(StepsHelpers) if respond_to?(:World)
