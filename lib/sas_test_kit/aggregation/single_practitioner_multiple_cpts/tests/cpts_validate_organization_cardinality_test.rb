module SasTestKit
    module SinglePractitionerMultipleCPTS
        class ValidateOrganizationCardinality < Inferno::Test
            title 'Vérification de la présence de deux ressources Organization'
            id :cpts_validate_organization_cardinality
            description %()

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" unless bundle.present?

                organizations = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").resource')
                scratch[:organization] = organizations

                assert(organizations.length >= 2, "Le Bundle doit contenir exactement deux ressources Organization, il en possède #{organizations.length}")
            end
        end
    end
end