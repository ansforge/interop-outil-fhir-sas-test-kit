module SasTestKit
  class SlotGroupPS < Inferno::TestGroup
    title 'Validation du bundle'
    description %(
      ## Description

      Ce groupe de tests a pour objectif de valider la conformité des réponses
      retournées par le serveur lors d'une recherche de ressources Slot.

      Les tests portent sur la structure globale du Bundle renvoyé, sa conformité
      aux profils FHIR attendus, ainsi que sur la cohérence entre les métadonnées
      du Bundle et les ressources Slot qu'il contient.

      Ce test group vise à s'assurer que le serveur est capable de répondre
      correctement à une requête de recherche Slot, en respectant les spécifications
      fonctionnelles et de structure définies pour l'agrégation de créneaux.
    )
    id :slot_group_ps

    test do
      title 'Test recherche par slot - renvoi Bundle'
      description %(
        Ce test vérifie qu'une recherche sur la ressource Slot aboutit au renvoi
        d'un Bundle conforme.

        Il contrôle notamment :
        - le succès de la requête de recherche,
        - le type de ressource retournée (Bundle),
        - la conformité du Bundle au profil FHIR d'agrégation attendu.

        L'objectif est de garantir que la recherche Slot fournit un résultat
        exploitable et conforme aux exigences de l'API.
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
        start: ["ge#{formatted_start_date}.000+00", "le#{formatted_end_date}.000+00"],
        status: 'free'
        }

        mTLS == 'true' ? fhir_search('Slot', params: hash) : fhir_search('Slot', params: hash, client: :no_mTLS)  
        
        assert_response_status(200)
        assert_resource_type('Bundle')
      
        assert_valid_resource(profile_url: 'http://sas.fr/fhir/StructureDefinition/BundleAgregateur', validator: :validator_sas)  
      end
    end

  end
end
