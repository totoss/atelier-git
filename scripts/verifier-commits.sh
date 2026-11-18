#!/usr/bin/env bash
# Vérifie que les commits de BASE..HEAD suivent la convention décrite dans le README.
# Usage : bash scripts/verifier-commits.sh origin/main HEAD
set -euo pipefail

base=${1:?usage : verifier-commits.sh BASE HEAD}
head=${2:?usage : verifier-commits.sh BASE HEAD}
# Le message par défaut de « git revert » est accepté tel quel.
motif='^((feat|fix|docs|test|refactor|chore|ci)(\([a-z0-9-]+\))?!?: .+[^.]|Revert ".+")$'

sujets=$(git log --no-merges --format=%s "$base..$head")
if [ -z "$sujets" ]; then
  echo "Aucun commit à vérifier entre $base et $head."
  exit 0
fi

echec=0
while IFS= read -r sujet; do
  if [ "${#sujet}" -le 72 ] && [[ $sujet =~ $motif ]]; then
    echo "ok     $sujet"
  else
    echo "REFUS  $sujet"
    echec=1
  fi
done <<< "$sujets"

if [ "$echec" -ne 0 ]; then
  echo
  echo "Format attendu : type(portée): résumé (72 caractères au plus, sans point final)."
  echo "Types : feat, fix, docs, test, refactor, chore, ci."
fi
exit "$echec"
