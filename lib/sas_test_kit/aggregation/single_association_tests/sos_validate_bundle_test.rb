module SasTestKit
    module SingleAssociationSinglePFG
        class ValidateBundle < Inferno::Test
            title "Validation du Bundle contre le profil d'agrégation SOS"
            id :validate_bundle
            description %(
                ## Description

                Ce test réalise une validation FHIR du Bundle de réponse contre le profil d'agrégation SOS.
            )
                
            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle)
                
                bundle_profile_url = 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-bundle-aggregator'

                assert_resource_type('Bundle', resource: bundle)
                assert_valid_resource(resource: bundle, profile_url: "#{bundle_profile_url}", validator: :validator_sas)
            end
        end
    end
end