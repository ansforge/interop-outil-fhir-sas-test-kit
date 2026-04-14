require_relative 'helper_fluxv1'

module SasTestKit
    class ModificationHabilitationTest < Inferno::Test
        title "Habilitation d'un régulateur"
        id :modification_habilitation
        description %(
            ## Description

            Ce test vérifie la capacité du serveur à **habiliter un compte régulateur** en réactivant la ressource *Practitioner* correspondante.  
            L'objectif est de repasser le champ **`active` à `true`**, indiquant que le compte régulateur doit être considéré comme habilité et autorisé à fonctionner.

            Le test construit une ressource *Practitioner* conforme au profil régulateur, utilisant l'identifiant IDNPS et les attributs requis.  
            Une requête `PUT` est ensuite envoyée sur la ressource ciblée via le paramètre `identifier`, permettant de mettre à jour le compte régulateur existant.

            Le test valide enfin que le serveur renvoie un code **2xx ou 3xx**, confirmant que l'habilitation a été appliquée correctement.

            Ce scénario garantit que le serveur permet bien de réactiver un compte régulateur en modifiant le champ `active`.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys)

            put("Practitioner?identifier=urn:oid:1.2.250.1.71.4.2.1|#{regulator_id}", body: updated_regulator.to_json)

            assert(response[:status] >=200 && response[:status] < 400, "Expected response status 2xx or 3xx, got #{response[:status]}")
        end
    end
end