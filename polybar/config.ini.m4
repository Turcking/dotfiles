define(`BAR_HEIGHT', 60)dnl
define(`BAR_PADDING', 3)dnl
define(`CLOCK_HEIGHT', 150)dnl
define(`CLOCK_WIDTH', 400)dnl
dnl
define(`SYS_DPI', esyscmd(`echo -n $(xrdb -get Xft.dpi)'))dnl
define(`SYS_DPI', ifelse(SYS_DPI, , 96, SYS_DPI))dnl
define(`REAL_BAR_HEIGHT', esyscmd(`echo -n $(echo ' BAR_HEIGHT ` "*" ' SYS_DPI ` / 96 | bc)'))dnl
define(`REAL_BAR_PADDING', esyscmd(`echo -n $(echo ' BAR_PADDING ` "*" ' SYS_DPI ` / 96 | bc)'))dnl
define(`REAL_CLOCK_HEIGHT', esyscmd(`echo -n $(echo ' CLOCK_HEIGHT ` "*" ' SYS_DPI ` / 96 | bc)'))dnl
define(`REAL_CLOCK_WIDTH', esyscmd(`echo -n $(echo ' CLOCK_WIDTH ` "*" ' SYS_DPI ` / 96 | bc)'))dnl
define(`NERD_FONT', esyscmd(`echo -n $(fc-list --format="%{family[0]}\n" | grep -iE "NF|Nerd Font" | head -n1)'))dnl
define(`BATS', esyscmd(`echo -n "\`"; ls -1 /sys/class/power_supply | grep "^BAT" | tr "\n" ","; echo -n "'"'))dnl
define(`WIRED_NETCARDS', esyscmd(`echo -n "\`"; ls -1 /sys/class/net | grep -E "^(en|eth)" | tr "\n" ","; echo -n "'"'))dnl
define(`WIRELESS_NETCARDS', esyscmd(`echo -n "\`"; ls -1 /sys/class/net | grep "^wl" | tr "\n" ","; echo -n "'"'))dnl
dnl
[colors]
background = #992e3440
background-alt = #a0505050
foreground = #eaeaea
trayforeground = #eaeaea
foreground-alt = #9c9c9c
primary = #ffb52a
secondary = #e60053
alert = #bd2c40

trans = #00000000
white = #FFFFFF
black = #000000

red = #e53935
pink = #d81b60
purple = #8e24aa
deep-purple = #5e35b1
indigo = #3949ab
blue = #1e88e5
light-blue = #039be5
cyan = #00acc1
teal = #00897b
green = #43a047
light-green = #7cb342
lime = #c0ca33
yellow = #fdd835
amber = #ffb300
orange = #fb8c00
deep-orange = #f4511e
brown = #6d4c41
grey = #757575
blue-gray = #546e7a

[bar/bar]
dpi = SYS_DPI
width = 100%
height = BAR_HEIGHT
fixed-center = true
override-redirect = true

background = ${colors.background}
foreground = ${colors.foreground}

padding = REAL_BAR_PADDING
module-margin = esyscmd(`echo -n $(echo ' REAL_BAR_PADDING ` / 2 | bc)')

font-0 = "monospace:pixelsize=10;1"
ifelse(NERD_FONT, ,
`font-1 = "fixed:pixelsize=10;1"'
,
`font-1 = "NERD_FONT:size=10;1"'
`font-2 = "fixed:pixelsize=10;1"'
)dnl

modules-left = launcher i3 xwindow
modules-center = date
define(`battery_BAT_generator', `ifelse($1, , , `battery_$1`'ifelse($2, , , ` ')$0(shift($@))')')dnl
define(`network_WIRELESS_NETCARDS_generator', `ifelse($1, , , `network_$1`'ifelse($2, , , ` ')$0(shift($@))')')dnl
define(`network_WIRED_NETCARDS_generator', `ifelse($1, , , `network_$1`'ifelse($2, , , ` ')$0(shift($@))')')dnl
modules-right = network_WIRED_NETCARDS_generator(WIRED_NETCARDS) network_WIRELESS_NETCARDS_generator(WIRELESS_NETCARDS) memory cpu pulseaudio battery_BAT_generator(BATS) tray
popdef(`network_WIRED_NETCARDS_generator')dnl
popdef(`network_WIRELESS_NETCARDS_generator')dnl
popdef(`battery_BAT_generator')dnl

scroll-up = "#i3.prev"
scroll-down = "#i3.next"

[module/xwindow]
type = internal/xwindow
label = %title%

[module/i3]
type = internal/i3
format = <label-state> <label-mode>
show-urgent = true
index-sort = true
enable-click = true
enable-scroll = true
wrapping-scroll = false
fuzzy-match = true

label-mode-padding = REAL_BAR_PADDING
label-mode-foreground = ${colors.foreground}
label-mode-background = ${colors.background-alt}

label-focused = %index%
label-focused-background = ${colors.background-alt}
label-focused-underline= ${colors.primary}
label-focused-padding = REAL_BAR_PADDING

label-unfocused = %index%
label-unfocused-padding = REAL_BAR_PADDING

label-visible = %index%
label-visible-background = ${self.label-focused-background}
label-visible-underline = ${self.label-focused-underline}
label-visible-padding = ${self.label-focused-padding}

label-urgent = %index%
label-urgent-background = ${colors.alert}
label-urgent-padding = REAL_BAR_PADDING

[module/tray]
type = internal/tray
tray-size = 80%
tray-foreground = ${colors.trayforeground}

[module/pulseaudio]
type = internal/pulseaudio
interval = 1
label-volume = 󰕾  %percentage%%
label-muted = 󰖁  %percentage%%
click-right = pavucontrol

[module/cpu]
type = internal/cpu
interval = 3
label =   CPU %percentage:2%%

[module/memory]
type = internal/memory
interval = 3
label = 󰍛  MEM %used% / %total%

define(`network_WIRED_NETCARDS_module_generator', `ifelse($1, , , `dnl
[module/network_$1]
type = internal/network
interface = $1
interface-type = wired
interval = 3
label-connected = 󰣾  %upspeed%%downspeed%
label-disconnected = 󰣽  Disconnect
ifelse($2, , , `
')dnl
$0(shift($@))')')dnl
network_WIRED_NETCARDS_module_generator(WIRED_NETCARDS)dnl
popdef(`network_WIRED_NETCARDS_module_generator')dnl

define(`network_WIRELESS_NETCARDS_module_generator', `ifelse($1, , , `dnl
[module/network_$1]
type = internal/network
interface = $1
interface-type = wireless
interval = 3
label-connected = 󰖩  %upspeed%%downspeed%
label-disconnected = 󰖪  Disconnect
ifelse($2, , , `
')dnl
$0(shift($@))')')dnl
network_WIRELESS_NETCARDS_module_generator(WIRELESS_NETCARDS)dnl
popdef(`network_WIRELESS_NETCARDS_module_generator')dnl

[module/date]
type = internal/date
interval = 1

date = "%Y-%m-%d"
date-alt = "%Y-%m-%d"
time = "%H:%M"
time-alt = "%H:%M:%S"
label = %date%  %time%

[module/launcher]
type = custom/text
content = 

define(`battery_BAT_module_generator', `ifelse($1, , , `dnl
[module/battery_$1]
type = internal/battery
full-at = 70
low-at = 30
battery = $1
label-charging = 󰂄  %percentage%%
label-discharging = 󰁹  %percentage%%
label-full = 󱟢  %percentage%%
label-low = 󰂃  %percentage%%
ifelse($2, , , `
')dnl
$0(shift($@))')')dnl
battery_BAT_module_generator(BATS)dnl
popdef(`battery_BAT_module_generator')dnl

[bar/clock]
bottom = true
width = REAL_CLOCK_WIDTH
height = REAL_CLOCK_HEIGHT
offset-x = 100%:-esyscmd(`echo -n $(echo ' REAL_CLOCK_WIDTH ` + ' REAL_CLOCK_HEIGHT ` | bc)')
offset-y = REAL_CLOCK_HEIGHT

font-0 = "monospace:size=40;4"
font-1 = "fixed:pixelsize=40;4"

modules-center = date
override-redirect = true

background = ${colors.background}
foreground = ${colors.foreground}
