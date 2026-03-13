require_relative 'setup_test'

module MyTestKit
  class PractiOptionelGroupPS < Inferno::TestGroup
    title 'Contrôles Practitioner - Champs optionnels'
    description 'Contrôles des données optionnelles du PS'
    id :practi_optionnel_group_ps

    input :practitioner_id,
            title: 'RPPS',
            description: 'Renseigner le RPPS (préfixé par 8) d\'un PS avec nom, prénom et téléphone',
            default: '810100901734'

    test from: :slot_search_setup do
      config(
        inputs: { 
          practitioner_id: { name: :practitioner_id },
        }
      )
    end
    
     test do
        title 'Vérification RPPS'
      description %(
       Format RPPS
      )
      run do
        bundle = scratch[:Bundle]
        IDNPS = scratch[:IDNPS]
        
        RPPSrecupere = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource.identifier.value')   
        add_message('info', "RPPS: " + RPPSrecupere[0]["element"].to_s) 
      
        assert( ((RPPSrecupere[0]["element"]) == IDNPS), "le RPPS retourné doit être égal au RPPS appelé")
        assert( (RPPSrecupere[0]["element"].to_s =~ /\A8[0-9]{11}\z/) , "le RPPS retourné doit comporter 11 chiffres préfixés par 8")
        
      end
    end


     test do
        title 'Vérification présence nom PS'
      description %(
       Vérification présence nom PS
      )
      run do
        bundle = scratch[:Bundle]
        
        Nom = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource.name.family')   
        add_message('info', "Nom de famille: " + Nom[0]["element"].to_s) 
      
        assert( (RPPSrecupere[0]["element"].to_s =~ /\A8[0-9]{11}\z/) , "le RPPS retourné doit comporter 11 chiffres préfixés par 8")
       
        
      end
    end

     test do
        title 'Vérification présence prénom PS'
      description %(
       Vérification présence prénom PS
      )
      run do
        bundle = scratch[:Bundle]
        
        Prenom = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource.name.given')   
        add_message('info', "Prénom: " + Prenom[0]["element"].to_s) 
      
        assert( ( Prenom != nil), "Le prénom doit être présent")
        assert( ( Prenom[0]["element"] != nil && !Prenom[0]["element"].empty?) , "Le prénom doit être renseigné")
        
      end
    end
  
    test do
        title 'Vérification numéro de téléphone PS'
      description %(
       Vérification numéro de téléphone PS
      )
      optional
      run do
        bundle = scratch[:Bundle]
        
        Telephone = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.telecom.value')   
        add_message('info', "Télephone: " + Telephone&.dig(0, "element").to_s) 
      
       #Gérer les ifnull
      value = Telephone&.dig(0, "element").to_s
      assert( value && !value.empty?, "Le numéro de téléphone est manquant")
       
      
      FormatsTel = [
      /^\+33\d{9}$/,
      /^\+262\d{9}$/,
      /^\+590\d{9}$/,
      /^\+596\d{9}$/,
      /^\+594\d{9}$/
      ]

      assert((Regexp.union(FormatsTel).match?(Telephone&.dig(0, "element").to_s)), "le numéro de téléphone doit être au bon format")
        
      end
    end

  end
end
