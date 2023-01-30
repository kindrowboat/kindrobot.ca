---

layout:     post
title:      "NixOS with AwesomeWM on a Framework laptop"
slug:       "nixos-awesomewm-framework"
date:       2023-01-29 22:53:54
categories: [linux]

---

[Framework] is a company that makes laptops that are easily repairable.
[AwesomeWM] is a modular tiling window manager. [NixOS] is a Linux distribution
that is configured using a declarative, idempotent language. This is a blog post
about how to install and configure NixOS using AwesomeWM with no display manager
(i.e. using `startx`) on a Framework laptop. I was inspired to write this after
receiving help from [elly's post] about installing Alpine on a Framework laptop.

## Install NixOS

### Create install medium

Download a copy of the [NixOS installation media]. I used the Gnome graphical
installer, but any of them will be fine. Once complete, you can burn the
installation image to a USB flash drive using something like

```bash
sudo dd if=/path/to/downloaded/image.iso of=/dev/sdX bs=4M status=progress
```

### Disable secure boot

Next disable [secure boot] (at least temporarily) in order to boot the
installer.

1. reboot the computer
1. repeatedly press F2 until you see the UEFI BIOS menu
1. go to the Security tab
1. go the Secure Boot
1. change "Enforce Secure Boot" to disabled
1. press F10 to save and exit

### Run installer

Reboot the computer and repeatedly press F10 until the boot menu appears. Select
the entry that has "USB" in it. Follow the prompts to install NixOS. You might
need to connect to a WiFi network, close the installer, and reopen the
installer. At the end of the installer, when prompted for which desktop
environment to install, select "None / terminal only". Don't worry, we'll be
installing AwesomeWM shortly.

## Connect to WiFi

After restarting and signing in at the login TTY, reconnect to the WiFi by
running `nmtui` and following the prompts.

## Configure NixOS

There are many ways to set up a NixOS configuration. I personally use a
[repository with Nix flakes]. By default you'll find your configuration in
`/etc/nixos/`. In this section, I'm going to provide statements that you'll
likely want to include in one of your NixOS configuration files. Which file to
put it in is a matter of preference, and is left up to the user, though I'll
provide links to where I included them in my repo.

### Kernel version

Wifi, Bluetooth, and graphics will require Linux Kernel 5.16 or greater. I
simply set mine to install the latest for now.

[source](https://git.kindrobot.ca/kindrobot/nix-config/src/commit/03353c4d0eac0c6ba50843289d201bd055ff3822/box/framework2.nix#L14)
```nix
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
```

### Backlight

xbacklight doesn't work out of the box. Get it working with

[source](https://git.kindrobot.ca/kindrobot/nix-config/src/commit/6dcc57a85715665d188de03e3c74a926056c58ea/box/framework2.nix#L42-L46)
```nix
{
  hardware.acpilight.enable = lib.mkDefault true;
  hardware.sensor.iio.enable = lib.mkDefault true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';
}
```

### Bluetooth

Enable bluetooth with

[source](https://git.kindrobot.ca/kindrobot/nix-config/src/commit/6dcc57a85715665d188de03e3c74a926056c58ea/box/framework2.nix#L49)
```nix
{
  hardware.bluetooth.enable = true;
}
```

Manage bluetooth through the CLI with `bluetoothctl`.

### Fingerprint Scanner

Enable the fingerprint reader with

[source](https://git.kindrobot.ca/kindrobot/nix-config/src/commit/6dcc57a85715665d188de03e3c74a926056c58ea/box/framework2.nix#L50)
```
{
  services.fprintd.enable = true;
}
```

Enroll your fingerprint with `sudo fprintd-enroll $USER`. You'll then be able to
user your finger print when signing in on a TTY and when using sudo.

### Increase the TTY console font

Because Framework laptops have high pixel density monitors, the main TTY console
can be hard to read. Installing and enabling a larger font can help.

[source](https://git.kindrobot.ca/kindrobot/nix-config/src/commit/6dcc57a85715665d188de03e3c74a926056c58ea/box/framework2.nix#L51-L59)
```nix
{
  environment.systemPackages = with pkgs; [
    terminus_font
  ];
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };
}
```

### Specify working touchpad drivers

Curiously if you install Gnome or KDE, NixOS will figure out the the correct (or
at least a working) touchpad driver. When using AwesomeWM with no display
manager, we're on our own. Specify using the synaptics driver with some
reasonable configuration.

[source](https://git.kindrobot.ca/kindrobot/nix-config/src/commit/465243fe219bfb22f1cdde743b4cd4a35f4c1c2e/box/framework2.nix#L60-L65)
```nix
{
  services.xserver.synaptics = {
    enable = true;
    twoFingerScroll = true;
    accelFactor = "0.075";
    fingersMap = [ 1 3 2 ];
  };
}
```

### Configure AwesomeWM

Some settings here are to help make the menu bar and title bars readable on the
high DPI monitor.

[source](https://git.kindrobot.ca/kindrobot/nix-config/src/commit/6dcc57a85715665d188de03e3c74a926056c58ea/conf/awesome_workstation.nix#L5-L18)
```nix
{
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks # is the package manager for Lua modules
      luadbi-mysql # Database abstraction layer
    ];
  };
  services.xserver.dpi = 180;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
}
```
  
Notice the this config enables a `startx` display manager. In fact, this is
configuring NixOS to be able to do `startx` without a display manager. Create an
`.xinitrc` with

```bash
echo awesome > ~/.xinitrc
```

### AwesomeWM bells and whistles

With all of the configuration up until now, after running `nixos-rebuild switch
...`, (and probably restarting), you should be able to get into Awesome by
signing in at the login TTY and running `startx`. If you'd like a more custom
desktop with most of the function keys working, try cloning my awesome config: 

```bash
git clone --recurse-submodules --remote-submodules https://git.kindrobot.ca/kindrobot/awesome.git ~/.config/awesome`
```

and reload nix by pressing Ctrl+Super+R.


[Framework]: https://frame.work
[AwesomeWM]: https://awesomewm.org/
[NixOS]: https://nixos.org
[elly's post]: https://elly.town/d/blog/2022-10-20-alpine-framework.txt
[NixOS installation media]: https://nixos.org/download.html#nixos-iso
[secure boot]: https://en.wikipedia.org/wiki/Hardware_restriction#Secure_boot
[repository with Nix flakes]: https://git.kindrobot.ca/kindrobot/nix-config
