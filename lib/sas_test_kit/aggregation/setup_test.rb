require_relative 'setup_helper'

module SasTestKit
  class SlotSearchSetupGroup < Inferno::Test
    title 'Setup - Recherche Slot par RPPS'
    description 'Initialisation et recherche Slot - Prépare les données pour les tests suivants'
    id :slot_search_setup

    input :practitioner_id,
          title: 'RPPS',
          description: 'Renseigner le RPPS (préfixé par 8)'

    input :practitioner_id_opt,
          title: 'RPPS secondaire',
          description: 'Renseigner un deuxième RPPS optionnel (préfixé par 8)',
          optional: true,
          hidden: true

    title 'Recherche par RPPS - Initialisation requête'
    description %(
        ## Description

        Ce test initialise la **recherche de créneaux (Slot)** pour un ou deux professionnels de santé (PS) identifiés par leur **RPPS**, conformément au fonctionnement attendu du flux Agrégateur dans les spécifications SAS.  
        Il effectue une requête `GET` vers la ressource **Slot**, en construisant dynamiquement les paramètres de recherche (période, identifiants, version de lancement).

        Les vérifications réalisées sont les suivantes :
        - **statut HTTP 200**, confirmant le bon déroulement de la requête ;
        - la réponse est bien un **Bundle FHIR valide** ;
        - le type de contenu retourné est **FHIR JSON** (`application/fhir+json`) ;

        Les ressources retournées et les paramètres utiles (Bundle, RPPS, date de fin, URL de la requête) sont placés en *scratch* afin d'être utilisés par l'ensemble des tests du groupe.

        Ce test constitue ainsi la **préparation indispensable** à l'exécution de tous les contrôles suivants du groupe.
    )

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
        add_message('info', "mTLS: #{mTLS}")
        if mTLS == 'true'
            fhir_search('Slot', params: params)
        else
            fhir_search('Slot', params: params, client: :no_mTLS)
        end
        add_message('info', "Requête FHIR effectuée avec les paramètres: #{params.to_json}")
        assert_response_status(200)

        # Stockage pour tous les tests du groupe
        scratch[:IDNPS] = practitioner_id
        scratch[:DateFin] = date_range[:end]
        scratch[:query] = request.url
    
        assert_resource_type('Bundle')
        assert(resource.entry != [], "Le Bundle est vide.")
        scratch[:Bundle] = resource
        warning do
            assert_response_content_type('application/fhir+json')
        end
    end
  end
end