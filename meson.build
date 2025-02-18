project('rollback', ['c', 'vala'],
          version: '0.1.0',
    meson_version: '>= 1.0.0',
  default_options: [ 'warning_level=2', 'werror=false', ],
)

i18n = import('i18n')
gnome = import('gnome')
valac = meson.get_compiler('vala')

add_global_arguments(['-Wall',
                      '-Wno-pointer-sign',
                      '-Wno-unused',
                      '-Wno-incompatible-pointer-types',
                      '-Wno-discarded-qualifiers'],
                     language: 'c')

srcdir = meson.project_source_root() / 'src'

commit = run_command(['git', 'rev-parse', '--short', 'HEAD'], capture : true, check : true).stdout().strip()

config_h = configuration_data()
config_h.set_quoted('COMMIT', commit)
config_h.set_quoted('PACKAGE_VERSION', meson.project_version ())
config_h.set_quoted('GETTEXT_PACKAGE', 'rollback')
config_h.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
configure_file(output: 'config.h', configuration: config_h)

config_dep = valac.find_library ('config', dirs: srcdir)
config_inc = include_directories('.')

add_project_arguments('-DCOMMIT="' + commit + '"', language: 'c')
add_project_arguments('-DGETTEXT_PACKAGE="' + meson.project_name () + '"', language: 'c')

subdir('data')
subdir('src')
subdir('po')

gnome.post_install(
     glib_compile_schemas: true,
    gtk_update_icon_cache: true,
  update_desktop_database: true,
)
