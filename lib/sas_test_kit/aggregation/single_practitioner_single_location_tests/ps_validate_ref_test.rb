module SasTestKit
    module SinglePractitionerSingleLocation
        class ValidateRef < Inferno::Test
            title 'Vérification de la cohérence des références entre Practitioner, PractitionerRole, Schedule et Location'
            id :validate_ref
            description %(
                ## Description

                Ce test valide la **cohérence des références** entre les ressources du Bundle :  
                - `PractitionerRole.practitioner.reference` pointe vers l'**ID du Practitioner** présent dans le Bundle ;
                - `Schedule.actor.reference` inclut les **références vers Practitioner et PractitionerRole** ;
                - la `Location` **contenue** dans `PractitionerRole` est référencée via un **lien local** (`#<id>`).
            )
            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

                reference_practi = evaluate_fhirpath(
                  resource: bundle,
                  path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.practitioner.reference'
                )

                reference_schedule = evaluate_fhirpath(
                  resource: bundle,
                  path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource.actor.reference'
                )

                #A creuser !!
                references_slot = evaluate_fhirpath(
                  resource: bundle,
                  path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource.schedule.reference'
                )

                practitioner_id = evaluate_fhirpath(
                resource: bundle, 
                path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource.id'
                )

                practitionerRole_id = evaluate_fhirpath(
                resource: bundle, 
                path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.id'
                )  

                value =  reference_schedule.map{ |item| item['element'].to_s }
                joined = value.join(', ')
                add_message('info', "References schedule: " + joined)
                add_message('info', "Reference practiRole: " + reference_practi[0]["element"].to_s)

                assert(reference_practi[0]["element"].to_s == "Practitioner/" + practitioner_id[0]["element"].to_s, "Il est attendu que l'identifiant du PS #{practitioner_id} matche la reference #{reference_practi}")
                assert(joined.include?("PractitionerRole/" + practitionerRole_id[0]["element"].to_s ))
                assert(joined.include?("Practitioner/" + practitioner_id[0]["element"].to_s ))

                #Ajouter test de la référence location
                reference_location = evaluate_fhirpath(
                  resource: bundle, 
                  path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.location.reference'
                )  
              
                location_id = evaluate_fhirpath(
                  resource: bundle, 
                  path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.id'
                )
                
                add_message('info', "Reference location: " + reference_location[0]["element"].to_s)
                assert(reference_location[0]["element"].to_s == "#" + location_id[0]["element"].to_s, "Il est attendu que l'identifiant de la réference à la ressource location  #{reference_location} matche la reference #{location_id}")
            end
        end
    end
end