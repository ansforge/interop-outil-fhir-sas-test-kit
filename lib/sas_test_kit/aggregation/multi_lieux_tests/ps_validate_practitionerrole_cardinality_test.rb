module SasTestKit
    module MultiLieux
        class ValidatePractitionerRoleCardinality < Inferno::Test
            title 'Vérification de la présence de deux ressources PractitionerRole'
            id :validate_practitionerrole_cardinality_1
            description %(
                ## Description

                Ce test vérifie la présence de **deux ressources PractitionerRole**, chacune représentant un lieu d'exercice différent du même professionnel de santé.  
                Le Bundle doit contenir **exactement deux** ressources *FrPractitionerRoleExerciceAgregateur*.
            )
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:practitioner_roles] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource')
                assert(scratch[:practitioner_roles].length == 2, "Le Bundle doit contenir exactement deux ressources PractitionerRole, il en possède #{scratch[:practitioner_roles].length}")
            end
        end
    end
end