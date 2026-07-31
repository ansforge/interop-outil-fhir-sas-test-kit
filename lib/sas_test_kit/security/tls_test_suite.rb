require_relative 'tls_version_test'
require_relative 'mtls_group'
 

module MyTestKit
  class TLSTestSuite  < Inferno::TestGroup
    title 'Tests de Securité '
    id :tls

    group from: :mtls_group

    group do
      title 'Version TLS sécurisée'

      test from: :tls_version_test,
           title: 'Le serveur ne doit prendre  en charge que les versions sécurisées de TLS',
           description: %(
            La version TLS 1.3 doit être prise en charge et privilégiée.
            La version TLS 1.2 est également acceptée sous condition de suivre les recommandations de ce [guide](https://messervices.cyber.gouv.fr/documents-guides/anssi-guide-recommandations_de_securite_relatives_a_tls-v1.2.pdf).
          ),
           config: {
             options: {
               minimum_allowed_version: OpenSSL::SSL::TLS1_2_VERSION
             } 
           }
    end 
  end
end