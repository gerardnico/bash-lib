% bashlib-git(1) Version Latest | bashlib-git
# bashlib-git documentation

Library of Git wrapper functions (known wildly as git helpers)

## DESCRIPTION

See also [git-extras](https://github.com/tj/git-extras/blob/main/Commands.md)

## Index

* [git::get_default_branch](#gitget_default_branch)
* [git::get_current_branch](#gitget_current_branch)
* [git::get_current_upstream_branch](#gitget_current_upstream_branch)
* [git::checkout_default](#gitcheckout_default)
* [git::branch_delete](#gitbranch_delete)
* [git::diff](#gitdiff)
* [git::is_dirty_index](#gitis_dirty_index)
* [git::is_dirty_commit](#gitis_dirty_commit)
* [git::is_dirty](#gitis_dirty)
* [git::get_commits_not_pushed](#gitget_commits_not_pushed)
* [git::get_eval_string](#gitget_eval_string)
* [git::get_dirty_files](#gitget_dirty_files)
* [git::get_auto_commit_message](#gitget_auto_commit_message)
* [git::has_upstream](#githas_upstream)

### git::get_default_branch

Get the default branch

### git::get_current_branch

Get the current branch

### git::get_current_upstream_branch

Get the current upstream branch

#### Exit codes

* **0**: - if the branch has an upstream (ie remote)
* **1**: - if the branch has no upstream (ie remote)

#### Output on stdout

* - the name of the upstream

### git::checkout_default

Go to the default branch (main/master)

#### Example

```bash
git::checkout_main
```

### git::branch_delete

Delete the current branch and go to the default branch

### git::diff

Diff of one file with the head

#### Example

```bash
gdiff README.md
```

### git::is_dirty_index

Check if there is some modified or delete files not commited

#### Exit codes

* **1**: if the repo is index dirty

### git::is_dirty_commit

Check if there is some commit not pushed

#### Exit codes

* **1**: if their is some commit not pushed

### git::is_dirty

Check if there is:
* some modified or delete files not commited
* some commit not pushed

#### Exit codes

* **0**: if the repo is dirty
* **1**: if the repo is not dirty

### git::get_commits_not_pushed

Get the commits not integrated in the upstream branch
The repository is considered dirty if this the case

#### Output on stdout

* the commits not pushed

### git::get_eval_string

Create a full git string command

### git::get_dirty_files

#### Arguments

* **$1** (string): - the separator (by default a comma)

### git::get_auto_commit_message

create a commit message automatically based on the changed files

### git::has_upstream

Check if the branch has an upstream

