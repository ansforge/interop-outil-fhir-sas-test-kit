require_relative 'helper_fluxv1'

module MyTestKit
    class BadCreationRegulateurTest < Inferno::Test
        title 'Creation de compte régulateur avec des données incorrectes'
        id :bad_creation_regulateur_test
        description %(
            Ce test tente de créer un compte régulateur avec des données incorrectes et vérifie la réponse du serveur.
        )
        run do
            bad_regulator = HelperFLuxv1.build_bad_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name)

            fhir_create(bad_regulator)
            assert(response[:status] >= 400 && response[:status] < 600, "Expected response status 4xx or 5xx, got #{response[:status]}")
        end
    end
end