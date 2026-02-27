module MyTestKit
  class AffichageslotGroup < Inferno::TestGroup
    title 'Contrôles Bundle - PS avec un seul lieu de consultation'
    description 'Contrôles sur le Bundle de réponse - champs obligatoires'
    id :affichage_slot_group_cpts

    
    test do
      title 'Recherche par RPPS - Initialisation requête'
      description %(
        Verifier les champs obligatoires
      )

      input :practitioner_id,
            title: 'RPPS',
            description: 'Renseigner le RPPS (préfixé par 8) d\'un PS ne possédant qu\'un lieu et avec au moins un créneau lié à une CPTS',
            default: '810100901734'

       input :cpts_id,
            title: 'Identifiant CPTS',
            description: 'Renseigner l\'identifiant FINESS (préfixé par 1) de la CPTS à laquelle est associée au moins un créneau',
            default: '1260021704'

      run do

        #prévoir de gérer les time zone
        formatted_start_date = Time.now.strftime("%Y-%m-%dT%H:%M:%S")

        three_days_later = Time.now + (3 * 24 * 60 * 60) # 3 days in seconds

        # Cap at 72 hours (3 days)
        max_limit = Time.now + (72 * 60 * 60)

        # End of third day (23:59:59)
        end_of_third_day = (Time.now + (2 * 24 * 60 * 60)).end_of_day rescue Time.new(Time.now.year, Time.now.month, Time.now.day + 2, 23, 59, 59)

        # Final capped time
        capped_time = [three_days_later, max_limit, end_of_third_day].min

        # Format capped time
        formatted_end_date = capped_time.strftime("%Y-%m-%dT%H:%M:%S")
        scratch[:DateFin] = formatted_end_date
    
        hash =  {
        _include: [
          'Slot:schedule',
          'Slot:service-type-reference'
        ],
        '_include:iterate': [
        'Schedule:actor',
        'HealthcareService:organization'
        ],
        'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + practitioner_id,
        start: ["ge#{formatted_start_date}.000", "le#{formatted_end_date}.000"],
        status: 'free'
        }

        fhir_search('Slot', params: hash)

        #Stockage pour les autres tests
        scratch[:Bundle] = resource
        scratch[:IDNPS] = practitioner_id
        scratch[:query] = request.url
        scratch[:IDNST] = cpts_id
  
        assert_response_status(200)
        assert_resource_type('Bundle')
        #verification content type
        warning do
          assert_response_content_type('application/fhir+json')
        end
    
      end
      
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

        NbRessourcesPractiRole =  evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").count()')
        add_message('info', "Nombre de ressources PractitionerRole dans le message : " + NbRessourcesPractiRole[0]["element"].to_s)

        NombreLieu = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.contained.count()')
        add_message('info', "Nombre de ressources Location dans le message : " + NombreLieu[0]["element"].to_s)

        NbRessourcesHealthcareService =  evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-healthcareservice-aggregator").count()')
        add_message('info', "Nombre de ressources HealthcareService dans le message : " + NbRessourcesHealthcareService[0]["element"].to_s)

        NbRessourcesOrganization =  evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").count()')
        add_message('info', "Nombre de ressources Organization dans le message : " + NbRessourcesOrganization[0]["element"].to_s)
        assert (NbRessourcesPracti[0]["element"]) == 1, "Une seule ressource practitioner doit être présente pour un RPPS appelé"
        
        #Méthode alternative à la clause where - checks de Inferno similaire à java-hapi !!! ne fonctionne pas dans Inferno mais dans FHIR path lab
        #NbRessourcesSchedule =  evaluate_fhirpath(resource: resource, path: 'entry.resource.ofType("Schedule").count()')
        
        assert (NbRessourcesSchedule[0]["element"]) == 1, "Une seule ressource schedule doit être présente pour un RPPS appelé"
  
        
        assert (NombreLieu[0]["element"]) == 1, "Une seule ressource Location doit être présente pour ce RPPS"
        #verification présence des 4 principales ressources dans le Bundle
        assert(evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").exists() and entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").exists() and entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").exists() and entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").exists()'))
        
        
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
        
        NbCreneauxAvantDebut = evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator" and resource.start < now()).count()')
        
        add_message('info', "Nb créneaux avant date début: " + NbCreneauxAvantDebut[0]["element"].to_s)  


        
        date_debut = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").resource.start')
        threshold = scratch[:DateFin]

         date_debut.each_with_index do |date_hash, int|
          date_str = date_hash["element"]
          date = Date.parse(date_str)
          add_message('info', "Date début: " + date.to_s)  
          assert date <= Date.parse(threshold), "La date #{date} n'est pas supérieure à la date de fin de la recherche #{threshold}"
        end

        #Vérification présence dates fin
        date_fin = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").resource.end.exists()')
        assert(date_fin[0]["element"].to_s == 'true', "tous les ressources Slot doivent avoir une date de fin")

        #Vérification date début < date fin
        Boolean_start_end = evaluate_fhirpath(resource: bundle, path:'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").resource.all(start<end)')
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

         reference_organization = evaluate_fhirpath(
          resource: bundle,
          path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-healthcareservice-aggregator").resource.providedBy.reference'
        )

        organization_id = evaluate_fhirpath(
        resource: bundle, 
        path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").resource.id'
        )

      add_message('info', "Reference Organization: " + reference_organization[0]["element"].to_s)  
      assert(reference_organization[0]["element"].to_s == "Organization/" + organization_id[0]["element"].to_s, "Il est attendu que l'identifiant de l'organization #{organization_id} matche la reference #{reference_organization}")

      value =  reference_schedule.map { |item| item['element'].to_s }
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


      lst_references_healthcareservice = evaluate_fhirpath(
         resource: bundle, 
        path: 'entry.resource.where(meta.profile = "https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").serviceType.where(coding.code = "604").extension.where(url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-Slot.serviceType" and value is Reference).value.reference'
      )

      healthcareserviceid = evaluate_fhirpath(
         resource: bundle, 
        path: 'entry.where(resource.meta.profile = "https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-healthcareservice-aggregator").resource.id'
      )

      liste =  lst_references_healthcareservice.map { |item| item['element'].to_s }
      liste_concat = liste.join(', ')
      add_message('info', "References Healthcare Service : " + liste_concat)

      lst_references_healthcareservice.each_with_index do |reference, int|
          lst_references_healthcareservice = reference["element"].to_s
          assert(lst_references_healthcareservice == "HealthcareService/" + healthcareserviceid[0]["element"].to_s, "La référence dans la ressource Slot doit être égale à l'identifiant de la ressource HealthcareService: #{healthcareserviceid[0]["element"].to_s}")
        end

      end
    end


    test do
        title 'Contrôle présence adresse professionnel de santé'
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

      end
    end


    test do
        title 'Vérification Identifiant CPTS'
      description %(
       Format et valeur identifiant CPTS
      )
      run do
        bundle = scratch[:Bundle]
        IDNST = scratch[:IDNST]
        
        IDNSTrecupere = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").resource.identifier.value')   
        add_message('info', "Identifiant de la CPTS: " + IDNSTrecupere[0]["element"].to_s) 
        assert ((IDNSTrecupere[0]["element"]) == IDNST), "l\'identifiant retourné doit être égal à l'identifiant indiqué dans les paramètres"
        assert (IDNSTrecupere[0]["element"].to_s =~ /\A1[0-9]{9}\z/) , "L\'identifiant retourné doit comporter 9 chiffres préfixés par 1"
        
      end
    end

    test do
        title 'Test champ URL'
      description %(
        vérification syntaxr URL
      )
      run do
        query = scratch[:query]
        bundle = scratch[:Bundle]
        URL = evaluate_fhirpath(
        resource: bundle, 
        path: 'link.url'
        )

        assert(query = URL[0]["element"].to_s)
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
        path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").resource.all(
          comment.exists() and comment.empty().not() and comment.matches("^[[:space:]]*$").not())'
        )

        assert(PresenceURLPRDV[0]["element"].to_s == 'true', "Une URL de prise de RDV (champ Comment) doit être présente sur chacun des créneaux")
        add_message('info', "Présence URL pour chaque slot: " + PresenceURLPRDV[0]["element"].to_s)

      end
    end

  end
end
