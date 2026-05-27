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

      Ce groupe de test vise à s'assurer que le serveur est capable de répondre
      correctement à une requête de recherche Slot, en respectant les spécifications
      fonctionnelles et de structure définies pour l'agrégation de créneaux.
    )
    id :slot_group

    input_order :base_url, :mTLS, :practitioner_id
    verifies_requirements 'agg-psindiv@4', 'agg-psindiv@13', 'agg-psindiv@14', 'agg-psindiv@26', 'agg-psindiv@27', 'agg-psindiv@28', 'agg-psindiv@29', 'agg-psindiv@30'

    test from: :slot_search_setup do
        config(
            inputs: { 
                practitioner_id: { name: :practitioner_id },
            }
        )
    end

    test do
      title 'Vérification du Bundle par le validateur'
      description %(
        Ce test vérifie la validité d'un Bundle FHIR. 

        Il contrôle notamment :
        - le type de ressource retournée (Bundle),
        - la conformité du Bundle au profil FHIR d'agrégation attendu.
      )
      verifies_requirements 'agg-psindiv@13', 'agg-psindiv@14'

      output :used_time
      run do
        bundle = scratch[:Bundle]
        skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle)
        
        BUNDLE_PROFILE_URL = suite_options[:launch_version] == 'ig_launch_1' ? 'http://sas.fr/fhir/StructureDefinition/BundleAgregateur' : 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-bundle-aggregator'

        start = Time.now
        assert_resource_type('Bundle', resource: bundle)
        assert_valid_resource(resource: bundle, profile_url: "#{BUNDLE_PROFILE_URL}", validator: :validator_sas)
        used_time = Time.now - start
        output used_time: used_time
      end
    end
  end
end
