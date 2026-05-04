require_relative 'setup_test'

module SasTestKit
  class OrgaOptionelGroupCPTS < Inferno::TestGroup
    title 'Contrôles Organization - Champs optionnels'
    description 'Contrôles des données optionnelles de la structure'
    id :orga_optionnel_group

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
        add_message('info', "Nom CPTS: " + TelCPTS[0]["element"].to_s) 
      
        assert ( TelCPTS != nil), "Le téléphone de la CPTS doit être présent"
        
      end
    end

  end
end
