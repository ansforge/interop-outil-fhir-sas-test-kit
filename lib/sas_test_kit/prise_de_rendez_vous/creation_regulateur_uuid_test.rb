require_relative 'helper_fluxv1'
require 'securerandom'

module MyTestKit
    class CreationRegulateurUUIDTest < Inferno::Test
        title "Création d'un compte régulateur avec identifiant UUID"
        id :creation_regulateur_uuid_test
        description %(
            ## Description

            Ce test vérifie la capacité du serveur à créer un **compte régulateur** dont l'identifiant principal est un **UUID**.  
            Un identifiant unique est généré dynamiquement pour le test, puis utilisé pour construire la ressource *Practitioner* conforme au profil attendu.

            Le test effectue ensuite une requête `FHIR Create` (`POST`) et s'assure que :

            - la création du compte est acceptée par le serveur ;
            - la réponse retournée est un **201 Created**, indiquant que la ressource a bien été enregistrée.

            Ce test valide ainsi le bon fonctionnement du flux de création d'un compte régulateur basé sur un UUID.
        )
        run do
            sys = 'urn:oid:1.2.250.1.213.3.6'
            scratch[:uuid] = SecureRandom.uuid
            new_regulator = HelperFLuxv1.build_regulateur_body(scratch[:uuid], "#{scratch[:uuid]}" + regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys)

            begin
                fhir_create(new_regulator)
            rescue StandardError => e
                add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
            end
            assert_response_status(201)
        end
    end
end