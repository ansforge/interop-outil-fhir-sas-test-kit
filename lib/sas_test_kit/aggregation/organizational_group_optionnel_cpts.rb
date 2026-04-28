module SasTestKit
  class OrgaOptionelGroupCPTS < Inferno::TestGroup
    title 'Contrôles Organization - Champs optionnels'
    description 'Contrôles des données optionnelles de la structure'
    id :orga_optionnel_group_cpts

    
   test do
      title 'Recherche par RPPS - Initialisation requête'

      input :practitioner_id,
            title: 'RPPS',
            description: 'Renseigner le RPPS (préfixé par 8) d\'un PS ne possédant qu\'un lieu et avec au moins un créneau lié à une CPTS'

      run do

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

        assert_response_status(200)
        assert_resource_type('Bundle')
    
      end
      
    end

    
     test do
        title 'Vérification nom CPTS'
      description %(
       Vérification présence nom CPTS
      )
      run do
        bundle = scratch[:Bundle]
        
        NomCPTS = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").resource.name')   
        add_message('info', "Nom CPTS: " + NomCPTS[0]["element"].to_s) 
      
        assert ( NomCPTS != nil), "Le nom de la CPTS doit être présent"
        
      end
    end

     test do
        title 'Vérification téléphone CPTS'
      description %(
       Vérification présence téléphone CPTS
      )
      run do
        bundle = scratch[:Bundle]
        
        TelCPTS = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").resource.telecom.value')   
        add_message('info', "Nom CPTS: " + TelCPTS[0]["element"].to_s) 
      
        assert ( TelCPTS != nil), "Le téléphone de la CPTS doit être présent"
        
      end
    end

  end
end
