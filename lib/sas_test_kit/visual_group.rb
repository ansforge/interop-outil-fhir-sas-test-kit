module SasTestKit
  class VisualGroup < Inferno::TestGroup
    title 'Attestation (Prérequis, fonctionnalités, ...) '
    description 'Verification des prérequis et des  fonctionnalités du logiciel'
    id :visual_group

    test do
      title 'Gestion du RPPS pour les professionels de santé'
      description %(
          Gestion du RPPS pour les professionels de santé
      )
      id 'Test01a'
      input :gestion_rpps,
            title: 'Est-ce que logiciel utilise l\'IDNPS (RPPS) pour identifier les professionnels de santé ?',
            type: 'radio',
            default: 'false',
            options: {
              list_options: [
                {
                  label: 'Oui',
                  value: 'true'
                },
                {
                  label: 'Non',
                  value: 'false'
                }
              ]
            }
      input :gestion_rpps_notes,
            title: 'Commentaire (en option)',
            type: 'textarea',
            optional: true

      run do
        pass gestion_rpps_notes 
      end
    end

     test do
      title 'Caractère obligatoire du RPPS'
      description %(
          Caractère obligatire du RPPS
      )
      id 'Test02a'
      input :gestion_rpps_obligatoire,
            title: 'Est-ce que tous les PS de la solution possèdent un IDNPS (RPPS) ?',
            type: 'radio',
            default: 'false',
            options: {
              list_options: [
                {
                  label: 'Oui',
                  value: 'true'
                },
                {
                  label: 'Non',
                  value: 'false'
                }
              ]
            }   
      output :selected_format
      
        
      input :gestion_rpps_obligatoire_notes,
            title: 'Commentaire (en option)',
            type: 'textarea',
            optional: true

      run do
        pass gestion_rpps_obligatoire_notes 
        add_message('info', "Gestion RPPS obligatoire : " + gestion_rpps_obligatoire.to_s) 
      end
    end

    test do
      title 'Gestion de l\'IDNST pour les structures'
      description %(
          Gestion de l\'IDNST pour les stuctures
      )
      id 'Test02'
      input :gestion_idnst,
            title: 'Est-ce que logiciel utilise l\'IDNST (FINESS, SIRET,RRPS Rang) pour identifier les structures ?',
            type: 'radio',
            default: 'false',
            options: {
              list_options: [
                {
                  label: 'Oui',
                  value: 'true'
                },
                {
                  label: 'Non',
                  value: 'false'
                }
              ]
            }
      input :gestion_idnst_notes,
            title: 'Commentaire (en option)',
            type: 'textarea',
            optional: true

      run do
        pass gestion_idnst_notes 
      end
    end

  end
end
