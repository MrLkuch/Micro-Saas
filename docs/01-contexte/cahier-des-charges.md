# Cahier des charges — ForgeRoster

Ce document découle de l'[expression du besoin](expression-besoin.md) : perte de temps et erreurs liées à la construction manuelle de warbands et au calcul de probabilités de réussite aux jets de combat pour Trench Crusade.

---

## 1. Cahier des charges fonctionnel

### 1.1 Fonctionnalité principale — Warband Builder + Calculateur de probabilités en temps réel

C'est la fonctionnalité qui apporte la valeur réelle du produit : elle répond directement à la problématique (calcul manuel du pool de dés, fastidieux et source d'erreur). Sans elle, ForgeRoster ne serait qu'un énième éditeur de liste.

**Description :**
- Le joueur choisit une faction et compose son warband par recrutement de combattants depuis un catalogue (profil : Mouvement / Mêlée / Tir / Armure, coût en Ducats).
- Le budget de Ducats configuré est vérifié en temps réel (solde restant affiché en permanence, recrutement bloqué en cas de dépassement). La structure du warband est aussi contrôlée : disponibilité minimale et maximale de chaque combattant, dont le chef obligatoire, et 6 Chefs et Élites au plus. Un warband incomplet peut être sauvegardé, mais ni partagé ni exporté.
- **Équipement par combattant** : chaque combattant recruté peut être équipé (arme de mêlée, arme à distance, armure/protection, accessoire) depuis les emplacements et options disponibles pour son profil. Chaque pièce d'équipement a un coût en Ducats et peut modifier les stats du combattant (ex. arme qui augmente le pool de dés en Mêlée, protection qui réduit le résultat du jet de blessure subi).
- **Règles spéciales du warband** : le joueur peut associer au warband une ou plusieurs règles spéciales (traits de faction, bonus/malus de campagne). Une règle spéciale modifie le comportement ou les stats des combattants concernés (ex. dé supplémentaire retenu en Mêlée pour tout le warband).
- Pour une attaque avec l'arme choisie (jet de mêlée ou de tir), l'application calcule automatiquement et affiche instantanément, **en tenant compte de l'équipement et des règles spéciales actives comme modificateurs du pool de dés** :
  - la probabilité d'échec (somme des deux dés retenus de 2 à 6),
  - la probabilité de succès (somme de 7 à 11),
  - la probabilité de succès critique (somme ≥ 12),
  - la liste des modificateurs actifs ayant produit ce résultat (équipement, règles spéciales).
- Pour une attaque contre une cible, l'application calcule aussi le **jet de blessure**, qui suit une attaque réussie. Il se lance comme le jet de réussite, avec ses propres dés bonus et malus (+/- INJURY DICE). Un succès critique ajoute +1 INJURY DICE, et l'armure de la cible retire des points au résultat, sans dépasser -3 au total. L'application affiche la probabilité de chaque issue de l'attaque :
  - attaque ratée (échec du jet de réussite),
  - aucun effet (résultat ≤ 1),
  - blessure légère (2 à 6),
  - à terre (7 à 8),
  - hors de combat (≥ 9).

**Critère de valeur ajoutée :** un calcul de probabilité sur un pool de dés modifié par l'équipement et les règles spéciales (non trivial à faire de tête, contrairement à un simple seuil sur un d6) qui prendrait plusieurs minutes à la main est restitué en moins d'une seconde, dans un panneau visible pendant toute la construction du warband.

**Acteur :** Joueur.

### 1.2 Fonctionnalités secondaires

| Fonctionnalité | Description | Valeur |
|---|---|---|
| Authentification | Création de compte, connexion (JWT) | Sauvegarde des warbands entre sessions |
| Partage par lien | Génération d'un token unique + QR code, durée de validité paramétrable | Remplace le partage par capture d'écran |
| Vue adversaire | Consultation d'un warband partagé en lecture seule, simulation d'une attaque contre l'un de ses combattants, dont l'armure est saisie sans créer de compte | Prépare la partie avant de jouer |
| Export PDF | Génération d'une liste imprimable (nom, Ducats dépensés, combattants, équipements) | Utilisable en tournoi/campagne, sans écran |
| Historique des warbands | Sauvegarde et duplication des listes d'un joueur | Réutilisation d'anciennes compositions |
| Gestion du catalogue | Un administrateur crée, modifie et supprime les factions, combattants, équipements et règles spéciales | Tenir les données de jeu à jour sans intervention sur la base |

### 1.3 Exigences non fonctionnelles

| Exigence | Détail |
|---|---|
| Performance | Calcul de probabilités affiché en moins de 200 ms après modification du warband (calcul déterministe côté client, pas d'appel serveur bloquant) |
| Sécurité | Mots de passe hashés (bcrypt), authentification par JWT à expiration courte, validation systématique des entrées côté API |
| Accessibilité / ergonomie | Interface responsive (usage terrain sur tablette/mobile en tournoi) |
| Confidentialité | Données personnelles minimales collectées (email, pseudo) — conformité RGPD par minimisation |
| Portée fonctionnelle du MVP | Une seule édition des règles Trench Crusade couverte (celle en vigueur au démarrage du projet) ; les autres jeux (WH40K, Age of Sigmar, Kill Team...) sont hors périmètre MVP |

### 1.4 Hors périmètre (MVP)

- Marketplace ou vente de figurines.
- Moteur de règles complet (phases de jeu, scénarios, campagne) : seul le calcul de probabilité sur les jets de réussite et de blessure est couvert. Les situations de partie (couvert, longue portée, cible à terre, marqueurs de sang et de bénédiction, jets Bloodbath) ne sont pas prises en compte.
- Application mobile native (le responsive web suffit au MVP).
- Glory Points, mercenaires, variantes de warband et mots-clés (Tough, Negate Fear…) : un warband de départ peut s'en passer.
- Règles spéciales appliquées à un combattant individuel (blessure de campagne, promotion…) : au MVP, les règles spéciales ne s'appliquent qu'au niveau du warband. Le modèle de données garde `SPECIAL_RULE` comme catalogue indépendant (cf. [MCD](../../README.md#architecture--mcd-résumé)) précisément pour que ce niveau individuel s'ajoute plus tard par une simple table de jointure supplémentaire, sans refonte du schéma existant.

---

## 2. Cahier des charges technique

### 2.1 Vue d'ensemble des choix

| Domaine | Choix | Version |
|---|---|---|
| Langage front & back | TypeScript | 6.0 |
| Framework frontend | Angular (standalone components) | 22.x |
| State management frontend | Angular Signals (natif) | inclus Angular 22 |
| Bibliothèque de composants UI | PrimeNG | 22.x |
| Runtime backend | Node.js (LTS) | 24.x |
| Framework backend | Express | 5.x |
| ORM | Prisma | 7.x |
| Base de données | PostgreSQL | 18 |
| Authentification | JWT (jsonwebtoken) + bcrypt | — |
| Validation des entrées | Zod | 4.x |
| Tests | Vitest (front & back) | 5.x |
| CI/CD | GitHub Actions | — |
| Déploiement frontend | Vercel | — |
| Déploiement backend + BDD | Railway | — |
| Génération PDF | pdfmake | 0.3.x |
| Génération QR code | qrcode (npm) | 1.5.x |

### 2.2 Justification des choix

**Angular 22 (frontend)**
Choisi plutôt que React : l'équipe (moi) est déjà à l'aise sur Angular, ce qui réduit le risque technique sur un projet solo à délai contraint. Angular apporte en plus, nativement, ce dont l'application a spécifiquement besoin :
- **Structure en couches imposée** (modules/composants/services) : cohérent avec l'exigence du titre CDA de justifier une architecture organisée en couches, sans avoir à l'imposer soi-même comme avec React.
- **Signals** (depuis Angular 16, stabilisés ensuite) : gestion d'état réactive native, suffisante pour la complexité de ForgeRoster (état d'un warband en cours d'édition, total de Ducats et probabilités recalculés automatiquement via `computed()`) — évite d'ajouter une dépendance externe type NgRx, disproportionnée pour ce périmètre.
- **RxJS intégré** : réservé aux flux réellement asynchrones (appels HTTP via `HttpClient`), Signals gérant l'état local synchrone.
- **Angular CLI** : build (esbuild), tests et lint packagés, réduit la configuration à maintenir seul.

**PrimeNG (bibliothèque de composants)**
Les maquettes du projet reposent sur des composants standards mais nombreux : popups (ajout de combattant, équipement, export PDF, partage), tableau avec tri/filtre/pagination (historique des warbands), listes de choix, cases à cocher. PrimeNG fournit ces composants prêts à l'emploi et accessibles pour Angular (`Dialog`, `Table`, `Select`, `Checkbox`…), ce qui évite de les reconstruire à la main comme l'aurait imposé une approche utility-first (Tailwind) sur un projet solo à délai contraint. Le thème est personnalisable par variables CSS pour appliquer la palette du projet (noir dominant, rouge `#B01E23` en accent unique). Depuis sa version 22, PrimeNG demande une clé de licence : la licence Community est gratuite pour un particulier, et la clé reste hors du dépôt.

**TypeScript de bout en bout**
Un seul langage sur front et back : partage de types (ex. structure d'un combattant, d'un warband) entre client et serveur, moins d'erreurs de contrat d'API, cohérent avec un projet solo.

**Node.js + Express (backend)**
Express reste suffisant pour une API REST de taille MVP (warband, catalogue de combattants, partage, auth) sans la complexité d'un framework plus opinionated (NestJS) : le périmètre ne justifie pas l'overhead d'architecture supplémentaire à ce stade.

**PostgreSQL + Prisma**
- PostgreSQL : les données du domaine sont fortement relationnelles (warband → combattants → équipements, contraintes de clé étrangère, budget de Ducats à agréger) — une base relationnelle est plus appropriée qu'une base documentaire.
- Prisma : ORM typé qui génère des types TypeScript à partir du schéma, cohérent avec le choix "TypeScript de bout en bout" ; migrations versionnées incluses, utiles pour la traçabilité demandée dans un dossier de projet.

**JWT + bcrypt**
Authentification stateless (JWT) adaptée à une API REST déployée séparément du frontend (pas de session serveur à synchroniser entre Vercel et Railway). bcrypt pour le hash des mots de passe : standard éprouvé, résistant aux attaques par force brute grâce au coût de calcul paramétrable.

**Zod**
Validation des entrées API par schéma, avec inférence de type TypeScript directe : évite de dupliquer une définition de type et une règle de validation séparément.

**Vitest**
Un seul outil de test pour le frontend, l'API et `shared`. Angular le prend en charge nativement, ce qui évite de configurer un second outil et simplifie la CI. Le calcul de probabilités (combinatoire sur pool de d6) est un candidat naturel aux tests unitaires exhaustifs (cas limites : bonus et malus qui s'annulent par paires, plafond de -3 sur le jet de blessure, etc.).

**pdfmake / qrcode**
Bibliothèques légères, sans dépendance à un service externe payant, suffisantes pour respectivement générer un PDF structuré (liste imprimable) et un QR code (lien de partage) côté serveur.

**Vercel (front) / Railway (back + PostgreSQL)**
Déploiement continu depuis GitHub, hébergement gratuit en phase MVP, séparation claire frontend statique / backend + BDD — cohérent avec l'architecture JWT stateless ci-dessus.

**GitHub Actions**
CI/CD intégré au dépôt (lint, tests, build) sans outil supplémentaire à administrer, aligné avec l'hébergement du code sur GitHub.

### 2.3 Services externes

Aucun service payant obligatoire au MVP. Bibliothèques utilisées (pdfmake, qrcode) fonctionnent en local côté serveur, sans appel à une API tierce — choix cohérent avec la contrainte de coût nul du plan Gratuit (cf. README, modèle économique). Les règles de Trench Crusade sont diffusées gratuitement par leurs créateurs : les données de jeu sont saisies à la main à partir de ces documents, sans service tiers.
