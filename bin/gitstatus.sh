#!/bin/bash
# -*- coding: utf-8 -*-
# gitstatus.sh -- produce the current git repo status on STDOUT
# Functionally equivalent to 'gitstatus.py', but written in bash (not python).
#
# Alan K. Stebbens <aks@stebbens.org> [http://github.com/aks]

if [[ "${__GIT_PROMPT_IGNORE_SUBMODULES}" == "1" ]]; then
  _ignore_submodules=--ignore-submodules
else
  _ignore_submodules=
fi

gitstatus=$( LC_ALL=C timeout 3 git status ${_ignore_submodules} --untracked-files=${__GIT_PROMPT_SHOW_UNTRACKED_FILES:-all} --porcelain --branch )

# if the status is fatal, exit now
[[ "$?" -ne 0 ]] && exit 0

git_dir="$(git rev-parse --git-dir 2>/dev/null)"
[[ -z "$git_dir" ]] && exit 0

__git_prompt_read ()
{
  local f="$1"
  shift
  test -r "$f" && read "$@" <"$f"
}

state=""
step=""
total=""
if [ -d "${git_dir}/rebase-merge" ]; then
  __git_prompt_read "${git_dir}/rebase-merge/msgnum" step
  __git_prompt_read "${git_dir}/rebase-merge/end" total
  if [ -f "${git_dir}/rebase-merge/interactive" ]; then
    state="|REBASE-i"
  else
    state="|REBASE-m"
  fi
else
  if [ -d "${git_dir}/rebase-apply" ]; then
    __git_prompt_read "${git_dir}/rebase-apply/next" step
    __git_prompt_read "${git_dir}/rebase-apply/last" total
    if [ -f "${git_dir}/rebase-apply/rebasing" ]; then
      state="|REBASE"
    elif [ -f "${git_dir}/rebase-apply/applying" ]; then
      state="|AM"
    else
      state="|AM/REBASE"
    fi
  elif [ -f "${git_dir}/MERGE_HEAD" ]; then
    state="|MERGING"
  elif [ -f "${git_dir}/CHERRY_PICK_HEAD" ]; then
    state="|CHERRY-PICKING"
  elif [ -f "${git_dir}/REVERT_HEAD" ]; then
    state="|REVERTING"
  elif [ -f "${git_dir}/BISECT_LOG" ]; then
    state="|BISECTING"
  fi
fi

if [ -n "$step" ] && [ -n "$total" ]; then
  state="${state} ${step}/${total}"
fi

num_staged=0
num_changed=0
num_conflicts=0
num_untracked=0
while IFS='' read -r line || [[ -n "$line" ]]; do
  status=${line:0:2}
  while [[ -n $status ]]; do
    case "$status" in
      #two fixed character matches, loop finished
      \#\#) branch_line="${line/\.\.\./^}"; break ;;
      \?\?) ((num_untracked++)); break ;;
      U?) ((num_conflicts++)); break;;
      ?U) ((num_conflicts++)); break;;
      DD) ((num_conflicts++)); break;;
      AA) ((num_conflicts++)); break;;
      #two character matches, first loop
      ?M) ((num_changed++)) ;;
      ?D) ((num_changed++)) ;;
      ?\ ) ;;
      #single character matches, second loop
      U) ((num_conflicts++)) ;;
      \ ) ;;
      *) ((num_staged++)) ;;
    esac
    status=${status:0:(${#status}-1)}
  done
done <<< "$gitstatus"

num_stashed=0
if [[ "$__GIT_PROMPT_IGNORE_STASH" != "1" ]]; then
  stash_file="$( git rev-parse --git-dir )/logs/refs/stash"
  if [[ -e "${stash_file}" ]]; then
    while IFS='' read -r wcline || [[ -n "$wcline" ]]; do
      ((num_stashed++))
    done < ${stash_file}
  fi
fi

clean=0
if (( num_changed == 0 && num_staged == 0 && num_untracked == 0 && num_stashed == 0 && num_conflicts == 0)) ; then
  clean=1
fi

IFS="^" read -ra branch_fields <<< "${branch_line/\#\# }"
branch="${branch_fields[0]}"
remote=
upstream=

if [[ "$branch" == *"Initial commit on"* ]]; then
  IFS=" " read -ra fields <<< "$branch"
  branch="${fields[3]}"
  remote="_NO_REMOTE_TRACKING_"
elif [[ "$branch" == *"No commits yet on"* ]]; then
  IFS=" " read -ra fields <<< "$branch"
  branch="${fields[4]}"
  remote="_NO_REMOTE_TRACKING_"
elif [[ "$branch" == *"no branch"* ]]; then
  tag=$( git describe --tags --exact-match )
  if [[ -n "$tag" ]]; then
    branch="$tag"
  else
    branch="_PREHASH_$( git rev-parse --short HEAD )"
  fi
else
  if [[ "${#branch_fields[@]}" -eq 1 ]]; then
    remote="_NO_REMOTE_TRACKING_"
  else
    IFS="[,]" read -ra remote_fields <<< "${branch_fields[1]}"
    upstream="${remote_fields[0]}"
    for remote_field in "${remote_fields[@]}"; do
      if [[ "$remote_field" == "ahead "* ]]; then
        num_ahead=${remote_field:6}
        ahead="_AHEAD_${num_ahead}"
      fi
      if [[ "$remote_field" == "behind "* ]] || [[ "$remote_field" == " behind "* ]]; then
        num_behind=${remote_field:7}
        behind="_BEHIND_${num_behind# }"
      fi
    done
    remote="${behind}${ahead}"
  fi
fi

if [[ -z "$remote" ]] ; then
  remote='.'
fi

if [[ -z "$upstream" ]] ; then
  upstream='^'
fi

printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" \
  "${branch}${state}" \
  "$remote" \
  "$upstream" \
  $num_staged \
  $num_conflicts \
  $num_changed \
  $num_untracked \
  $num_stashed \
  $clean

exit
