module SasTestKit
    module SearchMultiplePs
        class ValidatePractitionerCardinality < Inferno::Test
            title 'Vérification de la présence de deux ressources Practitioner'
            id :validate_practitioner_cardinality_2
            description %(
                ## Description

                Ce test réalise une vérification de la **présence de deux ressources Practitioner** dans le Bundle de réponse.  
                Il est attendu que la recherche multi-PS retourne **exactement deux** profils *FrPractitionerAgregateur* correspondant aux deux RPPS renseignés en entrée.
            )
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:practitioners] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource')
                assert(scratch[:practitioners].length == 2, "Le Bundle doit contenir exactement deux ressources Practitioner, il en possède #{scratch[:practitioners].length}")
            end
        end
    end
end