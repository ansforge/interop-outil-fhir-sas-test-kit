require_relative 'setup_helper'

module MyTestKit
  class SlotSearchSetupGroup < Inferno::Test
    title 'Setup - Recherche Slot par RPPS'
    description 'Initialisation et recherche Slot - Prépare les données pour les tests suivants'
    id :slot_search_setup

    input :practitioner_id,
          title: 'RPPS',
          description: 'Renseigner le RPPS (préfixé par 8)',
          default: '810100901734'

    input :practitioner_id_opt,
          title: 'RPPS secondaire',
          description: 'Renseigner un deuxième RPPS optionnel (préfixé par 8)',
          optional: true,
          hidden: true

    title 'Recherche par RPPS - Initialisation requête'
    description 'Effectue la recherche Slot et stocke les résultats pour les tests du groupe'

    run do
        # Calcul des dates
        date_range = SetupHelper.calculate_date_range
        formatted_id = SetupHelper.format_practitioner_id(practitioner_id, practitioner_id_opt)

            
        # Construction des paramètres
        params = SetupHelper.build_slot_search_params(
            formatted_id,
            date_range,
            suite_options[:launch_version],
        )
            
        # Exécution de la recherche
        fhir_search('Slot', params: params)
        add_message('info', "Requête FHIR effectuée avec les paramètres: #{params.to_json}")
        assert_response_status(200)

        # Stockage pour tous les tests du groupe
        scratch[:Bundle] = resource
        scratch[:IDNPS] = practitioner_id
        scratch[:DateFin] = date_range[:end]
        scratch[:query] = request.url
    
        assert_resource_type('Bundle')
        warning do
            assert_response_content_type('application/fhir+json')
        end
    end
  end
end