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

[GtkTemplate (ui = "/it/dadib/Rollback/ui/config-page.ui")]
public class Rollback.ConfigPage : Adw.NavigationPage {

    /* This is the underlying config object. The getter is internal to let the
     * parent access it. */
    public ConfigObject config { internal get; construct; }

    public ConfigPage (ConfigObject config) {
        Object (config: config, title: config.title);
    }

    construct {

        // Register config actions group
        var config_actions = new SimpleActionGroup();
        this.insert_action_group("config", config_actions);

        // Add the actual action entries
        config_actions.add_action_entries ({
            { "remove", () => this.config_remove () }
        }, this);

    }

    // Emits a signal that the configuration was removed
    public signal void config_remove ();
}
