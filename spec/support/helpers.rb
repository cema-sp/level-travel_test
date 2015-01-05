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
