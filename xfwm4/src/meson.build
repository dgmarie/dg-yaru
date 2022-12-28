foreach flavour: flavours
  foreach variant : window_controls
    foreach scale: ['', '-hdpi', '-xhdpi']
    suffix = flavour == 'default' ? '-@0@'.format(variant) : '-@0@-@1@'.format(flavour, variant)
      theme_name = meson.project_name() + suffix + scale
      theme_dir = join_paths(get_option('datadir'), 'themes', theme_name)

      conf_data = configuration_data()
      if scale == '-xhdpi'
        conf_data.set('offset', '28')
      elif scale == '-hdpi'
        conf_data.set('offset', '21')
      else
        conf_data.set('offset', '14')
      endif
      xfwm4_sources_dir = join_paths(flavour + '-' + variant, 'xfwm4')
      xfwm4_sources_dest = join_paths(theme_dir, 'xfwm4')

      themerc = configure_file(
        input: join_paths(xfwm4_sources_dir, 'themerc.in'),
        output: 'themerc-@0@-@1@'.format(scale, flavour),
        configuration: conf_data,
      )

      xfwm4_asset_dir = join_paths(xfwm4_sources_dir, 'assets' + scale)
      install_subdir(xfwm4_asset_dir, install_dir: xfwm4_sources_dest, strip_directory: true,)
      install_data(themerc, install_dir: xfwm4_sources_dest, rename: 'themerc')
    endforeach
  endforeach
endforeach
