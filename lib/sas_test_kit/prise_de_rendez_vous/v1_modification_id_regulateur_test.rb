require_relative 'helper_fluxv1'

module SasTestKit
    class ModificationIdRegulateurTest < Inferno::Test
        title "Modification de l\'ID d'un compte régulateur"
        id :modification_id_regulateur_test
        description %(
            ## Description

            Ce test vérifie la capacité du serveur à **modifier l'identifiant d'un compte régulateur**.

            L'opération consiste à mettre à jour une ressource *Practitioner* existante en remplaçant son identifiant IDNPS par un nouvel identifiant fourni en entrée.  
            La requête `PUT` est adressée via le paramètre `identifier`, permettant de cibler précisément le compte régulateur initial à modifier.

            Le test considère la mise à jour comme réussie si le serveur renvoie un statut **2xx ou 3xx**, indiquant que le changement d'identifiant a été correctement pris en compte.

            Ce scénario garantit que le serveur prend bien en charge la **réidentification** d'un compte régulateur tout en respectant la règle d'unicité fonctionnelle du flux SAS.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id_modif, regulator_mail_modif, resource_id, regulator_first_name, regulator_last_name, sys)

            put("Practitioner?identifier=urn:oid:1.2.250.1.71.4.2.1|#{regulator_id}", body: updated_regulator.to_json)

            assert(response[:status] >=200 && response[:status] < 400, "Expected response status 2xx or 3xx, got #{response[:status]}")
        end
    end
end