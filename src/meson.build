rollback_sources = [
  'main.vala',
  'system.vala',
  'disks.vala',
  'ui/snapshot-row.vala',
  'ui/config-page.vala',
  'ui/config-row.vala',
  'snapshot.vala',
  'config.vala',
  'application.vala',
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
