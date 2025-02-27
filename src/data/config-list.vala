/* data/config-list.vala
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

/* A ListModel that is synced to a desktop configuration key-value file
 * containing some config objects. */
public class Rollback.ConfigList : Object, ListModel {

    private KeyFile config = new KeyFile ();
    private string path = Path.build_filename (Environment.get_user_config_dir (),
                                               "configs.ini");

    construct {

        // Load file, with proper error handling
        try {
            this.config.load_from_file (this.path, KeyFileFlags.NONE);
        } catch (FileError e) {
            if (e.matches (FileError.quark (), FileError.NOENT)) {
                // missing file: no need to do shit, we can simply save to path
                // when we do the first sync
            } else {
                error (@"Error loading config file $(this.path): $(e.message)");
            }
        } catch (KeyFileError e) {
            error (@"Couldn't parse config file $(this.path): $(e.message)");
        }

        // Connect items changed signal to method
        this.items_changed.connect (on_items_changed);

    }

    /* Whenever the config changes we ought to save the config page. */
    private void on_items_changed () {
        try {
            config.save_to_file (path);
        } catch (FileError e) {
            warning (@"Error save config file $(this.path): $(e.message)");
        }
    }

    public Object? get_item (uint position) {
        try {
            var title = config.get_groups ()[position];
            var kind = config.get_integer (title, "kind");
            return new ConfigObject (title, kind);
        } catch (KeyFileError e) {
            warning ("Couldn't get item at position %u in config file: %s",
                     position, e.message);
            return null;
        }
    }

    public Type get_item_type () {
        return typeof (ConfigObject);
    }

    public uint get_n_items () {
        return config.get_groups ().length;
    }

    /* Helper function to find the group index: useful for update/removal.
     * If group doesn't exists it returns the group count. */
    private uint get_group_position (string title) {
        uint position = 0;
        foreach (var group in config.get_groups ()) {
            if (group == title) break;
            position++;
        }
        return position;
    }

    /* Serializes the config, without firing any signal.
     * If the group already exists it updates it, if it doesn't, then it gets
     * added to the KeyFile. */
    private void serialize (ConfigObject item) {
        config.set_integer (item.title, "kind", item.kind);
    }

    /* Adds a new config. */
    public void add (ConfigObject item) {
        serialize (item);
        uint position = get_group_position (item.title);
        items_changed (position, 0, 1);
    }

    /* Updates an existing config. */
    public void update (ConfigObject item) {
        serialize (item);
        uint position = get_group_position (item.title);
        items_changed (position, 1, 1);
    }

    /* Removes the config. */
    public void remove (ConfigObject item) {

        // Silently return if the KeyFile doesn't have the group
        if (!config.has_group (item.title)) return;

        // Get group position before deletion from KeyFile
        uint position = get_group_position (item.title);

        try {
            // Remove config from KeyFile
            config.remove_group (item.title);
        } catch (KeyFileError e) {
            // A KeyFileError could be thrown if the group can't be found.
            // This point may be reached if other kinds of KeyFileError get
            // added in the future (currently the missing group is the only one
            // in GLib source code).
            warning (@"Couldn't remove config $(item.title): $(e.message)");
        }

        // Fire signal
        items_changed (position, 1, 0);

    }
}
