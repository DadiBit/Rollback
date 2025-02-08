rollback_sources = [
  'main.vala',
  'application.vala',
  'dbus/host.vala',
  'ui/window.vala',
]

rollback_deps = [
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

rollback_sources += gnome.compile_resources('rollback-resources',
  'rollback.gresource.xml',
  c_name: 'rollback'
)

executable('rollback', rollback_sources,
  dependencies: rollback_deps,
  include_directories: config_inc,
       install: true,
)
