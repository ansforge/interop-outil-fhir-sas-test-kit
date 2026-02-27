# SAS TEST KIT

Le **SAS TEST KIT** est un kit de test [inferno](https://inferno-framework.github.io/) pour le guide d'implémentation du **SAS** [v1.2](https://interop.esante.gouv.fr/ig/fhir/sas/index.html).  
Ce kit de test fournit des tests d'intéropérabilité avec la plateforme du **SAS**.

## Démarrage rapide

### Démarrage en local

La manière la plus rapide de lancer ce kit de test en local est d'utiliser [Docker](https://www.docker.com/).

- Installer Docker
- Cloner ce dépôt
- Lancer `./setup.sh` à l'intérieur du dossier du kit de test pour télécharger les dépendances nécessaires
- Lancer `./run.sh` à l'intérieur du dossier du kit de test pour lancer l'application
- Se connecter à `http://localhost`

Se référer à la [Documentation Inferno](https://inferno-framework.github.io/docs/getting-started-users.html#running-an-existing-test-kit) 
pour plus d'information sur le lancement d'Inferno en local.