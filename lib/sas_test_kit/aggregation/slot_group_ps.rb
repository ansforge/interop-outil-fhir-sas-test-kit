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

    test from: :slot_search_setup do
        config(
            inputs: { 
                practitioner_id: { name: :practitioner_id },
            }
        )
    end

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
      run do
        bundle = scratch[:Bundle]
        skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle)
        
        assert_resource_type('Bundle', resource: bundle)
        assert_valid_resource(resource: bundle, profile_url: 'http://sas.fr/fhir/StructureDefinition/BundleAgregateur', validator: :validator_sas)  
      end
    end
  end
end
