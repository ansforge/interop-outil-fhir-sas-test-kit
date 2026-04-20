require_relative 'helper_fluxv1'

module SasTestKit
    class ModificationEmailRegulateurTest < Inferno::Test
        title "Modification de l\'email d'un compte régulateur"
        id :modification_email_regulateur_test
        description %(
            ## Description

            Ce test vérifie la capacité du serveur à **mettre à jour l'email d'un compte régulateur** déjà existant.  
            Pour cela, une ressource *Practitioner* mise à jour est construite avec le même identifiant IDNPS mais avec une nouvelle adresse électronique.

            Une requête `PUT` est ensuite envoyée sur la ressource ciblée via le paramètre `identifier`, afin de modifier l'email du compte régulateur identifié.  

            Le test considère l'opération comme réussie si le serveur renvoie un code **2xx ou 3xx**, indiquant que la mise à jour de l'email a bien été prise en compte.

            Ce scénario permet de s'assurer que le serveur prend correctement en charge la modification des informations de contact d'un compte régulateur.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'            
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, regulator_mail_modif, resource_id, regulator_first_name, regulator_last_name, sys)

            put("Practitioner?identifier=urn:oid:1.2.250.1.71.4.2.1|#{regulator_id}", body: updated_regulator.to_json)

            assert(response[:status] >=200 && response[:status] < 400, "Expected response status 2xx or 3xx, got #{response[:status]}")
        end
    end
end