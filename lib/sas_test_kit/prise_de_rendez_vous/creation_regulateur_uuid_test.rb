require_relative 'helper_fluxv1'
require 'securerandom'

module MyTestKit
    class CreationRegulateurUUIDTest < Inferno::Test
        title 'Creation de compte régulateur (format UUID)'
        id :creation_regulateur_uuid_test
        description %(
            Ce test crée un compte régulateur et vérifie la réponse du serveur.
        )
        run do
            sys = 'urn:oid:1.2.250.1.213.3.6'
            scratch[:uuid] = SecureRandom.uuid
            new_regulator = HelperFLuxv1.build_regulateur_body(scratch[:uuid], 'uuid.' + regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys)

            begin
                fhir_create(new_regulator)
            rescue StandardError => e
                add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
            end
            assert_response_status(201)
        end
    end
end