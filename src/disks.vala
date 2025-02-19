/* disks.vala
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

public class Disks {

    /* Helper class that stores DBus Proxies given the device ObjectPath as key */
    private class CachedDevices<P> {
        internal HashTable<ObjectPath, P> cache =
            new HashTable<ObjectPath, P>(str_hash, str_equal);
        internal P get (ObjectPath path) throws IOError {
            if (path in cache) return cache[path];
            cache[path] = Bus.get_proxy_sync<P>(
                BusType.SYSTEM,
                "org.freedesktop.UDisks2",
                path
            );
            return cache[path];
        }
        internal void invalidate () {
            cache.remove_all ();
        }
        internal ObjectPath[] devices {
            owned get { return cache.get_keys_as_array (); }
        }
    }

    /* Manager Proxy */
    [DBus (name = "org.freedesktop.UDisks2.Manager")]
    private interface Manager : Object {
        internal abstract ObjectPath[] GetBlockDevices (
            HashTable<string, Variant> options = new HashTable<string, Variant>(str_hash, str_equal)
        ) throws DBusError, IOError;
        internal abstract void EnableModule (string name, bool enable = true) throws DBusError, IOError;
    }
    private Manager? _manager = null;

    /* Get a list of currently available block devices */
    private ObjectPath[] _get_block_devices () throws DBusError, IOError {
        var options = new HashTable<string, Variant>(str_hash, str_equal);
        return _manager.GetBlockDevices (options);
    }

    /* Block Proxy */
    [DBus (name = "org.freedesktop.UDisks2.Block")]
    private interface Block : Object {
        internal abstract string IdType { owned get; } // btrfs, ext4 etc
    }
    private CachedDevices<Block> _block = new CachedDevices<Block>();

    private inline bool _is_btrfs (ObjectPath device) throws IOError {
        return "btrfs" == _block[device].IdType;
    }

    /* Filesystem Proxy */
    [DBus (name = "org.freedesktop.UDisks2.Filesystem")]
    private interface Filesystem : Object {
        internal abstract uint8[,] MountPoints { owned get; }
    }
    private CachedDevices<Filesystem> _filesystem = new CachedDevices<Filesystem>();

    private inline bool _is_mounted (ObjectPath device) throws IOError {
        return 0 < _filesystem[device].MountPoints.length[0];
    }

    /* Btrfs Filesystem Proxy */
    [DBus (name = "org.freedesktop.UDisks2.Filesystem.BTRFS")]
    public interface Btrfs : Object {
        public struct Subvolume {
            public uint64 id;
            public uint64 parent_id;
            public string path;
        }
        /* Abusing out field, since nested structs are not supported */
        internal abstract int32 GetSubvolumes (
            bool snapshots_only,
            out Subvolume[] subvolumes,
            HashTable<string, Variant> options = new HashTable<string, Variant>(str_hash, str_equal)
        ) throws DBusError, IOError;
    }
    private CachedDevices<Btrfs> _btrfs = new CachedDevices<Btrfs>();

    /* Returns a list of cached BTRFS block devices */
    public ObjectPath[] mounted_btrfs_partitions {
        owned get { return _btrfs.devices; }
    }

    /* Returns a list of snapshots subvolumes */
    public Btrfs.Subvolume[] get_btrfs_snapshots (ObjectPath device) {
        Btrfs.Subvolume[] subvols;
        _btrfs[device].GetSubvolumes (true, out subvols);
        return subvols;
    }

    /* Populate all currently available devices Proxies cache */
    private void _populate_cache () throws DBusError, IOError {
        Block block;
        Filesystem filesystem;
        foreach (var device in _get_block_devices ()) {
            block = _block[device];

            if (_is_btrfs (device)) {
                filesystem = _filesystem[device];

                if (_is_mounted (device)) {
                    // We end up caching just all currently mounted BTRFS devices
                    _btrfs.get(device);
                }
            }
        }
    }

    public void reload_cache () throws DBusError, IOError {
        _block.invalidate ();
        _filesystem.invalidate ();
        _btrfs.invalidate ();
        _populate_cache ();
    }

    /* Constructor that can throw, since neither connection, nor btrfs module
     * enabling, nor block device listing (for proxies caching), can be guaranteed */
    public Disks () throws DBusError, IOError {

        // Manager
        _manager = Bus.get_proxy_sync<Manager>(
            BusType.SYSTEM,
            "org.freedesktop.UDisks2",
            "/org/freedesktop/UDisks2/Manager"
        );

        /* Load BTRFS module: it throws a DBusError if we don't have the
         * module available in /usr/lib64/udisks2/modules/libudisks2_btrfs.so */
        _manager.EnableModule ("btrfs");

        _populate_cache ();

    }

}
