# Set early so /usr/bin/start-cosmic's `[ -z "$QT_QPA_PLATFORMTHEME" ]`
# check sees a value and skips its own default ("cosmic"). Qt5 apps
# then load qt5ct, which uses qt5gtk2 to inherit the GTK Catppuccin
# theme. Qt6 (CuteCosmic) keeps working regardless.
#
# Can't live in .config/environment.d/: the systemd user manager loads
# environment.d only after cosmic-comp has already inherited start-cosmic's
# value, so children launched by cosmic-comp never see env.d's setting.
export QT_QPA_PLATFORMTHEME=qt5ct

# Cursor theme — same place for consistency.
export XCURSOR_THEME=Qogir-Recolored-Catppuccin-Macchiato-v2
export XCURSOR_SIZE=24
