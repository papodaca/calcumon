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
