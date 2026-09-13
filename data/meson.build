desktop_file = configure_file(
  input: 'dev.calcumon.Calcumon.desktop.in',
  output: 'dev.calcumon.Calcumon.desktop',
  copy: true,
  install: true,
  install_dir: get_option('datadir') / 'applications',
)

gschema_file = configure_file(
  input: 'dev.calcumon.Calcumon.gschema.xml',
  output: 'dev.calcumon.Calcumon.gschema.xml',
  copy: true,
  install: true,
  install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
)

icon_dir = get_option('datadir') / 'icons' / 'hicolor'
install_data(
  'icons/hicolor/scalable/apps/dev.calcumon.Calcumon.svg',
  install_dir: icon_dir / 'scalable' / 'apps',
)
install_data(
  'icons/hicolor/symbolic/apps/dev.calcumon.Calcumon-symbolic.svg',
  install_dir: icon_dir / 'symbolic' / 'apps',
)

glib_compile_schemas = find_program('glib-compile-schemas')
custom_target(
  'gschemas.compiled',
  input: gschema_file,
  output: 'gschemas.compiled',
  command: [
    glib_compile_schemas,
    meson.current_build_dir (),
  ],
  build_by_default: true,
)
