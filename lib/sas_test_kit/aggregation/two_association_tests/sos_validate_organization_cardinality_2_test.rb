module SasTestKit
    module TwoAssociation
        class ValidateOrganizationCardinality < Inferno::Test
            title "Vérification de la présence de deux ressources Organization"
            id :sos_validate_organization_cardinality_2
            description %(
                ## Description

                Ce test réalise une vérification de la **présence de deux ressources Organization** dans le Bundle de réponse.  
            )

            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                scratch[:organizations] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-organization-aggregator").resource')
                assert(scratch[:organizations].length == 2, "Le Bundle doit contenir exactement deux ressources Organization, il en possède #{scratch[:organizations].length}")
            end
        end
    end
end