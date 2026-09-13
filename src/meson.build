engine_sources = files(
  'engine/engine-error.vala',
  'engine/line-result.vala',
  'engine/js-runtime.vala',
  'engine/sheet-engine.vala',
)

page_sources = files(
  'page.vala',
  'page-store.vala',
)

sheet_view_source = files('sheet-view.vala')
settings_source = files('settings.vala')

config_data = configuration_data ()
config_data.set ('VERSION', meson.project_version ())
config_vala = configure_file (
  input: 'config.vala.in',
  output: 'config.vala',
  configuration: config_data,
)

app_sources = files(
  'main.vala',
  'application.vala',
  'window.vala',
  'preferences.vala',
)

calcumon_resources = gnome.compile_resources(
  'calcumon-resources',
  meson.project_source_root() / 'data' / 'calcumon.gresource.xml',
  c_name: 'calcumon',
  source_dir: meson.project_source_root(),
)

calcumon_deps = [
  gtk_dep,
  adw_dep,
  gtksource_dep,
  gio_dep,
  jsc_dep,
  json_dep,
]

executable(
  'calcumon',
  app_sources + settings_source + page_sources + sheet_view_source + engine_sources + config_vala,
  calcumon_resources,
  dependencies: calcumon_deps,
  vala_args: [
    '--target-glib=2.78',
  ],
  install: true,
)
