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

              assert_response_status(200)
              assert_resource_type(:capability_statement)
            end
        end
    end
end