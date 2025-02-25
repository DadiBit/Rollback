/* data/config-object.vala
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

/* An abstract Object representing a configuration */
public class Rollback.ConfigObject : Object {
    public enum Kind {
        GENERIC = 0,
        USERS = 1,
        SYSTEM = 2;
    }

    public string title { get; construct; }
    public Kind kind { get; construct; }

    public ConfigObject (string title, Kind kind) {
        Object (title: title, kind: kind);
    }
}

