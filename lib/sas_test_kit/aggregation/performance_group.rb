require_relative '../sas_options.rb'
require_relative 'setup_helper.rb'

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
    verifies_requirements 'agg-psindiv@4', 'agg-psindiv@6', 'agg-psindiv@7','agg-psindiv@26', 'agg-psindiv@27', 'agg-psindiv@28', 'agg-psindiv@29', 'agg-psindiv@30'
    input :practitioner_id,
          title: 'RPPS',
          description: 'Renseigner le RPPS (préfixé par 8) d\'un PS ne possédant qu\'un lieu'

    input_order :base_url, :mTLS, :practitioner_id

    test do
      title 'Test de performance'

      run do
        wait_time = 1
        start = Time.now
        used_time = 0

        date_range = SetupHelper.calculate_date_range
        formatted_id = SetupHelper.format_practitioner_id(practitioner_id)

        params = SetupHelper.build_slot_search_params(
            formatted_id,
            date_range,
            config.options[:launch_version]
        )

        mTLS == 'true' ? fhir_search('Slot', params: params) : fhir_search('Slot', params: params, client: :no_mTLS)

        assert_response_status(200)
        assert_resource_type('Bundle')
        used_time = Time.now - start
        add_message('info', "Temps de réponse : " + used_time.to_s) 
        assert used_time < 1, 'Temps de réponse supérieur à 1 seconde'        
      end
    end
  end
end
