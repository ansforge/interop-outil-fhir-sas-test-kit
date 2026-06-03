require_relative 'setup_test'

module SasTestKit
  class OrgaOptionelGroupCPTS < Inferno::TestGroup
    title 'Contrôles Organization - Champs optionnels'
    description 'Contrôles des données optionnelles de la structure'
    id :orga_optionnel_group
    verifies_requirements 'agg-psindiv@4', 'agg-psindiv@6', 'agg-psindiv@7','agg-psindiv@26', 'agg-psindiv@27', 'agg-psindiv@28', 'agg-psindiv@29', 'agg-psindiv@30'

    test from: :slot_search_setup do
      config(
        inputs: {
          practitioner_id: { name: :practitioner_id },
        }
      )
    end

     test do
        title 'Vérification nom CPTS'
      description %(
       Vérification présence nom CPTS
      )
      run do
        bundle = scratch[:Bundle]
        skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)

        NomCPTS = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").resource.name')
        assert(NomCPTS != nil && NomCPTS[0] != nil, "Aucune ressource correspondant au profil sas-cpts-organization-aggregator n'a été trouvée dans le bundle")
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
        skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
        
        TelCPTS = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").resource.telecom.value')
        assert(TelCPTS != nil && TelCPTS[0] != nil, "Aucune ressource correspondant au profil sas-cpts-organization-aggregator n'a été trouvée dans le bundle")  
        add_message('info', "Numéro de téléphone CPTS: " + TelCPTS[0]["element"].to_s) 
      
        assert ( TelCPTS != nil), "Le téléphone de la CPTS doit être présent"
        
      end
    end
  end
end
