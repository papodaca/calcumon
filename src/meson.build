calcumon_sources = files(
  'main.vala',
  'application.vala',
  'window.vala',
)

executable(
  'calcumon',
  calcumon_sources,
  dependencies: [
    gtk_dep,
    adw_dep,
    gtksource_dep,
  ],
  vala_args: [
    '--target-glib=2.78',
  ],
  install: true,
)
