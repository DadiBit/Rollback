/* system.vala
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

public class System {

    /* Hostname - private API */

    [DBus (name = "org.freedesktop.hostname1")]
    private interface Hostname : Object {
        internal abstract string OperatingSystemPrettyName { owned get; }
        internal abstract string KernelRelease { owned get; }
        internal abstract string Hostname { owned get; }
    }
    private Hostname? _hostname = null;

    /* Hostname - public API */

    public bool immutable_distro {
        get { return "Silverblue" in _hostname.OperatingSystemPrettyName; }
    }

    public string hostname {
        owned get { return _hostname.Hostname; }
    }

    /* Constructor that can throw, since connection is not guaranteed */
    public System () throws IOError {

        // OS, kernel, hostname
        _hostname = Bus.get_proxy_sync<Hostname>(
            BusType.SYSTEM,
            "org.freedesktop.hostname1",
            "/org/freedesktop/hostname1"
        );

    }

}
