#!/usr/bin/env bash
# NordVPN legt Daten in /var/lib/nordvpn ab. /var wird auf Atomic-Systemen nicht aus dem Image übernommen,
# deshalb verschieben wir die Daten nach /usr und lassen sie beim Start zurückkopieren (tmpfiles).
set -euo pipefail

if ! rpm -q nordvpn >/dev/null 2>&1; then
    echo "NordVPN ist nicht installiert – überspringe."
    exit 0
fi

if [ -d /var/lib/nordvpn ]; then
    mkdir -p /usr/share/origem
    cp -a /var/lib/nordvpn /usr/share/origem/nordvpn-varlib
fi

cat > /usr/lib/tmpfiles.d/origem-nordvpn.conf <<'EOF'
C /var/lib/nordvpn - - - - /usr/share/origem/nordvpn-varlib
EOF

cat > /usr/lib/sysusers.d/origem-nordvpn.conf <<'EOF'
g nordvpn -
EOF

systemctl enable nordvpnd.service || systemctl enable nordvpnd.socket || true
echo "NordVPN vorbereitet."
