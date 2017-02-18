BULLETTRAIN_CONTEXT_DEFAULT_USER='naveed'

BULLETTRAIN_PROMPT_ORDER=(
  time
	status
	# custom
	context
	dir
	# perl
	ruby
	# virtualenv
	# go
	git
	# hg
	cmd_exec_time
)


# init according to man page
if (( $+commands[rbenv] ))
then
  eval "$(rbenv init -)"
fi

