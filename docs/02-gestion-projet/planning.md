# Planning — ForgeRoster

Roadmap du projet, découpée en sprints. Le détail de chaque ticket est dans les [issues du dépôt](https://github.com/MrLkuch/Micro-Saas/issues). Les User Stories et leurs critères d'acceptation sont dans [backlog.md](backlog.md).

## Principes

- **Un sprint = une semaine** (hypothèse reprise de la roadmap du README, à ajuster au calendrier réel de la formation).
- **Priorisation MoSCoW** : *Must* (indispensable au MVP ou au titre professionnel), *Should* (important, non bloquant), *Could* (confort), *Won't* (hors périmètre, gardé en réserve).
- **Estimation en points** (1, 2, 3, 5, 8) : effort relatif, pas des heures. Un ticket à 8 points doit être redécoupé avant d'être commencé.
- **MVP = fin du sprint 3** : un joueur peut créer un compte, construire un warband, l'équiper et lire ses probabilités de réussite. C'est la fonctionnalité principale du [cahier des charges](../01-contexte/cahier-des-charges.md) ; tout le reste (partage, export, gestion avancée des warbands) vient après. Le jet de blessure est prévu au sprint 3, mais c'est le premier ticket à reporter en cas de retard.

## Vue d'ensemble

| Sprint | Objectif | Livrable vérifiable | Points |
|---|---|---|---|
| **S0 — Cadrage et conception** | Passer du besoin à une organisation concrète | Backlog, cas d'utilisation, MCD/MLD/MPD, environnement Docker, architecture documentée | 27 |
| **S1 — Socle et authentification** | Une application qui démarre, avec des comptes | Inscription/connexion fonctionnelles, base de données migrée et peuplée, CI verte | 24 |
| **S2 — Warband Builder** | Construire et sauvegarder un warband | Un warband créé, modifié, retrouvé dans la liste et relu depuis la base, budget en Ducats respecté | 27 |
| **S3 — Calculateur (MVP)** | Fonctionnalité principale complète | Probabilités de réussite affichées en temps réel, équipement et règles spéciales pris en compte, jet de blessure si le temps le permet | 32 |
| **S4 — Partage** | Montrer son warband à un adversaire | Lien unique + QR code, vue adversaire en lecture seule avec simulation | 18 |
| **S5 — Export et gestion des warbands** | Finir les fonctionnalités secondaires | Export PDF, recherche et duplication des warbands sauvegardés, gestion du catalogue par l'administrateur, factions supplémentaires, responsive | 21 |
| **S6 — Qualité, sécurité, déploiement** | Rendre le projet présentable au jury | Application déployée, plan de tests exécuté, dossier de projet et diaporama | 34 |

## Pourquoi cet ordre

1. **La conception avant le code (S0)** : le modèle de données conditionne l'API, qui conditionne le frontend. Le corriger après coup coûte plus cher que de le poser d'abord.
2. **L'authentification avant le builder (S1)** : un warband appartient à un utilisateur. Sans compte, impossible de sauvegarder ni de vérifier les droits d'accès.
3. **Le builder avant le calculateur (S2 puis S3)** : le calculateur lit les combattants, l'équipement et les règles du warband. Il n'a rien à calculer tant que le warband n'existe pas.
4. **Le partage après le MVP (S4)** : il réutilise le warband et le calculateur déjà en place. La problématique le cite, mais il dépend de ces deux briques : il arrive donc juste après le MVP.
5. **La qualité en continu, la finalisation en S6** : les tests unitaires s'écrivent avec chaque ticket. Le sprint 6 sert à ce qui ne peut se faire qu'à la fin (déploiement, audit, rédaction du dossier).

## Jalons

| Jalon | Fin de sprint | Critère de passage |
|---|---|---|
| J1 — Conception validée | S0 | Le modèle de données couvre toutes les User Stories *Must* |
| J2 — Socle technique | S1 | `docker compose up` lance l'application, un utilisateur peut se connecter |
| J3 — **MVP** | S3 | Parcours complet : compte → warband → équipement → probabilités |
| J4 — Fonctionnalités complètes | S5 | Toutes les User Stories *Must* et *Should* sont terminées |
| J5 — Prêt pour le jury | S6 | Application en ligne, dossier de projet et diaporama terminés |

## Réserve (hors MVP, non planifié)

Besoins identifiés mais volontairement repoussés. Le modèle de données est conçu pour les accueillir sans refonte.

- Règles spéciales et statistiques propres à un combattant (blessure de campagne, promotion).
- Historique des batailles et suivi de campagne.
- Plans payants (Pro, Tournois).
- Autres jeux que Trench Crusade.

## Suivi

Colonnes du tableau : **Backlog → À faire (sprint en cours) → En cours → En revue → Terminé**.

Un ticket est *terminé* quand : le code est fusionné sur `main`, les tests passent dans la CI, les critères d'acceptation sont vérifiés à la main, et la documentation concernée est à jour.
