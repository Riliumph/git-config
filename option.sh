[alias]
# show option alias
	branches = branch -a
	rename-branch = branch -m
	remotes = remote -v
	log-tree = log --graph --abbrev-commit --date=short --pretty=format:'%C(green)[%cd] %C(cyan)<%an> %C(red)%h%C(yellow)%d %C(reset)%s '
	time-line = log --graph -20 --branches --remotes --tags  --format=format:'%C(cyan)<%cN> %C(red)%h %C(reset)%<(75,trunc)%s %C(green)(%cr) %C(yellow)%d' --date-order
	detail = status -uall
	summary = status -s -u
# work option alias
	stashes = stash list
	stage = add
	unstage = reset HEAD
	discard = checkout
# commit = commit
	uncommit = reset --mixed HEAD~
	meldiff = difftool
	melge = mergetool
	staged-diff = diff --cached
	purify = clean -df
[core]
	editor = vim
	quotepath = false
[diff]
	algorithm = patience
	compactionHeuristic = true
	indentHeuristic = true
	tool = meld
[difftool "meld"]
	cmd = meld $LOCAL $REMOTE
[merge]
	ff = false
	tool = meld
[mergetool "meld"]
	cmd = meld $LOCAL $BASE --auto-merge
[pager]
	log = diff-highlight | less
	show = diff-highlight | less
	diff = diff-highlight | less
[fetch]
	prune=true
[pull]
	ff = only
[push]
	default = simple

