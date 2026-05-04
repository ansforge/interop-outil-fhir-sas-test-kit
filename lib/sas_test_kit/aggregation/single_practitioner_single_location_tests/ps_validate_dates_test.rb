module SasTestKit
    module SinglePractitionerSingleLocation
        class ValidateDates < Inferno::Test
            title 'Vérification sur les dates des créneaux'
            id :validate_dates
            description %(
                ## Description

                Ce test contrôle la **cohérence temporelle** des `Slot` :  
                - absence de créneaux avec une **date de début antérieure** à “maintenant” ;
                - présence d'une **date de fin** pour chaque `Slot` ;
                - vérification que **`start ≤ end`** pour tous les `Slot` ;
                - **bornage** des dates de début par la **date de fin de recherche**.
            )
            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
                
                NbCreneauxAvantDebut = evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur" and resource.start < now()).count()')
                
                add_message('info', "Nb créneaux avant date début: " + NbCreneauxAvantDebut[0]["element"].to_s)  
                assert (NbCreneauxAvantDebut[0]["element"] == 0), "Il ne doit pas y avoir de créneaux avec une date de début antérieure à la date courante"
                
                date_debut = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.start')
                threshold = scratch[:DateFin]

                date_debut.each_with_index do |date_hash, int|
                date_str = date_hash["element"]
                date = Date.parse(date_str)
                add_message('info', "Date début: " + date.to_s)  
                assert date <= Date.parse(threshold), "La date #{date} n'est pas supérieure à la date de fin de la recherche #{threshold}"
                end

                #Vérification présence dates fin
                date_fin = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.end.exists()')
                assert(date_fin[0]["element"].to_s == 'true', "tous les ressources Slot doivent avoir une date de fin")

                #Vérification date début < date fin
                Boolean_start_end = evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.all(start<end)')
                assert(Boolean_start_end[0]["element"].to_s == 'true', "tous les ressources Slot doivent avoir une date de début inférieure à la date de fin")
            end
        end
    end
end