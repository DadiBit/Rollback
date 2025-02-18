/* ui/config-row.vala
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

[GtkTemplate (ui = "/it/dadib/Rollback/ui/config-row.ui")]
public class Rollback.ConfigRow : Adw.ActionRow {
    [GtkChild]
    private unowned Gtk.Image kind;

    public ConfigRow (ConfigObject config) {
        Object (title: config.title);
        switch (config.kind) {
            case ConfigObject.Kind.USERS:
                kind.icon_name = "system-users-symbolic";
                break;
            case ConfigObject.Kind.SYSTEM:
                kind.icon_name = "penguin-alt-symbolic";
                break;
            case ConfigObject.Kind.GENERIC:
            default:
                kind.icon_name = "drive-harddisk-symbolic";
                break;
        }
    }
}
