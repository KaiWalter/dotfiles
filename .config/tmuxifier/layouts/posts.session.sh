# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/src/automate-posts/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "posts"; then

  new_window "nvim"
  select_pane 0
  run_cmd "nvim ."

  split_h 20
  select_pane 1
  run_cmd "pwsh"

  select_pane 0

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
