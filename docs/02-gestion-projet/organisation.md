# Organisation du projet — ForgeRoster

Le suivi des tâches se fait sur [GitHub Projects](https://github.com/users/MrLkuch/projects/3). Chaque ticket est une issue du dépôt, ce qui relie directement le suivi au code.

## Où trouver quoi

| Document | Rôle |
|---|---|
| [Tableau GitHub Projects](https://github.com/users/MrLkuch/projects/3) | État de chaque ticket au quotidien. C'est la seule référence pour savoir où en est un ticket. |
| [planning.md](planning.md) | Sprints, jalons, ordre des tâches et définition de « terminé ». |
| [backlog.md](backlog.md) | Epics, User Stories, critères d'acceptation et décisions prises. |

## Colonnes du tableau

| Colonne | Signification |
|---|---|
| Backlog | Ticket prévu dans un sprint à venir |
| À faire | Ticket du sprint en cours, pas encore commencé |
| En cours | Ticket en train d'être traité |
| En revue | Travail produit, en attente de vérification |
| Terminé | Ticket vérifié et fermé |

Un ticket passe en Terminé quand il respecte la définition donnée dans [planning.md](planning.md).

## Champs des tickets

- **Epic** : grande fonctionnalité à laquelle le ticket appartient.
- **Sprint** : de S0 à S6, ou Réserve pour ce qui n'est pas planifié.
- **Priorité** : méthode MoSCoW (Must, Should, Could, Won't).
- **Points** : effort relatif (1, 2, 3, 5 ou 8), pas un nombre d'heures.

## Lien avec le code

Un commit ou une pull request qui traite un ticket cite le numéro de son issue. La mention `Closes #12` dans une pull request ferme l'issue au moment de la fusion.
