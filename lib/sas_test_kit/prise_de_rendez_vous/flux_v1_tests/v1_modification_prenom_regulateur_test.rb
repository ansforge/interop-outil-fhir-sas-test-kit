require_relative 'helper_fluxv1'

module SasTestKit
    class ModificationPrenomRegulateurTest < Inferno::Test
        title "Modification du prénom d'un compte régulateur"
        id :modification_prenom_regulateur_test
        description %(
            ## Description

            Ce test vérifie la capacité du serveur à **mettre à jour le prénom d'un compte régulateur** existant, conformément au flux de gestion des comptes régulateurs décrit dans les spécifications techniques SAS.

            La ressource *Practitioner* ciblée est identifiée via son IDNPS à l'aide du paramètre `identifier`.  
            Une nouvelle version de la ressource, intégrant un **prénom modifié**, est ensuite transmise au serveur par une requête `PUT`.

            Le test considère la mise à jour comme réussie si le serveur répond avec un statut **2xx ou 3xx**, indiquant que la modification du prénom a été correctement appliquée.

            Ce scénario valide que le serveur prend bien en charge la **mise à jour des attributs administratifs** d'un compte régulateur dans le cadre du flux SAS.
        )
        run do
            sys = 'urn:oid:1.2.250.1.213.3.6'
            uuid = SecureRandom.uuid
            new_regulator = HelperFLuxv1.build_regulateur_body(uuid, "#{uuid}" + regulator_mail, uuid, regulator_first_name, regulator_last_name, sys)

            begin
                mTLS == 'true' ? fhir_create(new_regulator) : fhir_create(new_regulator, client: :no_mTLS)
            rescue StandardError => e
                add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
            end

            assert_response_status(201)

            # -----------------------------------------------------------------
       
            updated_regulator = HelperFLuxv1.build_regulateur_body(uuid, "#{uuid}" + regulator_mail, uuid, regulator_first_name + "#{uuid}", regulator_last_name, sys)
            
            put("Practitioner?identifier=urn:oid:1.2.250.1.213.3.6|#{uuid}", body: updated_regulator.to_json)

            assert(response[:status] >=200 && response[:status] < 400, "Expected response status 2xx or 3xx, got #{response[:status]}")
        end
    end
end