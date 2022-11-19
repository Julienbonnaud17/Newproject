#! /bin/sh
#? Nous aurons besoin de plusieurs argument pour rendre le code dynamique
#? Autoriser l acces au script ( chmod 777 projet.sh )
#? $1 type du projet ( ss, s, r, sr ) ( ss = full symfo, s = symfo api, r = react, sr = symfo api et react )
#? $2 nom du projet
#* exemple ( ./projet.sh ss sstest )
#TODO enlever le login auto quand register, réussir a envoyer le mail
type=$1
name=$2

symfoConfig()
{
    while true; do
    read -p "Inscription / connexion ? (y/n) " yn
    case $yn in 
        y ) echo "yes" | echo "email" | echo "yes" | echo "User" | php bin/console make:user;
            php bin/console d:s:u --force;
            # echo "yes" | echo "SecurityController" | echo "LoginFormAuthenticator" | echo "1" | 
            php bin/console make:auth;
            # Remplace la ligne 53 et 54  LoginFormAuthenticator.php ( redirection login )
            sed -i "50s/.*/        return new RedirectResponse(\$this->urlGenerator->generate('app_index'));/" src/Security/LoginFormAuthenticator.php;
            sed -i "51s/.*/ /" src/Security/LoginFormAuthenticator.php;
            composer require symfony/google-mailer;
            composer require symfonycasts/verify-email-bundle;
            echo 'yes' | echo 'Getsu' | echo 'getsugatenshu17@gmail.com' | echo 'no' | echo 'yes' | echo 'yes' | php bin/console make:registration-form;
            sed -i "52s/.*/                    ->from(new Address(\$request->server->get('EMAIL'), \$request->server->get('EMAIL_NAME')))/" src/Controller/RegistrationController.php;
            php bin/console d:s:u --force;
            echo "# Variable de connexion a la BDD
DATABASE_URL=\"mysql://explorateur:Ereul9Aeng@127.0.0.1:3306/$name?serverVersion=mariadb-10.3.25\"
# connexion mail
MAILER_DSN=\"gmail://braveheart.clashofclan:mgtrrropwnmendjx@localhost\"
# email du site
EMAIL=\"braveheart.clashofclan@gmail.com\"
# Nom de l expediteur des mails
EMAIL_NAME=\"Getsu\"
" > .env.local
            cp -R ../base-projet/ss/Security/UserChecker.php ./src/Security/
            sed -i "2a\    form_themes: ['bootstrap_5_layout.html.twig']" config/packages/twig.yaml
            sed -i "1a\    enable_authenticator_manager: true" config/packages/security.yaml
            sed -i "5a\        App\\\Entity\\\User:" config/packages/security.yaml
            sed -i "6a\            algorithm: auto" config/packages/security.yaml
            sed -i "21a\            user_checker: App\\\Security\\\UserChecker" config/packages/security.yaml
            sed -i "27s/.*/                target: app_index/" config/packages/security.yaml
            sed -i "37a\        - { path: ^/backoffice, roles: ROLE_ADMIN }" config/packages/security.yaml
            sed -i "39d" config/packages/security.yaml
            sed -i "38a\ " config/packages/security.yaml
            sed -i "38a\    role_hierarchy:" config/packages/security.yaml
            sed -i "39a\        ROLE_MODO: ROLE_USER" config/packages/security.yaml
            sed -i "40a\        ROLE_ADMIN: ROLE_MODO" config/packages/security.yaml
            sed -i "41a\        ROLE_SUPER_ADMIN : ROLE_ADMIN" config/packages/security.yaml
            sed -i "42a\ " config/packages/security.yaml
            break;;
        n ) exit;;
        * ) echo réponse invalide, choisit 'y' ou 'n';;
    esac
    done
}

#! full Symfony
if [ "$type" = "ss" ]
    then
        echo 'p' | composer create-project symfony/website-skeleton $name
        cd $name/
        echo 'a' | composer require symfony/apache-pack
        touch .env.local
        echo "# Variable de connexion a la BDD
DATABASE_URL=\"mysql://explorateur:Ereul9Aeng@127.0.0.1:3306/$name?serverVersion=mariadb-10.3.25\"
" > .env.local
        php bin/console doctrine:database:create
        php bin/console d:s:u --force
        cp -R ../base-projet/ss/public/.htaccess ./public/
        cp -R ../base-projet/ss/Command ./src/
        cp -R ../base-projet/ss/Controller/MainController.php ./src/Controller/
        cp -R ../base-projet/ss/templates/main ./templates/

        symfoConfig
        
        code .
fi

#!  Symfony API
if [ "$type" = "s" ]
    then
        echo 'p' | composer create-project symfony/website-skeleton $name
        cd $name/
        echo 'a' | composer require symfony/apache-pack
        touch .env.local
        echo "# Variable de connexion a la BDD
        DATABASE_URL=\"mysql://explorateur:Ereul9Aeng@127.0.0.1:3306/$name?serverVersion=mariadb-10.3.25\"
        " > .env.local
        php bin/console doctrine:database:create
        php bin/console d:s:u --force

        code .
fi

#! React
if [ "$type" = "r" ]
    then
        mkdir $name
        cd $name/
        cp -a ../base-projet/React-model/. .
        yarn
        yarn add react-bootstrap bootstrap
        yarn add react-icons --save

        code .
fi

#! Symfony API et React
if [ "$type" = "sr" ]
    then
        mkdir $name
        cd $name/
        echo 'p' | composer create-project symfony/website-skeleton back
        cd back/
        echo 'a' | composer require symfony/apache-pack
        touch .env.local
        echo "# Variable de connexion a la BDD
        DATABASE_URL=\"mysql://explorateur:Ereul9Aeng@127.0.0.1:3306/$name?serverVersion=mariadb-10.3.25\"
        " > .env.local
        php bin/console doctrine:database:create
        php bin/console d:s:u --force
        
        cd ../
        mkdir front
        cd front/
        cp -a ../../base-projet/React-model/. .
        yarn
        yarn add react-bootstrap bootstrap
        yarn add react-icons --save

        cd ../
        code .
fi
