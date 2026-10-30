# Origem Secure 🔒

Ein sicheres Linux-Betriebssystem auf Basis von **Fedora Atomic** (Universal Blue) – mit **Claude** eingebaut,
umschaltbaren **Themes** und Gaming-Modus.

## Was drin ist

**Sicherheit**
- Unveränderliches System: Updates lassen sich zurücknehmen (`rpm-ostree rollback`)
- Firewall: alles Eingehende ist zu (Zone `origem`), kein SSH-Server
- Kernel-Härtung, zufällige MAC-Adresse im WLAN, IPv6-Privacy
- Apps als Flatpak in der Sandbox, Rechte-Panel mit **Flatseal**
- **Tresor**: verschlüsselter Ordner `~/Tresor` (`Super + T`)
- **Panik-Modus**: Tresor zu, Internet aus, Bildschirm gesperrt (`Super + F12`)
- **USB-Schutz** (USBGuard), im Willkommens-Assistenten einschaltbar
- **NordVPN** vorinstalliert, Tor Browser, verschlüsselte Backups (Déjà Dup)
- Datenschutz-Voreinstellungen in GNOME (keine Telemetrie, keine Benachrichtigungen auf dem Sperrbildschirm)

**Claude**
- Claude Code vorinstalliert (systemweit, Einstellungen in `/etc/claude-code/`)
- **Mini-Chat** per `Super + C`
- **Protokoll**: jede Aktion von Claude wird gespeichert (`origem-protokoll`)
- Kritische Aktionen (löschen, Systemänderungen, Downloads) brauchen eine Bestätigung

**Themes** (`origem-theme`)
- `glas` – hell, durchsichtig, Glas-Effekt
- `hacker` – schwarz/neon, Terminal-Schrift, Matrix-Intro im Terminal
- Eigene Themes: einfach Claude fragen („Bau mir ein Cyberpunk-Theme“)

**Extras**
- Steam, GameMode (`gamemoderun`), Mission Center
- Willkommens-Assistent beim ersten Start

## Bauen

Der Bau läuft automatisch über GitHub Actions:

1. **Signatur-Schlüssel** einmalig anlegen (auf einem PC mit [cosign](https://github.com/sigstore/cosign)):
   ```
   cosign generate-key-pair
   ```
   - `cosign.pub` ins Repo legen (ersetzt die Platzhalter-Datei)
   - Inhalt von `cosign.key` als Repository-Secret **`SIGNING_SECRET`** speichern
     (Settings → Secrets and variables → Actions)
   - `cosign.key` niemals hochladen!
2. Pushen → Workflow **bluebuild** baut das Image nach `ghcr.io/li4mski/origem-secure`
3. Unter **Actions → „ISO bauen“ → Run workflow** die Installations-ISO erstellen und herunterladen
4. ISO mit [Fedora Media Writer](https://fedoraproject.org/workstation/download) auf einen USB-Stick schreiben

**Beim Installieren „Festplatte verschlüsseln“ anhaken** – das ist der wichtigste Schutz.

## Auf ein bestehendes Fedora-Atomic-System wechseln

```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/li4mski/origem-secure:latest
systemctl reboot
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/li4mski/origem-secure:latest
systemctl reboot
```

## Aufbau des Projekts

```
recipes/recipe.yml          Bauplan (Pakete, Flatpaks, Erweiterungen)
files/scripts/              Skripte, die beim Bauen laufen
files/system/               Dateien, die ins System kopiert werden
  usr/bin/origem-*          Origem-Programme (Chat, Theme, Tresor, Panik, Protokoll, Willkommen)
  usr/share/origem/themes/  eingebaute Themes
  etc/claude-code/          Claude-Einstellungen und Wissen über das System
```
