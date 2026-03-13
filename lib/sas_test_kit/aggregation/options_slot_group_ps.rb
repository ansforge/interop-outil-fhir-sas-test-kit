require_relative 'setup_test'

module MyTestKit
  class OptionSlotGroupPS < Inferno::TestGroup
    title 'Options sur les créneaux'
    description 'Contrôles sur les données optionnelles des créneaux'
    id :optionslots_group_ps

    input :type_slot,
            title: 'Quels types de créneaux sont disponibles dans la solution ?',
            type: 'checkbox',
            options: {
              list_options: [
                {
                  label: 'Créneaux grand public',
                  value: 'PUBLIC'
                },
                {
                  label: 'Créneaux réservés aux professionnels',
                  value: 'PRO'
                },
                {
                  label: 'Créneaux typés SNP',
                  value: 'SNP'
                },
                {
                  label: 'Créneaux private',
                  value: 'private'
                }
              ]
            }

    input :type_consultation,
            title: 'Quels sont les types de consultations au niveau des créneaux ?',
            type: 'checkbox',
            options: {
              list_options: [
                {
                  label: 'Au cabinet',
                  value: 'AMB'
                },
                {
                  label: 'En téléconsultation',
                  value: 'VR'
                },
                {
                  label: 'Visite à domicile',
                  value: 'HH'
                }
              ]
            }       

    test from: :slot_search_setup do
      config(
        inputs: { 
          practitioner_id: { name: :practitioner_id },
        }
      )
    end

    test do
        title 'Vérification types de créneaux'
      description %(
       Verification type de créneaux
      )
    
      run do
        bundle = scratch[:Bundle]
    
        lst_type_creneaux_retournes = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.meta.security.code.distinct()')   
        str_creneaux = ""
        lst_type_creneaux_retournes.each_with_index do |type_creneau, int|
          str_creneaux = str_creneaux + type_creneau["element"].to_s + "," 
        end

        str_creneaux_dispo = ""
        type_slot.each_with_index do |type_creneau, int|
          str_creneaux_dispo = str_creneaux_dispo + type_creneau.to_s + ","
        end  

        add_message('info', "types de créneaux retournés: " + str_creneaux.to_s) 
        add_message('info', "types de slot disponibles: " + str_creneaux_dispo.to_s) 


       normalize = ->(s) {
        s.split(',')
       .map { |x| x.strip }
       .reject(&:empty?)
       .map(&:upcase)
       .to_set
        }

      returned_set  = normalize.call(str_creneaux)
      available_set = normalize.call(str_creneaux_dispo)

      manquants = available_set - returned_set
      supplementaire =  returned_set - available_set

      assert manquants.empty?, "Les types suivants prévus dans la solution ne sont pas retournés au niveau des créneaux : #{manquants.to_a.join(', ')}"
      assert supplementaire.empty?, "Les types suivants sont retournés au niveau des créneaux alors qu'ils ne sont pas déclarés comme disponibles dans la solution : #{supplementaire.to_a.join(', ')}"
      end
    end

     test do
        title 'Vérification types de consultation'
      description %(
       Verification types de consultation retournés
      )
    
      run do
        bundle = scratch[:Bundle]
    
        lst_type_consultation_retournes = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.serviceType.coding.code.distinct()')   
        str_consultation = ""
        lst_type_consultation_retournes.each_with_index do |type_consult, int|
          str_consultation = str_consultation + type_consult["element"].to_s + "," 
        end

        str_consultation_dispo = ""
        type_consultation.each_with_index do |type_consult, int|
          str_consultation_dispo = str_consultation_dispo + type_consult.to_s + ","
        end  

        add_message('info', "types de créneaux retournés: " + str_consultation.to_s) 
        add_message('info', "types de slot disponibles: " + str_consultation_dispo.to_s) 


       normalize = ->(s) {
        s.split(',')
       .map { |x| x.strip }
       .reject(&:empty?)
       .map(&:upcase)
       .to_set
        }

      returned_set  = normalize.call(str_consultation)
      available_set = normalize.call(str_consultation_dispo)

      manquants = available_set - returned_set
      supplementaire =  returned_set - available_set

      assert manquants.empty?, "Les types suivants prévus dans la solution ne sont pas retournés au niveau des créneaux : #{manquants.to_a.join(', ')}"
      assert supplementaire.empty?, "Les types suivants sont retournés au niveau des créneaux alors qu'ils ne sont pas déclarés comme disponibles dans la solution : #{supplementaire.to_a.join(', ')}"
      end
    end
  end
end
