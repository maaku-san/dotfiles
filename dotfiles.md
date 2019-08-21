dotfiles
========

* https://www.atlassian.com/git/tutorials/dotfiles
* https://harfangk.github.io/2016/09/18/manage-dotfiles-with-a-git-bare-repository.html

start from scratch
------------------

* create a bare git repo which will track our files
```
git init --bare $HOME/.dotfiles
```

* create an alias to make using our new repo easier
```
alias dfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

* hide files that we are not tracking from git
```
dfiles config --local status.showUntrackedFiles no
```

* add an origin repo
```
dfiles remote add origin https://github.com/mark-vandenbos/dotfiles.git
```

* add the dfiles alias to our shell profile
```
`echo "alias dfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> ${HOME}/.zshrc`
```

workflow
--------

* add 
```
dfiles add .vimrc
dfiles commit -m "add vimrc"
dfiles add .zshrc
dfiles commit -m "add zshrc"
```

* push 
```
dfiles push -u origin master
dfiles push -u -f origin master
```

clone dfiles onto a new machine
-------------------------------

* create your alias
```
alias dfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

* ignore .dotfiles dir to prevent weird recursion problems
```
echo ".dotfiles" >> .gitignore
```

* clone dotfiles into a bare repo
```
git clone --bare https://github.com/mark-vandenbos/dotfiles.git $HOME/.dotfiles
```

* checkout the actual content from the bare repository to your $HOME:
```
dfiles checkout
```

* you might need tp cleanup existing configs
```
mkdir -p .dotfiles-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
```

* re-run the checkout
```
dfiles checkout 
```
