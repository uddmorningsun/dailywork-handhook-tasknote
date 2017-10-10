# Aliases definitions, parts of alias refer to: https://github.com/robbyrussell/oh-my-zsh

alias chromium="/bin/chromium-browser --proxy-server='http://127.0.0.1:8118;https://127.0.0.1:8118'"
# Debian/Ubuntu `which` from debianutils, CentOS/Fedora > Debian/Ubuntu
alias ipython="$(which --skip-alias ipython >/dev/null 2>&1 || which ipython) --term-title --HistoryManager.hist_file=/tmp/ipython_hist.sqlite --colors Linux"
