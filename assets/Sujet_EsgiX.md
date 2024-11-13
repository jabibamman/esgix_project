# Projet ESGIX

## Introduction

Ce projet a pour objectif de développer un simili réseau social inspiré de X (anciennement Twitter).

Pour ce faire les élèves ont accès à une API développée exprès et partagée entre toutes les classes.

## Fonctionnalités et documentation de l’API

Ci-dessous la documentation de l’API à destination des développeurs.

### Documentation Postman de l’API accessible ici : [https://api.postman.com/collections/30856059-ffedacd3-7733-4529-ba35-5c6308fd31ec?access_key=PMAT-01J976BQ3DB6GS3962V7CCKA9W](https://api.postman.com/collections/30856059-ffedacd3-7733-4529-ba35-5c6308fd31ec?access_key=PMAT-01J976BQ3DB6GS3962V7CCKA9W)

<aside>
⚠️

Chaque groupe d’élève se verra attribuer une clef d’API permettant de communiquer avec le serveur. Cela a pour but de pouvoir tracer les potentiels comptes problématiques.

Si vous n’avez pas encore de clef d’API, envoyez-moi un mail à [thomasecalle+esgix@gmail.com](mailto:thomasecalle+esgix@gmail.com) et je vous en fournirai pour votre groupe

Une fois la clef obtenue, il faut la placer dans les headers de chaque requête dans un champs `x-api-key`

</aside>

Normalement tout devrait être assez clair dans la documentation mais voici ici quelques explications supplémentaires :

- 🔒Authentification
    - En plus de la clef d’API à mettre dans le champs `x-api-key`, certaines routes demandent à l’utilisateur d’être connecté. 
    Une fois le `token` récupéré dans la réponse du login, il s’agit ensuite de placer ce token dans les Headers de chaque route comme ceci :
    `Authorization: Bearer <token>`
    - Pour la création de compte, voici les champs possibles :
        - email (obligatoire et unique)
        - password (obligatoire)
        - username (obligatoire et unique)
        - avatar (prend une `url` pour ne pas avoir à stocker des fichiers

- 👥 Utilisateurs
    - Pour la modification d’un utilisateur, il est possible de modifier les champs suivants :
        - username (unique)
        - avatar
        - description (champs texte

- 📭 Posts
    - Un post peut être créé avec les champs suivants :
        - content (obligatoire et non vide) : il s’agit du texte du post
        - imageUrl : il s’agit d’une potentielle url d’image du post
        - parent (id du commentaire parent) : ce champs n’est pas obligatoire mais s’il est rempli alors cela va créer un commentaire au message parent
    - Like d’un post
        - La même route est utilisée à la fois pour LIKE et UNLIKE un post, il s’agit simple d’un toggle de l’état
    
- 💬 Commentaires
    - Création d’un commentaire :
        - il s’agit en fait de créer un `post` en renseignant le champs `parent` et en y mettant l’ID du message que l’on veut commenter
    - Récupération des commentaires d’un message
        - Il y a un champs `parent` que l’on peut renseigner dans les query params de la récupération des posts et qui permet d’indiquer l’ID du parent.
        Si il est renseigné alors la route ne renvoie que les messages qui ont cet ID comme parent (et donc tous les commentaires finalement)