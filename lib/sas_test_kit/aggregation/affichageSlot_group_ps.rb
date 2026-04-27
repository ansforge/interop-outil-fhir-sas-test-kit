require_relative 'setup_test'

require 'uri'
require 'cgi'

module SasTestKit
  class AffichageslotGroupPS < Inferno::TestGroup
    title "PS avec un seul lieu de consultation"
    description %(
      ## Description

      Ce groupe vérifie la conformité du **Bundle de réponse** renvoyé par le **flux Agrégateur - recherche de créneaux** pour un **professionnel de santé (PS) disposant d'un seul lieu de consultation**.  
      Les contrôles portent sur la **présence**, la **cardinalité**, la **cohérence des références inter-ressources** et la **validité des données clés** attendues par les profils SAS.

      Plus précisément, les tests valident :
      - la présence et le nombre des ressources principales du Bundle (*FrPractitionerAgregateur*, *FrPractitionerRoleExerciceAgregateur*, *FrScheduleAgregateur*, *FrSlotAgregateur*) pour un RPPS donné (un seul Practitioner, un seul PractitionerRole, un seul Schedule, un seul Location) ;
      - le **format du RPPS** (préfixe « 8 » + 11 chiffres) et l'égalité entre le RPPS demandé et celui retrouvé ;
      - la **cohérence des dates de Slot** (pas de créneau antérieur à 'maintenant'), existence des dates de fin, et vérification `start ≤ end` ;
      - la **cohérence des références** entre Practitioner, PractitionerRole, Schedule (et Location contenue), selon les profils SAS ;
      - la **présence de l'adresse** (ligne, ville, code postal à 5 chiffres) pour le lieu unique du PS ;
      - la conformité du champ `Bundle.link.url` avec l'URL de requête ;
      - la **présence d'une URL de prise de RDV** (champ `Slot.comment`) sur chaque créneau retourné.

      Ces contrôles s'appuient sur les profils et règles publiés dans le **Guide d'implémentation SAS** et la page **Spécifications fonctionnelles** concernant la **recherche de créneaux via l'agrégateur**. Ils visent à garantir que la réponse fournie par l'éditeur est exploitable par la plateforme SAS conformément aux attentes officielles.
    )
    id :affichage_slot_group_ps

    input :practitioner_id,
          title: 'RPPS',
          description: 'Renseigner le RPPS (préfixé par 8) d\'un PS ne possédant qu\'un lieu',
          default: '810100901734'
    
    test from: :slot_search_setup do
      config(
        inputs: { 
          practitioner_id: { name: :practitioner_id },
        }
      )
    end

    test do
        title 'Vérification de la présence et des cardinalités des ressources du Bundle'
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
          
            assert (NbRessourcesSchedule[0]["element"]) == 1, "Une seule ressource schedule doit être présente pour un RPPS appelé"
            assert (NbRessourcesPractiRole[0]["element"]) == 1, "Une seule ressource PractitionerRole doit être présente ce RPPS"
            assert (NbRessourcesPracti[0]["element"]) == 1, "Une seule ressource Practitioner doit être présente pour un RPPS appelé"
            assert (NombreLieu[0]["element"]) == 1, "Une seule ressource Location doit être présente pour ce RPPS"
            #verification présence des 4 principales ressources dans le Bundle
            total = evaluate_fhirpath(resource: bundle, path: 'total')      
            expected_total = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").count()')
            add_message('info', "Total (bundle) : " + total[0]["element"].to_s + "/ Total Slot (Calculé) : " + expected_total[0]["element"].to_s) 
            warning do
                assert (total[0]["element"]) == (expected_total[0]["element"]), "le valeur de total doit être égale au nombre de ressources slot dans le Bundle"
            end

            assert(evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").exists() and entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").exists() and entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").exists() and entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").exists()'))
            
        end
    end

    test do
        title 'Vérification du RPPS retourné'
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


    test do
        title 'Vérification sur les dates des créneaux'
        description %(
            ## Description

            Ce test contrôle la **cohérence temporelle** des `Slot` :  
            - absence de créneaux avec une **date de début antérieure** à “maintenant” ;
            - présence d'une **date de fin** pour chaque `Slot` ;
            - vérification que **`start ≤ end`** pour tous les `Slot` ;
            - **bornage** des dates de début par la **date de fin de recherche**.
        )
        run do
            bundle = scratch[:Bundle]
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
            
            NbCreneauxAvantDebut = evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur" and resource.start < now()).count()')
            
            add_message('info', "Nb créneaux avant date début: " + NbCreneauxAvantDebut[0]["element"].to_s)  
            assert (NbCreneauxAvantDebut[0]["element"] == 0), "Il ne doit pas y avoir de créneaux avec une date de début antérieure à la date courante"
            
            date_debut = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.start')
            threshold = scratch[:DateFin]

            date_debut.each_with_index do |date_hash, int|
              date_str = date_hash["element"]
              date = Date.parse(date_str)
              add_message('info', "Date début: " + date.to_s)  
              assert date <= Date.parse(threshold), "La date #{date} n'est pas supérieure à la date de fin de la recherche #{threshold}"
            end

            #Vérification présence dates fin
            date_fin = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.end.exists()')
            assert(date_fin[0]["element"].to_s == 'true', "tous les ressources Slot doivent avoir une date de fin")

            #Vérification date début < date fin
            Boolean_start_end = evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.all(start<end)')
            assert(Boolean_start_end[0]["element"].to_s == 'true', "tous les ressources Slot doivent avoir une date de début inférieure à la date de fin")
        end
    end

    test do
        title 'Vérification de la cohérence des références entre Practitioner, PractitionerRole, Schedule et Location'
        description %(
            ## Description

            Ce test valide la **cohérence des références** entre les ressources du Bundle :  
            - `PractitionerRole.practitioner.reference` pointe vers l’**ID du Practitioner** présent dans le Bundle ;
            - `Schedule.actor.reference` inclut les **références vers Practitioner et PractitionerRole** ;
            - la `Location` **contenue** dans `PractitionerRole` est référencée via un **lien local** (`#<id>`).
        )
        run do
            bundle = scratch[:Bundle]
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

            reference_practi = evaluate_fhirpath(
              resource: bundle,
              path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.practitioner.reference'
            )

            reference_schedule = evaluate_fhirpath(
              resource: bundle,
              path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource.actor.reference'
            )

            #A creuser !!
            references_slot = evaluate_fhirpath(
              resource: bundle,
              path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource.schedule.reference'
            )

            practitioner_id = evaluate_fhirpath(
            resource: bundle, 
            path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource.id'
            )

            practitionerRole_id = evaluate_fhirpath(
            resource: bundle, 
            path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.id'
            )  

            value =  reference_schedule.map{ |item| item['element'].to_s }
            joined = value.join(', ')
            add_message('info', "References schedule: " + joined)
            add_message('info', "Reference practiRole: " + reference_practi[0]["element"].to_s)

            assert(reference_practi[0]["element"].to_s == "Practitioner/" + practitioner_id[0]["element"].to_s, "Il est attendu que l'identifiant du PS #{practitioner_id} matche la reference #{reference_practi}")
            assert(joined.include?("PractitionerRole/" + practitionerRole_id[0]["element"].to_s ))
            assert(joined.include?("Practitioner/" + practitioner_id[0]["element"].to_s ))

            #Ajouter test de la référence location
            reference_location = evaluate_fhirpath(
              resource: bundle, 
              path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.location.reference'
            )  
          
            location_id = evaluate_fhirpath(
              resource: bundle, 
              path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.id'
            )
            
            add_message('info', "Reference location: " + reference_location[0]["element"].to_s)
            assert(reference_location[0]["element"].to_s == "#" + location_id[0]["element"].to_s, "Il est attendu que l'identifiant de la réference à la ressource location  #{reference_location} matche la reference #{location_id}")
        end
    end


    test do
        title "Vérification de la présence de l'adresse du lieu (ligne, ville, code postal)"
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

    test do
        title "Vérification de la correspondance entre Bundle.link.url et l'URL de la requête"
        description %(
            ## Description

            Ce test valide que le champ **`Bundle.link.url`** **reflète exactement** l'URL de la requête FHIR ayant produit le Bundle.
        )
        run do
            request_url = scratch[:query]
            bundle = scratch[:Bundle]
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
            URL = evaluate_fhirpath(
            resource: bundle,
            path: 'link.url'
            )

            assert(URL[0] != nil, "Le champ link.URL n'est pas présent ou est vide")
            
            link_url = URL[0]["element"].to_s
       
            def normalized_query(url)
                decoded_url = CGI.unescapeHTML(url)
                uri = URI.parse(decoded_url)
                CGI.parse(uri.query).transform_values(&:sort)
            end

            add_message('info', "champ link.URL: " + link_url)
            add_message('info', "requête FHIR: " + request_url)
            
            request_query = normalized_query(request_url)
            link_query    = normalized_query(link_url)

            assert(request_query == link_query, "Les query strings ne correspondent pas")
            add_message("warning", "L'URL du bundle et de la requête ne sont pas identiques !") if (link_url != request_url)
        end
    end

     test do
        title "Vérification de la présence d'une URL de prise de RDV sur chaque créneau"
        description %(
            ## Description

            Ce test s'assure que chaque ressource **`Slot`** fournit une **URL de prise de RDV** dans le champ **`comment`** :  
            - champ présent et **non vide** ;
            - champ **non composé uniquement d'espaces** ;
            - condition respectée **pour tous** les créneaux retournés.
        )
        run do
            bundle = scratch[:Bundle]
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
            PresenceURLPRDV = evaluate_fhirpath(
            resource: bundle, 
            path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.all(
              comment.exists() and comment.empty().not() and comment.matches("^[[:space:]]*$").not())'
            )

            assert(PresenceURLPRDV[0]["element"].to_s == 'true', "Une URL de prise de RDV (champ Comment) doit être présente sur chacun des créneaux")
            add_message('info', "Présence URL pour chaque slot: " + PresenceURLPRDV[0]["element"].to_s)

        end
    end
  end
end
