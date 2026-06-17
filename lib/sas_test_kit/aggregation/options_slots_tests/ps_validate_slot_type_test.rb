module SasTestKit
    module OptionSlot
        class ValidateSlotType < Inferno::Test
            title 'Vérification types de créneaux'
            id :ps_validate_slot_type
            short_id '4.7.02'
            description %(
            Verification type de créneaux
            )
            verifies_requirements 'agg-psindiv@23', 'agg-psindiv@46'

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
                      value: 'PRIVATE'
                    }
                  ]
                }
        
            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

                lst_type_creneaux_retournes = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur").resource.meta.security.code.distinct()')   
                str_creneaux = ""
                lst_type_creneaux_retournes.each_with_index do |type_creneau, int|
                str_creneaux = str_creneaux + type_creneau["element"].to_s + " " 
                end

                str_creneaux_dispo = ""
                type_slot.each_with_index do |type_creneau, int|
                str_creneaux_dispo = str_creneaux_dispo + type_creneau.to_s + " "
                end  

                add_message('info', "types de créneaux retournés: " + str_creneaux.to_s) 
                add_message('info', "types de slot disponibles: " + str_creneaux_dispo.to_s) 

                normalize = ->(s) {
                    s.split(' ')
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
    end
end