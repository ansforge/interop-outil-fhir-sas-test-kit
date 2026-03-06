require_relative 'helper_fluxv1'
require 'securerandom'

module MyTestKit
    class IdnpsSwitchAccountTest < Inferno::Test
        title "Réattribution d'un IDNPS après déshabilitation du compte régulateur d'origine"
        id :idnps_reattribution_test
        description %(
            
            ## Description

            Ce test valide le scénario dans lequel un compte régulateur initialement associé à un IDNPS est d'abord **déshabilités**, puis remplacé par un nouveau compte créé avec un UUID distinct, auquel l'IDNPS est ensuite réattribué.

            Le test vérifie successivement trois étapes essentielles :

            1. **Déshabilitation du compte d'origine** : le compte doit passer à l'état « déshabilités », et l'IDNPS doit devenir disponible pour une réaffectation.  
            2. **Création d'un nouveau compte** : un nouveau compte régulateur doit pouvoir être créé avec un nouvel UUID sans référence résiduelle au compte précédent.  
            3. **Réassociation de l'IDNPS** : l'IDNPS initial doit pouvoir être associé au nouveau compte sans erreur, et l'API doit confirmer la réussite de cette opération.

            L'ensemble du test garantit que chacune de ces étapes renvoie les réponses attendues et que la transition du compte d'origine vers le nouveau compte se déroule correctement.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'            
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys, active: false)

            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + regulator_id })
            response = http.put(url, updated_regulator.to_json, headers)

            assert(response.code.to_i == 200, "Expected response status 200, got #{response.code}")
        # ------------------------------------------

            sys = 'urn:oid:1.2.250.1.213.3.6'
            uuid = SecureRandom.uuid
            new_regulator = HelperFLuxv1.build_regulateur_body(uuid, "#{uuid}." + regulator_mail, resource_id, "#{uuid}" + regulator_first_name, "#{uuid}" + regulator_last_name, sys)

            fhir_create(new_regulator)
            assert_response_status(201)
        # ------------------------------------------
         
            sys = 'urn:oid:1.2.250.1.71.4.2.1'
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, "#{uuid}." + regulator_mail, resource_id, "#{uuid}" + regulator_first_name, "#{uuid}" + regulator_last_name, sys)

            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.213.3.6|' + uuid })
            response = http.put(url, updated_regulator.to_json, headers)

            assert(response.code.to_i == 200, "Expected response status 200, got #{response.code}")
        end
    end
end