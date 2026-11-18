# Atelier Git

Un dépôt pour s'entraîner au workflow Git : branches courtes, pull requests, rebase, conflits, réparations et versions.

Le projet est volontairement minuscule : une page web statique, sans rien à installer. Chacun travaille sur son propre fork, vous ne pouvez donc rien casser.

| Chemin | Rôle |
| --- | --- |
| `site/` | La page du Café du Dépôt. C'est le seul dossier que vous modifiez. Ouvrez `site/index.html` dans un navigateur pour voir le résultat. |
| [`EXERCICES.md`](EXERCICES.md) | Les six exercices, à faire dans l'ordre. |
| `scripts/verifier-commits.sh` | La vérification des messages de commit, lancée aussi sur chaque pull request. |

## Mise en place

Les commandes se tapent dans un terminal. Sous Windows, utilisez **Git Bash**, installé avec Git, et non PowerShell.

1. Sur GitHub, cliquez sur **Fork** en haut de cette page. Laissez cochée l'option « Copy the `main` branch only ».
2. Dans votre fork, ouvrez l'onglet **Actions** et activez les workflows. Ils sont désactivés par défaut sur un fork.
3. Clonez votre fork, pas le dépôt d'origine :

   ```bash
   git clone https://github.com/<votre-compte>/atelier-git.git
   cd atelier-git
   ```

4. Déclarez le dépôt d'origine sous le nom `upstream`, pour pouvoir récupérer d'éventuelles mises à jour des exercices :

   ```bash
   git remote add upstream https://github.com/totoss/atelier-git.git
   ```

5. Vérifiez :

   ```bash
   git remote -v
   ```

   Vous devez voir `origin` (votre fork) et `upstream` (le dépôt d'origine), chacun deux fois.

> **Attention aux pull requests.** Depuis un fork, GitHub propose par défaut d'ouvrir la pull request vers le dépôt d'origine. À chaque exercice, choisissez **votre fork** comme « base repository » avant de créer la pull request.

Pour récupérer une mise à jour des exercices :

```bash
git switch main
git fetch upstream
git merge upstream/main
git push
```

## Le workflow en bref

```text
main     ●────────────────────────●───▶   toujours déployable
          \                      /
branche    ●───●───●── pull request      revue + CI verte, puis fusion
```

1. Mettre `main` à jour et créer une branche pour le changement.
2. Commiter par petites étapes et pousser tôt.
3. Ouvrir une pull request.
4. Attendre la revue et une CI verte.
5. Fusionner dans `main`, puis supprimer la branche.

## Les conventions

**Branches** : `type/description-courte`, en minuscules avec tirets. Exemples : `feat/ajouter-chocolat-chaud`, `fix/prix-the-vert`, `hotfix/horaires`.

**Commits** : `type(portée): résumé`, la portée étant facultative.

- Types : `feat` (fonctionnalité), `fix` (correction), `docs`, `test`, `refactor`, `chore`, `ci`.
- Résumé à l'infinitif, 72 caractères au plus, sans point final.
- Exemple : `fix(horaires): corriger l'heure de fermeture`

Pour vérifier vos commits avant de pousser :

```bash
bash scripts/verifier-commits.sh origin/main HEAD
```

**Historique** : on ne réécrit jamais un historique déjà partagé.

- Pas de `git push --force` : après un rebase de votre propre branche, utilisez `git push --force-with-lease`.
- Pas de `rebase`, `reset` ou `amend` sur des commits que d'autres ont déjà récupérés.
- Un commit déjà poussé s'annule avec `git revert`.

## Si vous êtes perdu

| Situation | Commande |
| --- | --- |
| Voir où vous en êtes | `git status` |
| Abandonner un rebase en cours | `git rebase --abort` |
| Abandonner un merge en cours | `git merge --abort` |
| Retrouver un commit perdu | `git reflog` |
