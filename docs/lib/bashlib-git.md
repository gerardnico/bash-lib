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
* [git::is_dirty](#gitis_dirty)
* [git::get_eval_string](#gitget_eval_string)
* [git::get_dirty_files](#gitget_dirty_files)
* [git::get_auto_commit_message](#gitget_auto_commit_message)

### git::get_default_branch

Get the default branch

### git::get_current_branch

Get the current branch

### git::get_current_upstream_branch

Get the current upstream branch

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

### git::is_dirty

Check if there is some modified or delete files not commited

#### Exit codes

* **1**: if the repo is dirty

### git::get_eval_string

Create a full git string command

### git::get_dirty_files

#### Arguments

* **$1** (string): - the separator (by default a comma)

### git::get_auto_commit_message

create a commit message automatically based on the changed files

