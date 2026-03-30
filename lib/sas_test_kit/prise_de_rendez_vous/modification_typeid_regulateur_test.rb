require_relative 'helper_fluxv1'

module SasTestKit
    class ModificationTypeIdRegulateurTest < Inferno::Test
        title "Conversion de l'identifiant du compte régulateur (UUID → IDNPS)"
        id :modification_typeid_regulateur_test
        description %(
            ## Description

            Ce test vérifie la capacité du serveur à **convertir le type d'identifiant d'un compte régulateur** en remplaçant l'**UUID éditeur** (`system: urn:oid:1.2.250.1.213.3.6`) par un **IDNPS** (`system: urn:oid:1.2.250.1.71.4.2.1`) pour la ressource *Practitioner* ciblée.

            Le scénario procède comme suit :
            - la ressource à modifier est ciblée via son **UUID** (paramètre `identifier` en requête `PUT`) ;
            - une représentation mise à jour est envoyée avec l'**IDNPS** comme identifiant principal (et l'email ajusté si nécessaire) ;
            - la réponse du serveur doit indiquer le **succès de la mise à jour** par un statut **2xx** ou **3xx**.

            Ce test confirme que l'implémentation permet de **basculer d'un UUID à un IDNPS** pour un compte régulateur existant, conformément aux attentes de gestion des identifiants.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, "#{scratch[:uuid] }" + regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys)

            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.213.3.6|' + scratch[:uuid] })
            response = http.put(url, updated_regulator.to_json, headers)

            add_message("info", "request : #{url}")
            add_message("info", "response body: #{response.body}")
            assert(response.code.to_i >=200 && response.code.to_i < 400, "Expected response status 2xx or 3xx, got #{response.code}")
        end
    end
end