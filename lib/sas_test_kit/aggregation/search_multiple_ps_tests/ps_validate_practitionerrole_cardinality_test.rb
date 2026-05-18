module SasTestKit
    module SearchMultiplePs
        class ValidatePractitionerRoleCardinality < Inferno::Test
            title "Vérification de la présence d'au moins deux ressources PractitionerRole"
            id :validate_practitionerrole_cardinality_2
            description %(
                ## Description

                Ce test effectue une vérification sur les **ressources PractitionerRole** retournées dans le Bundle.  
                Il est attendu que la recherche multi-PS présente **au moins deux ressources** *FrPractitionerRoleExerciceAgregateur*, reflétant la présence de plusieurs PS dans la réponse.
            )
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:practitioner_roles] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource')
                assert(scratch[:practitioner_roles].length >= 2, "Le Bundle doit contenir au moins deux ressources PractitionerRole, il en possède #{scratch[:practitioner_roles].length}")
            end
        end
    end
end