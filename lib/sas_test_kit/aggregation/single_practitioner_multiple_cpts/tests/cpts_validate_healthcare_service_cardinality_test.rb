module SasTestKit
    module SinglePractitionerMultipleCPTS
        class ValidateHealthcareServiceCardinality < Inferno::Test
            title 'Vérification de la présence de deux ressources HealthcareService'
            id :cpts_validate_healthcare_service_cardinality
            description %()

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" unless bundle.present?

                healthcareServices = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-healthcareservice-aggregator").resource')   
                scratch[:healthcareServices] = healthcareServices

                assert(healthcareServices.length >= 2, "Le Bundle doit contenir exactement deux ressources HealthcareService, il en possède #{healthcareServices.length}")
            end
        end
    end
end