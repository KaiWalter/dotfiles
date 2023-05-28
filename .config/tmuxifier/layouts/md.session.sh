# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/src/message-distribution/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "md"; then

  new_window "nvim"
  split_v 60
  select_pane 0
  run_cmd "nvim ."

  select_pane 1
  split_h 20
  run_cmd "cat ~/.tmux.conf | grep  -E '^bind'"

  select_pane 0

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
