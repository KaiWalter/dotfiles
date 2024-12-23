# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

uptime_formatted=$(uptime | cut -d ',' -f1  | sed 's/.*up //')

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %F %H:%M")

# Get the Linux version but remove the "-1-ARCH" part
linux_version=$(uname -r | cut -d '-' -f1)
hostname=$(uname -n)

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')

# Returns the battery status: "Full", "Discharging", or "Charging".
# battery_status=$(cat /sys/class/power_supply/BAT0/status)

# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 \|
echo ↑ $uptime_formatted  🖥️ $hostname  🐧$linux_version 󰥔  $date_formatted 󰕿 $volume
