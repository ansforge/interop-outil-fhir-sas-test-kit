module SasTestKit
    module MultiLieux
        class ValidateScheduleCardinality < Inferno::Test
            title 'Vérification de la présence de deux ressources Schedule'
            id :validate_schedule_cardinality
            description %(
                ## Description

                Ce test confirme que le Bundle contient **exactement deux** ressources `Schedule`, chacune associée à un lieu d'exercice distinct.  
                Cette cardinalité reflète les disponibilités propres à chaque lieu.
            )
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:schedules] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource')
                assert(scratch[:schedules].length == 2, "Le Bundle doit contenir exactement deux ressources Schedule, il en possède #{scratch[:schedules].length}")
            end
        end
    end
end