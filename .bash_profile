export SVN_EDITOR=vim
export PS1="\u:\[\e[0;36m\]\W\[\e[m\] \[\033[31m\]\`ruby -e \"print (%x{git branch 2> /dev/null}.grep(/^\*/).first || '').gsub(/^\* (.+)$/, '(\1) ')  rescue ''\"\`\[\033[37m\]# "

export PATH=$(echo $PATH | sed -e 's;:\?/opt/local/lib/postgresql83/bin;;' -e 's;/opt/local/lib/postgresql83/bin:\?;;')
export PATH=/usr/local/cuda/bin:/usr/local/pgsql/bin/:$PATH 
export PATH=/usr/local/sbin:$PATH 
export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PAT

alias gols='cd ~/Projects/ls-server'
alias gomile="cd ~/Projects/luxurysociety/branches;cd \`ls -ld milestone-* |tail -n1|egrep -o 'milestone-.*'\`"
alias gostats='cd ~/Projects/Stats\ Api/rails' 
alias gosub='cd /Users/zog/Projects/luxurysociety/branches/subscriptions'
alias gowhite='cd /Users/zog/Projects/luxurysociety/branches/whiteboard'
alias mate_conflicts="svn st |grep C|awk '{ FS = \" \" } ; {print $2}'|xargs mate"
alias resolve_conflicts="svn st |grep C|awk -F \" \" '{print $2}'|xargs svn resolved"
alias reset_log='echo "" > log/development.log;echo "" > log/test.log'
alias solr_start='gols;rake sunspot:solr:start;cd -'
alias solr_stop='gols;rake sunspot:solr:stop;cd -'
alias solr_restart='gols;rake sunspot:solr:start;rake sunspot:solr:stop;cd -'
alias goto='. ~/go_project.sh $1'
#alias trim='echo $1;sed "s/^[ \t]*$//" $1  > .trim_tmp; mv .trim_tmp $1'
alias trim='sed "s/^[ \t]*$//" $1 > .trim_tmp; mv .trim_tmp $1'
alias get_last_ls_dump="cd /Users/zog/Projects/luxurysociety/dumps;/opt/local/bin/s3cmd ls s3://woa/saves/db/|tail -n1|egrep -o 's3:\/\/.*'|xargs /opt/local/bin/s3cmd get;ls -l|egrep -o 'ls_.*bz2'|tail -n1|xargs bunzip2;ls -l|egrep -o 'ls_.*'|tail -n1|xargs ./prep_db.rb > REBUILD_DB"
alias check='ruby ~/scripts/check_before_commit.rb|less -f -R'
alias clear_prod_files='find public -name prod-*|xargs rm'
alias edit_bash_profile='mate ~/.bash_profile'
alias gui='open /Users/zog/Projects/ls-design'

alias pgrep='ps aux|grep -i $1'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"