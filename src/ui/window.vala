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
    private unowned Adw.NavigationView navigation;

    [GtkChild]
    private unowned Adw.ViewStack stack;

    [GtkChild]
    private unowned Adw.ViewStackPage overview;

    [GtkChild]
    private unowned Adw.ViewStackPage empty_overview;

    [GtkChild]
    private unowned Gtk.ListBox configurations;

    public Window (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        var model = new ConfigList ();
        configurations.bind_model (model, item => {
            var page = new ConfigPage ((ConfigObject) item);
            navigation.add (page);

            var row = new ConfigRow ((ConfigObject) item) {
                activatable_widget = page,
            };
            row.activated.connect (() => {
                navigation.push (page);
            });
            return row;
        });
    }
}
