# SAS TEST KIT

Le **SAS TEST KIT** est un kit de test [inferno](https://inferno-framework.github.io/) pour le guide d'implémentation du **SAS** [v1.2](https://interop.esante.gouv.fr/ig/fhir/sas/index.html).  
Ce kit de test fournit des tests d'intéropérabilité avec la plateforme du **SAS**.

## Démarrage rapide

### Effectuer les tests sur notre instance publique

La plateforme [Gazelle](https://interop.esante.gouv.fr/) héberge une [instance publique](https://interop.esante.gouv.fr/inferno/sas) de ce kit de tests que les développeurs et testeurs sont invités à utiliser pour exécuter rapidement des tests sans installation locale.

### Démarrage en local

La manière la plus rapide de lancer ce kit de test en local est d'utiliser [Docker](https://www.docker.com/).

- Installer Docker
- Cloner ce dépôt ou installez une [release](https://github.com/ansforge/interop-outil-fhir-sas-test-kit/releases) officielle 
- Lancer `./setup.sh` à l'intérieur du dossier du kit de test pour télécharger les dépendances nécessaires
- Lancer `./run.sh` à l'intérieur du dossier du kit de test pour lancer l'application
- Se connecter à `http://localhost:4567`

Se référer à la [Documentation Inferno](https://inferno-framework.github.io/docs/getting-started-users.html#running-an-existing-test-kit) 
pour plus d'information sur le lancement d'Inferno en local.

## Utilisation du kit de test en CI / CD

Le SAS TEST KIT peut être intégré dans vos pipelines CI/CD afin de réaliser des tests de non-régression automatisés.

Un exemple de script est fourni dans le dossier `execution_scripts`.

### Configuration

- Le script de démonstration : `execution_scripts/demo_sas.yml`
- L'hôte cible est configuré via la variable d'environnement : `INFERNO_HOST`

### Exécution des tests

`bundle exec inferno execute_script execution_scripts/demo_sas.yml --no-compare-messages`

Se réferer à la [documentation inferno](https://inferno-framework.github.io/docs/advanced-test-features/scripting-execution) pour plus d'information sur l'utilisation des scripts d'execution en CI / CD.

### Validation des résultats

Les résultats des tests sont comparés avec le fichier : `execution_scripts/expected.json`

#### Fonctionnement

- Un diff est éffectué entre :
  - Les résultats attendus (`expected.json`)
  - Les résultats obtenus

#### Codes de retour

- 0 : aucun écart détecté
- 3 : différences détectées

#### Initialisation du fichier expected

Si le fichier expected.json est supprimé :
- Il sera automatiquement recréé lors du prochain lancement
- Il reflétera l'état actuel de votre implémentation

Ce qui est utile pour initialiser une base de référence stable.

#### Personnalisation

Vous êtes invité à adapter le fichier `execution_scripts/demo_sas.yml` selon vos besoins :
- Désactiver les tests non-applicables à votre implémentation