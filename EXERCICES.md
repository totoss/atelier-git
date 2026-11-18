# Exercices

À faire dans l'ordre, après la mise en place décrite dans le [README](README.md). Chaque exercice se termine par une vérification : si le résultat diffère, relisez les étapes avant de continuer.

Les modifications se font dans `site/index.html`, avec l'éditeur de votre choix.

## 1. Le cycle complet

Objectif : mener un changement de la création de la branche à son nettoyage.

1. Partez de `main` à jour et créez la branche :

   ```bash
   git switch main
   git pull --ff-only
   git switch -c feat/ajouter-chocolat-chaud
   ```

2. Dans la carte, ajoutez cette ligne après le thé vert :

   ```html
   <li>Chocolat chaud — 3,50 €</li>
   ```

3. Relisez votre modification, commitez et poussez :

   ```bash
   git diff
   git add site/index.html
   git commit -m "feat(carte): ajouter le chocolat chaud"
   git push -u origin feat/ajouter-chocolat-chaud
   ```

4. Sur GitHub, ouvrez une pull request **vers le `main` de votre fork**. Donnez-lui le même titre que le commit.
5. Attendez que la vérification passe au vert, puis choisissez **Squash and merge** et supprimez la branche.
6. Nettoyez en local :

   ```bash
   git switch main
   git pull --ff-only
   git fetch --prune
   git branch -D feat/ajouter-chocolat-chaud
   ```

   `-D` est nécessaire : après un squash, Git ne voit pas la branche comme fusionnée et `-d` refuse de la supprimer.

Vérification :

```bash
git log --oneline -1
git branch
```

Le dernier commit de `main` est `feat(carte): ajouter le chocolat chaud`, suivi du numéro de la pull request. Il ne reste que la branche `main`.

Pour aller plus loin : refaites une pull request avec un message de commit volontairement faux, par exemple `ajout du café`, et observez la vérification passer au rouge.

## 2. Rester à jour avec un rebase

Objectif : remettre votre branche à jour quand `main` a avancé, sans conflit.

1. Créez une branche et ajoutez une adresse dans le pied de page, sous la ligne de contact :

   ```bash
   git switch main
   git pull --ff-only
   git switch -c feat/ajouter-adresse
   ```

   ```html
   <p>Adresse : 12 rue des Branches, 75000 Paris</p>
   ```

   ```bash
   git add site/index.html
   git commit -m "feat(contact): ajouter l'adresse"
   git push -u origin feat/ajouter-adresse
   ```

2. Jouez le rôle d'un collègue dont le changement vient d'arriver sur `main`. Pour aller vite, vous commitez directement sur `main` : c'est une simulation, à ne pas reproduire dans un vrai projet. Passez sur `main` et changez le prix du thé vert de `2,50 €` à `2,60 €` :

   ```bash
   git switch main
   ```

   ```bash
   git add site/index.html
   git commit -m "fix(carte): corriger le prix du thé vert"
   git push
   ```

3. Revenez sur votre branche et rejouez vos commits sur le nouveau `main` :

   ```bash
   git switch feat/ajouter-adresse
   git fetch origin
   git rebase origin/main
   ```

4. Essayez de pousser normalement :

   ```bash
   git push
   ```

   Git refuse : le rebase a réécrit votre commit, la branche distante n'a plus le même historique.

5. Poussez en confirmant la réécriture de votre propre branche :

   ```bash
   git push --force-with-lease
   ```

Vérification :

```bash
git log --oneline -2
git rev-list --count HEAD..origin/main
```

Votre commit `feat(contact)` est juste au-dessus du commit `fix(carte)`, et la seconde commande affiche `0` : votre branche contient tout `main`.

Terminez comme à l'exercice 1 : pull request vers votre fork, squash, nettoyage.

## 3. Résoudre un conflit

Objectif : provoquer un conflit, l'abandonner une fois, puis le résoudre.

1. Créez une branche et remplacez le slogan par `Le café où chaque commit compte.` :

   ```bash
   git switch main
   git pull --ff-only
   git switch -c feat/changer-slogan
   ```

   ```bash
   git add site/index.html
   git commit -m "feat(accueil): changer le slogan"
   git push -u origin feat/changer-slogan
   ```

2. Simulez de nouveau un collègue, qui modifie la même ligne sur `main`. Passez sur `main` et remplacez le slogan par `Le café des branches courtes.` :

   ```bash
   git switch main
   ```

   ```bash
   git add site/index.html
   git commit -m "feat(accueil): raccourcir le slogan"
   git push
   ```

3. Lancez le rebase de votre branche :

   ```bash
   git switch feat/changer-slogan
   git fetch origin
   git rebase origin/main
   ```

   Git s'arrête et annonce un conflit dans `site/index.html`.

4. Regardez l'état, puis abandonnez :

   ```bash
   git status
   git rebase --abort
   git status
   ```

   Vous êtes revenu exactement à l'état d'avant le rebase. C'est votre sortie de secours.

5. Relancez le rebase :

   ```bash
   git rebase origin/main
   ```

   Ouvrez `site/index.html`. Le conflit ressemble à ceci :

   ```text
   <<<<<<< HEAD
       <p class="slogan">Le café des branches courtes.</p>
   =======
       <p class="slogan">Le café où chaque commit compte.</p>
   >>>>>>> a277d30 (feat(accueil): changer le slogan)
   ```

   Pendant un rebase, la partie du haut (`HEAD`) est la version de `main` et la partie du bas est votre commit.

6. Gardez un seul slogan, celui de votre choix, et supprimez les trois lignes de marqueurs. Puis terminez :

   ```bash
   git add site/index.html
   git rebase --continue
   ```

   Git ouvre l'éditeur pour confirmer le message du commit : enregistrez et fermez.

7. Ouvrez la page dans le navigateur pour contrôler le résultat, puis poussez :

   ```bash
   git push --force-with-lease
   ```

Vérification :

```bash
grep -c "<<<<<<<" site/index.html
git status --short
git rev-list --count HEAD..origin/main
```

Les commandes affichent `0`, puis rien, puis `0` : plus de marqueurs, rien en attente, branche à jour.

Terminez comme à l'exercice 1 : pull request vers votre fork, squash, nettoyage.

## 4. Réparer ses erreurs

Objectif : corriger un message, défaire un commit local, annuler un commit poussé, retrouver un commit perdu. Tout se passe sur une branche jetable.

```bash
git switch main
git pull --ff-only
git switch -c chore/bac-a-sable
```

**a. Corriger le message du dernier commit, non poussé**

```bash
echo "premier essai" > notes.txt
git add notes.txt
git commit -m "notes"
git commit --amend -m "chore: ajouter un fichier de notes"
git log --oneline -1
```

Le message affiché est le second. Le commit a changé d'identifiant : c'est pour cela qu'on ne le fait jamais sur un commit déjà partagé.

**b. Défaire un commit local en gardant les modifications**

```bash
echo "deuxième essai" >> notes.txt
git commit -am "chore: compléter les notes"
git reset --soft HEAD~1
git status --short
```

La dernière commande affiche `M  notes.txt` : le commit a disparu, la modification est toujours là, prête à être commitée. Refaites le commit :

```bash
git commit -m "chore: compléter les notes"
```

**c. Annuler un commit déjà poussé**

```bash
git push -u origin chore/bac-a-sable
git revert --no-edit HEAD
git push
git log --oneline -3
```

Un troisième commit, `Revert "chore: compléter les notes"`, annule le précédent sans réécrire l'historique. Un `git push` normal suffit.

**d. Retrouver un commit perdu**

```bash
git reset --hard HEAD~2
git log --oneline -1
```

Deux commits ont disparu de la branche. Ils existent encore : `git reflog` garde la trace de toutes les positions de `HEAD`.

```bash
git reflog -3
git reset --hard "HEAD@{1}"
```

Vérification :

```bash
git log --oneline -3
```

Les trois commits sont revenus, le `Revert` en tête.

Nettoyage :

```bash
git switch main
git branch -D chore/bac-a-sable
git push origin --delete chore/bac-a-sable
```

## 5. Corriger en urgence et publier une version

Objectif : livrer un correctif par le flux habituel et le publier sous un numéro de version.

La page contient un bogue : le café fermerait à 81 h.

1. Marquez la version actuellement « en production » :

   ```bash
   git switch main
   git pull --ff-only
   git tag -a v1.0.0 -m "v1.0.0"
   git push origin v1.0.0
   ```

2. Créez la branche de correctif, remplacez `81 h` par `18 h`, commitez et poussez :

   ```bash
   git switch -c hotfix/horaires
   ```

   ```bash
   git add site/index.html
   git commit -m "fix(horaires): corriger l'heure de fermeture"
   git push -u origin hotfix/horaires
   ```

3. Sur GitHub : pull request vers votre fork, vérification verte, **Squash and merge**, suppression de la branche. Un correctif urgent suit le même flux que le reste, en plus rapide.
4. Publiez la version corrigée. Un `fix` augmente le dernier chiffre :

   ```bash
   git switch main
   git pull --ff-only
   git tag -a v1.0.1 -m "v1.0.1"
   git push origin v1.0.1
   git fetch --prune
   git branch -D hotfix/horaires
   ```

Vérification :

```bash
git tag --list "v1.*"
git describe
```

Les commandes affichent `v1.0.0` et `v1.0.1`, puis `v1.0.1`.

## 6. Squash ou merge classique

Objectif : comparer les deux stratégies de fusion sur une branche de plusieurs commits.

1. Créez une branche avec deux commits :

   ```bash
   git switch main
   git pull --ff-only
   git switch -c feat/ajouter-desserts
   ```

   Ajoutez `<li>Cookie — 2,00 €</li>` à la carte, puis :

   ```bash
   git add site/index.html
   git commit -m "feat(carte): ajouter le cookie"
   ```

   Ajoutez `<li>Brownie — 2,80 €</li>`, puis :

   ```bash
   git add site/index.html
   git commit -m "feat(carte): ajouter le brownie"
   git push -u origin feat/ajouter-desserts
   ```

2. Sur GitHub, ouvrez la pull request vers votre fork et choisissez cette fois **Create a merge commit**. Supprimez la branche.
3. Récupérez le résultat :

   ```bash
   git switch main
   git pull --ff-only
   git fetch --prune
   git branch -d feat/ajouter-desserts
   ```

   Cette fois `-d` suffit : Git voit la branche comme fusionnée.

Vérification :

```bash
git log --oneline --graph -4
```

Le graphe montre un commit de merge et, sur une ligne à part, vos deux commits conservés. Comparez avec le commit unique de l'exercice 1 : le squash donne un historique plus court, le merge classique garde le détail.
