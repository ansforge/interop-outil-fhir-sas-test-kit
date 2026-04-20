require_relative 'v1_creation_regulateur_idnps_test'
require_relative 'v1_creation_regulateur_uuid_test'
require_relative 'v1_creation_double_regulateur_test'
require_relative 'v1_creation_regulateur_champs_manquants_test'
require_relative 'v1_creation_regulateur_valeurs_invalides'
require_relative 'v1_modification_email_regulateur_test'
require_relative 'v1_modification_id_regulateur_test'
require_relative 'v1_modification_typeid_regulateur_test'
require_relative 'v1_modification_nom_regulateur_test'
require_relative 'v1_modification_prenom_regulateur_test'
require_relative 'v1_modification_regulateur_champs_manquants_test'
require_relative 'v1_put_as_create_missing_fields_test'
require_relative 'v1_modification_deshabilitation_test'
require_relative 'v1_modification_habilitation_test'
require_relative 'v1_put_as_create_test'
require_relative 'v1_idnps_reattribution_test.rb'

<<<<<<< HEAD

=======
>>>>>>> origin/dev
module SasTestKit
    class FluxV1Group < Inferno::TestGroup
        title "Gestion des comptes régulateurs - Flux V1"
        description %(
            ## Description

            Ce groupe regroupe un ensemble de tests de conformité relatifs au **flux V1 de gestion des comptes régulateurs**, tel que défini dans les spécifications techniques SAS publiées par l'ANS.  
            Ces tests valident le comportement du serveur vis-à-vis des opérations FHIR attendues autour de la ressource **Practitioner** profilée en *FrPractitionerRegul*, conformément au document officiel « Gestion des comptes régulateurs » [1](https://esante.gouv.fr/sites/default/files/media_entity/documents/sas_spec-int_r02_gestion-des-comptes-regulateurs_v2.0.pdf) et au guide SAS v1.2.0 [2](https://interop.esante.gouv.fr/ig/fhir/sas/).

            Le groupe vérifie notamment :

            ### Création d'un compte régulateur
            - Création via identifiant **IDNPS** (`system: urn:oid:1.2.250.1.71.4.2.1`).  
            - Création via identifiant **UUID éditeur** (`system: urn:oid:1.2.250.1.213.3.6`).  
            - Conformité des champs obligatoires  
            - Détection des tentatives de **création en doublon**, conformément à la règle d'unicité du régulateur (un seul compte actif par identifiant).  
            - Gestion des valeurs invalides ou incohérentes dans les structures FHIR.

            ### Modification d'un compte régulateur existant
            - Mise à jour de l'**email**, du **nom**, du **prénom**, du **type d'identifiant**, ou des systèmes d'identification.  
            - Test des cas d'erreur attendus (format incorrect, champs manquants, incohérences système/code).

            ### Habilitation et déshabilitation
            - Passage du champ **`active` à `false`** (déshabilitation du compte), rendant l'identifiant réattribuable selon les règles métier SAS.  
            - Réactivation via **`active = true`** (habilitation).  
            - Vérification du comportement du serveur pour refléter correctement l'état opérationnel du régulateur.

            ---

            Ce groupe assure ainsi la **conformité** de l'implémentation serveur à l'ensemble du périmètre fonctionnel du **flux V1 SAS**, garantissant l'intégration correcte des comptes régulateurs dans l'écosystème du Service d'Accès aux Soins.
        )
        id :flux_v1_group

        input :base_url

        input :regulator_id,
            title: 'ID du régulateur (format IDNPS)',
            default: '3456780581/11242343'
        
        input :regulator_id_modif,
            title: 'ID du régulateur pour modification',
            description: 'ID différent de celui utilisé pour la création du compte régulateur',
            default: '3456780581/11242344'
        
        input :regulator_mail,
            title: 'Email du régulateur',
            default: 'sebastien.loridon@test.com'

        input :regulator_mail_modif,
            title: 'Email du regulateur pour modification',
            description: 'Email différent de celui utilisé pour la création du compte régulateur',
            default: 'sebastien.loridon.modif@test.com'
        
        input :regulator_first_name,
            title: 'Prénom du régulateur',
            default: 'Sébastien'
        
        input :regulator_first_name_modif,
            title: 'Prénom du régulateur pour modification',
            description: 'Prénom différent de celui utilisé pour la création du compte régulateur',
            default: 'Sébastien-modif'
        
        input :regulator_last_name,
            title: 'Nom du régulateur',
            default: 'Loridon'

        input :regulator_last_name_modif,
            title: 'Nom du régulateur pour modification',
            description: 'Nom différent de celui utilisé pour la création du compte régulateur',
            default: 'Loridon-modif'
        
        input :resource_id,
            title: 'ID de la ressource à récupérer',
            default: 'example-regulator-1'

        run_as_group

        http_client do
            url :base_url  
            headers(
                'Content-Type' => 'application/json',
                'Accept'       => 'application/fhir+json'
                )
        end

        test from: :creation_regulateur_idnps_test

        test from: :creation_regulateur_uuid_test

        test from: :creation_double_regulateur_uuid_test

        test from: :creation_regulateur_champs_manquants_test

        test from: :creation_regulateur_valeurs_invalides

        test from: :modification_deshabilitation

        test from: :modification_habilitation

        test from: :modification_email_regulateur_test

        test from: :modification_id_regulateur_test 

        test from: :modification_typeid_regulateur_test

        test from: :modification_nom_regulateur_test 

        test from: :modification_prenom_regulateur_test

        test from: :modification_regulateur_champs_manquants_test

        test from: :put_as_create_missing_fields_test

        test from: :put_as_create

        test from: :idnps_reattribution_test
    end
end