# Yuki Nagato XDG Sound Theme Suite (`yuki-nagato`, `yuki-nagato-sfx`, `yuki-nagato-voice`)

A modern, non-intrusive [freedesktop.org XDG Sound Theme](https://specifications.freedesktop.org/sound-theme/latest-single) and [Sound Naming Specification](https://specifications.freedesktop.org/sound-naming/0.2) package curated from:
1. **Suzumiya Haruhi no Chokuretsu (NDS) - Yuki Nagato Voice Archive** ([The Sounds Resource](https://sounds.spriters-resource.com/ds_dsi/suzumiyaharuhinochokuretsujpn/?source=genre))
2. **Suzumiya Haruhi no Chokuretsu (NDS) - Miscellaneous Sound Effects** ([The Sounds Resource](https://sounds.spriters-resource.com/ds_dsi/suzumiyaharuhinochokuretsujpn/?source=genre))
3. **Suzumiya Haruhi no Gekitou (PC) - Miscellaneous Sound Effects** ([The Sounds Resource Asset #401845](https://sounds.spriters-resource.com/pc_computer/suzumiyaharuhinogekitou/asset/401845/))
4. **Suzumiya Haruhi no Tsuisou (PSP) - Yuki Nagato Voice Archive** ([The Spriters Resource](https://www.spriters-resource.com/psp/suzumiyaharuhinotsuisou/))

## Included Theme Profiles
- **`themes/yuki-nagato/` (Recommended Default — Smart Hybrid)**:
  - **52 High-Frequency UI, Notification, Bell & Hardware Events** use crisp, short (`0.03s–0.61s`) UI sound effects so frequent notifications (`message-new-instant`, `audio-volume-change`, `bell-terminal`, `button-pressed`, `device-added`) never cause voice fatigue.
  - **31 Low-Frequency Semantic Lifecycle, Completion, Search & Alert Events** use Yuki Nagato's concise, deadpan `0.44s–1.91s` humanoid-interface voice cues (`desktop-login` 「歓迎する。」, `system-shutdown` 「終了。」, `complete-download` 「完了。」, `trash-empty` 「消滅を確認。」, `item-deleted` 「消去する。」, `search-results` 「発見。」, `dialog-error` 「対応不能。」, `battery-low` 「状況、悪化。」, `suspend-start` 「待機状態を継続。」).
  - **42 Unmapped Events** (such as surround speaker calibration callouts `audio-channel-*` and noisy continuous window/scroll micro-events) are intentionally left unmapped to inherit cleanly from `freedesktop`.
- **`themes/yuki-nagato-sfx/` (Pure Minimalist SFX)**:
  - All 83 mapped events use pure Chokuretsu/Gekitou UI sound effects (zero voice lines).
- **`themes/yuki-nagato-voice/` (Extended Voice)**:
  - Adds ultra-short (`0.23s–1.29s`) Yuki Nagato voice cues to notifications, hardware plug events, and dialogs (e.g. `message-new-instant` 「ここ。」 `0.41s`, `message-new-email` 「伝える。」 `0.65s`, `device-added` 「端末を発見。」 `1.29s`, `dialog-ok` 「分かった。」 `0.62s`).

## Installation (Gentoo / Wayland / Hyprland / GNOME / KDE)
```bash
make install-all
# Set active XDG sound theme in GTK / GSettings:
gsettings set org.gnome.desktop.sound theme-name 'yuki-nagato'
gsettings set org.gnome.desktop.sound event-sounds true
```
