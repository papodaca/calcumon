engine_test = executable(
  'engine-test',
  files('engine-test.vala') + engine_sources,
  calcumon_resources,
  dependencies: [
    gio_dep,
    jsc_dep,
  ],
  vala_args: [
    '--target-glib=2.78',
  ],
)

test('engine', engine_test)

sheet_smoke = executable(
  'sheet-smoke',
  files('sheet-smoke.vala') + settings_source + sheet_view_source + engine_sources,
  calcumon_resources,
  dependencies: [
    gtk_dep,
    adw_dep,
    gtksource_dep,
    gio_dep,
    jsc_dep,
  ],
  vala_args: [
    '--target-glib=2.78',
  ],
)

test('sheet-smoke', sheet_smoke,
  env: {
    'GSETTINGS_SCHEMA_DIR': meson.project_build_root () / 'data',
  },
)

page_store_test = executable(
  'page-store-test',
  files('page-store-test.vala') + page_sources,
  dependencies: [
    gio_dep,
    json_dep,
  ],
  vala_args: [
    '--target-glib=2.78',
  ],
)

test('page-store', page_store_test)
