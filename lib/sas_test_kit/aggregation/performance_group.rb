module SasTestKit
  class PerformanceGroup < Inferno::TestGroup
    title 'Temps de réponse'
    description %(
        # Description

        Ce groupe de tests permet de vérifier le temps de réponse du serveur
        lors d'une recherche de ressources Slot.

        Il contrôle que la requête aboutit correctement et que le temps de réponse
        reste inférieur au seuil attendu.
      )
    id :performance_group



    test do
      title 'Test de performance'
      

      input :practitioner_id,
            title: 'RPPS',
            default: '810100901734'

      run do

        wait_time = 1
        start = Time.now
        used_time = 0

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
    
        hash = {
        _include: 'Slot:schedule', 
        '_include:iterate': 'Schedule:actor',
        'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|'+ practitioner_id,
        start: ["ge#{formatted_start_date}.000+00", "le#{formatted_end_date}.000+00"],
        status: 'free'
        }

        mTLS == 'true' ? fhir_search('Slot', params: hash) : fhir_search('Slot', params: hash, client: :no_mTLS)



        assert_response_status(200)
        assert_resource_type('Bundle')
        used_time = Time.now - start        
        add_message('info', "Temps de réponse : " + used_time.to_s) 
        assert used_time < 1, 'Temps de réponse supérieur à 1 seconde' 
        
      end
    end

  end
end
