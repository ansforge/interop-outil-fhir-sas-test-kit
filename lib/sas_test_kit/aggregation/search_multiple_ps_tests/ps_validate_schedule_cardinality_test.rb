module SasTestKit
    module SearchMultiplePs
        class ValidateScheduleCardinality < Inferno::Test
            title "Vérification de la présence d'au moins deux ressources Schedule"
            id :validate_schedule_cardinality_2
            description %(
                ## Description

                Ce test réalise une vérification sur les **ressources Schedule** du Bundle de réponse.  
                La recherche multi-PS doit retourner **au minimum deux ressources Schedule**, chacune correspondant à un professionnel remonté par le flux Agrégateur.
            )
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:schedules] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource')
                assert(scratch[:schedules].length >= 2, "Le Bundle doit contenir au moins deux ressources Schedule, il en possède #{scratch[:schedules].length}")
            end
        end
    end
end