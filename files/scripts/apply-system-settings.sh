#!/usr/bin/env bash
# Rechte setzen und GNOME-Standardeinstellungen (dconf) kompilieren.
set -euo pipefail

chmod 0755 /usr/bin/origem-* /usr/libexec/origem/* 2>/dev/null || true

# dconf-Profil, damit unsere Systemvorgaben (Tastenkürzel, Theme) gelten
mkdir -p /etc/dconf/profile
if [ ! -f /etc/dconf/profile/user ] || ! grep -q "system-db:local" /etc/dconf/profile/user; then
    printf 'user-db:user\nsystem-db:local\n' > /etc/dconf/profile/user
fi
dconf update

# Firewall-Standardzone auf unsere sichere Zone stellen
if [ -f /etc/firewalld/firewalld.conf ]; then
    sed -i 's/^DefaultZone=.*/DefaultZone=origem/' /etc/firewalld/firewalld.conf
else
    echo "DefaultZone=origem" > /etc/firewalld/firewalld.conf
fi

echo "Systemeinstellungen angewendet."
