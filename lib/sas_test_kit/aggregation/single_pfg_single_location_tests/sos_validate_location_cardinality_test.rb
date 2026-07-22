module SasTestKit
    module SingleAssociation
        class ValidateLocationCardinality < Inferno::Test
            title "Vérification de la présence d'au moins une ressource Location"
            id :validate_location_cardinality
            description %(
                ## Description

                Ce test réalise une vérification de la **présence d'au moins une ressource Location** dans le Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:locations] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-location-aggregator").resource')
                assert(scratch[:locations].length >= 1, "Le Bundle doit contenir au moins une ressource Location, il en possède #{scratch[:locations].length}")
            end
        end
    end
end