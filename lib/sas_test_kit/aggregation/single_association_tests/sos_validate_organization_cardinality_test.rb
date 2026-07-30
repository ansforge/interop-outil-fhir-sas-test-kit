module SasTestKit
    module SingleAssociation
        class ValidateOrganizationCardinality < Inferno::Test
            title "Vérification de la présence d'une seule ressource Organization"
            id :validate_organization_cardinality
            description %(
                ## Description

                Ce test réalise une vérification de la **présence d'une seule ressource Organization** dans le Bundle de réponse.  
            )

            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:organizations] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-organization-aggregator").resource')
                assert(scratch[:organizations].length == 1, "Le Bundle doit contenir exactement une ressource Organization, il en possède #{scratch[:organizations].length}")
            end
        end
    end
end