require_relative 'helper_fluxv1'

module MyTestKit
    class CreationRegulateurTest < Inferno::Test
        title 'Creation de compte régulateur'
        id :creation_regulateur_test
        description %(
            Ce test crée un compte régulateur et vérifie la réponse du serveur.
        )
        run do
            new_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name)

            fhir_create(new_regulator)
            assert_response_status(201)
        end
    end
end