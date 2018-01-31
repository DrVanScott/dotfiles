## Bazaar integration
## Just works with the GIT integration just add $(bzr_prompt_info) to the PROMPT

bzr_prompt_info()
{
  local bzr_dirty=''
	local bzr_cb=''

  bzr_cb=$(bzr nick 2> /dev/null \
    | grep -v "ERROR" \
    | cut -d ":" -f2 \
    | awk -F / '{print "bzr::"$1}')

	if [ -n "$bzr_cb" ]; then
		[[ -n $(bzr status) ]] && bzr_dirty=" %{$fg[red]%} * %{$fg[green]%}"
		echo "${ZSH_THEME_SCM_PROMPT_PREFIX}${bzr_cb}${bzr_dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
	fi
}
