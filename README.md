### Setup


* Run Chezmoi `$ sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply kishan2k`



run `./bin/chezmoi edit-config`
and enter this:
```
mode = "symlink"
[data]
    email = "kishan+git@ambasana.me"
    name = "Kishan"    
[git]
    autoCommit = true
    autoPush = true
[edit]
    command = "code"
    args = ["--wait"]
```