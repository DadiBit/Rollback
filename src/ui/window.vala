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
    private unowned Adw.ViewStack overview;

    [GtkChild]
    private unowned Gtk.ScrolledWindow nonempty;

    [GtkChild]
    private unowned Adw.StatusPage empty;

    [GtkChild]
    private unowned Gtk.ListBox configurations;

    public Window (Rollback.Application app) {
        Object (application: app);
        configurations.bind_model (app.configurations, item => ConfigRow.factory (item, navigation));
        app.configurations.items_changed.connect (on_config_count_change);
        on_config_count_change ();
    }

    private void on_config_count_change () {
        var app = (Rollback.Application) this.application;
        uint count = app.configurations.get_n_items ();
        overview.visible_child = 0 == count
            ? (Gtk.Widget) empty
            : (Gtk.Widget) nonempty;
    }
}
