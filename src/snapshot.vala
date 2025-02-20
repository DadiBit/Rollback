/* ui/snapshot.vala
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

/* An abstract Object representing a snapshot */
public class Rollback.SnapshotObject : Object {
    public string path;

    public SnapshotObject (string path) {
        this.path = path;
    }
}

/* A ListModel that manages a device snapshots */
public class Rollback.SnapshotList : Object, ListModel {
    private ConfigObject _config;

    public SnapshotList (ConfigObject config) {
        _config = config;
    }

    public Object? get_item (uint position) {
        var subvol = _config.disks.get_btrfs_snapshots (_config.device)[position];
        return new Rollback.SnapshotObject (subvol.path);
    }

    public Type get_item_type () {
        return typeof (SnapshotObject);
    }

    public uint get_n_items () {
        return _config.disks.get_btrfs_snapshots (_config.device).length;
    }

}
