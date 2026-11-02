# Backlog — ForgeRoster

Ce document réunit les epics, les User Stories et leurs critères d'acceptation. Tous les tickets, y compris les tâches techniques, sont dans les [issues du dépôt](https://github.com/MrLkuch/Micro-Saas/issues). L'ordre des sprints et le MVP sont expliqués dans [planning.md](planning.md).

Une User Story exprime un besoin utilisateur. Les tâches techniques restent des tickets à part : elles ne figurent pas ici. Chaque critère est vérifiable par un test et porte un numéro, à reprendre dans le plan de tests.

## Epics

| Epic | Priorité | User Stories | Tickets | Pourquoi cette priorité |
|---|---|---|---|---|
| Cadrage et conception | Must | 0 | 8 | Le modèle de données conditionne l'API, qui conditionne le frontend. |
| Socle technique | Must | 0 | 7 | Sans environnement ni base de données, rien ne peut être développé. |
| Compte et sécurité | Must | 2 | 6 | Un warband appartient à un utilisateur : sans compte, ni sauvegarde ni contrôle d'accès. |
| Warband Builder | Must | 10 | 11 | Première moitié de la fonctionnalité principale. Le calculateur lit le warband. |
| Calculateur | Must | 2 | 5 | Répond directement à la problématique du projet. |
| Partage et export | Should | 5 | 5 | Le partage fait partie de la problématique, mais il dépend du warband et du calculateur : il arrive juste après le MVP. |
| Administration | Should | 1 | 2 | Le jeu de données de test remplit le catalogue, le MVP n'en dépend donc pas. |
| Qualité et livraison | Must | 0 | 8 | Exigé pour le titre. Les tests unitaires se font avec chaque ticket, le reste en fin de projet. |
| Campagne | Won't | 1 | 1 | Hors périmètre, gardé en réserve. |

Priorité : méthode MoSCoW. Must signifie indispensable au MVP ou au titre professionnel. La colonne donne la priorité dominante de l'epic, chaque ticket garde la sienne.

**MVP** : fin du sprint 3. Un joueur crée un compte, construit et équipe un warband, puis lit ses probabilités de réussite. Le jet de blessure (FR-307) est prévu au même sprint, mais c'est le premier ticket à reporter en cas de retard.

## User Stories

### Compte et sécurité

#### FR-103 — Créer un compte

Must · S1 · 3 points

En tant que visiteur, je souhaite créer un compte afin de sauvegarder mes warbands. Mot de passe haché, email unique.

1. Étant donné un visiteur sur le formulaire d'inscription, quand un e-mail, un pseudo et un mot de passe valides sont saisis, alors le compte est créé avec le rôle Joueur et permet de se connecter.
2. Étant donné un e-mail ou un pseudo déjà utilisé, quand le formulaire est envoyé, alors aucun compte n'est créé et un message d'erreur s'affiche.
3. Étant donné un champ manquant ou invalide, quand le formulaire est envoyé, alors aucun compte n'est créé et l'erreur s'affiche sous le champ concerné.
4. Étant donné un compte créé, quand la base est consultée, alors le mot de passe n'y figure que sous forme hachée, et aucune réponse de l'API ne le renvoie.
5. Étant donné un mot de passe de moins de 12 caractères, quand le formulaire est envoyé, alors aucun compte n'est créé et l'erreur est affichée.

#### FR-104 — Se connecter et se déconnecter

Must · S1 · 3 points

En tant que joueur, je souhaite me connecter afin de retrouver mes warbands. Authentification par JWT à durée limitée.

1. Étant donné un compte existant, quand les bons identifiants sont saisis, alors le joueur est connecté et accède à ses warbands.
2. Étant donné un e-mail inconnu ou un mot de passe incorrect, quand le formulaire est envoyé, alors la connexion est refusée avec le même message dans les deux cas.
3. Étant donné un joueur connecté, quand la déconnexion est demandée, alors les pages réservées ne sont plus accessibles et la page de connexion s'affiche.
4. Étant donné un jeton expiré, valable 1 heure après la connexion, quand une requête est envoyée à l'API, alors elle est refusée et le joueur est renvoyé vers la page de connexion.

### Warband Builder

#### FR-201 — Consulter le catalogue de combattants par faction

Must · S2 · 3 points

En tant que joueur, je souhaite parcourir les combattants d'une faction afin de choisir ceux que je recrute.

1. Étant donné un joueur connecté, quand une faction est choisie, alors seuls les combattants de cette faction s'affichent, avec leur profil et leur coût en Ducats.
2. Étant donné un catalogue affiché, quand un nom est recherché, alors la liste se réduit aux combattants correspondants.
3. Étant donné un catalogue affiché, quand un coût maximum est choisi, alors seuls les combattants de coût inférieur ou égal restent affichés.
4. Étant donné une recherche sans résultat, quand la liste se met à jour, alors un message l'indique.

#### FR-202 — Créer un warband

Must · S2 · 3 points

En tant que joueur, je souhaite créer un warband avec un nom, une faction et un budget afin de commencer ma liste.

1. Étant donné un joueur connecté, quand un nom, une faction et un budget valides sont saisis, alors le warband est créé et le builder s'ouvre avec un warband vide et un solde égal au budget.
2. Étant donné le formulaire de création, quand il s'ouvre, alors le budget proposé est de 700 Ducats et reste modifiable.
3. Étant donné un nom vide, une faction absente ou un budget nul ou négatif, quand le formulaire est envoyé, alors le warband n'est pas créé et l'erreur est affichée.

#### FR-203 — Ajouter et retirer un combattant

Must · S2 · 5 points

En tant que joueur, je souhaite ajouter ou retirer un combattant depuis une fenêtre de recherche afin de composer mon warband.

1. Étant donné un warband ouvert, quand un combattant est ajouté depuis la fenêtre de recherche, alors il apparaît dans le warband et son coût est déduit du solde.
2. Étant donné un combattant du warband, quand sa quantité est augmentée ou réduite, alors le total et le solde sont mis à jour.
3. Étant donné un combattant du warband, quand il est retiré, alors il disparaît et son coût, équipement compris, est recrédité sur le solde.
4. Étant donné un warband d'une faction, quand l'API reçoit un combattant d'une autre faction, alors l'ajout est refusé.
5. Étant donné un combattant dont la limite de recrutement est atteinte, quand un exemplaire de plus est ajouté, alors l'ajout est bloqué et un message l'explique.
6. Étant donné 6 combattants de catégorie Chef ou Élite dans le warband, quand un septième est ajouté, alors l'ajout est bloqué et un message l'explique.
7. Étant donné un warband qui n'atteint pas le minimum d'un combattant, comme un chef absent, quand il s'affiche, alors un avertissement indique ce qui manque et la sauvegarde reste possible.

#### FR-204 — Suivre le budget en Ducats en temps réel

Must · S2 · 3 points

En tant que joueur, je souhaite voir mon solde de Ducats se mettre à jour afin de ne pas dépasser mon budget. Ajout bloqué en cas de dépassement.

1. Étant donné un warband ouvert, quand il est affiché, alors le solde restant (budget moins combattants et équipement) reste visible en permanence.
2. Étant donné un budget de 700 Ducats et 420 dépensés, quand le warband s'affiche, alors le solde indique 280 Ducats.
3. Étant donné un ajout, un retrait ou un changement d'équipement, quand il est effectué, alors le solde se met à jour sans recharger la page.
4. Étant donné un ajout qui dépasserait le budget, quand il est tenté, alors il est bloqué, un message l'explique et le warband reste inchangé.
5. Étant donné un ajout qui amène le solde exactement à zéro, quand il est tenté, alors il est accepté.
6. Étant donné une requête directe qui dépasserait le budget, quand l'API la reçoit, alors elle la refuse.

#### FR-205 — Sauvegarder et rouvrir un warband

Must · S2 · 5 points

En tant que joueur, je souhaite retrouver mon warband à ma prochaine connexion afin de continuer à le modifier.

1. Étant donné un warband sauvegardé, quand le joueur se déconnecte puis se reconnecte, alors le warband est retrouvé à l'identique : combattants, quantités, équipement, règles spéciales et budget.
2. Étant donné un warband modifié, quand le joueur utilise le bouton de sauvegarde, alors le warband est enregistré et sa date de modification est mise à jour.
3. Étant donné un échec de sauvegarde, quand l'erreur survient, alors un message s'affiche et les modifications restent à l'écran.
4. Étant donné le warband d'un autre joueur, quand son ouverture est demandée, alors l'accès est refusé.

#### FR-207 — Retrouver mes warbands

Must · S2 · 2 points

En tant que joueur, je souhaite voir la liste de mes warbands afin de rouvrir celui que je veux modifier.

1. Étant donné un joueur connecté, quand la page Mes warbands s'ouvre, alors seuls ses warbands s'affichent, avec leur nom et leur faction.
2. Étant donné un warband de la liste, quand il est ouvert, alors il s'affiche dans le builder.
3. Étant donné aucun warband, quand la page s'ouvre, alors un message invite à en créer un.

#### FR-303 — Équiper un combattant

Must · S3 · 5 points

En tant que joueur, je souhaite choisir l'équipement d'un combattant afin d'adapter son profil. Le coût s'ajoute au budget.

1. Étant donné un combattant du warband, quand la fenêtre d'équipement s'ouvre, alors seuls les équipements autorisés pour ce combattant sont proposés, par emplacement : arme de mêlée, arme à distance, armure et accessoire.
2. Étant donné un équipement sélectionné, avant validation, alors son coût et son effet sur le profil du combattant sont visibles.
3. Étant donné une sélection validée, quand la fenêtre se ferme, alors l'équipement est enregistré sur le combattant, le solde est mis à jour et les probabilités sont recalculées.
4. Étant donné une sélection annulée, quand la fenêtre se ferme, alors l'équipement, le solde et les probabilités restent inchangés.
5. Étant donné un équipement dont le coût dépasse le solde, quand il est validé, alors il est refusé et un message l'explique.
6. Étant donné un équipement non autorisé pour le combattant, quand l'API le reçoit, alors elle le refuse.

#### FR-304 — Ajouter des règles spéciales au warband

Must · S3 · 5 points

En tant que joueur, je souhaite associer des règles spéciales à mon warband afin de voir leurs effets dans mes probabilités.

1. Étant donné un warband ouvert, quand une règle spéciale est ajoutée, alors elle apparaît dans la liste des règles du warband.
2. Étant donné une règle déjà associée, quand la liste des règles disponibles s'affiche, alors elle ne peut pas être ajoutée une seconde fois.
3. Étant donné une règle active qui modifie un jet, quand le calcul est effectué, alors son effet est pris en compte et elle figure dans les modificateurs actifs.
4. Étant donné une règle active, quand elle est retirée, alors son effet disparaît et les probabilités reviennent à leur valeur sans cette règle.
5. Étant donné une règle réservée à une autre faction, quand la liste des règles s'affiche, alors elle n'est pas proposée.

#### FR-501 — Gérer mes warbands sauvegardés

Should · S5 · 3 points

En tant que joueur, je souhaite rechercher, dupliquer et supprimer mes warbands afin de garder ma liste en ordre. Recherche, filtre et pagination.

1. Étant donné un joueur connecté, quand la page Mes warbands s'ouvre, alors chaque warband indique aussi les Ducats dépensés sur le budget et la date de modification.
2. Étant donné un warband de la liste, quand il est dupliqué, alors une copie apparaît et modifier cette copie ne change pas l'original.
3. Étant donné un warband de la liste, quand sa suppression est demandée, alors une confirmation est exigée, puis le warband et ses liens de partage sont supprimés.
4. Étant donné une liste affichée, quand une recherche par nom, un filtre par faction ou un tri par date est appliqué, alors la liste se met à jour.
5. Étant donné plus de 10 warbands, quand la liste s'affiche, alors 10 warbands sont visibles par page et la pagination donne accès aux autres.

### Calculateur

#### FR-302 — Lire les probabilités de réussite d'une action

Must · S3 · 5 points

En tant que joueur, je souhaite voir mes chances de succès, de critique et d'échec afin de décider de mes actions. Résultat affiché en moins de 200 ms.

1. Étant donné un combattant et l'une de ses armes, quand ils sont sélectionnés, alors les probabilités d'échec, de succès et de critique s'affichent et leur somme fait 100 %, aux arrondis près.
2. Étant donné un jet sans modificateur (2 dés), quand le calcul est effectué, alors le résultat est 41,67 % d'échec (somme de 2 à 6), 55,56 % de succès (7 à 11) et 2,78 % de critique (12 et plus).
3. Étant donné +1 DICE (3 dés, les 2 plus hauts retenus), quand le calcul est effectué, alors le résultat est 19,44 % d'échec, 73,15 % de succès et 7,41 % de critique.
4. Étant donné -1 DICE (3 dés, les 2 plus bas retenus), quand le calcul est effectué, alors le résultat est 68,06 % d'échec, 31,48 % de succès et 0,46 % de critique.
5. Étant donné +2 DICE et -1 DICE sur le même jet, quand le calcul est effectué, alors les bonus et malus s'annulent par paires et le résultat est celui de +1 DICE.
6. Étant donné un jet modifié, quand le résultat s'affiche, alors la liste des modificateurs actifs indique la source de chacun (équipement ou règle spéciale).
7. Étant donné une modification du warband, quand elle est effectuée, alors les probabilités se mettent à jour en moins de 200 ms, sans appel au serveur.
8. Étant donné aucun combattant ou aucune arme sélectionnés, quand le panneau s'affiche, alors aucun pourcentage n'apparaît et un message invite à en choisir un.
9. Étant donné un combattant portant deux armes, quand l'une est sélectionnée, alors seuls les bonus de cette arme s'appliquent.

#### FR-307 — Lire les issues d'une attaque contre une cible

Should · S3 · 5 points

En tant que joueur, je souhaite voir les issues possibles d'une attaque contre une cible afin de choisir mes combats. Résultat affiché en moins de 200 ms.

1. Étant donné un combattant, une arme et une cible, quand ils sont sélectionnés, alors les probabilités d'attaque ratée, d'aucun effet, de blessure légère, d'être à terre et d'être hors de combat s'affichent et leur somme fait 100 %, aux arrondis près.
2. Étant donné un jet de blessure seul sans modificateur, quand le calcul est effectué, alors le résultat est 0 % d'aucun effet, 41,67 % de blessure légère, 30,56 % à terre et 27,78 % hors de combat.
3. Étant donné un jet de blessure seul avec +1 INJURY DICE, quand le calcul est effectué, alors le résultat est 0 % d'aucun effet, 19,44 % de blessure légère, 28,24 % à terre et 52,31 % hors de combat.
4. Étant donné un jet de blessure seul contre une armure de -1, quand le calcul est effectué, alors le résultat est 2,78 % d'aucun effet, 55,56 % de blessure légère, 25,00 % à terre et 16,67 % hors de combat.
5. Étant donné une attaque sans modificateur contre une cible sans armure, quand le calcul est effectué, un critique ajoutant +1 INJURY DICE, alors le résultat est 41,67 % d'attaque ratée, 0 % d'aucun effet, 23,69 % de blessure légère, 17,76 % à terre et 16,89 % hors de combat.
6. Étant donné +1 DICE contre une armure de -1, quand le calcul est effectué, alors le résultat est 19,44 % d'attaque ratée, 2,07 % d'aucun effet, 42,97 % de blessure légère, 20,69 % à terre et 14,83 % hors de combat.
7. Étant donné un total de modificateurs de -4, quand le calcul est effectué, alors le résultat est celui de -3.
8. Étant donné +2 INJURY DICE et -1 INJURY DICE sur le même jet, quand le calcul est effectué, alors ils s'annulent par paires et le résultat est celui de +1 INJURY DICE.
9. Étant donné une cible choisie dans le catalogue, quand elle est sélectionnée, alors son armure est reprise et le joueur peut la modifier pour tenir compte de l'équipement de la cible.
10. Étant donné aucune cible sélectionnée, quand le panneau s'affiche, alors les probabilités de réussite restent visibles et un message invite à choisir une cible.

### Partage et export

#### FR-401 — Générer un lien de partage

Should · S4 · 5 points

En tant que joueur, je souhaite obtenir un lien unique et un QR code afin de montrer mon warband à mon adversaire. Durée de validité réglable.

1. Étant donné un warband sauvegardé, quand le joueur demande un partage, alors un lien unique et un QR code sont générés.
2. Étant donné la fenêtre de partage, quand elle s'ouvre, alors la durée de validité proposée est de 7 jours et reste modifiable.
3. Étant donné une durée choisie, quand le lien est généré, alors il expire au terme de cette durée.
4. Étant donné un lien généré, quand le joueur le copie ou télécharge le QR code, alors le lien est dans le presse-papiers ou l'image est téléchargée, et le QR code ouvre ce lien.
5. Étant donné deux liens générés, quand ils sont comparés, alors leurs jetons sont différents et aucun ne contient l'identifiant du warband.
6. Étant donné le warband d'un autre joueur, quand un lien est demandé, alors l'API refuse.
7. Étant donné un lien actif, quand un nouveau lien est généré, alors le précédent ne fonctionne plus et un seul lien reste actif.
8. Étant donné un warband incomplet, quand un lien est demandé, alors le partage est refusé et un message indique ce qui manque.

#### FR-402 — Consulter un warband partagé

Should · S4 · 5 points

En tant qu'adversaire, je souhaite ouvrir un lien reçu afin de lire le warband sans créer de compte. Lecture seule.

1. Étant donné un lien valide et un visiteur sans compte, quand le lien est ouvert, alors le warband s'affiche : nom, faction, combattants, équipement et règles spéciales.
2. Étant donné la vue adversaire, quand elle s'affiche, alors elle ne propose aucune action de modification.
3. Étant donné une requête de modification portant sur un warband partagé, quand elle est envoyée sans être celle du propriétaire, alors l'API la refuse.
4. Étant donné la vue adversaire, quand elle s'affiche, alors l'e-mail du propriétaire n'est ni affiché ni renvoyé par l'API.
5. Étant donné un jeton inexistant, quand le lien est ouvert, alors un message indique que le lien n'est pas valide.

#### FR-403 — Simuler une confrontation contre un warband partagé

Should · S4 · 5 points

En tant qu'adversaire, je souhaite simuler une attaque du warband partagé contre l'un de mes combattants afin de préparer la partie.

1. Étant donné un warband partagé ouvert, quand un combattant de ce warband, une arme et l'armure de la cible sont renseignés, alors les probabilités de réussite et les issues de l'attaque s'affichent, avec le même calcul que FR-302 et FR-307.
2. Étant donné un combattant équipé, quand la simulation s'affiche, alors son équipement et les règles spéciales de son warband sont appliqués et listés.
3. Étant donné une simulation effectuée, quand la page est rechargée, alors le warband partagé n'a pas changé.
4. Étant donné une simulation effectuée, quand elle se termine, alors rien n'est enregistré en base.
5. Étant donné aucune sélection, quand la page s'affiche, alors aucun pourcentage n'apparaît.
6. Étant donné un visiteur sans compte, quand la simulation est utilisée, alors aucune connexion n'est demandée.

#### FR-404 — Révoquer un lien de partage

Should · S4 · 3 points

En tant que joueur, je souhaite désactiver un lien afin d'en reprendre le contrôle. Un lien expiré ou révoqué n'affiche plus rien.

1. Étant donné un warband partagé, quand son propriétaire consulte le partage, alors le lien actif et sa date d'expiration sont visibles.
2. Étant donné un lien actif, quand son propriétaire le désactive, alors l'ouverture du lien n'affiche plus aucune donnée du warband, seulement un message.
3. Étant donné un lien expiré, quand il est ouvert, alors il se comporte comme un lien désactivé.
4. Étant donné un lien désactivé, quand le warband est consulté par son propriétaire, alors le warband est intact.
5. Étant donné le lien d'un autre joueur, quand sa désactivation est demandée, alors l'API refuse.

#### FR-502 — Exporter un warband en PDF

Should · S5 · 5 points

En tant que joueur, je souhaite télécharger mon warband en PDF afin de l'imprimer pour un tournoi. Contenu à inclure au choix.

1. Étant donné un warband ouvert, quand la fenêtre d'export s'ouvre, alors le joueur choisit le contenu à inclure et voit un aperçu.
2. Étant donné un contenu choisi, quand le téléchargement est demandé, alors un fichier PDF au format A4 portrait est téléchargé.
3. Étant donné le contenu par défaut, quand le PDF est ouvert, alors il indique le nom du warband, les Ducats dépensés, les combattants et leur équipement.
4. Étant donné un contenu décoché, quand le PDF est généré, alors ce contenu n'y figure pas.
5. Étant donné le warband d'un autre joueur, quand son export est demandé, alors l'API refuse.
6. Étant donné un warband incomplet, quand l'export est demandé, alors il est refusé et un message indique ce qui manque.

### Administration

#### FR-506 — Gérer le catalogue

Should · S5 · 5 points

En tant qu'administrateur, je souhaite créer, modifier et supprimer les factions, combattants, équipements et règles spéciales afin de tenir le catalogue à jour. Accès réservé au rôle administrateur.

1. Étant donné un administrateur connecté, quand une faction, un combattant, un équipement ou une règle spéciale est créé ou modifié, alors le changement apparaît dans le catalogue des joueurs.
2. Étant donné un joueur ou un visiteur, quand la gestion du catalogue est demandée, alors l'accès est refusé, sur la page comme sur l'API.
3. Étant donné une donnée inutilisée, quand sa suppression est demandée, alors une confirmation est exigée avant de la supprimer.
4. Étant donné une donnée utilisée par un warband, quand sa suppression est demandée, alors elle est refusée et un message en donne la raison.
5. Étant donné un coût négatif ou un nom déjà pris, quand le formulaire est envoyé, alors rien n'est enregistré et l'erreur est affichée.

## Réserve

Ces deux User Stories sont classées Won't et ne sont pas planifiées. Elles n'ont pas de critères d'acceptation.

- **FR-901 — Règles spéciales propres à un combattant.** En tant que joueur, je souhaite associer une règle spéciale à un seul combattant afin de suivre son évolution en campagne.
- **FR-902 — Historique des batailles et suivi de campagne.** En tant que joueur, je souhaite enregistrer les résultats de mes parties afin de suivre ma campagne.

## Décisions prises

- **FR-103** : mot de passe de 12 caractères minimum.
- **FR-104** : jeton valable 1 heure, sans renouvellement au MVP.
- **FR-205** : sauvegarde manuelle, par un bouton dans le builder.
- **FR-401** : un seul lien actif par warband. Un nouveau lien remplace le précédent.
- **FR-403** : l'adversaire reste sans compte et saisit l'armure de sa cible.
- **FR-501** : 10 warbands par page.
- **FR-505** : la page Historique devient Mes warbands.
- **Versionnement** : retiré. La duplication d'un warband couvre le besoin.
- **Filigrane PDF et filtre par rôle** : retirés des maquettes.
- **FR-203, FR-401 et FR-502** : le minimum et le maximum de chaque combattant sont contrôlés. Un warband incomplet, par exemple sans chef, reste sauvegardable, mais ne peut être ni partagé ni exporté.
- **FR-302, FR-307 et FR-403** : le joueur choisit une arme, dont les bonus ne comptent que pour cette attaque.
