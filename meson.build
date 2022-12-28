project('qualia',
        version: '1.0',
        meson_version: '>= 0.59',
        license : ['GPL3', 'CC BY-SA 4.0'],
        default_options: ['prefix=/usr'])

fs = import('fs')
gnome = import('gnome')

python = find_program('python3')
sassc = find_program('sassc')
rsync = find_program('rsync')

subdir('common')

components = [
  'cinnamon-shell',
  'metacity',
  'gnome-shell',
  'icons',
  'gtksourceview',
  'cursors',
  'sounds',
  'ubuntu-unity',
  'xfwm4',
]

enabled_accent_colors = get_option('accent-colors')
window_controls = get_option('window-controls')

foreach component: components
  if not get_option(component)
    message('skip component ' + component)
    continue
  endif

  message('build component ' + component)
  subdir(component)

endforeach
