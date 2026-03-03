require_relative 'helper_fluxv1'

module MyTestKit
    class CreationRegulateurIDNPSTest < Inferno::Test
        title 'Creation de compte régulateur (format IDNPS)'
        id :creation_regulateur_idnps_test
        description %(
            Ce test crée un compte régulateur et vérifie la réponse du serveur.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'
            new_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys)

            fhir_create(new_regulator)
            assert_response_status(201)
        end
    end
end