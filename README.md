# git-watch
systemd service watching for commits in a git repository and trigger an action.

## Install
```
git clone https://github.com/RandomReaper/git-watch.git
cd git-watch
sudo ./install.sh
```

## Example use
* Create a git repository
```
cd /tmp/
git init test
cd test
echo "just a test" > test.txt
git add test.txt
git commit -a -m "Initial commit."
```

* Create a config file : `/etc/watch-git/test`
```
GITSRC="/tmp/test"
GITCMD="md5sum *"
```

* Start the service
```
sudo systemctl start git-watch@test
```

* Sample output on syslog:
```
MMM DD HH:15:11 rr-linux systemd[1]: Starting git-watch test...
MMM DD HH:15:11 rr-linux systemd[1]: Started git-watch test.
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: Cloning into '/var/cache/git-watch/test/git'...
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: done.
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: commit a294d55d74d1d155e0faf49dcb4c265c27195cf4
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: Author: XXX <XXX@XXX.XXX>
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: Date:   ddd MMM DD HH:14:30 YYYY +0100
MMM DD HH:15:11 rr-linux git-watch(test)[PID]:     Initial commit.
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: success
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: STDOUT:
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: efbba249bd50cd2e9983a73f1af2bab7  test.txt
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: ---
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: STDERR:
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: ---
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: Setting up watches.
MMM DD HH:15:11 rr-linux git-watch(test)[PID]: Watches established.
```

* Do some changes to the repository
```
cd /tmp/test
echo "A new line" >> test.txt
git add test.txt
git commit -a -m "testing git-watch"

```

* Sample output on syslog:
```
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: /tmp/test/.git/refs/heads/master OPEN
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: Fetching origin
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: From /tmp/test
MMM DD HH:17:42 rr-linux git-watch(test)[PID]:    a294d55..043d415  master     -> origin/master
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: HEAD is now at 043d415 testing git-watch
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: commit 043d41528516deaa2743d3a041be7ecbf3816624
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: Author: XXX <XXX@XXX.XXX>
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: Date:   ddd MMM DD HH:17:42 YYYY +0100
MMM DD HH:17:42 rr-linux git-watch(test)[PID]:     testing git-watch
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: success
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: STDOUT:
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: ec9dba4f1af159b4e76e4f04567f4fe2  test.txt
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: ---
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: STDERR:
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: ---
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: Setting up watches.
MMM DD HH:17:42 rr-linux git-watch(test)[PID]: Watches established.
```