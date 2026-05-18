module SasTestKit
    module SinglePractitionerSingleLocation
        class ValidateRPPS < Inferno::Test
            title 'Vérification du RPPS retourné'
            id :validate_rpps
            description %(
                ## Description

                Ce test valide le **RPPS** retourné dans le Bundle :  
                - **correspondance** entre le RPPS demandé et celui retrouvé ;
                - **format** conforme : **préfixe “8”** suivi de **11 chiffres** (`8XXXXXXXXXXX`).
            )
            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
                IDNPS = scratch[:IDNPS]
                
                RPPSrecupere = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource.identifier.value')   
                add_message('info', "RPPS: " + RPPSrecupere[0]["element"].to_s) 
            
                assert ((RPPSrecupere[0]["element"]) == IDNPS), "le RPPS retourné doit être égal au RPPS appelé"
                assert (RPPSrecupere[0]["element"].to_s =~ /\A8[0-9]{11}\z/) , "le RPPS retourné doit comporter 11 chiffres préfixés par 8"
            end
        end
    end
end