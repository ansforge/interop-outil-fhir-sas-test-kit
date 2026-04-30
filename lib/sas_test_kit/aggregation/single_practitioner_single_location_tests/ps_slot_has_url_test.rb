module SasTestKit
    class SlotHasUrl < Inferno::Test
        title "Vérification de la présence d'une URL de prise de RDV sur chaque créneau"
        id :slot_has_url
        description %(
            ## Description

            Ce test s'assure que chaque ressource **`Slot`** fournit une **URL de prise de RDV** dans le champ **`comment`** :  
            - champ présent et **non vide** ;
            - champ **non composé uniquement d'espaces** ;
            - condition respectée **pour tous** les créneaux retournés.
        )
        run do
            bundle = scratch[:Bundle]
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
            PresenceURLPRDV = evaluate_fhirpath(
            resource: bundle, 
            path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.all(
              comment.exists() and comment.empty().not() and comment.matches("^[[:space:]]*$").not())'
            )

            assert(PresenceURLPRDV[0]["element"].to_s == 'true', "Une URL de prise de RDV (champ Comment) doit être présente sur chacun des créneaux")
            add_message('info', "Présence URL pour chaque slot: " + PresenceURLPRDV[0]["element"].to_s)
        end
    end
end