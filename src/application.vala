/* application.vala
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

public class Rollback.Application : Adw.Application {
    public bool immutable_distro = false;
    public ConfigList configurations;

    public Application () {
        Object (
            application_id: "it.dadib.Rollback",
            flags: ApplicationFlags.DEFAULT_FLAGS
        );
    }

    construct {
        ActionEntry[] action_entries = {
            { "about", this.on_about_action },
            { "quit", this.quit }
        };
        this.add_action_entries (action_entries, this);
        this.set_accels_for_action ("app.quit", {"<primary>q"});

        try {
            var system = new System ();
            this.immutable_distro = system.immutable_distro;
        } catch (IOError e) {
            warning (@"Couldn't determine if system is an immutable distro: $(e.message)");
        }

        try {
            var disks = new Disks ();
            this.configurations = new ConfigList (disks);
        } catch (DBusError e) {
            error (@"Couldn't create BTRFS UDisks2 DBus interface: $(e.message)");
        } catch (IOError e) {
            error (@"Couldn't create UDisks2 DBus interface: $(e.message)");
        } catch (KeyFileError e) {
            // TODO: warning and do something to recover
            error (@"Couldn't parse configuration file: $(e.message)");
        } catch (FileError e) {
            // TODO: warning and do something to recover
            error (@"Couldn't open/read configuration file: $(e.message)");
        }

    }

    public override void activate () {
        base.activate ();
        var win = this.active_window ?? new Rollback.Window (this);
        win.present ();
    }

    private void on_about_action () {
        string[] developers = { "Davide Bassi" };
        string debug_info = @"- commit: $(Config.COMMIT)";
        var about = new Adw.AboutDialog () {
            application_name = "rollback",
            application_icon = "it.dadib.Rollback",
            developer_name = "Davide Bassi",
            translator_credits = _("translator-credits"),
            version = Config.PACKAGE_VERSION,
            developers = developers,
            copyright = "© 2025 Davide Bassi",
            debug_info = debug_info,
        };

        about.present (this.active_window);
    }
}

