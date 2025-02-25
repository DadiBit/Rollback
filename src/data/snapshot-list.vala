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
    public ConfigList () {

    }

    public Object? get_item (uint position) {
        return null;
    }

    public Type get_item_type () {
        return typeof (ConfigObject);
    }

    public uint get_n_items () {
        return 0;
    }

    public void append (ConfigObject item) {
    }

    public void remove (ConfigObject item) {
    }
}
