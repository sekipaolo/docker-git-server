#!/bin/sh

set -u

log() {
  if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}

add_keys(){
	mkdir -p /home/git/.ssh 
	touch /home/git/.ssh/authorized_keys 
	cat /home/git/keys/*.pub > /home/git/.ssh/authorized_keys 
	chown -R git:git /home/git/
	chmod -R 700 /home/git/  
}

make_repos(){
	for REPO in "configs"; do		
		REPO_NAME=/home/git/repos/$REPO.git
		if [ ! -d $REPO_NAME ]; then
			log "Create repo $REPO"
			mkdir -p $REPO_NAME
			cd $REPO_NAME && git init --bare
			chown -R git:git $REPO_NAME
		fi
	done
}

KEYS_DIR=/home/git/keys
SSH_CMD="$(which sshd) -D"

rsyslogd

add_keys
make_repos
log "waiting 1 seconds"
sleep 1
exec $SSH_CMD 

# Check if config has changed
# Note: also monitor /etc/hosts where the new back-end hosts might be provided.
# while inotifywait -q -e create,delete,modify,attrib $NGINX_CONFIG; do
#   log "Restarting NGINX due to config changes..."
#   $NGINX_CHECK_CONFIG_CMD
#   $NGINX_CMD -s reload
#   log "NGINX restarted, pid $(cat $NGINX_PID_FILE)." 
# done
