require_relative 'helper_fluxv2'

module SasTestKit
    class ConnexionWithPwdTest < Inferno::Test
        title "Connexion avec mot de passe"
        id :sso_with_pwd
        description %(
        ## Description

        Ce test est un test manuel, avec le jeu de données fourni suivez les étapes suivantes :
        1. Connnectez vous en login/mot de passe à la plateforme du SAS via le lien suivant : [page de connexion SAS](https://seconnecter.preproduction.santefr.esante.gouv.fr/realms/sas/protocol/openid-connect/auth?client_id=sas&response_type=code&scope=openid%20email%20profile%20pro_sante_connect&redirect_uri=https%3A//sas.preproduction.santefr.esante.gouv.fr/openid-connect/sas&state=cW3f5R37FDZOUHW2PySnEGLlIP6uT2xIfab93Qj7fx8&prompt=login%20login)
        2. Un lien de redirection vers un créneau de rendez-vous doit apparaître, cliquez dessus.

        Le succès du test est conditionné à l'affichage de l'agenda du PS ou bien à une page de réservation de rendez-vous fonctionnelle, indiquant que la connexion a été établie avec succès.
        )
        run do
            bundle = scratch[:Bundle]
            assert(bundle.present?, 'Bundle not found in scratch')
            
            sso_url = scratch[:sso_url] + "&origin=sas-preprod"
            add_message('info', "URL de redirection : #{sso_url}")
        end
    end
end