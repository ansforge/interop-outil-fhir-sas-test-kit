module SasTestKit
  class VisualGroup < Inferno::TestGroup
    title 'Tests déclaratifs (prérequis, fonctionnalités,...)'
    description 'Verification des prérequis et des  fonctionnalités du logiciel'
    id :visual_group

    input_order :gestion_rpps, :gestion_rpps_notes, :gestion_rpps_obligatoire, :gestion_rpps_obligatoire_notes, :gestion_idnst,:gestion_idnst_notes, :conformite_hds, :conformite_hds_notes, :authentification_mfa, :authentification_mfa_notes, :access_restriction, :access_restriction_notes

    test do
      title 'Gestion du RPPS pour les professionels de santé'
      description %(
          Gestion du RPPS pour les professionels de santé
      )
      id 'Test01a'
      input :gestion_rpps,
            title: 'Est-ce que la solution utilise l\'IDNPS (RPPS) pour identifier les professionnels de santé ?',
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
            type: 'text',
            optional: true

      run do
        pass gestion_rpps_notes if gestion_rpps_notes.present?
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
            type: 'text',
            optional: true

      run do
        pass gestion_rpps_obligatoire_notes if gestion_rpps_obligatoire_notes.present?
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
            title: 'Est-ce que la solution utilise l\'IDNST (FINESS, SIRET,RRPS Rang) pour identifier les structures ?',
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
            type: 'text',
            optional: true

      run do
        pass gestion_idnst_notes if gestion_idnst_notes.present?
      end
    end

    test do
      title 'Conformité HDS'
      description %(
          Vérification de la conformité aux règles d'hébergement HDS
      )
      id 'hds'
      input :conformite_hds,
            title: "Est-ce que la solution est conforme aux règles d'hergement HDS",
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
      input :conformite_hds_notes,
            title: 'Commentaire (en option)',
            type: 'text',
            optional: true

      run do
        pass conformite_hds_notes if conformite_hds_notes.present?
      end
    end

    test do
      title 'Authentification multi-facteurs'
      description %(
          Vérification de la prise en charge de l'authentification multi-facteurs
      )
      id 'mfa'
      input :authentification_mfa,
            title: "Est ce que la solution met en place une authentification à deux facteurs pour les PS effecteurs ?",
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
      input :authentification_mfa_notes,
            title: 'Commentaire (en option)',
            type: 'text',
            optional: true
      run do
        pass authentification_mfa_notes if authentification_mfa_notes.present?
      end
    end

    test do
      title "Restriction d'accès"
      description %(
          Vérification de la mise en place de restrictions d'accès après X tentatives de connexion infructueuses
      )
      id 'access_restriction'
      input :access_restriction,
            title: "Est ce que la solution met en place une restriction d'accès après X tentatives en erreurs ?",
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
      input :access_restriction_notes,
            title: 'Commentaire (en option)',
            type: 'text',
            optional: true
      run do
        pass access_restriction_notes if access_restriction_notes.present?
      end
    end
  end
end
