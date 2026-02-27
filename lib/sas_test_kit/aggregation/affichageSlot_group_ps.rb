require_relative 'setup_test'

module MyTestKit
  class AffichageslotGroupPS < Inferno::TestGroup
    title 'Contrôles Bundle - PS avec un seul lieu de consultation'
    description 'Contrôles sur le Bundle de réponse - champs obligatoires'
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
        title 'Vérification présence ressources'
      description %(
       Nombre et présence ressource
      )
      run do
        bundle = scratch[:Bundle]
        assert(bundle.present?, 'Bundle not found in scratch')
        
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

        assert(evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").exists() and entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").exists() and entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").exists() and entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").exists()'))
        

      end
    end

     test do
        title 'Vérification RPPS'
      description %(
       Format RPPS
      )
      run do
        bundle = scratch[:Bundle]
        IDNPS = scratch[:IDNPS]
        
        RPPSrecupere = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource.identifier.value')   
        add_message('info', "RPPS: " + RPPSrecupere[0]["element"].to_s) 
      
        assert ((RPPSrecupere[0]["element"]) == IDNPS), "le RPPS retourné doit être égal au RPPS appelé"
        assert (RPPSrecupere[0]["element"].to_s =~ /\A8[0-9]{11}\z/) , "le RPPS retourné doit comporter 11 chiffres préfixés par 8"
        
      end
    end


     test do
        title 'Vérification dates'
      description %(
        Verifier dates
      )
      run do
        bundle = scratch[:Bundle]
        assert(bundle.present?, 'Bundle not found in scratch')
        
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
        title 'Vérification références'
      description %(
        Verifier cohérence message
      )
      run do
        bundle = scratch[:Bundle]
        assert(bundle.present?, 'Bundle not found in scratch')

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
        title 'Contrôle présence adresse'
      description %(
        Verifier cohérence message
      )
      run do
        bundle = scratch[:Bundle]
        assert(bundle.present?, 'Bundle not found in scratch')
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
        title 'Test champ URL.link Bundle'
      description %(
        vérification syntaxe URL.link Bundle
      )
      run do
        query = scratch[:query]
        bundle = scratch[:Bundle]
        URL = evaluate_fhirpath(
        resource: bundle, 
        path: 'link.url'
        )

        assert(query == URL[0]["element"].to_s)
        add_message('info', "champ URL.link: " + URL[0]["element"].to_s + ", requête FHIR: " + query)

      end
    end

     test do
        title 'Vérification URL prise de RDV'
      description %(
        vérification présence URL de prise de RDV
      )
      run do
        bundle = scratch[:Bundle]
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
