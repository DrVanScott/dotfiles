
############# SETOPT ######################################

# http://zsh.sourceforge.net/Doc/Release/Options-Index.html

# ===== Basics
# please no beeeeeeps
setopt NO_BEEP
# list jobs in the long format by default
setopt LONG_LIST_JOBS
# allow comments even in interactive shells
setopt INTERACTIVECOMMENTS
# all unquoted arguments of the form identifier=expression appearing after the command name have file expansion
setopt MAGIC_EQUAL_SUBST
# append a trailing ‘/’ to all directory names resulting from filename generation
setopt MARK_DIRS

# do not beeep, please
unsetopt HIST_BEEP
# do not freezes output to the terminal until you type ^q `\
unsetopt FLOWCONTROL


# ===== Prompt
# the prompt string is first subjected to parameter expansion, command substitution and arithmetic expansion
setopt PROMPT_SUBST
# remove any right prompt from display when accepting a command line. This may be useful with terminals with other cut/paste methods
setopt TRANSIENT_RPROMPT


# ===== Changing Directories
# Make cd push the old directory onto the directory stack
setopt AUTO_PUSHD
# swapped the meaning of cd +1 and cd -1; we want them to mean the opposite of what they mean im csh
setopt PUSHDMINUS
# don’t push multiple copies of the same directory onto the directory stack
setopt PUSHD_IGNORE_DUPS
# if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt CDABLEVARS

# do not print the directory stack after pushd or popd
unsetopt PUSHD_SILENT
# if a command is not in the hash table, and there exists an executable directory by that name, perform the cd command to that directory
unsetopt AUTO_CD


# ===== Expansion and Globbing
# when the current word has a glob pattern, do not insert all the words resulting from the expansion but generate matches as for completion and cycle through them
setopt GLOB_COMPLETE
# more patterns for filename generation
setopt EXTENDED_GLOB


# ===== History
# Allow multiple terminal sessions to all append to one zsh command history
setopt APPEND_HISTORY
# Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file
setopt EXTENDED_HISTORY
# Add commands as they are typed, don't wait until shell exit
setopt INC_APPEND_HISTORY
# If the internal history needs to be trimmed to add the current command line, setting this option will cause the oldest history event that has a duplicate to be lost before losing a unique event
setopt HIST_EXPIRE_DUPS_FIRST
# Do not enter command lines into the history list if they are duplicates of the previous event
setopt HIST_IGNORE_DUPS
# remove command lines from the history list when the first character on the line is a space
setopt HIST_IGNORE_SPACE
# When searching history don't display results already cycled through twice
setopt HIST_FIND_NO_DUPS
# remove the history (fc -l) command from the history list when invoked
setopt HIST_NO_STORE
# remove superfluous blanks from each command line being added to the history list
setopt HIST_REDUCE_BLANKS
# whenever the user enters a line with history expansion, don’t execute the line directly 
setopt HIST_VERIFY

# this option both imports new commands from the history file, and also causes your typed command
unsetopt SHARE_HISTORY


# ===== Completion
# show completion menu on successive tab press ... needs unsetop menu_complete to work
setopt AUTO_MENU
# automatically list choices on an ambiguous completion
setopt AUTO_LIST
# when listing files that are possible completions, show the type of each file with a trailing identifying mark
setopt LIST_TYPES
# extra completion
setopt COMPLETE_ALIASES
# if unset, the cursor is set to the end of the word if completion is started. Otherwise it stays there and completion is done from both ends
setopt COMPLETE_IN_WORD
# if a completion is performed with the cursor within a word, and a full completion is inserted, the cursor is moved to the end of the word
setopt ALWAYS_TO_END

# do not autoselect the first completion entry
unsetopt MENU_COMPLETE
# do not set auto_name_dirs because it messes up prompts (any parameter that is set to the absolute name of a directory immediately becomes a name for that directory)
unsetopt AUTO_NAME_DIRS


# ===== Correction
# no spelling correction for commands
unsetopt CORRECT
# no spelling correction for arguments
unsetopt CORRECT_ALL


# ===== Scripts and Functions
# # perform implicit tees or cats when multiple redirections are attempted
setopt MULTIOS