engine_sources = files(
  'engine/engine-error.vala',
  'engine/line-result.vala',
  'engine/js-runtime.vala',
  'engine/sheet-engine.vala',
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
]

executable(
  'calcumon',
  files(
    'main.vala',
    'application.vala',
    'window.vala',
  ) + engine_sources,
  calcumon_resources,
  dependencies: calcumon_deps,
  vala_args: [
    '--target-glib=2.78',
  ],
  install: true,
)
