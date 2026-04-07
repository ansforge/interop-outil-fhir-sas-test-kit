module SasTestKit
  class SlotGroupPS < Inferno::TestGroup
    title 'Slot Tests'
    description 'Verification sur Slot'
    id :slot_group_ps

    test do
      optional
      title 'Test lecture slot'
      description %(
        Verification  que le serveur renvoie la ressource Slot passée en paramètre
      )

      input :slot_id,
            title: 'Slot ID',
            default: '3364560'


      # Named requests can be used by other tests
      makes_request :slot 

      run do
        fhir_read(:slot, slot_id)
 
        assert_response_status(200)
        assert_valid_json(request.response_body)
        assert_resource_type(:slot)
        #assert resource.id == slot_id,
        #       "Requested resource with id #{slot_id}, received resource with id #{resource.id}"
        assert_valid_resource(validator: :validator_sas)
        #assert_valid_resource(profile_url: 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator')                
      end
    end

    test do
      title 'Test recherche par slot - renvoi Bundle'
      description %(
        Verifier la recherche par ressource Slot et le renvoie d'un Bundle
      )

      input :practitioner_id,
            title: 'RPPS',
            default: '810101603008'

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
    
        hash = {
        _include: 'Slot:schedule', 
        '_include:iterate': 'Schedule:actor',
        'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|'+ practitioner_id,
        start: ["ge#{formatted_start_date}.000", "le#{formatted_end_date}.000"],
        status: 'free'
        }

        
      
        fhir_search('Slot', params: hash)
  
        
        assert_response_status(200)
        assert_resource_type('Bundle')
        #verification content type
        warning do
          assert_response_content_type('application/fhir+json')
        end
        
        #A corriger avec fhir path evaluation assert (resource.entry.where(resource.resourceType='Slot').count()) > resource.total
        #output body: resource.to_json
        results = evaluate_fhirpath(resource: resource, path: 'total')      
        results1 = evaluate_fhirpath(resource: resource, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").count()')
        add_message('info', "Total (bundle) : " + results[0]["element"].to_s + "/ Total Slot (Calculé) : " + results1[0]["element"].to_s) 
        warning do
        assert (results[0]["element"]) == (results1[0]["element"]), "le valeur de total doit être égale au nombre de ressources slot dans le Bundle"
        end
        
      
        assert_valid_resource(profile_url: 'http://sas.fr/fhir/StructureDefinition/BundleAgregateur', validator: :validator_sas)  
        #assert_valid_resource(validator: :validator_sas)
       
      end
    end

  end
end
