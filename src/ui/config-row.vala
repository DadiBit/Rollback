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
    public enum Icon {
        DEFAULT,
        GENERIC,
        USERS,
        SYSTEM,
    }

    [GtkChild]
    private unowned Gtk.Image image;

    public ConfigRow (string title, Icon? icon) {
        Object (title: title);

        switch (icon) {
            case Icon.USERS:
                image.icon_name = "system-users-symbolic";
                break;
            case Icon.SYSTEM:
                image.icon_name = "penguin-alt-symbolic";
                break;
            case Icon.DEFAULT:
            case Icon.GENERIC:
            default:
                image.icon_name = "drive-harddisk-symbolic";
                break;
        }
    }

}
