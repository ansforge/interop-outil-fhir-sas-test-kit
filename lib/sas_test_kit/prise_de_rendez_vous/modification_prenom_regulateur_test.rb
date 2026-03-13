require_relative 'helper_fluxv1'

module MyTestKit
    class ModificationPrenomRegulateurTest < Inferno::Test
        title "'Modification du prénom d'un compte régulateur'"
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
            sys = 'urn:oid:1.2.250.1.71.4.2.1'            
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id_modif, regulator_mail_modif, resource_id, regulator_first_name_modif, regulator_last_name_modif, sys)
            
            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + regulator_id_modif })
            response = http.put(url, updated_regulator.to_json, headers)

            add_message("info", "request : #{url}")
            add_message("info", "response body: #{response.body}")
            assert(response.code.to_i >=200 && response.code.to_i < 400, "Expected response status 2xx or 3xx, got #{response.code}")
        end
    end
end