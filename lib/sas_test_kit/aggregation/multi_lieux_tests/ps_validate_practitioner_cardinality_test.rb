module SasTestKit
    class ValidatePractitionerCardinality < Inferno::Test
        title "Vérification de la présence d'une seule ressource Practitioner"
        id :validate_practitioner_cardinality
        description %(
            ## Description

            Ce test vérifie que le Bundle de réponse contient **exactement une** ressource *Practitioner*, correspondant au RPPS fourni en entrée.  
            Cette cardinalité est attendue même dans le cas d'un PS exerçant sur plusieurs lieux.
        )
        run do
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
            scratch[:practitioner] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource')
            assert(scratch[:practitioner].length == 1, "Le Bundle doit contenir exactement une ressource Practitioner, il en possède #{scratch[:practitioner].length}")
        end    
    end
end