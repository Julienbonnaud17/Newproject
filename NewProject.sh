#! /bin/sh

# variable des couleurs
YELLOW='\033[1;93m' 
GREEN='\033[1;92m'
PURPLE='\033[1;95m'
RESET="\033[0m"

# Choix du projet
read -p "Choisissez le type de votre projet ( ex: 4 ):
[$(echo $YELLOW"1"$RESET)] Symfo ( back + front )
[$(echo $YELLOW"2"$RESET)] Symfo Api
[$(echo $YELLOW"3"$RESET)] React
[$(echo $YELLOW"4"$RESET)] Symfo Api & React
$(echo $PURPLE"-->"$RESET) " typeProject

# définition des fonctions
NameProject()
{
    read -p "Choisissez le nom de votre projet $1
$(echo $PURPLE"-->"$RESET) " nameProject
}

InstallSymfo()
{
    echo 'p' | composer create-project symfony/website-skeleton $fullNameBack
    cd $fullNameBack/
    echo 'a' | composer require symfony/apache-pack
    touch .env.local
    echo "# Variable de connexion a la BDD
DATABASE_URL=\"mysql://explorateur:Ereul9Aeng@127.0.0.1:3306/$nameProject?serverVersion=mariadb-10.3.25\"
" > .env.local
    php bin/console doctrine:database:create
    php bin/console d:s:u --force
    cp -R ${deltaLinkSymfo}../base-projet/.htaccess ./public/
}

CreateIndexSymfo()
{
    cp -R ${deltaLinkSymfo}../base-projet/Controller/MainController.php ./src/Controller/
    cp -R ${deltaLinkSymfo}../base-projet/templates/main ./templates/
}

CreateIndexApi()
{
    cp -R ${deltaLinkSymfo}../base-projet/Api ./src/Controller/
}

InstallReact()
{
    mkdir $fullNameFront
    cd $fullNameFront/
    cp -a ${deltaLinkReact}../base-projet/React-model/. .
    yarn
    yarn add react-bootstrap bootstrap
    yarn add react-icons --save
}

# Appel des fonctions selon le choix du projet
case $typeProject in
1)  NameProject "Symfo ( back + front )"
    fullNameBack=${nameProject}
    deltaLinkSymfo=""
    InstallSymfo
    CreateIndexSymfo
    ;;
2)  NameProject "Symfo Api"
    fullNameBack=${nameProject}"-Api"
    deltaLinkSymfo=""
    InstallSymfo
    CreateIndexApi
    ;;
3)  NameProject "React"
    fullNameFront=${nameProject}"-React"
    deltaLinkReact=""
    InstallReact
    ;;
4)  NameProject "Symfo Api & React"
    fullNameBack=${nameProject}"-Api"
    mkdir ${nameProject}
    cd "${nameProject}/"
    deltaLinkSymfo="../"
    InstallSymfo
    CreateIndexApi
    cd ../
    fullNameFront=${nameProject}"-React"
    deltaLinkReact="../"
    InstallReact
    ;;
*)  echo "Choisissez le numéro de l'une des 4 options"
    ;;
esac

# A la fin on ouvre vscode
code ${deltaLinkSymfo}${eltaLinkReact}.
