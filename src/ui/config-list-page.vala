/* ui/config-list-page.vala
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

[GtkTemplate (ui = "/it/dadib/Rollback/ui/config-list-page.ui")]
public class Rollback.ConfigListPage : Adw.NavigationPage {

    [GtkChild]
    private unowned Adw.ViewStack view;

    [GtkChild]
    private unowned Gtk.ScrolledWindow nonempty;

    [GtkChild]
    private unowned Adw.StatusPage empty;

    [GtkChild]
    private unowned Gtk.ListBox list;

    /* This is the (abstract) configurations model interface that syncs with the
     * desktop key-value configuration file. */
    public ConfigList model { private get; construct; }

    /* This is the navigation to which the page gets added to and which contains
     * all sub-pages to which each row lets you navigate. */
    public Adw.NavigationView navigation { private get; construct; }

    public ConfigListPage (Adw.NavigationView navigation) {
        Object (
            navigation: navigation,
            model: new ConfigList ()
        );
    }

    construct {

        // Register config actions group
        var config_actions = new SimpleActionGroup();
        this.insert_action_group("config", config_actions);

        // Add the actual action entries
        config_actions.add_action_entries ({
            { "add", this.on_config_add_action }
        }, this);

        // Bind the model and factory to the list
        list.bind_model (this.model, this.factory);
        on_model_count_change ();
        this.model.items_changed.connect (on_model_count_change);

        // Add the page to the navigation view
        this.navigation.add (this);

    }

    /* This method makes sure the empty page is shown whenever the item count
     * changes to 0. */
    private void on_model_count_change () {
        uint count = this.model.get_n_items ();
        view.visible_child = 0 == count
            ? (Gtk.Widget) empty
            : (Gtk.Widget) nonempty;
    }

    public void on_config_add_action () {
        var item = new ConfigObject ("System", ConfigObject.Kind.SYSTEM);
        if (model.has (item.title)) {
            // Prevent user from creating a config with the same title
        } else if (model.add (item)) {

        } else {
            // Failed to add a new config
        }
    }

    public void on_config_remove_action (ConfigPage source) {
        if (model.remove (source.config)) {
            navigation.pop ();
        }
    }

    /* This method produces a ConfigRow from an Object. It must be casted to the
     * underlying ListModel type (not retrievable via `get_item_type ()`, oddly
     * enough) */
    private Gtk.Widget factory (Object item) {
        ConfigObject it = (ConfigObject) item;

        // Create a new row to append to the list
        var row = new ConfigRow (it);

        // Create a new detailed page to open when the row is clicked
        var page = new ConfigPage (it);

        // Connects the children signals to the parent
        page.config_remove.connect (on_config_remove_action);

        // Connect the page to the click action of the row
        row.activatable_widget = page;
        row.activated.connect (() => this.navigation.push (page) );

        return row;
    }

}
