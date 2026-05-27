module SasTestKit
    module PractitionerOpt
        class ValidateName < Inferno::Test
            title 'Vérification présence nom PS'
            id :ps_validate_name
            description %(
            Vérification présence nom PS
            )
            verifies_requirements 'agg-psindiv@33'
            
            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
                
                Nom = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource.name.family')
                assert(Nom != nil && Nom[0] != nil)
                add_message('info', "Nom de famille: " + Nom[0]["element"].to_s)
            end
        end
    end
end