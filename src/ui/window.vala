/* ui/window.vala
 *
 * Copyright 2025 Davide Bassi
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

[GtkTemplate (ui = "/it/dadib/Rollback/ui/window.ui")]
public class Rollback.Window : Adw.ApplicationWindow {
    [GtkChild]
    private unowned Adw.NavigationView navigation_view;

    [GtkChild]
    private unowned Gtk.Button create_config_header_button;

    [GtkChild]
    private unowned Gtk.Button create_config_empty_list_button;

    [GtkChild]
    private unowned Adw.Dialog create_new_config_dialog;

    [GtkChild]
    private unowned Gtk.ListBox config_list;

    public Window (Gtk.Application app) {
        Object (application: app);
    }

    construct {

        /*var config_page = data_config_page;
        var config_row = new Rollback.ConfigRow("Data") {
            activatable_widget = config_page
        };
        config_row.activated.connect (() => {
            navigation_view.push (config_page);
        });

        config_list.append (config_row);*/

        // On header row '+' button click
        create_config_header_button.clicked.connect (() => {
            // Open config creation dialog
            create_new_config_dialog.present (this);
        });

        // On empty list 'Add Configuration' button click
        create_config_empty_list_button.clicked.connect (() => {
            // Open config creation dialog
            create_new_config_dialog.present (this);
        });

        // List configurations
        Rollback.Config[] configs = {
            new Rollback.Config (
                (ObjectPath) "/org/freedesktop/UDisks2/block_devices/nvme0n1p3",
                "System",
                Rollback.Config.Kind.SYSTEM
            )
        };
        foreach (var config in configs) {
            navigation_view.add (config.page);
            config.row.activated.connect (() => {
                navigation_view.push (config.page);
            });
            config_list.append (config.row);
        }

    }

}
