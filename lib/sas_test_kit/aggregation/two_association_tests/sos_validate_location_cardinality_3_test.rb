module SasTestKit
    module TwoAssociation
        class ValidateLocationCardinality < Inferno::Test
            title "Vérification de la présence de trois ressources Location"
            id :sos_validate_location_cardinality_3
            description %(
                ## Description

                Ce test réalise une vérification de la **présence de trois ressources Location** dans le Bundle de réponse.
            )

            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:locations] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-location-aggregator").resource')
                assert(scratch[:locations].length == 3, "Le Bundle doit contenir trois ressources Location, il en possède #{scratch[:locations].length}")

                locations = scratch[:locations]
                location_ids = []
                locations.each do |location|
                    assert(!location_ids.include?(location['element'].id), "Deux ressources Location possède le même ID")
                    location_ids << location['element'].id
                end
            end
        end
    end
end