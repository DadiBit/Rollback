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

    }

    /* Fires the items_changed signal **if** it can save the changes to the file */
    private bool change_items (uint position, uint removed, uint added) {
        try {
            if (config.save_to_file (path)) {
                // We are sure the config was saved to the file
                items_changed (position, removed, added);
                return true;
            }
        } catch (FileError e) {
            warning (@"Error save config file $(this.path): $(e.message)");
        }
        return false;
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
    public bool add (ConfigObject item) {
        serialize (item);
        uint position = get_group_position (item.title);
        return change_items (position, 0, 1);
    }

    /* Updates an existing config. */
    public bool update (ConfigObject item) {
        serialize (item);
        uint position = get_group_position (item.title);
        return change_items (position, 1, 1);
    }

    /* Check whether there's already a configuration with the same title. */
    public bool has (string title) {
        return config.has_group (title);
    }

    /* Removes the config. */
    public bool remove (ConfigObject item) {

        // Return without any message if the KeyFile doesn't have the group
        if (!config.has_group (item.title)) return false;

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
            return false;
        }

        // Fire signal
        return change_items (position, 1, 0);

    }
}
