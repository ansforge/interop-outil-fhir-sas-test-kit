require_relative 'helper_fluxv1'

module SasTestKit
    class CreationRegulateurIDNPSTest < Inferno::Test
        title "Création d'un compte régulateur avec identifiant IDNPS"
        id :creation_regulateur_idnps_test
        description %(
            ## Description

            Ce test vérifie la capacité du serveur à créer un **compte régulateur** dont l'identifiant repose sur un **IDNPS** (type d'identifiant officiel issu du système `urn:oid:1.2.250.1.71.4.2.1`).  

            Le test construit une ressource *Practitioner* conforme au profil attendu, l'envoie via une requête `FHIR Create` (`POST`), puis vérifie que :

            - la création du compte est acceptée ;
            - le serveur répond avec un code **201 Created**, indiquant que la ressource a été correctement enregistrée.

            Ce test valide donc le bon fonctionnement du flux de création de compte régulateur basé sur un IDNPS.

        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'
            new_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys)

            mTLS == 'true' ? fhir_create(new_regulator) : fhir_create(new_regulator, client: :no_mTLS)
            assert_response_status(201)
        end
    end
end