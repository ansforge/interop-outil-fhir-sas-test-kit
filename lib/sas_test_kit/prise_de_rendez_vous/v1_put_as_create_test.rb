require_relative 'helper_fluxv1'
require 'securerandom'

module SasTestKit
    class PutAsCreate < Inferno::Test
        title "Création d'un compte régulateur via PUT"
        id :put_as_create
        description %(
            ## Description

            Ce test vérifie le comportement du serveur lors de l'envoi d'une requête **PUT** visant une ressource *Practitioner* **inexistante**, conformément au principe du *PUT-as-Create* prévu par les spécifications FHIR.  
            Un identifiant unique (UUID) est généré et utilisé pour construire une représentation complète du compte régulateur à créer.

            La ressource est ensuite transmise via une requête `PUT` ciblant l'identifiant fourni dans le paramètre `identifier`.  
            Le test considère l'opération comme réussie si le serveur renvoie un statut **201 (Created)** ou **200 (OK)**, indiquant que la création a été correctement effectuée ou reconnue.

            Ce scénario valide la capacité du serveur à accepter la **création d'un nouveau compte régulateur** au moyen d'une requête `PUT` adressée à un identifiant non encore enregistré.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'
            uuid = SecureRandom.uuid
            updated_regulator = HelperFLuxv1.build_regulateur_body(uuid, "#{uuid}" + regulator_mail, resource_id, "#{uuid}" + regulator_first_name, "#{uuid}" + regulator_last_name, sys)

            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + uuid })
            response = http.put(url, updated_regulator.to_json, headers)

            add_message("info", "request : #{url}")
            add_message("info", "response body: #{response.body}")
            assert(response.code.to_i == 201 || response.code.to_i == 200, "Expected response status 200 or 201, got #{response.code}")
        end
    end
end