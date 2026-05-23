module SasTestKit
    class CapabilityStatementGroup < Inferno::TestGroup
        id :capability_statement
        title 'Capability Statement'
        description 'Verification de la présence du  CapabilityStatement sur le serveur'
        optional

        test do
            optional
            id :capability_statement_read
            title 'Recupération du  CapabilityStatement'
            description 'Récupération  du CapabilityStatement du endpoint  /metadata '

            run do
              mTLS == 'true' ? fhir_get_capability_statement() : fhir_get_capability_statement(client: :no_mTLS)
              error_message = %(Une API FHIR RESTful devrait disposer d'un capability statement, cf. [http - FHIR v4.0.1](https://hl7.org/fhir/R4/http.html#3.1.0))
              add_message('info', error_message)

              assert_response_status(200)
              assert_resource_type(:capability_statement)
            end 
        end
    end
end