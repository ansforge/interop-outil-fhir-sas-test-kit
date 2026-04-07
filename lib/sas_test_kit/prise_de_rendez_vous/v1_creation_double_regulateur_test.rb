require_relative 'helper_fluxv1'
require 'securerandom'

module SasTestKit
    class CreationDoubleRegulateurUUIDTest < Inferno::Test
        title 'Création en double : rejet de la seconde requête POST pour un compte régulateur déjà existant'
        id :creation_double_regulateur_uuid_test
        description %(
            ## Description
            
            Ce test envoie successivement **deux requêtes `POST`** visant à créer un même compte régulateur, en utilisant un **email identique** pour les deux créations.

            L'objectif est de vérifier que le serveur applique correctement la règle d'unicité du compte régulateur :

            - la **première requête** doit aboutir à la création du compte
            - la **seconde requête**, utilisant les mêmes données (notamment le même email), doit être **rejetée** avec une erreur indiquant qu'un compte identique ne peut pas être créé une seconde fois.

            Ce test garantit que le système empêche la création multiple d'un compte régulateur ayant le même identifiant fonctionnel.
        )
        run do
            sys = 'urn:oid:1.2.250.1.213.3.6'
            uuid = SecureRandom.uuid
            new_regulator = HelperFLuxv1.build_regulateur_body(uuid, "#{uuid}" + regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys)
            
            fhir_create(new_regulator)
            assert_response_status(201)

            fhir_create(new_regulator)
            assert(response[:status] >= 400 && response[:status] < 600, "Expected response status 4xx or 5xx, got #{response[:status]}")
        end
    end
end