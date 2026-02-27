module SasTestKit
  class UrlGroup < Inferno::TestGroup
    title 'Test URL'
    description 'Verification syntaxe endpoint FHIR'
    id :url_group
    test do
      title 'Test format URL'
      description %(
         Test format URL
      )
      run do
        assert(base_url.start_with?('https'), 'Le serveur doit supporter https')
      end
    end
  end
end
