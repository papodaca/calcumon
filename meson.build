project(
  'calcumon',
  ['vala', 'c'],
  version: '0.1.0',
  meson_version: '>= 1.0.0',
  default_options: [
    'warning_level=1',
    'c_std=c11',
  ],
)

gnome = import('gnome')

gtk_dep = dependency('gtk4', version: '>= 4.14')
adw_dep = dependency('libadwaita-1', version: '>= 1.5')
gtksource_dep = dependency('gtksourceview-5', version: '>= 5.0')
gio_dep = dependency('gio-2.0')
jsc_dep = dependency('javascriptcoregtk-6.0')

subdir('data')
subdir('src')
subdir('tests')
