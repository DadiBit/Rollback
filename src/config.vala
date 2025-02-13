/* config.vala
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



public class Rollback.Config : Object {

    public enum Kind {
        GENERIC = 0,
        USERS = 1,
        SYSTEM = 2
    }

    public Rollback.ConfigPage page;
    public Rollback.ConfigRow row;

    public ObjectPath device;
    public string title;
    public Kind kind;

    public Config (ObjectPath device, string title, Kind kind) {
        this.device = device;
        this.title = title;
        this.kind = kind;
        this.page = new Rollback.ConfigPage (this);
        this.row = new Rollback.ConfigRow (this) {
            activatable_widget = this.page,
        };
    }

}
