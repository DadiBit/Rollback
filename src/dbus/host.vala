/* dbus/host.vala
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

class Host : Object {
    [DBus (name = "org.freedesktop.hostname1")]
    public interface Proxy : Object {
        public abstract string OperatingSystemPrettyName { owned get; }
        public abstract string KernelRelease { owned get; }
        public abstract string Hostname { owned get; }
    }

    private Proxy proxy;

    public Host () throws IOError {
        this.proxy = Bus.get_proxy_sync(
            BusType.SYSTEM,
            "org.freedesktop.hostname1",
            "/org/freedesktop/hostname1"
        );
    }

    public bool is_root_immutable () throws IOError {
        return "Silverblue" in proxy.OperatingSystemPrettyName;
    }

}
