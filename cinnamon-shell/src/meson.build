variants = [
  'light',
  'dark',
]

foreach accent: enabled_accent_colors
  if enabled_accent_colors.contains(accent)
    variants += (get_option('default') ? [accent] : [])
    variants += (get_option('dark') ? [ accent + '-dark' ] : [])
  endif
endforeach

colorable_theme_assets = files(
  run_command(
    'find', meson.current_source_dir() / 'colorable-assets', '-name', '*.svg'
  ).stdout().strip().split('\n')
)

colorable_assets_names = []
foreach asset: colorable_theme_assets
  basename = fs.name(asset)
  colorable_assets_names += basename
endforeach

foreach variant: variants
  is_dark = variant == 'dark' or variant.endswith('-dark')
  is_variant = variant != 'light'
  variant_base_name = is_dark ? variant.split('-dark')[0] : variant
  variant_suffix = is_variant ? '-@0@'.format(variant)  : ''
  theme_name = meson.project_name() + variant_suffix
  is_custom_accent = enabled_accent_colors.contains(variant_base_name)
  flavour = is_dark ? 'dark' : 'default' 
  theme_dir = join_paths(get_option('datadir'), 'themes', meson.project_name() + variant_suffix, 'cinnamon')

  accent_configuration = {
    'yaru_dark_variant': is_dark ? 'true' : 'false',
    'yaru_accent_color': is_custom_accent ? variant_base_name : 'default',
  }

  # Prepare colorable assets
  cinnamon_shell_yaru_colors_defs_scss = configure_file(
    configuration: accent_configuration + {
      'yaru_theme_entry_point': yaru_colors_defs_scss
    },
    input: accent_colors_definitions_scss,
    output: 'cinnamon-shell-yaru-colors-defs-@0@.scss'.format(variant),
  )

  cinnamon_shell_yaru_colors_defs = custom_target(
    'cinnamon-shell-yaru-color-definitions-@0@'.format(variant),
    input: cinnamon_shell_yaru_colors_defs_scss,
    output: '@BASENAME@.css'.format(variant),
    command: [
      sassc, '-a', '@INPUT@', '@OUTPUT@',
    ],
    depend_files: [
      yaru_colors_defs_scss,
    ]
  )

  foreach colorable_asset: colorable_theme_assets
    basename = fs.name(colorable_asset)
    relative_dir = fs.parent(colorable_asset).split(meson.current_source_dir() / 'colorable-assets/')[1]
    asset_target = custom_target(
      fs.stem(basename) + '-' + variant + '.svg',
      input: colorable_asset,
      output: '@BASENAME@-@0@.svg'.format(variant),
      command: [
        colorize_dummy_svg,
        cinnamon_shell_yaru_colors_defs,
        '--input-file', '@INPUT@',
        '--output-folder', '@OUTDIR@',
        '--variant', variant,
      ],
      depends: cinnamon_shell_yaru_colors_defs,
      install: true,
      install_dir: theme_dir / relative_dir,
    )
  endforeach

  # Install CSS
  theme_main_file = configure_file(
    configuration: accent_configuration + {
      'yaru_theme_entry_point': join_paths(meson.current_source_dir(), flavour, 'cinnamon.scss'),
    },
    input: accent_colors_definitions_scss,
    output: '@0@-accent-colors.scss'.format(variant),
  )

  scss_dependencies = run_command(
    'find', flavour, '-name', '_*.scss'
  ).stdout().strip().split('\n')

  custom_target(theme_name,
    input: theme_main_file,
    output: '@0@.css'.format(variant),
    depend_files: files(scss_dependencies),
    command: [sassc, '-a', '@INPUT@', '@OUTPUT@'],
    install: true,
    install_dir: theme_dir,
  )

  # Install assets
  assets_folders = [
    'common-assets',
    'light-assets',
    'dark-assets'
  ]
  foreach asset_folder: assets_folders
    if fs.is_dir(join_paths(flavour, asset_folder))
      install_subdir(join_paths(flavour, asset_folder),
        install_dir: join_paths(theme_dir, asset_folder),
        strip_directory: true,
      )
    endif
  endforeach

  if is_custom_accent
    thumbnail_file = 'thumbnail-@0@.png'.format(variant_base_name)
  else
    thumbnail_file = 'thumbnail.png'
  endif

  # Install thumbnail image
  install_data(
    meson.current_source_dir() / 'thumbnails' / thumbnail_file,
    install_dir: theme_dir,
    rename: 'thumbnail.png'
  )
endforeach

meson.add_install_script('post_install.py', get_option('datadir'), meson.project_name(), variants)
