foreach flavour: flavours
  foreach variant : window_controls
    suffix = flavour == 'default' ? '-@0@'.format(variant) : '-@0@-@1@'.format(flavour, variant)
    theme_name = meson.project_name() + suffix
    theme_dir = join_paths(get_option('datadir'), 'themes', theme_name)
    
    # install unity assets
    unity_asset_dir = join_paths(flavour + '-' + variant, 'unity')
    unity_asset_data = run_command(
      'find', unity_asset_dir, '-name', '*.svg'
      ).stdout().strip().split('\n')

    unity_assets_dest = join_paths(theme_dir, 'unity')
    install_data(unity_asset_data, install_dir: unity_assets_dest)
    foreach accent: enabled_accent_colors
      dest = join_paths(get_option('prefix'), get_option('datadir'), 'themes', meson.project_name() + '-' + accent + suffix)
      meson.add_install_script('symlink.sh', get_option('prefix') / theme_dir, dest, 'unity')
    endforeach
  endforeach
endforeach
