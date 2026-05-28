module SasTestKit
    module PractitionerOpt
        class ValidatePhone < Inferno::Test
            title 'Vérification numéro de téléphone PS'
            id :ps_validate_phone
            description %(
            Vérification numéro de téléphone PS
            )
            optional
            verifies_requirements 'agg-psindiv@34'

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                
                Telephone = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.telecom.value')   
                add_message('info', "Téléphone: " + Telephone&.dig(0, "element").to_s) 
                
                phone_number = Telephone&.dig(0, "element").to_s
                assert( phone_number && !phone_number.empty?, "Le numéro de téléphone est manquant")         
                
                FormatsTel = [
                /^\+33\d{9}$/,
                /^\+262\d{9}$/,
                /^\+590\d{9}$/,
                /^\+596\d{9}$/,
                /^\+594\d{9}$/
                ]

                assert((Regexp.union(FormatsTel).match?(phone_number)), "le numéro de téléphone doit être au bon format")    
            end
        end
    end
end