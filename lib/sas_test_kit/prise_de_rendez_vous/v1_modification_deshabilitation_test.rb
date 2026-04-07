require_relative 'helper_fluxv1'

module SasTestKit
    class ModificationDeshabilitationTest < Inferno::Test
        title "Retrait d'habilitation d'un régulateur"
        id :modification_deshabilitation
        description %(
            ## Description

            Ce test vérifie la capacité du serveur à **retirer l'habilitation d'un compte régulateur** en passant la ressource *Practitioner* associée en **`active = false`**.  
            Cela correspond à la déshabilitation du compte, qui ne doit alors plus être considéré comme actif.

            Le test génère une ressource *Practitioner* conforme au profil régulateur, incluant l'identifiant IDNPS et l'ensemble des données nécessaires, puis force la valeur `active` à `false`.  
            La requête `PUT` envoyée avec le bon paramètre `identifier` met à jour le compte régulateur ciblé.

            Le test vérifie ensuite que le serveur répond par un statut **2xx ou 3xx**, indiquant la réussite de la modification.

            Ce scénario permet de s'assurer que le serveur gère correctement la déshabilitation d'un compte régulateur via la mise à jour de son champ `active`.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'            
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys, false)

            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + regulator_id })
            response = http.put(url, updated_regulator.to_json, headers)

            add_message("info", "request : #{url}")
            add_message("info", "response body: #{response.body}")
            assert(response.code.to_i >=200 && response.code.to_i < 400, "Expected response status 2xx or 3xx, got #{response.code}")
        end
    end
end