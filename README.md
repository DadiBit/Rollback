# Rollback

A simple GNOME app, bundled as Flatpak, to rollback your data.

> [!WARNING]
> This is alpha software: stuff will break.

## **What** is this?

This is a graphical application, developed for the GNOME Desktop Environment, that can create a timeline of your btrfs subvolumes.

You can create one or more configurations, each one with its own policy and its own

## **How** to use?

### 1. Install the app

You should find it in your software/app center available as a Flatpak app.

### 2. Open the app

You can find it either in the application menu or by showing all apps in the GNOME overview.

### 3. Create a new configuration

You can click the highlighted button, or, if you prefer, the "+" button in the header bar at the top.

### 4. Pick the btrfs sub-volume

This is going to be, usually, one of the following:

> [!TIP]
> If running an immutable distro (Vanilla OS 2, Fedora Silverblue etc.) you probably don't want to create a configuration for your root partition, since the rollback is already baked in the system.

### 5. Select the timeline policy

You can specify how often a snapshot should be taken.
If the sub-volume was already configured, the configuration gets picked up automatically.

### 6. All set!

Now you can just sit back and relax. Whenever you'll need 

## **Why** did you develop this?

Cuz noobs like me struggle to rollback btrfs snapshots made by snapper.
I loved btrfs, until I had to understand how it worked to recover my data (it took too much time).

Yep, personal skill issue.

### **Why** not snapper backend?

Cuz:

1. it doesn't have a polkit policy, so I couldn't just prompt for a password and edit the config or something
2. it doesn't support rollback/undochange via DBus
3. it's overkill for what we want to do here

