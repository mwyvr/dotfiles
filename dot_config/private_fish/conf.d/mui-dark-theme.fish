# (c) Mike Watkins, MIT licensed: https://github.com/mwyvr/cli-themes/blob/main/LICENSE

# mui_dark is a dark Material Design-inspired theme for the Helix editor, fish shell and others.

# Matching and other themes can be found at https://github.com/mwyvr/cli-themes.

# surfaces 
set -l surface_dim 111318 # N-6; in this scheme, same as Surface; unused 
set -l surface 111318 # N-6; the primary editor surface layer; surface neutrals have a weak primary colour tint 
set -l surface_bright 37393e # N-24; ui.selection 
set -l surface_container_lowest 0c0e13 # N-4; unused
set -l surface_container_low 191c20 # N-10; unused 
set -l surface_container 1d2024 # N-12; cursorline, bufferline, statusline 
set -l surface_container_high 282a2f # N-17; background for all popups, menus, help
set -l surface_container_highest 33353a # N-24; window splitline
set -l inverse_surface e2e2e9 # N-90; unused 
set -l inverse_on_surface 2e3036 # N-20; unused 
set -l inverse_primary 415f91 # P-40
set -l primary aac7ff # P-80; (blue primary, affects NV and surface)
set -l on_primary 0a305f # P-20;
set -l primary_container 284777 # P-30; 
set -l on_primary_container d6e3ff # P-90; 
set -l secondary bec6dc # S-80; 
set -l on_secondary 283141 # S-20;
set -l secondary_container 3e4759 # S-30; 
set -l on_secondary_container dae2f9 # S-90; 
set -l tertiary ddbce0 # T-80; 
set -l on_tertiary 3f2844 # T-20
set -l tertiary_container 573e5c # T-30; 
set -l on_tertiary_container fad8fd # T-90; 
set -l error ffb4ab # E-80; 
set -l on_error 690005 # E-20;
set -l error_container 93000a # E-30; 
set -l on_error_container ffdad6 # E-90;
set -l on_surface e2e2e9 # N-90; 
set -l on_surface_variant c4c6d0 # NV-90; primary text colour 
set -l outline_brighter A9ABB4 # NV-70; 
set -l outline 8e9099 # NV-60; 
set -l outline_dimmer 5B5E66 # NV-40; comments
set -l outline_variant 44474e # NV-30; # redefine standard 16 colour names
set -l black 24262B # 0; NV-15
set -l red FF5449 # 1; Error-60 
set -l green 7D9A59 # 2; Green-60(green primary)
set -l yellow A3903F # 3; Yellow-60 (yellow primary)
set -l blue 7491C7 # 4; Primary-60 (blue primary)
set -l magenta A487A9 # 5; Tertiary-60 (blue primary)
set -l cyan 6B9995 # 6; Cyan-60 
set -l white 8F9097 # 7; NV-60
set -l light_black 44474E # 8; NV-30
set -l light_red ffb4ab # 9; Error-80 
set -l light_green B1D18A # 10; Green-80 (green primary)
set -l light_yellow DBC66E # 11; Yellow-80(yellow primary)
set -l light_blue AAC7FF # 12; Primary-80 
set -l light_magenta DDBCE0 # 13; Tertiary-80 (blue primary)
set -l light_cyan A0D0CB # 14; Cyan-80 
set -l light_white C4C6D0 # 15; NV-80

# theme
set -g fish_color_autosuggestion $outline
set -g fish_color_cancel --reverse
set -g fish_color_command $light_green
set -g fish_color_comment $outline_dimmer
set -g fish_color_cwd $green
set -g fish_color_cwd_root $red
set -g fish_color_end $magenta
set -g fish_color_error $error
set -g fish_color_escape $cyan
set -g fish_color_hg_added $green
set -g fish_color_hg_clean $green
set -g fish_color_hg_copied $magenta
set -g fish_color_hg_deleted $red
set -g fish_color_hg_dirty $red
set -g fish_color_hg_modified $yellow
set -g fish_color_hg_renamed $magenta
set -g fish_color_hg_unmerged $red
set -g fish_color_hg_untracked $yellow
set -g fish_color_history_current --bold
set -g fish_color_host $normal
set -g fish_color_host_remote $red --bold
set -g fish_color_keyword $magenta
set -g fish_color_match $light_yellow
set -g fish_color_normal $on_surface
set -g fish_color_operator $magenta
set -g fish_color_option
set -g fish_color_param $outline_brighter
set -g fish_color_quote $outline
set -g fish_color_redirection $white
set -g fish_color_search_match $light_yellow '--background=$light_black'
set -g fish_color_selection $white --bold '--background=$light_black'
set -g fish_color_status $red
set -g fish_color_user $light_green
set -g fish_color_valid_path --underline
set -g fish_pager_color_background
set -g fish_pager_color_completion $normal
set -g fish_pager_color_description $yellow
set -g fish_pager_color_prefix normal --bold --underline
set -g fish_pager_color_progress brwhite '--background=cyan'
set -g fish_pager_color_secondary_background
set -g fish_pager_color_secondary_completion
set -g fish_pager_color_secondary_description
set -g fish_pager_color_secondary_prefix
set -g fish_pager_color_selected_background --background=brblack
set -g fish_pager_color_selected_completion
set -g fish_pager_color_selected_description
set -g fish_pager_color_selected_prefix
