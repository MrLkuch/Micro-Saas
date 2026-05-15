# ForgeRoster ⚔️

> **"Build your army. Crush your enemy."**

Application Micro-SaaS de construction de listes d'armées et de calcul de probabilités de combat pour Warhammer 40K et jeux similaires.

---

## Présentation du projet

**ForgeRoster** est une application web pensée pour la communauté Warhammer 40K. Elle permet de :

- **Construire** des rosters d'armées avec interface drag-and-drop
- **Calculer automatiquement** les probabilités de combat (toucher, blesser, sauvegarder)
- **Partager** ses listes via un lien unique avec ses adversaires
- **Simuler** les échanges de tirs / combats avant une partie

---

## Le problème résolu

| Problème | Impact |
|----------|--------|
| Listes construites manuellement (papier / Excel) | ~90% des joueurs concernés |
| Calculs de proba fastidieux en partie | ~30 min perdues par session |
| Partage via screenshots non standardisés | Aucun outil dédié gratuit |

---

## Public cible

- **Joueurs réguliers** de Warhammer 40K (25–40 ans, technophiles)
- **Joueurs de tournoi** cherchant des listes validées et optimisées
- **Clubs & associations** de wargaming
- Compatible avec : Age of Sigmar, Kill Team, Horus Heresy

---

## Fonctionnalités

### Fonctionnalité principale (MVP)

**Army Builder + Calculateur de probabilités en temps réel**

- Interface de construction de roster par faction
- Base de données d'unités avec toutes les statistiques (WS / BS / S / T / W / A / Ld / Sv)
- Calcul automatique :
  - Probabilité de toucher (Ballistic / Weapon Skill)
  - Probabilité de blesser (Force vs Endurance)
  - Probabilité de sauvegarde
  - Résultat final (blessures mortelles attendues)
- Gestion du plafond de points (limite configurable)
- Visualisation temps réel dans le panneau latéral

### Fonctionnalités secondaires

| Fonctionnalité | Description |
|----------------|-------------|
| Partage par lien | Token unique, QR code, durée paramétrable |
| Vue adversaire | Roster en lecture seule + simulation contre-liste |
| Export PDF | Liste imprimable pour tournois |
| Historique des rosters | Sauvegarde et versionning |

---

## Stack technique

```
Frontend      →  React + TypeScript · Vite · Tailwind CSS · Zustand
Backend       →  Node.js + Express · REST API · JWT · Bcrypt
Base de données → PostgreSQL · Prisma ORM
Déploiement   →  Vercel (front) · Railway (back + DB) · GitHub Actions
```

### Justification des choix


- **PostgreSQL** : données relationnelles indispensables (entités, FK, requêtes complexes)
-

---

## Architecture — MCD (résumé)

```
UTILISATEUR (1) ─── crée ────→ (n) ROSTER
FACTION     (1) ─── classe ──→ (n) ROSTER
FACTION     (1) ─── propose ─→ (n) UNITE_CATALOGUE
UNITE_CATALOGUE (1) ── instancié dans ─→ (n) ROSTER_UNITE
ROSTER      (1) ─── regroupe ─→ (n) ROSTER_UNITE
ROSTER      (1) ─── génère ──→ (n) PARTAGE
ROSTER      (1) ─── loggue ──→ (n) COMBAT_LOG
UNITE_CATALOGUE (1) ── possède ─→ (n) EQUIPEMENT
```

**Entités principales :**
- `UTILISATEUR` — compte joueur (email, pseudo, premium)
- `ROSTER` — liste d'armée (nom, points, faction)
- `FACTION` — faction du jeu (Space Marines, Chaos, Tyranids…)
- `UNITE_CATALOGUE` — unité de base avec stats (WS/BS/S/T/W/A/Ld/Sv)
- `ROSTER_UNITE` — table d'association enrichie (quantité, surnom, options)
- `EQUIPEMENT` — armes et équipements disponibles par unité
- `PARTAGE` — liens de partage tokenisés avec expiration
- `COMBAT_LOG` — historique des calculs de probabilités

---

## Diagramme de cas d'utilisation (résumé)

**Acteurs :**
- **Joueur** (principal) : crée, gère et partage ses rosters
- **Adversaire** (secondaire) : consulte les rosters partagés et simule

**Cas d'utilisation principaux :**
1. Créer un compte
2. Construire un roster (`include` → Ajouter/retirer des unités)
3. Calculer les probabilités de combat
4. Partager un roster via lien (`extend` de "Construire")
5. Consulter un roster partagé (Adversaire)
6. Voir les calculs adverses (Adversaire, `require` consultation)
7. Exporter le roster en PDF

---

## Wireframes

Trois vues principales ont été maquettées :

| Vue | Description |
|-----|-------------|
| **Army Builder** | Layout 3 colonnes : factions / roster / calculateur |
| **Modal ajout d'unité** | Recherche + filtres + aperçu stats + calculateur détaillé |
| **Partage & Vue adversaire** | Génération lien / QR code + consultation lecture seule |

---

## Identité visuelle

| Élément | Valeur |
|---------|--------|
| Nom | **ForgeRoster** |
| Slogan | *"Build your army. Crush your enemy."* |
| Couleur principale | `#1A1A2E` Void Black |
| Couleur accent | `#C0392B` Blood Red |
| Or | `#D4A017` Imperial Gold |
| Bleu | `#3D5A80` Tactical Blue |
| Typo titres | Cinzel (serif, ambiance impériale) |
| Typo UI | Inter / Calibri |
| Typo stats | Monospace (Consolas) |

---

## Roadmap de développement

```
Phase 1 — MVP (S1–S3)
├── Authentification (JWT + Bcrypt)
├── Base de données unités Space Marines
├── Army Builder drag-and-drop
└── Calculateur de probabilités

Phase 2 — Fonctionnalités (S4–S5)
├── Autres factions (+3)
├── Système de partage (token + QR)
├── Vue adversaire (read-only)
└── Export PDF

Phase 3 — Optimisation (S6)
├── Mobile responsive
├── Performance & tests
├── Tests utilisateurs communauté
└── CI/CD GitHub Actions finalisé
```

---

## Modèle économique

| Plan | Prix | Fonctionnalités |
|------|------|-----------------|
| **Gratuit** | 0 €/mois | 5 rosters · Calculs basiques · Partage limité |
| **Pro** | 4,99 €/mois | Rosters illimités · Toutes factions · Export PDF |
| **Tournois** | 9,99 €/mois | Tout Pro + Stats avancées · Mode ligue · API |

---

## Risques & mitigation

| Risque | Mitigation |
|--------|------------|
| Droits sur les noms/stats officielles | Données issues de sources communautaires ouvertes |
| Complexité des règles (éditions multiples) | Focus sur la 10e édition en MVP |
| Adoption initiale faible | Marketing Reddit/Discord communauté WH40K |
| Concurrence (Battlescribe) | Différenciation : UX moderne + calculs auto + partage |

