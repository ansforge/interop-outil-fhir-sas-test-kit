module SasTestKit
    module PractitionerOpt
        class ValidateFirstname < Inferno::Test
            title 'Vérification présence prénom PS'
            id :ps_validate_firstname
            description %(
            Vérification présence prénom PS
            )

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)

                Prenom = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource.name.given')   
                
                assert(( Prenom != nil), "Le prénom doit être présent")
                assert(( Prenom[0]["element"] != nil && !Prenom[0]["element"].empty?) , "Le prénom doit être renseigné")
                add_message('info', "Prénom: " + Prenom[0]["element"].to_s)      
            end
        end
    end
end