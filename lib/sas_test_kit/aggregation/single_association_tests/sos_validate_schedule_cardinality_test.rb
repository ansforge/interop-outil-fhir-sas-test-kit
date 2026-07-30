module SasTestKit
    module SingleAssociation
        class ValidateScheduleCardinality < Inferno::Test
            title "Vérification de la présence d'une ressource Schedule"
            id :sos_validate_schedule_cardinality
            description %(
                ## Description

                Ce test réalise une vérification de la **présence d'une unique ressource Schedule** dans le Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:schedules] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-schedule-aggregator").resource')
                assert(scratch[:schedules].length == 1, "Le Bundle doit contenir une ressource Schedule, il en possède #{scratch[:schedules].length}")
            end
        end
    end
end