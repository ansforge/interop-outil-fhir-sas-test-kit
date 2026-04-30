module SasTestKit
    class ValidateLocation < Inferno::Test
        title "Vérification de la présence de l'adresse du lieu (ligne, ville, code postal)"
        id :validate_location
        description %(
            ## Description

            Ce test vérifie la **présence et le format** des éléments d'**adresse** du lieu (ressource `Location` contenue) :  
            - présence de **line**, **city** et **postalCode** ;
            - **code postal** conforme : exactement **5 chiffres**.
        )
        run do
            bundle = scratch[:Bundle]
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
            assert(evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.address.line.exists()'))
            add_message('info', "Ligne adresse: " + (evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.address.line.value'))[0]["element"].to_s) 
            add_message('info', "Ville: " + (evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.address.city.value'))[0]["element"].to_s) 
            
            CodePostal = evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.address.postalCode.value')[0]["element"].to_s
            
            add_message('info', "Code postal: " + CodePostal) 
            
            assert(evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.address.city.exists()'))
            assert(evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.address.postalCode.exists()'))

            assert(CodePostal.match?(/\A[0-9]{5}\z/), "le code postal doit avoir exactement 5 chiffres")
            #Certains code postal peuvent comporter des lettres (ex: 2A, 2B) ? NDLR BRE : pas de pb, 5 chiffres tout le temps
            #Gérer les DROM COM ? NDLR BRE : pas de pb, 5 chiffres tout le temps
        end
    end
end