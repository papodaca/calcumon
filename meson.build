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

fs = import('fs')

# Git tag is the source of truth (packaging/version.sh). meson.project_version()
# is only the snapshot fallback when there is no checkout and no override.
app_version = get_option('app_version').strip()
if app_version == '' and fs.exists(meson.project_source_root() / '.git')
  version_sh = meson.project_source_root() / 'packaging' / 'version.sh'
  bash = find_program('bash', required: false)
  if bash.found() and fs.is_file(version_sh)
    version_r = run_command(bash, version_sh, check: false)
    if version_r.returncode() == 0
      app_version = version_r.stdout().strip()
    endif
  endif
endif
if app_version == ''
  version_stamp = meson.project_source_root() / 'packaging' / '.app-version'
  if fs.is_file(version_stamp)
    app_version = fs.read(version_stamp).strip()
  endif
endif
if app_version == ''
  app_version = meson.project_version()
endif

gnome = import('gnome')

gtk_dep = dependency('gtk4', version: '>= 4.14')
adw_dep = dependency('libadwaita-1', version: '>= 1.5')
gtksource_dep = dependency('gtksourceview-5', version: '>= 5.0')
gio_dep = dependency('gio-2.0')
jsc_dep = dependency('javascriptcoregtk-6.0')
json_dep = dependency('json-glib-1.0')

subdir('data')
subdir('src')
subdir('tests')

meson.add_devenv({
  'GSETTINGS_SCHEMA_DIR': meson.project_build_root () / 'data',
})

summary({'Version': app_version}, section: 'Calcumon')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: find_program('update-desktop-database', required: false).found(),
)
