module SasTestKit
    module SinglePractitionerSingleLocation
        class ValidateCardinality < Inferno::Test
            title 'Vérification de la présence et des cardinalités des ressources du Bundle'
            id :validate_cardinality
            description %(
                ## Description

                Ce test vérifie la **présence** et les **cardinalités attendues** des ressources principales du Bundle de réponse (cas PS avec un **seul lieu**).  
                Il contrôle notamment :
                - `Practitioner`, `PractitionerRole`, `Schedule`, `Location` : **exactement 1** occurrence chacune ;
                - la présence des profils SAS attendus : *FrPractitionerAgregateur*, *FrPractitionerRoleExerciceAgregateur*, *FrScheduleAgregateur*, *FrSlotAgregateur* ;
                - la présence simultanée des quatre ressources principales dans le Bundle.
            )
            run do
                bundle = scratch[:Bundle]    
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

                SLOT_PROFILE_URL = suite_options[:launch_version] == 'ig_launch_1' ? 'http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur' : 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator'
                
                NbRessourcesPracti = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").count()')   
                add_message('info', "Nombre de PS dans le message : " + NbRessourcesPracti[0]["element"].to_s) 

                NbRessourcesSchedule =  evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").count()')
                add_message('info', "Nombre de ressources schedule dans le message : " + NbRessourcesSchedule[0]["element"].to_s)
                assert (NbRessourcesPracti[0]["element"]) == 1, "Une seule ressource practitioner doit être présente pour un RPPS appelé"
                
                NbRessourcesPractiRole =  evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").count()')
                add_message('info', "Nombre de ressources PractitionerRole dans le message : " + NbRessourcesPractiRole[0]["element"].to_s)

                NombreLieu = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.count()')
                add_message('info', "Nombre de ressources Location dans le message : " + NombreLieu[0]["element"].to_s)

                #Méthode alternative à la clause where - checks de Inferno similaire à java-hapi !!! ne fonctionne pas dans Inferno mais dans FHIR path lab
                #NbRessourcesSchedule =  evaluate_fhirpath(resource: resource, path: 'entry.resource.ofType("Schedule").count()')
            
                assert((NbRessourcesSchedule[0]["element"]) == 1, "Une seule ressource schedule doit être présente pour un RPPS appelé")
                assert((NbRessourcesPractiRole[0]["element"]) == 1, "Une seule ressource PractitionerRole doit être présente ce RPPS")
                assert((NbRessourcesPracti[0]["element"]) == 1, "Une seule ressource Practitioner doit être présente pour un RPPS appelé")
                assert((NombreLieu[0]["element"]) == 1, "Une seule ressource Location doit être présente pour ce RPPS")
                #verification présence des 4 principales ressources dans le Bundle
                total = evaluate_fhirpath(resource: bundle, path: 'total')      
                expected_total = evaluate_fhirpath(resource: bundle, path: "entry.where(resource.meta.profile='#{SLOT_PROFILE_URL}').count()")
                add_message('info', "Total (bundle) : " + total[0]["element"].to_s + "/ Total Slot (Calculé) : " + expected_total[0]["element"].to_s) 
                warning do
                    assert (total[0]["element"]) == (expected_total[0]["element"]), "le valeur de total doit être égale au nombre de ressources slot dans le Bundle"
                end

                assert(evaluate_fhirpath(resource: bundle, path:"entry.where(resource.meta.profile='#{SLOT_PROFILE_URL}').exists() and entry.where(resource.meta.profile='http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur').exists() and entry.where(resource.meta.profile='http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur').exists() and entry.where(resource.meta.profile='http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur').exists()"))
            end
        end
    end
end