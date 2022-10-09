icon_flavors = [
  'default',
  'dark',
]

foreach accent: enabled_accent_colors
  icon_flavors += (get_option('default') ? [accent] : [])
  icon_flavors += (get_option('dark') ? [ accent + '-dark' ] : [])
endforeach

fullcolor_path = 'src' / 'fullcolor'
render_bitmaps = find_program(fullcolor_path / 'render-bitmaps.py', required: true)
generate_symlinks = find_program('src' / 'symlinks' / 'generate-symlinks.sh', required: true)
generate_index_theme = find_program('src' / 'generate-index-theme.py', required: true)
dark_theme = meson.project_name() + '-dark'
index_theme = 'index.theme'
render_targets = []
render_accented_targets = []
render_and_symlink_targets = []
render_and_symlink_accented_targets = []
symlink_targets = []
render_by_icon_targets = {}
cleanup_rendered_icons_targets = []
cleanup_rendered_icons_accented_targets = []

foreach flavour: icon_flavors
  is_dark = flavour == 'dark'
  is_dark_flavour = not is_dark and flavour.endswith('-dark')
  is_accent = enabled_accent_colors.contains(flavour)
  base_flavour = is_dark_flavour ? flavour.split('-dark')[0] : ''
  is_dark_accent = is_dark_flavour and enabled_accent_colors.contains(base_flavour)

  if (is_accent or is_dark_accent) or get_option(flavour)
    is_flavour = flavour != 'default'
    suffix = is_flavour ? '-@0@'.format(flavour) : ''
    icon_dir = 'Yaru' + suffix
    theme_name = meson.project_name() + suffix
    theme_install_dir = join_paths(get_option('prefix'), 'share/icons', theme_name)

    rendering_deps = []
    rendering_args = [
      '--variant', flavour,
      '--dest-path', meson.current_source_dir(),
    ]

    source_svgs = []
    fullcolor_svgs_path = fullcolor_path / (is_accent ? 'accented' : flavour)

    if fs.is_dir(fullcolor_svgs_path)
      source_svgs += files(
        run_command(
          'find',
          meson.current_source_dir() / fullcolor_svgs_path,
          '-name', '*.svg',
        ).stdout().strip().split('\n')
      )
    endif

    if is_accent
      accent_configuration = {
        'yaru_dark_variant': is_dark ? base_flavour : flavour,
        'yaru_accent_color': flavour,
      }
      icons_accent_colors_scss = configure_file(
        configuration: accent_configuration + {
          'yaru_theme_entry_point': yaru_colors_defs_scss,
        },
        input: accent_colors_definitions_scss,
        output: '@0@-accent-colors.scss'.format(icon_dir),
      )
      icons_accent_colors = custom_target(
        '@0@-accent-colors'.format(icon_dir),
        input: icons_accent_colors_scss,
        output: '@BASENAME@.css',
        command: [
          sassc, '-a',
          '@INPUT@', '@OUTPUT@',
        ],
        depend_files: [
          yaru_colors_defs_scss,
        ]
      )

      foreach accent_svg: source_svgs
        category = fs.name(fs.parent(accent_svg))
        accented_svg = custom_target(
          '-'.join([icon_dir, fs.name(accent_svg)]),
          input: accent_svg,
          output: '@BASENAME@-@0@.svg'.format(flavour),
          command: [
            colorize_dummy_svg,
            icons_accent_colors,
            '--input-file', '@INPUT@',
            '--output-folder', '@OUTDIR@' / flavour / category,
          ],
          depends: icons_accent_colors,
        )
        rendering_deps += accented_svg
      endforeach

      rendering_args += [
        '--source-path', meson.current_build_dir(),
      ]
    endif

    render_flavour_targets = []
    foreach i: range(source_svgs.length())
      svg = source_svgs[i]
      basename = fs.stem(fs.name(svg))
      category = fs.name(fs.parent(svg))
      render_bitmap_target = custom_target('render-icon-' + '-'.join([category, basename, flavour]),
        input: svg,
        output: 'rendered-@0@-@BASENAME@-@1@.svg'.format(category, flavour),
        command: [
          render_bitmaps,
          rendering_args,
          '--categories', category,
          basename,
        ],
        depends: is_accent ? rendering_deps[i] : [],
      )
      render_flavour_targets += render_bitmap_target
      render_targets += render_bitmap_target

      icon_targets = render_by_icon_targets.get(basename, [])
      icon_targets += render_bitmap_target
      render_by_icon_targets += { basename: icon_targets }
    endforeach

    render_bitmaps_command = [
      render_bitmaps,
      rendering_args,
    ]
    render_bitmaps_target = custom_target(icon_dir + '-render',
      output: icon_dir + '-render',
      command: render_bitmaps_command,
      depends: rendering_deps,
    )

    # Sadly we can't use a run target as dependency, thus the duplication
    generate_symlinks_command = [
      generate_symlinks,
      '--variant', flavour,
    ]
    generate_symlinks_target = run_target('symlink-icons-' + flavour,
      command: generate_symlinks_command,
    )
    symlink_targets += generate_symlinks_target

    render_and_symlink_flavour = run_target('render+symlink-' + flavour,
      command: generate_symlinks_command,
      depends: render_flavour_targets,
    )
    render_and_symlink_targets += render_and_symlink_flavour

    cleanup_rendered_flavour = run_target('cleanup-rendered-' + flavour,
      command: [
        'bash', '-c', 'rm -rfv "$0"/$1',
        meson.project_source_root() / meson.current_source_dir() / icon_dir,
        '[0-9]*x[0-9]*',
      ]
    )
    cleanup_rendered_icons_targets += cleanup_rendered_flavour

    if render_flavour_targets.length() > 0
      alias_target('render-icons-' + flavour, render_flavour_targets)
      alias_target('render+symlink-icons-' + flavour, render_and_symlink_flavour)
      alias_target('cleanup-rendered-icons-' + flavour, cleanup_rendered_flavour)
    endif

    if is_accent
      render_accented_targets += render_flavour_targets
      render_and_symlink_accented_targets += render_and_symlink_flavour
      cleanup_rendered_icons_accented_targets += cleanup_rendered_flavour

      if not fs.is_dir(icon_dir)
        warning('@0@ does not exists, ensure you generated it with `ninja -C @1@ render-icons-@2@,`'.format(
          icon_dir, meson.project_build_root(), flavour))
        continue
      endif
    endif

    # The part above this line is meant to only contain "target definition"
    # not to install or generate things. Put them below!

    if fs.is_dir(icon_dir)
      meson.add_install_script('bash', '-c',
        'rsync -lr --exclude=@0@ @1@/ ${DESTDIR}/@2@'.format(index_theme, meson.current_source_dir() / icon_dir, theme_install_dir))
    endif

    generate_index_theme_args = []
    if is_flavour
      if is_dark_flavour
        generate_index_theme_args += [
          '--inherits', dark_theme,
          '--source-dir', meson.current_source_dir() / dark_theme,
        ]
      endif

      inherited_flavour = base_flavour != '' ? '-' + base_flavour : ''
        generate_index_theme_args += [
          '--inherits', meson.project_name() + inherited_flavour
        ]
    endif

    install_data(
      configure_file(
        output: flavour + '-@0@'.format(index_theme),
        command: [
          generate_index_theme,
          icon_dir,
          '--source-dir', meson.current_source_dir() / icon_dir,
          '--output-dir', '@OUTDIR@',
          '--output-name', '@OUTPUT@',
        ] + generate_index_theme_args,
      ),
      install_dir: theme_install_dir,
      rename: index_theme,
    )

    # Cleanup empty directories, as per excluded files
    meson.add_install_script('bash', '-c',
      'find "${DESTDIR}/@0@" -type d -empty -print -delete'.format(theme_install_dir))
    meson.add_install_script('meson/post_install.py', theme_name)

    test('generate-symlinks' + suffix,
      generate_symlinks,
      args: [
        '--variant', flavour,
        '--dry-run',
        '--verbose',
      ],
      suite: ['tools', 'generate-symlinks'],
      workdir: fs.parent(generate_symlinks.full_path()))
  endif
endforeach

alias_target('render-icons', render_targets)
alias_target('render+symlink-icons', render_and_symlink_targets)
alias_target('symlink-icons', symlink_targets)
alias_target('cleanup-rendered-icons', cleanup_rendered_icons_targets)

if render_accented_targets.length() > 0
  alias_target('render-accented-icons', render_and_symlink_accented_targets)
  alias_target('render-icons-accented', render_accented_targets)
  alias_target('render+symlink-icons-accented', render_and_symlink_accented_targets)
  alias_target('cleanup-rendered-icons-accented', cleanup_rendered_icons_accented_targets)
endif

foreach icon, targets: render_by_icon_targets
  alias_target('icon-render-' + icon, targets)
endforeach
