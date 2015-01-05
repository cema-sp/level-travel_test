module SpecHelpers
  def yaml_fixture(name)
    YAML.load(File.read(Rails.root.join('spec', 'fixtures', name.to_s + '.yml')))
  end

  def stub_typhoeus_request(request, response)
    stub_request(request.options[:method], request.base_url)
      .with(
        headers: request.options[:headers],
        query: request.options[:params])
      .to_return(
        status: response.code,
        body: response.body)
  end
end

# Configure usage with RSpec
if RSpec.respond_to?(:configure)
  RSpec.configure do |config|
    config.include SpecHelpers
  end
end
# Configure usage with Cucumber
World(SpecHelpers) if respond_to?(:World)
