# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

# Terragrunt multi version installer 
export PATH="$HOME/.tgenv/bin:$PATH"

PS1='\h:\W \u\$ '
# Make bash check its window size after a process completes
shopt -s checkwinsize
[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"


#### Custom bash env setups #########
# vim: ft=sh
# No brainer, default to Vim
#export EDITOR="vim"

# Color LS output to differentiate between directories and files
export LS_OPTIONS="--color=auto"
export CLICOLOR="Yes"
export LSCOLOR=""

# Customize Path
export PATH=$HOME/bin:$PATH

# Get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ]
  then
    STAT=`parse_git_dirty`
    echo "[${BRANCH}${STAT}]"
  else
    echo ""
  fi
}

# get current status of git repo
function parse_git_dirty {
  status=`git status 2>&1 | tee`
  dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  bits=''
  if [ "${renamed}" == "0" ]; then
    bits=">${bits}"
  fi
  if [ "${ahead}" == "0" ]; then
    bits="*${bits}"
  fi
  if [ "${newfile}" == "0" ]; then
    bits="+${bits}"
  fi
  if [ "${untracked}" == "0" ]; then
    bits="?${bits}"
  fi
  if [ "${deleted}" == "0" ]; then
    bits="x${bits}"
  fi
  if [ "${dirty}" == "0" ]; then
    bits="!${bits}"
  fi
  if [ ! "${bits}" == "" ]; then
    echo " ${bits}"
  else
    echo ""
  fi
}

# Shortify prompt 
export PS1="\[\e[36m\]\W\[\e[m\]\[\e[32m\]\`parse_git_branch\`\[\e[m\] $ "

# Custom: Linux Aliases 
alias ll="ls -lrt"

# Custom: cloud infra 
alias tf="/Users/fmbah/.tfenv/bin/terraform"
alias tfplan="/Users/fmbah/.tfenv/bin/terraform validate && /Users/fmbah/.tfenv/bin/terraform fmt && /Users/fmbah/.tfenv/bin/terraform plan"
alias tg="/Users/fmbah/.tgenv/bin/terragrunt"
alias tfws="/Users/fmbah/.tfenv/bin/terraform workspace "
alias scout2="/usr/local/bin/Scout2"

# Custom: K8s Aliases 
alias k="/usr/local/bin/kubectl"
complete -F __start_kubectl k
alias klogs="/usr/local/bin/kubectl logs -f"
alias kcontext="/usr/local/bin/kubectl config current-context"
alias kswitch="/usr/local/bin/kubectl config use-context "
alias kcontextlist="/usr/local/bin/kubectl config get-contexts "
alias kcd="/usr/local/bin/kubectl config set-context --current --namespace "
alias kdesc="/usr/local/bin/kubectl describe "
alias kconfigcluster="/usr/local/bin/aws eks --region eu-west-1 update-kubeconfig --name "

# Custom: Git aliases 
alias gl="git log --graph --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias glb="git log --graph --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"


# Custom Docker Aliases 
alias dcompose="/usr/local/bin/docker-compose"

# Custom AWS aliases 
alias aws_current_acct="aws iam list-account-aliases"
alias aws_current_acct_instances="aws ec2 describe-instances | jq -r '.Reservations[].Instances[]|.InstanceId+\" \"+.InstanceType+\" \"+(.Tags[] | select(.Key == \"Name\").Value)'"
alias aws_current_acct_vpc="aws ec2 describe-vpcs | jq -r '.Vpcs[]|.VpcId+\" \"+(.Tags[]|select(.Key==\"Name\").Value)+\" \"+.CidrBlock'"
alias awsclf="aws cloudformation "

# Local jenkins
alias start_jenkins="sudo brew services start jenkins-lts"
alias stop_jenkins="sudo brew services stop jenkins-lts"
alias restart_jenkins="sudo brew services restart jenkins-lts"

# Terragrunt plan|apply 
alias tgplan="/Users/fmbah/.tgenv/bin/terragrunt plan  --terragrunt-source-update 2>/dev/null"
alias tgapply="/Users/fmbah/.tgenv/bin/terragrunt apply  --terragrunt-source-update 2>/dev/null"

