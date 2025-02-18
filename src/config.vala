/* ui/config.vala
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

/* An abstract Object representing a configuration
 * */
public class Rollback.ConfigObject : Object {
    public enum Kind {
        GENERIC = 0,
        USERS = 1,
        SYSTEM = 2,
    }

    public string title;
    public Kind kind;

    public ConfigObject (string title, Kind kind) {
        this.title = title;
        this.kind = kind;
    }
}

/* A ListModel that writes changes to the key configuration file (`.desktop`,
 * which is `.ini`-like) designed for the ConfigObject
 * */
public class Rollback.ConfigList : Object, ListModel {
    private string _path;
    private KeyFile _file = new KeyFile ();

    public ConfigList (
        string filename = "configs.desktop",
        string dirpath = Environment.get_user_config_dir ()
    ) throws KeyFileError, FileError {
        _path = Path.build_filename (dirpath, filename);
        _file.load_from_file (_path, KeyFileFlags.NONE);
    }

    construct {
        items_changed.connect (() => {
            _file.save_to_file (_path);
            // TODO: fire error signal, if file can' be saved
        });
    }

    public new void set (ConfigObject object) throws KeyFileError {
        bool append = !_file.has_group (object.title);
        _file.set_integer (object.title, "kind", object.kind);
        uint position = 0;
        foreach (var group in _file.get_groups ()) {
            if (group == object.title) break;
            position++;
        }
        // if we're just updating the entry make sure to remove it and add it.
        items_changed (position, append ? 0 : 1, 1);
    }

    public void remove (string title) throws KeyFileError {
        uint position = 0;
        foreach (var group in _file.get_groups ()) {
            if (group == title) break;
            position++;
        }
        _file.remove_group (title);
        items_changed (position, 1, 0);
    }

    public Object? get_item (uint position) {
        // TODO: handle KeyFileError
        var title = _file.get_groups ()[position];
        var kind = _file.get_integer (title, "kind");
        return new ConfigObject (title, kind);
    }

    public Type get_item_type () {
        return typeof (ConfigObject);
    }

    public uint get_n_items () {
        return _file.get_groups ().length;
    }

}
