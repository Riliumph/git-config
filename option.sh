[alias]
	branches = branch -a
	rename-branch = branch -m
	stashes = stash list
	remotes = remote -v
	log-tree = log --graph --abbrev-commit --date=short --pretty=format:'%C(green)[%cd] %C(cyan)<%an> %C(red)%h%C(yellow)%d %C(reset)%s '
	time-line = log --graph -20 --branches --remotes --tags  --format=format:'%C(cyan)<%cN> %C(red)%h %C(reset)%<(75,trunc)%s %C(green)(%cr) %C(yellow)%d' --date-order
	detail = status -uall
	summary = status -s -u
# work option alias
	stage = add
	unstage = reset HEAD
	discard = checkout
# commit = commit
	uncommit = reset --mixed HEAD~
	meldiff = difftool
	melge = mergetool
	staged-diff = diff --cached
[core]
	quotepath = false
[diff]
	algorithm = patience
	compactionHeuristic = true
	indentHeuristic = true
	tool = meld
[difftool "meld"]
	cmd = meld $LOCAL $REMOTE
[pull]
	ff = only
[push]
	default = simple

