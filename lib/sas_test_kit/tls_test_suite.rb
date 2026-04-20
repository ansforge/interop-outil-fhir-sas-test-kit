require_relative 'tls_version_test'
require_relative 'mtls_group'
 

module MyTestKit
  class TLSTestSuite  < Inferno::TestGroup
    title 'Tests de Securité '
    id :tls

    group from: :mtls_group

    group do
      title 'Test TLS'

      test from: :tls_version_test,
           title: 'Le serveur ne doit prendre  en charge que les versions sécurisées de TLS',
           description: %(
            Ce test vérifie que le serveur prend en charge au moins une version de
            TLS supérieure ou égale à 1.2. Les versions de TLS inférieures à 1.2 ont
            été déclarées obsolètes dans la [RFC 8996](https://datatracker.ietf.org/doc/html/rfc8996).
          ),
           config: {
             options: {
               minimum_allowed_version: OpenSSL::SSL::TLS1_2_VERSION
             } 
           }
    end 


  end
end