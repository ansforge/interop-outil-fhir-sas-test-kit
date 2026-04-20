require_relative 'helper_fluxv1'

module SasTestKit
    class ModificationNomRegulateurTest < Inferno::Test
        title "Modification du nom d'un compte régulateur"
        id :modification_nom_regulateur_test
        description %(
            ## Description

            Ce test vérifie la capacité du serveur à **mettre à jour le nom d'un compte régulateur** existant, conformément au flux de gestion des comptes régulateurs décrit dans les spécifications SAS.

            La ressource *Practitioner* associée au compte est identifiée à l'aide de son IDNPS via le paramètre `identifier`.  
            Une nouvelle version de la ressource est ensuite envoyée par requête `PUT`, incluant un **nom modifié**.

            La mise à jour est considérée comme réussie si le serveur renvoie un statut **2xx ou 3xx**, confirmant que le changement de nom a bien été pris en compte.

            Ce scénario assure que le serveur prend correctement en charge la **modification des attributs administratifs** d'un compte régulateur.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'            
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id_modif, regulator_mail_modif, resource_id, regulator_first_name, regulator_last_name_modif, sys)

            put("Practitioner?identifier=urn:oid:1.2.250.1.71.4.2.1|#{regulator_id_modif}", body: updated_regulator.to_json)

            assert(response[:status] >=200 && response[:status] < 400, "Expected response status 2xx or 3xx, got #{response[:status]}")
        end
    end
end