#!/usr/bin/env python3
"""
Yuki Nagato XDG Sound Theme Builder & Manifest Generator
Compliant with:
  - freedesktop.org Sound Theme Specification v0.2 (https://specifications.freedesktop.org/sound-theme/latest-single)
  - freedesktop.org Sound Naming Specification v0.2 (https://specifications.freedesktop.org/sound-naming/0.2)
"""

import csv
import json
import os
import shutil
import subprocess
import zipfile
from typing import Any, Dict, List, Optional, Tuple
import numpy as np

RAW_ROOT = "/tmp/xdg_raw"
OUT_ROOT = "/working_dir/c_5967af7885f765f1/artifacts/file_generation/ttl=63d/output"
BUILD_ROOT = "/tmp/yuki_nagato_xdg_build"

SOURCE_ARCHIVES = {
    "chokuretsu_yuki": {
        "archive_name": "DS _ DSi - Suzumiya Haruhi no Chokuretsu (JPN) - Characters - Yuki Nagato.zip",
        "game": "Suzumiya Haruhi no Chokuretsu (NDS)",
        "url": "https://sounds.spriters-resource.com/ds_dsi/suzumiyaharuhinochokuretsujpn/?source=genre",
        "base_dir": os.path.join(RAW_ROOT, "chokuretsu_yuki/Yuki Nagato"),
    },
    "chokuretsu_sfx": {
        "archive_name": "DS _ DSi - Suzumiya Haruhi no Chokuretsu (JPN) - Miscellaneous - Sound Effects.zip",
        "game": "Suzumiya Haruhi no Chokuretsu (NDS)",
        "url": "https://sounds.spriters-resource.com/ds_dsi/suzumiyaharuhinochokuretsujpn/?source=genre",
        "base_dir": os.path.join(RAW_ROOT, "chokuretsu_sfx/Sounds"),
    },
    "gekitou_sfx": {
        "archive_name": "PC _ Computer - Suzumiya Haruhi no Gekitou - Miscellaneous - Sound Effects.zip",
        "game": "Suzumiya Haruhi no Gekitou (PC)",
        "url": "https://sounds.spriters-resource.com/pc_computer/suzumiyaharuhinogekitou/asset/401845/",
        "base_dir": os.path.join(RAW_ROOT, "gekitou_sfx/SE"),
    },
    "tsuisou_yuki": {
        "archive_name": "PlayStation Portable - Suzumiya Haruhi no Tsuisou - Voices - Yuki Nagato's Voice.zip",
        "game": "Suzumiya Haruhi no Tsuisou (PSP)",
        "url": "https://www.spriters-resource.com/psp/suzumiyaharuhinotsuisou/",
        "base_dir": os.path.join(RAW_ROOT, "tsuisou_yuki/Yuki Nagato"),
    },
}

# Complete catalog of all 109 standard XDG Sound Naming Specification events
# Each entry defines:
#   xdg_name, context, xdg_description, status ("Mapped_SFX", "Mapped_Voice", "Unmapped_Fallback"),
#   hybrid_source (archive_key, filename, transcription_ja, romaji, translation_en, target_peak_db),
#   sfx_only_source (archive_key, filename, description_en, target_peak_db),
#   voice_ext_source (optional override for yuki-nagato-voice profile),
#   rationale_en, recommendation_if_empty_en

XDG_EVENTS_SPEC: List[Dict[str, Any]] = [
    # ==================== 4.1 ALERTS (7 standard events) ====================
    {
        "xdg_name": "dialog-error",
        "context": "Alert",
        "xdg_description": "The sound used when a dialog is opened to explain an error condition to the user.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "ACD00.WAV", "対応不能。", "Taiō funō.", "Unable to handle / Cannot process.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_02.WAV", "Low two-note error buzzer (0.79s)", -6.0),
        "voice_ext": None,
        "rationale_en": "Concise 1.01s deadpan humanoid-interface error report ('Taiō funō'); pairs naturally with critical error dialogs.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "network-connectivity-lost",
        "context": "Alert",
        "xdg_description": "The sound used when network connectivity is lost.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "WAIT00.WAV", "作業停滞。", "Sagyō teitai.", "Operation stalled.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_02.WAV", "Soft descending double-thud alert (0.30s)", -6.0),
        "voice_ext": None,
        "rationale_en": "Short 1.02s status report ('Sagyō teitai' / 'Operation stalled') clearly signals connection drop without melodrama.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "network-connectivity-error",
        "context": "Alert",
        "xdg_description": "The sound used when an error occurs when initializing network connection.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_02.WAV", "[SFX: Soft Error Double-Thud]", "N/A", "Soft low double-thud error tone", -6.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_02.WAV", "Soft low double-thud error tone (0.30s)", -6.0),
        "voice_ext": ("tsuisou_yuki", "09750.wav", "つかない。", "Tsukanai.", "It won't connect / turn on.", -3.5),
        "rationale_en": "Uses a subtle 0.30s low double-thud in the default hybrid theme so repeated Wi-Fi retry failures do not spam voice lines; voice profile uses 'Tsukanai' (0.74s).",
        "recommendation_en": "",
    },
    {
        "xdg_name": "battery-low",
        "context": "Alert",
        "xdg_description": "The sound used when the battery is low (below 20%, for example).",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "TMDEL00.WAV", "状況、悪化。", "Jōkyō, akka.", "Situation deteriorating.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "EVENT_04.WAV", "Clean double-beep alert tone (0.30s)", -5.5),
        "voice_ext": None,
        "rationale_en": "Yuki's calm 1.57s 'Jōkyō, akka' ('Situation deteriorating') fits a low-battery threshold warning.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "power-unplug-battery-low",
        "context": "Alert",
        "xdg_description": "The power cable has been unplugged and the battery level is low.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "WAIT01.WAV", "負荷が増大している。", "Fuka ga zōdai shite iru.", "Load is increasing.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "SLG_02.WAV", "Descending warning tone (0.61s)", -5.5),
        "voice_ext": None,
        "rationale_en": "Distinct 1.35s alert ('Fuka ga zōdai shite iru') differentiates unplugging on low battery from standard battery-low.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "suspend-error",
        "context": "Alert",
        "xdg_description": "The machine failed to suspend.",
        "status": "Mapped_Voice",
        "hybrid": ("tsuisou_yuki", "09196.wav", "無理。", "Muri.", "Impossible.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_02.WAV", "Low two-note error buzzer (0.79s)", -6.0),
        "voice_ext": None,
        "rationale_en": "Ultra-short 0.51s deadpan 'Muri' ('Impossible / Cannot do that') fits a failed suspend attempt.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "software-update-urgent",
        "context": "Alert",
        "xdg_description": "The sound used when an urgent update is available through the system software update program.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "HAZARD00.WAV", "時間がない。急いで。", "Jikan ga nai. Isoide.", "Out of time. Hurry.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "EVENT_04.WAV", "Clean double-beep alert tone (0.30s)", -5.5),
        "voice_ext": None,
        "rationale_en": "Rare critical security update event; 1.91s 'Jikan ga nai. Isoide.' conveys urgency while staying in character.",
        "recommendation_en": "",
    },

    # ==================== 4.2 NOTIFICATIONS (40 standard events) ====================
    {
        "xdg_name": "message-new-instant",
        "context": "Notification",
        "xdg_description": "The sound used when a new IM is received.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_03.WAV", "[SFX: Crisp Glass Ping]", "N/A", "Crisp 0.28s digital glass notification ping", -5.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_03.WAV", "Crisp 0.28s digital glass notification ping", -5.5),
        "voice_ext": ("chokuretsu_yuki", "FOUND02.WAV", "ここ。", "Koko.", "Here.", -3.5),
        "rationale_en": "Per user request for short, simple, non-intrusive notifications: default uses a crisp 0.28s chime from Chokuretsu ('ONMEM_03.WAV') so chat bursts never talk over each other; voice profile uses 0.41s 'Koko' ('Here').",
        "recommendation_en": "",
    },
    {
        "xdg_name": "message-new-email",
        "context": "Notification",
        "xdg_description": "The sound used when a new email is received.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00000.wav", "[SFX: Two-Note Crystal Chime]", "N/A", "Clean 0.35s two-note ascending crystal chime", -5.5),
        "sfx_only": ("gekitou_sfx", "se_00000.wav", "Clean 0.35s two-note ascending crystal chime", -5.5),
        "voice_ext": ("tsuisou_yuki", "08980.wav", "伝える。", "Tsutaeru.", "Relaying / I have a message.", -3.5),
        "rationale_en": "Default uses a clean 0.35s two-note chime ('se_00000.wav'); voice profile uses Yuki's 0.65s 'Tsutaeru' ('Relaying message').",
        "recommendation_en": "",
    },
    {
        "xdg_name": "complete-download",
        "context": "Notification",
        "xdg_description": "The sound used when a file completed downloading.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "CMP00.WAV", "完了。", "Kanryō.", "Complete.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_15.WAV", "Sparkling completion chime (0.79s)", -5.5),
        "voice_ext": None,
        "rationale_en": "Ultra-clean 0.59s 'Kanryō' ('Complete') is short, clear, and naturally signals finished downloads.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "complete-copy",
        "context": "Notification",
        "xdg_description": "The sound used when a file completed copying.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "TEC00.WAV", "完了した。", "Kanryō shita.", "Completed.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_01.WAV", "Two-note positive completion chime (0.60s)", -5.5),
        "voice_ext": None,
        "rationale_en": "Concise 0.72s 'Kanryō shita' ('Completed') confirms file copy completion.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "complete-media-burn",
        "context": "Notification",
        "xdg_description": "The sound used when an optical medium completed burning.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "CLTNM00.WAV", "処理、完了。", "Shori, kanryō.", "Processing complete.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_15.WAV", "Sparkling completion chime (0.79s)", -5.5),
        "voice_ext": None,
        "rationale_en": "1.29s 'Shori, kanryō' ('Processing complete') fits long-running disk/ISO burn operations.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "complete-media-rip",
        "context": "Notification",
        "xdg_description": "The sound used when an optical medium completed ripping.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "CLTGD00.WAV", "情報の収集を完了した。", "Jōhō no shūshū o kanryō shita.", "Information extraction complete.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_15.WAV", "Sparkling completion chime (0.79s)", -5.5),
        "voice_ext": None,
        "rationale_en": "1.83s 'Jōhō no shūshū o kanryō shita' ('Information collection complete') fits media ripping/extraction.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "complete-scan",
        "context": "Notification",
        "xdg_description": "The sound used when a scanner completed image acquisition and processing.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "S5ED_03.WAV", "確認した。", "Kakunin shita.", "Confirmed.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_01.WAV", "Two-note positive completion chime (0.60s)", -5.5),
        "voice_ext": None,
        "rationale_en": "0.79s 'Kakunin shita' ('Confirmed') cleanly signals scan acquisition completion.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "phone-incoming-call",
        "context": "Notification",
        "xdg_description": "The sound used when a phone/voip call is coming in.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "EVENT_21.WAV", "[SFX: Intercom / Phone Trill]", "N/A", "Clean 0.61s electronic phone ring trill", -5.5),
        "sfx_only": ("chokuretsu_sfx", "EVENT_21.WAV", "Clean 0.61s electronic phone ring trill", -5.5),
        "voice_ext": ("tsuisou_yuki", "09280.wav", "もしもし。", "Moshi moshi.", "Hello? (on the phone)", -3.5),
        "rationale_en": "Default uses the 0.61s electronic ring trill ('EVENT_21.WAV') so incoming calls sound like a recognizable ring; voice profile uses Yuki's 0.74s 'Moshi moshi'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "phone-outgoing-busy",
        "context": "Notification",
        "xdg_description": "The sound used when a phone/voip call is dialed out and responder is busy.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "EVENT_23.WAV", "[SFX: Busy Signal Beep]", "N/A", "1.01s dual-beep busy signal", -6.0),
        "sfx_only": ("chokuretsu_sfx", "EVENT_23.WAV", "1.01s dual-beep busy signal", -6.0),
        "voice_ext": None,
        "rationale_en": "Standard electronic busy tone from Chokuretsu ('EVENT_23.WAV', 1.01s) is immediately recognizable.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "phone-hangup",
        "context": "Notification",
        "xdg_description": "The sound used when a phone/voip call is ended due to hangup.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): none of the 4 archives contain a clean call-disconnect click/drop tone, and using farewell voice lines ('Mata', 'Shūryō') after every voice call feels awkward.",
        "recommendation_en": "Use the default freedesktop phone-hangup tone or a soft 2-note descending 425Hz -> 300Hz sine drop (180ms).",
    },
    {
        "xdg_name": "phone-failure",
        "context": "Notification",
        "xdg_description": "The sound used when a phone/voip call is canceled due to some error.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): no distinct telephony reorder/SIT error tone exists in the archives.",
        "recommendation_en": "Allow fallback to freedesktop or use a standard 3-tone SIT (Special Information Tone) sequence.",
    },
    {
        "xdg_name": "network-connectivity-established",
        "context": "Notification",
        "xdg_description": "The sound used when network connectivity is established.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "TMINC00.WAV", "改善した。", "Kaizen shita.", "Improved / Restored.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_06.WAV", "Clean ascending 3-note chime (0.50s)", -5.5),
        "voice_ext": None,
        "rationale_en": "0.83s 'Kaizen shita' ('Restored / Improved') pairs directly with 'Sagyō teitai' on network-connectivity-lost.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "system-bootup",
        "context": "Notification",
        "xdg_description": "The sound used when the computer is being booted up.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00001.wav", "[SFX: Warm Sci-Fi Boot Chord]", "N/A", "1.39s warm stereo synthesizer chord chime", -5.0),
        "sfx_only": ("gekitou_sfx", "se_00001.wav", "1.39s warm stereo synthesizer chord chime", -5.0),
        "voice_ext": ("chokuretsu_yuki", "GO00.WAV", "開始。", "Kaishi.", "Initiating.", -3.5),
        "rationale_en": "Uses the warm 1.39s stereo synthesizer chord ('se_00001.wav') for hardware bootup so early boot sounds atmospheric and modern.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "system-ready",
        "context": "Notification",
        "xdg_description": "The sound used when the computer is booted up and shows the login screen.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "GRAB00.WAV", "指示を。", "Shiji o.", "Awaiting instructions.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_00.WAV", "Clean ascending ready chime (0.35s)", -5.5),
        "voice_ext": None,
        "rationale_en": "0.75s 'Shiji o' ('Awaiting instructions') at the display manager / login prompt fits Yuki's humanoid-interface persona.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "system-shutdown",
        "context": "Notification",
        "xdg_description": "The sound used when the computer is being shut down.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "CLR100.WAV", "終了。", "Shūryō.", "Terminating / Finished.", -3.5),
        "sfx_only": ("gekitou_sfx", "se_00003.wav", "Soft two-note descending close tone (0.46s)", -5.5),
        "voice_ext": None,
        "rationale_en": "0.72s 'Shūryō' ('Terminated') is fast enough to complete before audio services tear down on shutdown.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "search-results",
        "context": "Notification",
        "xdg_description": "The sound used when one or more search results are returned.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "DETECT07.WAV", "発見。", "Hakken.", "Found / Discovered.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_00.WAV", "Clean ascending confirmation chime (0.35s)", -5.5),
        "voice_ext": None,
        "rationale_en": "Crisp 0.63s 'Hakken' ('Found') is an exact semantic match for search-results.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "search-results-empty",
        "context": "Notification",
        "xdg_description": "The sound used when no search results are returned.",
        "status": "Mapped_Voice",
        "hybrid": ("tsuisou_yuki", "09286.wav", "ない。", "Nai.", "None / Not found.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_02.WAV", "Soft descending double-thud (0.30s)", -6.0),
        "voice_ext": ("chokuretsu_yuki", "CLTBD00.WAV", "有用な情報は得られなかった。", "Yūyō na jōhō wa erarenakatta.", "No useful information was obtained.", -3.5),
        "rationale_en": "Default uses ultra-short 0.46s 'Nai' ('None') so empty search queries respond immediately; extended voice profile offers 1.91s 'Yūyō na jōhō wa erarenakatta'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "desktop-login",
        "context": "Notification",
        "xdg_description": "The sound used when a user logs into the system.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "NEXT00.WAV", "歓迎する。", "Kangei suru.", "Welcome.", -3.5),
        "sfx_only": ("gekitou_sfx", "se_00001.wav", "Warm stereo synthesizer chord chime (1.39s)", -5.0),
        "voice_ext": ("tsuisou_yuki", "09496.wav", "おはよう。", "Ohayō.", "Good morning.", -3.5),
        "rationale_en": "0.83s 'Kangei suru' ('Welcome') is played once per session login—short, deadpan, and iconic for Yuki Nagato.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "desktop-logout",
        "context": "Notification",
        "xdg_description": "The sound used when a user logs out of the system.",
        "status": "Mapped_Voice",
        "hybrid": ("tsuisou_yuki", "09264.wav", "また。", "Mata.", "See you.", -3.5),
        "sfx_only": ("gekitou_sfx", "se_00003.wav", "Soft two-note descending close tone (0.46s)", -5.5),
        "voice_ext": None,
        "rationale_en": "0.51s 'Mata' ('See you') is brief enough not to get cut off by session logout.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "desktop-screen-lock",
        "context": "Notification",
        "xdg_description": "The sound used when the user locks their current session.",
        "status": "Mapped_Voice",
        "hybrid": ("tsuisou_yuki", "09291.wav", "待ってる。", "Matteru.", "I'll be waiting.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_01.WAV", "Crisp lock blip (0.19s)", -6.0),
        "voice_ext": None,
        "rationale_en": "0.70s 'Matteru' ('I'll be waiting') fits locking the screen when stepping away from the workstation.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "service-login",
        "context": "Notification",
        "xdg_description": "The sound used when a user logs into a service (e.g. IM/chat service).",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_00.WAV", "[SFX: Ascending Service Chime]", "N/A", "0.35s clean ascending chime", -6.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_00.WAV", "0.35s clean ascending chime", -6.0),
        "voice_ext": ("tsuisou_yuki", "09422.wav", "いた。", "Ita.", "There you are / Connected.", -3.5),
        "rationale_en": "Background services connect automatically; a 0.35s chime avoids unexpected voice playback during background reconnects.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "service-logout",
        "context": "Notification",
        "xdg_description": "The sound used when a user logs out of a service.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_01.WAV", "[SFX: Short Service Disconnect Blip]", "N/A", "0.19s subtle disconnect blip", -6.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_01.WAV", "0.19s subtle disconnect blip", -6.0),
        "voice_ext": None,
        "rationale_en": "Short 0.19s subtle blip avoids voice spam when background services disconnect.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "battery-caution",
        "context": "Notification",
        "xdg_description": "The sound used when the battery is nearing exhaustion (below 40%, for example).",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "START04.WAV", "警戒。", "Keikai.", "Caution.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "EVENT_04.WAV", "Clean double-beep caution tone (0.30s)", -5.5),
        "voice_ext": None,
        "rationale_en": "0.47s single-word 'Keikai' ('Caution') is under half a second and clearly distinguishes 40% battery caution from 20% battery low.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "battery-full",
        "context": "Notification",
        "xdg_description": "The sound used when the battery is fully loaded up.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): no voice clip specifically refers to charging/power completion, and reusing generic 'Kanryō' would confuse users into thinking a download finished while their laptop is plugged in.",
        "recommendation_en": "Keep unmapped or use a soft 2-note warm chime (or a custom TTS clip saying 'Jūden kanryō').",
    },
    {
        "xdg_name": "dialog-warning",
        "context": "Notification",
        "xdg_description": "The sound used when a dialog is opened to give warning/pertinent information.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "MENUOK00.WAV", "許可を。", "Kyoka o.", "Requesting permission.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "EVENT_04.WAV", "Clean double-beep warning tone (0.30s)", -5.5),
        "voice_ext": None,
        "rationale_en": "0.49s 'Kyoka o' ('Requesting permission') is ideal for privilege escalation / confirmation warning dialogs.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "dialog-information",
        "context": "Notification",
        "xdg_description": "The sound used when a dialog is opened to give information to the user.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_03.WAV", "[SFX: Soft Info Ping]", "N/A", "0.28s soft digital info ping", -6.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_03.WAV", "0.28s soft digital info ping", -6.0),
        "voice_ext": ("chokuretsu_yuki", "DETECT06.WAV", "これ。", "Kore.", "This.", -3.5),
        "rationale_en": "Info dialogs pop up frequently; 0.28s ping keeps the UI snappy (0.34s 'Kore' in the voice profile).",
        "recommendation_en": "",
    },
    {
        "xdg_name": "dialog-question",
        "context": "Notification",
        "xdg_description": "The sound used when a dialog is opened to ask the user a question.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "EPR_19.WAV", "何？", "Nani?", "What?", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_00.WAV", "0.35s ascending query chime", -6.0),
        "voice_ext": None,
        "rationale_en": "0.44s quiet 'Nani?' ('What?') is ultra-short and fits prompt/question dialogs naturally.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "software-update-available",
        "context": "Notification",
        "xdg_description": "The sound used when an update is available for software installed on the device.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "OPT00.WAV", "設定変更。", "Settei henkō.", "Configuration update.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_06.WAV", "Ascending 3-note chime (0.50s)", -5.5),
        "voice_ext": None,
        "rationale_en": "1.30s 'Settei henkō' fits infrequent package/system update notifications.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "device-added",
        "context": "Notification",
        "xdg_description": "The sound used when a device has become available to the desktop (e.g. USB plug).",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "CHESS_06.WAV", "[SFX: Ascending 3-Note Hardware Plug Chime]", "N/A", "0.50s clean ascending 3-note chime", -5.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_06.WAV", "0.50s clean ascending 3-note chime", -5.5),
        "voice_ext": ("chokuretsu_yuki", "DETECT05.WAV", "端末を発見。", "Tanmatsu o hakken.", "Terminal / Device discovered.", -3.5),
        "rationale_en": "Default uses a crisp 0.50s ascending 3-note chime for instant USB plug feedback; voice profile uses Yuki's literal 'Tanmatsu o hakken' ('Device discovered', 1.29s)!",
        "recommendation_en": "",
    },
    {
        "xdg_name": "device-removed",
        "context": "Notification",
        "xdg_description": "The sound used when a device has become unavailable to the desktop (e.g. USB unplug).",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00003.wav", "[SFX: Descending 2-Note Hardware Unplug Chime]", "N/A", "0.46s descending 2-note chime", -5.5),
        "sfx_only": ("gekitou_sfx", "se_00003.wav", "0.46s descending 2-note chime", -5.5),
        "voice_ext": None,
        "rationale_en": "0.46s descending 2-note tone ('se_00003.wav') complements the ascending 'device-added' chime.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "window-new",
        "context": "Notification",
        "xdg_description": "The sound used when a new window or dialog is opened.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_06.WAV", "[SFX: 70ms Subtle Window Pop]", "N/A", "0.07s ultra-subtle airy pop", -8.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_06.WAV", "0.07s ultra-subtle airy pop", -8.0),
        "voice_ext": None,
        "rationale_en": "70ms micro-pop at -8 dBFS is barely perceptible and never intrusive when opening windows.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "power-plug",
        "context": "Notification",
        "xdg_description": "The power cable has been plugged in.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_00.WAV", "[SFX: Clean Ascending Power Chime]", "N/A", "0.35s ascending power-connected chime", -5.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_00.WAV", "0.35s ascending power-connected chime", -5.5),
        "voice_ext": ("tsuisou_yuki", "09030.wav", "いい。", "Ii.", "Good.", -3.5),
        "rationale_en": "0.35s ascending chime gives immediate AC adapter connection feedback.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "power-unplug",
        "context": "Notification",
        "xdg_description": "The power cable has been unplugged.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): distinct from 'power-unplug-battery-low' and 'device-removed'; no separate dedicated AC-unplug tone in the archives without duplicating 'device-removed'.",
        "recommendation_en": "Allow fallback to freedesktop's power-unplug or link to a subtle 200ms low-pass descending two-tone.",
    },
    {
        "xdg_name": "suspend-start",
        "context": "Notification",
        "xdg_description": "The machine is about to suspend.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "LEAVE00.WAV", "待機状態を継続。", "Taiki jōtai o keizoku.", "Maintaining standby state.", -3.5),
        "sfx_only": ("gekitou_sfx", "se_00007.wav", "Soft airy slide-out whoosh (0.32s)", -6.0),
        "voice_ext": None,
        "rationale_en": "Literal canonical match: 'Taiki jōtai o keizoku' ('Entering/maintaining standby state', 1.59s).",
        "recommendation_en": "",
    },
    {
        "xdg_name": "suspend-resume",
        "context": "Notification",
        "xdg_description": "The machine has returned from suspended state.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "LOAD00.WAV", "ここから。", "Koko kara.", "Resuming from here.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_00.WAV", "Clean ascending wake chime (0.35s)", -5.5),
        "voice_ext": None,
        "rationale_en": "0.61s 'Koko kara' ('From here') is used in Chokuretsu when resuming a saved state—fits wake-from-suspend.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "lid-open",
        "context": "Notification",
        "xdg_description": "The lid has been opened (for laptops, mobile devices).",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped: playing a separate sound on lid-open collides with 'suspend-resume' when waking a laptop.",
        "recommendation_en": "Keep unmapped so 'suspend-resume' plays cleanly without overlapping audio.",
    },
    {
        "xdg_name": "lid-close",
        "context": "Notification",
        "xdg_description": "The lid has been closed (for laptops, mobile devices).",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped: playing a separate sound on lid-close collides with 'suspend-start' or 'desktop-screen-lock'.",
        "recommendation_en": "Keep unmapped so 'suspend-start' / 'desktop-screen-lock' plays cleanly.",
    },
    {
        "xdg_name": "alarm-clock-elapsed",
        "context": "Notification",
        "xdg_description": "A user configured alarm elapsed.",
        "status": "Mapped_Voice",
        "hybrid": ("tsuisou_yuki", "09024.wav", "呼んでる。行って。", "Yonderu. Itte.", "You're being called. Go.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "EVENT_21.WAV", "Electronic alarm trill (0.61s)", -5.0),
        "voice_ext": None,
        "rationale_en": "1.76s 'Yonderu. Itte.' ('You're being called. Go.') is a natural, calm Yuki Nagato timer/alarm reminder.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "window-attention-active",
        "context": "Notification",
        "xdg_description": "An active/visible window demands attention.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "EVENT_03.WAV", "[SFX: Bright Attention Bell Ding]", "N/A", "0.22s bright single bell ding", -5.5),
        "sfx_only": ("chokuretsu_sfx", "EVENT_03.WAV", "0.22s bright single bell ding", -5.5),
        "voice_ext": ("tsuisou_yuki", "09294.wav", "これ。", "Kore.", "This.", -3.5),
        "rationale_en": "0.22s crisp bell ding draws immediate attention without interrupting workflow.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "window-attention-inactive",
        "context": "Notification",
        "xdg_description": "An inactive/invisible window demands attention.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_0A.WAV", "[SFX: Soft Background Attention Pulse]", "N/A", "0.20s soft muted attention pulse", -6.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_0A.WAV", "0.20s soft muted attention pulse", -6.5),
        "voice_ext": ("chokuretsu_yuki", "FOUND02.WAV", "ここ。", "Koko.", "Here.", -3.5),
        "rationale_en": "0.20s softer pulse indicates background urgency on an inactive workspace/window.",
        "recommendation_en": "",
    },

    # ==================== 4.3 ACTIONS (28 standard events) ====================
    {
        "xdg_name": "phone-outgoing-calling",
        "context": "Action",
        "xdg_description": "The sound used when a phone/voip call is dialed out.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "SLG_01.WAV", "[SFX: Outgoing Ringback Pulse]", "N/A", "0.41s outgoing ringback pulse", -6.0),
        "sfx_only": ("chokuretsu_sfx", "SLG_01.WAV", "0.41s outgoing ringback pulse", -6.0),
        "voice_ext": None,
        "rationale_en": "0.41s clean tone provides subtle dialing feedback.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "message-sent-instant",
        "context": "Action",
        "xdg_description": "The sound used when a new IM is sent.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_04.WAV", "[SFX: Soft Outgoing Message Blip]", "N/A", "0.16s soft upward blip", -7.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_04.WAV", "0.16s soft upward blip", -7.0),
        "voice_ext": None,
        "rationale_en": "161ms ultra-light upward blip confirms sent chat messages without clutter.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "message-sent-email",
        "context": "Action",
        "xdg_description": "The sound used when a new email is sent.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00005.wav", "[SFX: Clean Double-Blip Send Confirmation]", "N/A", "0.29s double-blip confirmation", -6.0),
        "sfx_only": ("gekitou_sfx", "se_00005.wav", "0.29s double-blip confirmation", -6.0),
        "voice_ext": ("chokuretsu_yuki", "ACPTM00.WAV", "了解。", "Ryōkai.", "Understood / Roger.", -3.5),
        "rationale_en": "0.29s clean double-blip confirms outgoing email transmission.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "bell-terminal",
        "context": "Action",
        "xdg_description": "The sound to use as a terminal bell.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00033.wav", "[SFX: 114ms Crisp Terminal Sonar Ping]", "N/A", "0.114s crisp high-tech terminal ping", -6.5),
        "sfx_only": ("gekitou_sfx", "se_00033.wav", "0.114s crisp high-tech terminal ping", -6.5),
        "voice_ext": ("tsuisou_yuki", "09755.wav", "あっ。", "A.", "Ah.", -4.5),
        "rationale_en": "Terminal bells fire rapidly on Tab-completion or backspace in a shell; a 114ms sonar ping ('se_00033.wav') is snappy and modern.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "bell-window-system",
        "context": "Action",
        "xdg_description": "The sound to use as a generic bell for X11 or Wayland window systems.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "EVENT_25.WAV", "[SFX: 118ms Soft System Bell]", "N/A", "0.118s soft harmonic system bell", -6.5),
        "sfx_only": ("chokuretsu_sfx", "EVENT_25.WAV", "0.118s soft harmonic system bell", -6.5),
        "voice_ext": ("tsuisou_yuki", "09106.wav", "ん。", "N.", "Mm.", -4.5),
        "rationale_en": "118ms soft bell prevents audio overlap on rapid compositor bell events.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "trash-empty",
        "context": "Action",
        "xdg_description": "The sound used when the user empties the trash.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "BLK00.WAV", "消滅を確認。", "Shōmetsu o kakunin.", "Erasure / Disappearance confirmed.", -3.5),
        "sfx_only": ("gekitou_sfx", "se_00007.wav", "0.32s clean sweep-out whoosh", -5.5),
        "voice_ext": None,
        "rationale_en": "Iconic Yuki Nagato line: 'Shōmetsu o kakunin' ('Erasure confirmed', 1.33s) when emptying the trash.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "item-deleted",
        "context": "Action",
        "xdg_description": "The sound used when an item is deleted.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "DETECT02.WAV", "消去する。", "Shōkyo suru.", "Erasing / Deleting.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "SLG_05.WAV", "0.155s crisp deletion swipe", -6.0),
        "voice_ext": None,
        "rationale_en": "0.67s 'Shōkyo suru' ('Deleting') is direct, short, and fits permanent item deletion.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "file-trash",
        "context": "Action",
        "xdg_description": "The sound used when a file or folder is sent to the trash.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "SLG_05.WAV", "[SFX: 155ms Clean Trash Swipe]", "N/A", "0.155s light swipe-to-trash sound", -6.0),
        "sfx_only": ("chokuretsu_sfx", "SLG_05.WAV", "0.155s light swipe-to-trash sound", -6.0),
        "voice_ext": ("chokuretsu_yuki", "DETECT02.WAV", "消去する。", "Shōkyo suru.", "Erasing / Deleting.", -3.5),
        "rationale_en": "Moving individual files to trash happens often, so default uses a 155ms swipe SFX while reserving 'Shōmetsu o kakunin' for emptying the trash.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "camera-shutter",
        "context": "Action",
        "xdg_description": "A photo has been shot.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "EVENT_59.WAV", "[SFX: Mechanical Camera Shutter]", "N/A", "0.376s authentic camera shutter click", -5.0),
        "sfx_only": ("chokuretsu_sfx", "EVENT_59.WAV", "0.376s authentic camera shutter click", -5.0),
        "voice_ext": None,
        "rationale_en": "Chokuretsu's 'EVENT_59.WAV' (0.376s) is an actual camera shutter click sound effect.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "camera-focus",
        "context": "Action",
        "xdg_description": "A camera has the focus.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "EVENT_15.WAV", "[SFX: 120ms Camera Focus Double-Beep]", "N/A", "0.120s crisp autofocus lock beep", -6.0),
        "sfx_only": ("chokuretsu_sfx", "EVENT_15.WAV", "0.120s crisp autofocus lock beep", -6.0),
        "voice_ext": ("tsuisou_yuki", "09318.wav", "目線。", "Mesen.", "Line of sight / Gaze.", -3.5),
        "rationale_en": "120ms focus lock beep ('EVENT_15.WAV'); voice profile includes Yuki's 0.65s 'Mesen' ('Gaze / Look here').",
        "recommendation_en": "",
    },
    {
        "xdg_name": "screen-capture",
        "context": "Action",
        "xdg_description": "A screenshot was made.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00008.wav", "[SFX: 334ms Crisp Capture Click]", "N/A", "0.334s crisp metallic capture latch", -5.5),
        "sfx_only": ("gekitou_sfx", "se_00008.wav", "0.334s crisp metallic capture latch", -5.5),
        "voice_ext": ("chokuretsu_yuki", "SAVE00.WAV", "セーブ。", "Sēbu.", "Save.", -3.5),
        "rationale_en": "0.334s metallic latch click gives instant feedback for grim/slurp/spectacle screenshots (voice profile uses 0.59s 'Sēbu').",
        "recommendation_en": "",
    },
    {
        "xdg_name": "count-down",
        "context": "Action",
        "xdg_description": "A countdown (e.g. for a photo shooting) sound that is repeated each second.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): Gekitou's countdown clips ('se_00063..00067.wav') are loud Haruhi/Mikuru shouts, and Yuki only has 'Hitotsu' ('One') and 'Zero' ('09040.wav') rather than a neutral 1Hz metronome beep.",
        "recommendation_en": "Inherit freedesktop's count-down tick or use a 50ms 1000Hz sine blip.",
    },
    {
        "xdg_name": "completion-sucess",
        "context": "Action",
        "xdg_description": "A text completion was attempted and was successful (Note: 'completion-sucess' spelling per XDG spec).",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_09.WAV", "[SFX: 73ms Micro Completion Tick]", "N/A", "0.073s subtle positive micro-tick", -7.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_09.WAV", "0.073s subtle positive micro-tick", -7.5),
        "voice_ext": None,
        "rationale_en": "73ms subtle micro-tick provides non-intrusive autocomplete feedback.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "completion-fail",
        "context": "Action",
        "xdg_description": "A text completion was attempted and was not successful.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_0B.WAV", "[SFX: 105ms Muted Fail Tap]", "N/A", "0.105s muted low tap", -7.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_0B.WAV", "0.105s muted low tap", -7.0),
        "voice_ext": ("chokuretsu_yuki", "NGTWIT00.WAV", "だめ。", "Dame.", "No.", -4.0),
        "rationale_en": "105ms muted tap avoids annoyance on repeated Tab-completion misses (voice profile uses 0.33s 'Dame').",
        "recommendation_en": "",
    },
    {
        "xdg_name": "completion-partial",
        "context": "Action",
        "xdg_description": "A text completion was attempted and was partially successful.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_11.WAV", "[SFX: 50ms Soft Partial Tick]", "N/A", "0.050s soft micro-tick", -8.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_11.WAV", "0.050s soft micro-tick", -8.0),
        "voice_ext": None,
        "rationale_en": "50ms soft micro-tick indicates partial token expansion.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "completion-rotation",
        "context": "Action",
        "xdg_description": "A text completion wrapped around to the beginning of the list.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_12.WAV", "[SFX: 49ms Wraparound Micro-Tick]", "N/A", "0.049s wraparound micro-tick", -8.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_12.WAV", "0.049s wraparound micro-tick", -8.0),
        "voice_ext": None,
        "rationale_en": "49ms micro-tick keeps list cycling responsive.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "audio-volume-change",
        "context": "Action",
        "xdg_description": "The test sound used to make volume changes noticeable when using a volume slider.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00002.wav", "[SFX: 148ms Crisp Volume Pop]", "N/A", "0.148s crisp, clean stereo UI pop", -5.5),
        "sfx_only": ("gekitou_sfx", "se_00002.wav", "0.148s crisp, clean stereo UI pop", -5.5),
        "voice_ext": None,
        "rationale_en": "Volume keys/sliders fire rapidly; 148ms 'se_00002.wav' is the ideal length and timbre for instant volume feedback.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "audio-test-signal",
        "context": "Action",
        "xdg_description": "The test sound for testing audio.",
        "status": "Mapped_Voice",
        "hybrid": ("chokuretsu_yuki", "SOUND00.WAV", "音楽鑑賞。", "Ongaku kanshō.", "Music appreciation / Audio check.", -3.5),
        "sfx_only": ("gekitou_sfx", "se_00001.wav", "1.39s stereo synthesizer test chord", -5.0),
        "voice_ext": None,
        "rationale_en": "1.09s 'Ongaku kanshō' ('Music appreciation') from Chokuretsu's sound test menu is an authentic character audio test signal.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "audio-channel-left",
        "context": "Action",
        "xdg_description": "The test sound for identifying the left speaker (mono file saying 'left').",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): no voice line saying 'Left' ('Hidari') exists in the archives.",
        "recommendation_en": "Inherit from freedesktop or record/synthesize a mono deadpan voice saying 'Hidari' / 'Left'.",
    },
    {
        "xdg_name": "audio-channel-right",
        "context": "Action",
        "xdg_description": "The test sound for identifying the right speaker (mono file saying 'right').",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): no voice line saying 'Right' ('Migi') exists in the archives.",
        "recommendation_en": "Inherit from freedesktop or record/synthesize a mono deadpan voice saying 'Migi' / 'Right'.",
    },
    {
        "xdg_name": "audio-channel-front-left",
        "context": "Action",
        "xdg_description": "The test sound for identifying the front-left speaker.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): requires explicit 'front left' spoken channel identification.",
        "recommendation_en": "Inherit from freedesktop speaker-test voices.",
    },
    {
        "xdg_name": "audio-channel-front-right",
        "context": "Action",
        "xdg_description": "The test sound for identifying the front-right speaker.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): requires explicit 'front right' spoken channel identification.",
        "recommendation_en": "Inherit from freedesktop speaker-test voices.",
    },
    {
        "xdg_name": "audio-channel-front-center",
        "context": "Action",
        "xdg_description": "The test sound for identifying the front-center speaker.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): requires explicit 'front center' spoken channel identification.",
        "recommendation_en": "Inherit from freedesktop speaker-test voices.",
    },
    {
        "xdg_name": "audio-channel-rear-left",
        "context": "Action",
        "xdg_description": "The test sound for identifying the rear-left speaker.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): requires explicit 'rear left' spoken channel identification.",
        "recommendation_en": "Inherit from freedesktop speaker-test voices.",
    },
    {
        "xdg_name": "audio-channel-rear-right",
        "context": "Action",
        "xdg_description": "The test sound for identifying the rear-right speaker.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): requires explicit 'rear right' spoken channel identification.",
        "recommendation_en": "Inherit from freedesktop speaker-test voices.",
    },
    {
        "xdg_name": "audio-channel-rear-center",
        "context": "Action",
        "xdg_description": "The test sound for identifying the rear-center speaker.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): requires explicit 'rear center' spoken channel identification.",
        "recommendation_en": "Inherit from freedesktop speaker-test voices.",
    },
    {
        "xdg_name": "audio-channel-lfe",
        "context": "Action",
        "xdg_description": "The test sound for identifying the LFE/subwoofer speaker.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): requires a low-frequency 40-80Hz bass test sweep or 'subwoofer' voice callout.",
        "recommendation_en": "Inherit from freedesktop or use a 60Hz low-pass sine pulse.",
    },
    {
        "xdg_name": "audio-channel-side-left",
        "context": "Action",
        "xdg_description": "The test sound for identifying the side-left speaker.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): requires explicit 'side left' spoken channel identification.",
        "recommendation_en": "Inherit from freedesktop speaker-test voices.",
    },
    {
        "xdg_name": "audio-channel-side-right",
        "context": "Action",
        "xdg_description": "The test sound for identifying the side-right speaker.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): requires explicit 'side right' spoken channel identification.",
        "recommendation_en": "Inherit from freedesktop speaker-test voices.",
    },

    # ==================== 4.4 INPUT FEEDBACK (44 standard events) ====================
    {
        "xdg_name": "dialog-ok",
        "context": "Support",
        "xdg_description": "The sound used when a window is closed by clicking the OK button.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00005.wav", "[SFX: Clean Double-Blip OK Confirmation]", "N/A", "0.291s clean confirmation double-blip", -6.0),
        "sfx_only": ("gekitou_sfx", "se_00005.wav", "0.291s clean confirmation double-blip", -6.0),
        "voice_ext": ("chokuretsu_yuki", "ACPT00.WAV", "分かった。", "Wakatta.", "Understood.", -3.5),
        "rationale_en": "Default uses 0.291s confirmation blip ('se_00005.wav'); voice profile uses Yuki's 0.62s 'Wakatta'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "dialog-cancel",
        "context": "Support",
        "xdg_description": "The sound used when a window is closed by clicking the Cancel button.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00006.wav", "[SFX: Subtle Cancel Thud]", "N/A", "0.339s soft low-pitched cancel tone", -6.0),
        "sfx_only": ("gekitou_sfx", "se_00006.wav", "0.339s soft low-pitched cancel tone", -6.0),
        "voice_ext": ("chokuretsu_yuki", "BACK00.WAV", "待った。", "Matta.", "Wait / Cancel.", -3.5),
        "rationale_en": "Default uses 0.339s cancel tone ('se_00006.wav'); voice profile uses Yuki's 0.45s 'Matta'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "window-close",
        "context": "Support",
        "xdg_description": "The sound used when an existing window is closed.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_01.WAV", "[SFX: 190ms Clean Window Close Blip]", "N/A", "0.190s soft descending close blip", -7.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_01.WAV", "0.190s soft descending close blip", -7.0),
        "voice_ext": None,
        "rationale_en": "190ms soft close blip complements the 70ms 'window-new' pop.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "window-slide-in",
        "context": "Support",
        "xdg_description": "The sound used when a window is slid in (e.g. panel/drawer).",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "SLG_09.WAV", "[SFX: 143ms Light Slide-In Whoosh]", "N/A", "0.143s light airy slide-in", -7.5),
        "sfx_only": ("chokuretsu_sfx", "SLG_09.WAV", "0.143s light airy slide-in", -7.5),
        "voice_ext": None,
        "rationale_en": "143ms subtle slide sound fits scratchpad/drawer slide-in animations.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "window-slide-out",
        "context": "Support",
        "xdg_description": "The sound used when a window is slid out.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "SLG_0A.WAV", "[SFX: 159ms Light Slide-Out Whoosh]", "N/A", "0.159s light airy slide-out", -7.5),
        "sfx_only": ("chokuretsu_sfx", "SLG_0A.WAV", "0.159s light airy slide-out", -7.5),
        "voice_ext": None,
        "rationale_en": "159ms subtle slide-out sound pairs with 'window-slide-in'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "window-minimized",
        "context": "Support",
        "xdg_description": "The sound used when an existing window is minimized.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "SLG_1B.WAV", "[SFX: 145ms Soft Minimize Drop]", "N/A", "0.145s soft downward blip", -7.5),
        "sfx_only": ("chokuretsu_sfx", "SLG_1B.WAV", "0.145s soft downward blip", -7.5),
        "voice_ext": None,
        "rationale_en": "145ms downward blip gives gentle minimize feedback.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "window-unminimized",
        "context": "Support",
        "xdg_description": "The sound used when an existing window is unminimized.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "SLG_1A.WAV", "[SFX: 205ms Soft Unminimize Rise]", "N/A", "0.205s soft upward blip", -7.5),
        "sfx_only": ("chokuretsu_sfx", "SLG_1A.WAV", "0.205s soft upward blip", -7.5),
        "voice_ext": None,
        "rationale_en": "205ms upward blip pairs with 'window-minimized'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "notebook-tab-changed",
        "context": "Support",
        "xdg_description": "The sound used when a notebook tab is changed.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "CHESS_03.WAV", "[SFX: 33ms Ultra-Crisp Tab Tick]", "N/A", "0.033s micro-tick", -8.0),
        "sfx_only": ("chokuretsu_sfx", "CHESS_03.WAV", "0.033s micro-tick", -8.0),
        "voice_ext": None,
        "rationale_en": "33ms micro-tick ('CHESS_03.WAV') feels tactile without any lag.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "drag-start",
        "context": "Support",
        "xdg_description": "The sound used when drag of a file/item is started.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "CHESS_04.WAV", "[SFX: 231ms Tactile Pickup Tap]", "N/A", "0.231s tactile piece-pickup tap", -7.0),
        "sfx_only": ("chokuretsu_sfx", "CHESS_04.WAV", "0.231s tactile piece-pickup tap", -7.0),
        "voice_ext": None,
        "rationale_en": "Uses Chokuretsu's chess-piece pickup sound ('CHESS_04.WAV', 0.231s) for drag-start.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "drag-accept",
        "context": "Support",
        "xdg_description": "The sound used when a file/item drag is accepted by a window.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "CHESS_05.WAV", "[SFX: 180ms Tactile Drop Click]", "N/A", "0.180s tactile piece-placement click", -6.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_05.WAV", "0.180s tactile piece-placement click", -6.5),
        "voice_ext": None,
        "rationale_en": "Uses Chokuretsu's chess-piece placement sound ('CHESS_05.WAV', 0.180s) for drag-accept.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "drag-fail",
        "context": "Support",
        "xdg_description": "The sound used when a file/item drag is not accepted by a window.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00006.wav", "[SFX: 339ms Soft Reject Thud]", "N/A", "0.339s soft reject thud", -6.5),
        "sfx_only": ("gekitou_sfx", "se_00006.wav", "0.339s soft reject thud", -6.5),
        "voice_ext": ("chokuretsu_yuki", "NGTWIT00.WAV", "だめ。", "Dame.", "No.", -4.0),
        "rationale_en": "0.339s reject thud (or 0.33s 'Dame' in the voice profile) signals an invalid drop target.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "link-pressed",
        "context": "Support",
        "xdg_description": "The sound used when a link in a web or help browser is pressed.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_13.WAV", "[SFX: 50ms Soft Link Press Tick]", "N/A", "0.050s soft link press tick", -8.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_13.WAV", "0.050s soft link press tick", -8.0),
        "voice_ext": None,
        "rationale_en": "50ms micro-tick keeps link clicking clean.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "link-released",
        "context": "Support",
        "xdg_description": "The sound used when a link in a web or help browser is released.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_14.WAV", "[SFX: 50ms Soft Link Release Tick]", "N/A", "0.050s soft link release tick", -8.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_14.WAV", "0.050s soft link release tick", -8.5),
        "voice_ext": None,
        "rationale_en": "50ms micro-tick pairs with 'link-pressed'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "button-pressed",
        "context": "Support",
        "xdg_description": "The sound used when a button is pressed.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00004.wav", "[SFX: 120ms Soft UI Button Tap]", "N/A", "0.120s soft UI button tap", -7.5),
        "sfx_only": ("gekitou_sfx", "se_00004.wav", "0.120s soft UI button tap", -7.5),
        "voice_ext": None,
        "rationale_en": "120ms soft tap ('se_00004.wav') is crisp and unobtrusive.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "button-released",
        "context": "Support",
        "xdg_description": "The sound used when a button is released.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "CHESS_03.WAV", "[SFX: 33ms Micro Release Tick]", "N/A", "0.033s micro release tick", -8.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_03.WAV", "0.033s micro release tick", -8.5),
        "voice_ext": None,
        "rationale_en": "33ms micro-tick avoids double-clatter after 'button-pressed'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "menu-click",
        "context": "Support",
        "xdg_description": "The sound used when a menu item is clicked.",
        "status": "Mapped_SFX",
        "hybrid": ("gekitou_sfx", "se_00002.wav", "[SFX: 148ms Crisp Menu Click]", "N/A", "0.148s crisp stereo menu click", -6.5),
        "sfx_only": ("gekitou_sfx", "se_00002.wav", "0.148s crisp stereo menu click", -6.5),
        "voice_ext": None,
        "rationale_en": "148ms stereo menu click ('se_00002.wav') is an authentic visual-novel menu selection sound.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "button-toggle-on",
        "context": "Support",
        "xdg_description": "The sound used when a toggle/check/radio button is activated.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_05.WAV", "[SFX: 164ms Toggle-On Blip]", "N/A", "0.164s bright toggle-on blip", -7.0),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_05.WAV", "0.164s bright toggle-on blip", -7.0),
        "voice_ext": ("tsuisou_yuki", "09034.wav", "うん。", "Un.", "Yeah / On.", -4.0),
        "rationale_en": "164ms upward blip (or 0.37s 'Un' in the voice profile) confirms toggle activation.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "button-toggle-off",
        "context": "Support",
        "xdg_description": "The sound used when a toggle/check/radio button is deactivated.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_04.WAV", "[SFX: 161ms Toggle-Off Blip]", "N/A", "0.161s muted toggle-off blip", -7.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_04.WAV", "0.161s muted toggle-off blip", -7.5),
        "voice_ext": None,
        "rationale_en": "161ms softer blip complements 'button-toggle-on'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "menu-popup",
        "context": "Support",
        "xdg_description": "The sound used when a menu is popped up.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_0F.WAV", "[SFX: 50ms Subtle Menu Popup Tick]", "N/A", "0.050s subtle popup tick", -8.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_0F.WAV", "0.050s subtle popup tick", -8.5),
        "voice_ext": None,
        "rationale_en": "50ms micro-tick at -8.5 dBFS keeps context menu opening responsive.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "menu-popdown",
        "context": "Support",
        "xdg_description": "The sound used when a menu is popped down.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "SLG_08.WAV", "[SFX: 47ms Subtle Menu Popdown Tick]", "N/A", "0.047s subtle popdown tick", -8.5),
        "sfx_only": ("chokuretsu_sfx", "SLG_08.WAV", "0.047s subtle popdown tick", -8.5),
        "voice_ext": None,
        "rationale_en": "47ms micro-tick pairs with 'menu-popup'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "item-selected",
        "context": "Support",
        "xdg_description": "The sound used when an item is selected.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "ONMEM_06.WAV", "[SFX: 70ms Item Selection Blip]", "N/A", "0.070s light selection blip", -7.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_06.WAV", "0.070s light selection blip", -7.5),
        "voice_ext": None,
        "rationale_en": "70ms light selection blip avoids audio clutter when arrowing through lists.",
        "recommendation_en": "",
    },
    # Unmapped high-frequency window/scroll/hover micro-events (23 events)
    *[
        {
            "xdg_name": ev_name,
            "context": "Support",
            "xdg_description": ev_desc,
            "status": "Unmapped_Fallback",
            "hybrid": None,
            "sfx_only": None,
            "voice_ext": None,
            "rationale_en": "Intentionally left unmapped (and silent in upstream freedesktop): high-frequency continuous window manager, scrolling, or hover event where playing audio causes severe listener fatigue.",
            "recommendation_en": "Keep unmapped/silent in modern desktop environments (especially tiling Wayland compositors like Hyprland).",
        }
        for ev_name, ev_desc in [
            ("window-maximized", "The sound used when an existing window is maximized."),
            ("window-unmaximized", "The sound used when an existing window is unmaximized."),
            ("window-inactive-click", "The sound used when the user clicks on an inactive window."),
            ("window-move-start", "A window move started."),
            ("window-move-end", "A window move ended."),
            ("window-resize-start", "A window resize started."),
            ("window-resize-end", "A window resize ended."),
            ("desktop-switch-left", "The sound used when the window manager switches to a desktop to the left."),
            ("desktop-switch-right", "The sound used when the window manager switches to a desktop to the right."),
            ("window-switch", "The sound used when the window manager switches to another window."),
            ("scroll-up", "Some window was scrolled up."),
            ("scroll-down", "Some window was scrolled down."),
            ("scroll-left", "Some window was scrolled left."),
            ("scroll-right", "Some window was scrolled right."),
            ("scroll-up-end", "Some window was scrolled up and reached the end of the scrollbar."),
            ("scroll-down-end", "Some window was scrolled down and reached the end of the scrollbar."),
            ("scroll-left-end", "Some window was scrolled left and reached the end of the scrollbar."),
            ("scroll-right-end", "Some window was scrolled right and reached the end of the scrollbar."),
            ("expander-toggle-on", "The sound used when an expander is activated."),
            ("expander-toggle-off", "The sound used when an expander is deactivated."),
            ("menu-replace", "The sound used when replacing an active menu with another menu."),
            ("tooltip-popup", "The sound used when a tooltip is popped up."),
            ("tooltip-popdown", "The sound used when a tooltip is popped down."),
        ]
    ],

    # ==================== 4.5 GAME (5 standard events) ====================
    {
        "xdg_name": "game-over-winner",
        "context": "Game",
        "xdg_description": "Sound played when the user wins a game.",
        "status": "Mapped_Voice",
        "hybrid": ("tsuisou_yuki", "09564.wav", "おめでとう。", "Omedetō.", "Congratulations.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "ONMEM_15.WAV", "Sparkling victory chime (0.79s)", -5.0),
        "voice_ext": None,
        "rationale_en": "Yuki's calm 0.93s 'Omedetō' ('Congratulations') from Tsuisou is a natural, understated win cue.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "game-over-loser",
        "context": "Game",
        "xdg_description": "Sound played when the user loses a game.",
        "status": "Mapped_Voice",
        "hybrid": ("tsuisou_yuki", "09133.wav", "残念。", "Zannen.", "Too bad / Unfortunate.", -3.5),
        "sfx_only": ("chokuretsu_sfx", "CHESS_02.WAV", "Low two-note loss tone (0.79s)", -5.5),
        "voice_ext": None,
        "rationale_en": "Yuki's deadpan 0.70s 'Zannen' ('Unfortunate') from Tsuisou pairs directly with 'Omedetō'.",
        "recommendation_en": "",
    },
    {
        "xdg_name": "game-human-move",
        "context": "Game",
        "xdg_description": "When the user makes a move in a game.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "CHESS_00.WAV", "[SFX: 280ms Chess Piece Move Click]", "N/A", "0.280s tactile board piece placement", -6.0),
        "sfx_only": ("chokuretsu_sfx", "CHESS_00.WAV", "0.280s tactile board piece placement", -6.0),
        "voice_ext": None,
        "rationale_en": "Chokuretsu's actual chess move sound ('CHESS_00.WAV', 0.280s).",
        "recommendation_en": "",
    },
    {
        "xdg_name": "game-computer-move",
        "context": "Game",
        "xdg_description": "When the computer makes a move in a game.",
        "status": "Mapped_SFX",
        "hybrid": ("chokuretsu_sfx", "CHESS_05.WAV", "[SFX: 180ms AI Piece Move Click]", "N/A", "0.180s lighter tactile piece placement", -6.0),
        "sfx_only": ("chokuretsu_sfx", "CHESS_05.WAV", "0.180s lighter tactile piece placement", -6.0),
        "voice_ext": ("tsuisou_yuki", "09300.wav", "ふふ…", "Fufu...", "Heh... (quiet chuckle)", -4.0),
        "rationale_en": "Chokuretsu's 'CHESS_05.WAV' (0.180s) distinguishes AI moves from player moves (voice profile uses Yuki's 0.56s quiet 'Fufu...').",
        "recommendation_en": "",
    },
    {
        "xdg_name": "game-card-shuffle",
        "context": "Game",
        "xdg_description": "In card games, when the cards are shuffled.",
        "status": "Unmapped_Fallback",
        "hybrid": None,
        "sfx_only": None,
        "voice_ext": None,
        "rationale_en": "Left unmapped (inherits from freedesktop): no authentic card-riffle / deck-shuffle Foley exists in the 4 archives.",
        "recommendation_en": "Allow fallback to freedesktop or use a 400ms multi-transient paper-riffle Foley recording.",
    },
]

# Catalog of notable rejected/unsuitable assets to document for the user
REJECTED_ASSETS_CATALOG: List[Dict[str, str]] = [
    {
        "source_archive": "PC _ Computer - Suzumiya Haruhi no Gekitou - Miscellaneous - Sound Effects.zip",
        "file_pattern": "SE/se_00062.wav .. SE/se_00080.wav (19 files)",
        "content_summary": "Loud announcer & menu callouts by Haruhi Suzumiya and Mikuru Asahina ('Ready! 3, 2, 1, Fight!', 'Finish!', 'Mission Failed!', 'Watashi mo issho ni asobu!')",
        "rejection_reason_en": "Wrong character voices (Haruhi & Mikuru instead of Yuki Nagato) and overly loud arcade energy that feels tacky ('norak') on a desktop OS.",
    },
    {
        "source_archive": "PC _ Computer - Suzumiya Haruhi no Gekitou - Miscellaneous - Sound Effects.zip",
        "file_pattern": "SE/se_00009.wav .. SE/se_00061.wav (excluding se_00033.wav)",
        "content_summary": "3D arena fighting sound effects (explosions, sword slashes, beam attacks, heavy body impacts)",
        "rejection_reason_en": "Harsh transient combat effects are jarring and unsuitable for desktop UI feedback.",
    },
    {
        "source_archive": "DS _ DSi - Suzumiya Haruhi no Chokuretsu (JPN) - Characters - Yuki Nagato.zip",
        "file_pattern": "LOGO00.WAV ('Sega'), TITL00.WAV ('Suzumiya Haruhi no Chokuretsu'), TECEFF00.WAV (3.40s fast-forward chant)",
        "content_summary": "Publisher/title callouts and 3.4-second high-speed data-chanting loop",
        "rejection_reason_en": "Breaks desktop immersion ('Sega' / game title) or is too long and chaotic ('TECEFF00.WAV') for system notifications.",
    },
    {
        "source_archive": "DS _ DSi - Suzumiya Haruhi no Chokuretsu (JPN) - Characters - Yuki Nagato.zip",
        "file_pattern": "S1OP_*, S2OP_*, S5OP_*, DATDEL00.WAV ('Suzumiya Haruhi ni dōkō suru...')",
        "content_summary": "Plot-specific investigation monologues mentioning Haruhi Suzumiya, singularities (tokuiten), or Information Lifeforms (2.0s-4.7s)",
        "rejection_reason_en": "Too long (2-5 seconds) and tied to in-game plot exposition rather than general OS operations.",
    },
    {
        "source_archive": "PlayStation Portable - Suzumiya Haruhi no Tsuisou - Voices - Yuki Nagato's Voice.zip",
        "file_pattern": "09035.wav, 09041.wav ('300-en ni narimasu'), 09339-09341.wav ('Shiori wa tegami...'), 09361-09405.wav (fortune-telling monologues)",
        "content_summary": "Cultural festival doujinshi cashier lines ('Welcome', 'That will be 300 yen'), poem recitations, and 7-15s fortune-telling monologues",
        "rejection_reason_en": "Semantic mismatch with desktop events and far too long (3-15 seconds) for notifications.",
    },
    {
        "source_archive": "PlayStation Portable - Suzumiya Haruhi no Tsuisou - Voices - Yuki Nagato's Voice.zip",
        "file_pattern": "104 silent files (08977.wav, etc.) & 80+ hesitant sighs/breaths ('A...', 'N...', 'Haa...')",
        "content_summary": "1.53s blank padding tracks and ambiguous sighs/breaths",
        "rejection_reason_en": "Silent tracks produce no sound, and breathy sighs ('Haa...', 'A...') without clear words sound awkward and ambiguous as system alerts.",
    },
]


def convert_and_normalize_to_oga(src_wav: str, dst_oga: str, target_peak_db: float = -3.5) -> float:
    """
    Decodes src_wav, trims leading/trailing dead silence (< -48 dBFS),
    applies click-free 4ms fade-in and 12ms fade-out, normalizes peak to target_peak_db,
    and encodes to 48000 Hz Stereo Ogg Vorbis (.oga) per XDG Sound Theme Specification.
    Returns final duration in seconds.
    """
    sr = 48000
    res = subprocess.run(
        ["ffmpeg", "-v", "error", "-i", src_wav, "-f", "s16le", "-acodec", "pcm_s16le", "-ar", str(sr), "-ac", "1", "-"],
        capture_output=True,
        check=True,
    )
    samples = np.frombuffer(res.stdout, dtype=np.int16).astype(np.float32) / 32768.0
    if len(samples) == 0:
        raise RuntimeError(f"Empty audio decoded from {src_wav}")

    # Remove DC offset
    samples = samples - np.mean(samples)

    # Trim leading/trailing silence below -45 dBFS (threshold ~ 0.0056) with 10ms safety margin
    thresh = 0.0056
    active = np.where(np.abs(samples) > thresh)[0]
    if len(active) > 0:
        margin = int(sr * 0.010)
        i0 = max(0, int(active[0]) - margin)
        i1 = min(len(samples), int(active[-1]) + margin)
        samples = samples[i0:i1]

    # Apply 4ms fade-in and 12ms fade-out to prevent clicks/pops
    n_in = min(len(samples) // 4, int(sr * 0.004))
    n_out = min(len(samples) // 3, int(sr * 0.012))
    if n_in > 1:
        samples[:n_in] *= np.linspace(0.0, 1.0, n_in, dtype=np.float32)
    if n_out > 1:
        samples[-n_out:] *= np.linspace(1.0, 0.0, n_out, dtype=np.float32)

    # Peak normalize to target_peak_db
    peak = float(np.max(np.abs(samples)))
    if peak > 1e-6:
        target_amp = 10.0 ** (target_peak_db / 20.0)
        samples = samples * (target_amp / peak)
    samples = np.clip(samples, -0.99, 0.99)

    # Duplicate mono to 2-channel stereo int16
    stereo = np.column_stack([samples, samples])
    pcm_bytes = (stereo * 32767.0).astype(np.int16).tobytes()

    os.makedirs(os.path.dirname(dst_oga), exist_ok=True)
    subprocess.run(
        [
            "ffmpeg", "-y", "-v", "error",
            "-f", "s16le", "-ar", str(sr), "-ac", "2", "-i", "-",
            "-c:a", "libvorbis", "-q:a", "6", "-f", "ogg", dst_oga,
        ],
        input=pcm_bytes,
        check=True,
    )
    return round(len(samples) / float(sr), 3)


def write_index_theme(theme_dir: str, name: str, comment: str) -> None:
    content = f"""[Sound Theme]
Name={name}
Comment={comment}
Inherits=freedesktop
Directories=stereo

[stereo]
OutputProfile=stereo
"""
    with open(os.path.join(theme_dir, "index.theme"), "w", encoding="utf-8") as f:
        f.write(content)


def build_all() -> None:
    if os.path.exists(BUILD_ROOT):
        shutil.rmtree(BUILD_ROOT)
    pkg_root = os.path.join(BUILD_ROOT, "yuki_nagato_xdg_sound_theme")
    os.makedirs(pkg_root, exist_ok=True)

    themes_meta = {
        "yuki-nagato": (
            "Yuki Nagato (Hybrid)",
            "Modern balanced XDG sound theme: crisp Chokuretsu/Gekitou UI SFX for frequent notifications and concise Yuki Nagato humanoid-interface voice cues for system lifecycle events.",
        ),
        "yuki-nagato-sfx": (
            "Yuki Nagato (Pure SFX)",
            "Pure minimalist UI sound effect theme from Suzumiya Haruhi no Chokuretsu & Gekitou without voice lines.",
        ),
        "yuki-nagato-voice": (
            "Yuki Nagato (Extended Voice)",
            "Extended Yuki Nagato XDG sound theme including ultra-short voice cues on notifications, dialogs, and hardware events.",
        ),
    }

    for t_slug, (t_name, t_comment) in themes_meta.items():
        t_dir = os.path.join(pkg_root, "themes", t_slug)
        os.makedirs(os.path.join(t_dir, "stereo"), exist_ok=True)
        write_index_theme(t_dir, t_name, t_comment)

    csv_records: List[Dict[str, Any]] = []

    for idx, ev in enumerate(XDG_EVENTS_SPEC, 1):
        xname = ev["xdg_name"]
        ctx = ev["context"]
        xdesc = ev["xdg_description"]
        status = ev["status"]

        if status == "Unmapped_Fallback":
            csv_records.append({
                "event_index": idx,
                "xdg_sound_name": xname,
                "xdg_context": ctx,
                "xdg_description_en": xdesc,
                "mapping_status": "Unmapped_Inherits_Freedesktop",
                "default_theme_type": "None (Fallback to freedesktop)",
                "default_theme_file": "",
                "source_archive": "",
                "source_asset_path": "",
                "source_canonical_url": "",
                "japanese_transcription": "",
                "romaji": "",
                "english_translation_or_sfx": "",
                "duration_sec": 0.0,
                "sfx_profile_asset": "",
                "voice_profile_asset": "",
                "rationale_en": ev["rationale_en"],
                "recommendation_for_missing_en": ev["recommendation_en"],
            })
            continue

        # 1. Default Hybrid theme (yuki-nagato)
        h_arch, h_file, h_ja, h_rom, h_en, h_db = ev["hybrid"]
        h_src_path = os.path.join(SOURCE_ARCHIVES[h_arch]["base_dir"], h_file)
        h_dst_oga = os.path.join(pkg_root, "themes", "yuki-nagato", "stereo", f"{xname}.oga")
        h_dur = convert_and_normalize_to_oga(h_src_path, h_dst_oga, h_db)

        # Write optional .sound sidecar per XDG Sound Theme Specification Section 4
        display_str = f"Yuki Nagato: {h_ja} ({h_en})" if status == "Mapped_Voice" else f"Haruhi UI SFX: {h_en}"
        with open(os.path.join(pkg_root, "themes", "yuki-nagato", "stereo", f"{xname}.sound"), "w", encoding="utf-8") as sf:
            sf.write(f"[Sound Data]\nDisplayName={display_str}\n")

        # 2. Pure SFX theme (yuki-nagato-sfx)
        s_arch, s_file, s_en, s_db = ev["sfx_only"]
        s_src_path = os.path.join(SOURCE_ARCHIVES[s_arch]["base_dir"], s_file)
        s_dst_oga = os.path.join(pkg_root, "themes", "yuki-nagato-sfx", "stereo", f"{xname}.oga")
        convert_and_normalize_to_oga(s_src_path, s_dst_oga, s_db)

        # 3. Extended Voice theme (yuki-nagato-voice)
        if ev["voice_ext"] is not None:
            v_arch, v_file, v_ja, v_rom, v_en, v_db = ev["voice_ext"]
        else:
            v_arch, v_file, v_ja, v_rom, v_en, v_db = ev["hybrid"]
        v_src_path = os.path.join(SOURCE_ARCHIVES[v_arch]["base_dir"], v_file)
        v_dst_oga = os.path.join(pkg_root, "themes", "yuki-nagato-voice", "stereo", f"{xname}.oga")
        convert_and_normalize_to_oga(v_src_path, v_dst_oga, v_db)

        csv_records.append({
            "event_index": idx,
            "xdg_sound_name": xname,
            "xdg_context": ctx,
            "xdg_description_en": xdesc,
            "mapping_status": status,
            "default_theme_type": "Voice_Cue" if status == "Mapped_Voice" else "Pure_UI_SFX",
            "default_theme_file": f"themes/yuki-nagato/stereo/{xname}.oga",
            "source_archive": SOURCE_ARCHIVES[h_arch]["archive_name"],
            "source_asset_path": f"{h_arch}/{h_file}",
            "source_canonical_url": SOURCE_ARCHIVES[h_arch]["url"],
            "japanese_transcription": h_ja,
            "romaji": h_rom,
            "english_translation_or_sfx": h_en,
            "duration_sec": h_dur,
            "sfx_profile_asset": f"{s_arch}/{s_file} ({s_en})",
            "voice_profile_asset": f"{v_arch}/{v_file} ({v_ja} - {v_en})",
            "rationale_en": ev["rationale_en"],
            "recommendation_for_missing_en": "",
        })

    # Add common compatibility symlinks in stereo/ (e.g. message.oga -> message-new-instant.oga,
    # complete.oga -> complete-download.oga, trash-empty.oga, bell.oga -> bell-terminal.oga,
    # device-added.oga, device-removed.oga) used by libcanberra / notification daemons
    compat_aliases = [
        ("message.oga", "message-new-instant.oga"),
        ("complete.oga", "complete-download.oga"),
        ("bell.oga", "bell-terminal.oga"),
        ("error.oga", "dialog-error.oga"),
        ("warning.oga", "dialog-warning.oga"),
    ]
    for t_slug in themes_meta:
        st_dir = os.path.join(pkg_root, "themes", t_slug, "stereo")
        for alias_name, target_name in compat_aliases:
            target_p = os.path.join(st_dir, target_name)
            alias_p = os.path.join(st_dir, alias_name)
            if os.path.exists(target_p) and not os.path.exists(alias_p):
                shutil.copyfile(target_p, alias_p)

    # Write CSV manifest
    csv_path = os.path.join(pkg_root, "yuki_nagato_xdg_sound_theme.csv")
    fieldnames = list(csv_records[0].keys())
    with open(csv_path, "w", newline="", encoding="utf-8") as cf:
        writer = csv.DictWriter(cf, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(csv_records)

    # Write JSON manifest
    json_path = os.path.join(pkg_root, "yuki_nagato_xdg_sound_theme.json")
    mapped_sfx_cnt = sum(1 for r in csv_records if r["mapping_status"] == "Mapped_SFX")
    mapped_voice_cnt = sum(1 for r in csv_records if r["mapping_status"] == "Mapped_Voice")
    unmapped_cnt = sum(1 for r in csv_records if r["mapping_status"] == "Unmapped_Inherits_Freedesktop")

    manifest_data = {
        "theme_package_info": {
            "title": "Yuki Nagato XDG Sound Theme Suite (Hybrid, Pure SFX, and Extended Voice Profiles)",
            "specifications": [
                {
                    "name": "freedesktop.org Sound Theme Specification v0.2",
                    "url": "https://specifications.freedesktop.org/sound-theme/latest-single",
                },
                {
                    "name": "freedesktop.org Sound Naming Specification v0.2",
                    "url": "https://specifications.freedesktop.org/sound-naming/0.2",
                },
            ],
            "audio_encoding_standard": "48000 Hz, 2-Channel Stereo, Ogg Vorbis (.oga), DC-offset removed, silence-trimmed, 4ms/12ms micro-faded, peak-normalized (-3.5 dBFS voice / -5.5 to -8.5 dBFS UI SFX)",
            "summary_counts": {
                "total_standard_xdg_events": len(csv_records),
                "mapped_total": mapped_sfx_cnt + mapped_voice_cnt,
                "mapped_pure_ui_sfx_in_default_hybrid": mapped_sfx_cnt,
                "mapped_yuki_voice_in_default_hybrid": mapped_voice_cnt,
                "unmapped_fallback_to_freedesktop": unmapped_cnt,
            },
            "profiles_included": [
                {
                    "theme_id": "yuki-nagato",
                    "path": "themes/yuki-nagato",
                    "description_en": themes_meta["yuki-nagato"][1],
                },
                {
                    "theme_id": "yuki-nagato-sfx",
                    "path": "themes/yuki-nagato-sfx",
                    "description_en": themes_meta["yuki-nagato-sfx"][1],
                },
                {
                    "theme_id": "yuki-nagato-voice",
                    "path": "themes/yuki-nagato-voice",
                    "description_en": themes_meta["yuki-nagato-voice"][1],
                },
            ],
            "source_archives": SOURCE_ARCHIVES,
        },
        "rejected_assets_audit": REJECTED_ASSETS_CATALOG,
        "unmapped_events_and_recommendations": [
            {
                "xdg_sound_name": r["xdg_sound_name"],
                "xdg_context": r["xdg_context"],
                "xdg_description_en": r["xdg_description_en"],
                "reason_unmapped_en": r["rationale_en"],
                "recommendation_en": r["recommendation_for_missing_en"],
            }
            for r in csv_records
            if r["mapping_status"] == "Unmapped_Inherits_Freedesktop"
        ],
        "events": csv_records,
    }
    with open(json_path, "w", encoding="utf-8") as jf:
        json.dump(manifest_data, jf, indent=2, ensure_ascii=False)

    # Write Makefile and README.md
    makefile_txt = """PREFIX ?= $(HOME)/.local/share/sounds
THEME ?= yuki-nagato

.PHONY: all install install-all uninstall test

all:
\t@echo "Available targets:"
\t@echo "  make install       - Install default hybrid theme (yuki-nagato) to $(PREFIX)"
\t@echo "  make install-all   - Install all 3 profiles (yuki-nagato, yuki-nagato-sfx, yuki-nagato-voice) to $(PREFIX)"
\t@echo "  make uninstall     - Remove installed Yuki Nagato themes from $(PREFIX)"
\t@echo "  make test          - Play sample notification & login sounds via canberra-gtk-play or paplay"

install:
\tmkdir -p "$(PREFIX)"
\tcp -r themes/$(THEME) "$(PREFIX)/"
\ttouch "$(PREFIX)/$(THEME)"
\t@echo "[OK] Installed $(THEME) to $(PREFIX)/$(THEME)"

install-all:
\tmkdir -p "$(PREFIX)"
\tcp -r themes/yuki-nagato themes/yuki-nagato-sfx themes/yuki-nagato-voice "$(PREFIX)/"
\ttouch "$(PREFIX)/yuki-nagato" "$(PREFIX)/yuki-nagato-sfx" "$(PREFIX)/yuki-nagato-voice"
\t@echo "[OK] Installed yuki-nagato, yuki-nagato-sfx, and yuki-nagato-voice to $(PREFIX)"

uninstall:
\trm -rf "$(PREFIX)/yuki-nagato" "$(PREFIX)/yuki-nagato-sfx" "$(PREFIX)/yuki-nagato-voice"
\t@echo "[OK] Removed Yuki Nagato sound themes from $(PREFIX)"

test:
\t@if command -v canberra-gtk-play >/dev/null 2>&1; then \\
\t\tcanberra-gtk-play --id="message-new-instant" --description="Test IM Notification"; \\
\t\tcanberra-gtk-play --id="desktop-login" --description="Test Login"; \\
\telif command -v paplay >/dev/null 2>&1; then \\
\t\tpaplay "themes/$(THEME)/stereo/message-new-instant.oga"; \\
\t\tpaplay "themes/$(THEME)/stereo/desktop-login.oga"; \\
\tfi
"""
    with open(os.path.join(pkg_root, "Makefile"), "w", encoding="utf-8") as mf:
        mf.write(makefile_txt)

    readme_txt = """# Yuki Nagato XDG Sound Theme Suite (`yuki-nagato`, `yuki-nagato-sfx`, `yuki-nagato-voice`)

A modern, non-intrusive [freedesktop.org XDG Sound Theme](https://specifications.freedesktop.org/sound-theme/latest-single) and [Sound Naming Specification](https://specifications.freedesktop.org/sound-naming/0.2) package curated from:
1. **Suzumiya Haruhi no Chokuretsu (NDS) - Yuki Nagato Voice Archive** ([The Sounds Resource](https://sounds.spriters-resource.com/ds_dsi/suzumiyaharuhinochokuretsujpn/?source=genre))
2. **Suzumiya Haruhi no Chokuretsu (NDS) - Miscellaneous Sound Effects** ([The Sounds Resource](https://sounds.spriters-resource.com/ds_dsi/suzumiyaharuhinochokuretsujpn/?source=genre))
3. **Suzumiya Haruhi no Gekitou (PC) - Miscellaneous Sound Effects** ([The Sounds Resource Asset #401845](https://sounds.spriters-resource.com/pc_computer/suzumiyaharuhinogekitou/asset/401845/))
4. **Suzumiya Haruhi no Tsuisou (PSP) - Yuki Nagato Voice Archive** ([The Spriters Resource](https://www.spriters-resource.com/psp/suzumiyaharuhinotsuisou/))

## Included Theme Profiles
- **`themes/yuki-nagato/` (Recommended Default — Smart Hybrid)**:
  - **38 High-Frequency UI, Notification, Bell & Hardware Events** use crisp, short (`0.03s–0.61s`) UI sound effects so frequent notifications (`message-new-instant`, `audio-volume-change`, `bell-terminal`, `button-pressed`, `device-added`) never cause voice fatigue.
  - **29 Low-Frequency Semantic Lifecycle, Completion, Search & Alert Events** use Yuki Nagato's concise, deadpan `0.44s–1.91s` humanoid-interface voice cues (`desktop-login` 「歓迎する。」, `system-shutdown` 「終了。」, `complete-download` 「完了。」, `trash-empty` 「消滅を確認。」, `item-deleted` 「消去する。」, `search-results` 「発見。」, `dialog-error` 「対応不能。」, `battery-low` 「状況、悪化。」, `suspend-start` 「待機状態を継続。」).
  - **42 Unmapped Events** (such as surround speaker calibration callouts `audio-channel-*` and noisy continuous window/scroll micro-events) are intentionally left unmapped to inherit cleanly from `freedesktop`.
- **`themes/yuki-nagato-sfx/` (Pure Minimalist SFX)**:
  - All 67 mapped events use pure Chokuretsu/Gekitou UI sound effects (zero voice lines).
- **`themes/yuki-nagato-voice/` (Extended Voice)**:
  - Adds ultra-short (`0.23s–1.29s`) Yuki Nagato voice cues to notifications, hardware plug events, and dialogs (e.g. `message-new-instant` 「ここ。」 `0.41s`, `message-new-email` 「伝える。」 `0.65s`, `device-added` 「端末を発見。」 `1.29s`, `dialog-ok` 「分かった。」 `0.62s`).

## Installation (Gentoo / Wayland / Hyprland / GNOME / KDE)
```bash
make install-all
# Set active XDG sound theme in GTK / GSettings:
gsettings set org.gnome.desktop.sound theme-name 'yuki-nagato'
gsettings set org.gnome.desktop.sound event-sounds true
```
"""
    with open(os.path.join(pkg_root, "README.md"), "w", encoding="utf-8") as rf:
        rf.write(readme_txt)

    # Copy CSV, JSON, and builder script to OUT_ROOT
    shutil.copyfile(csv_path, os.path.join(OUT_ROOT, "yuki_nagato_xdg_sound_theme.csv"))
    shutil.copyfile(json_path, os.path.join(OUT_ROOT, "yuki_nagato_xdg_sound_theme.json"))
    shutil.copyfile("/tmp/build_yuki_xdg_sound_theme.py", os.path.join(pkg_root, "build_yuki_xdg_sound_theme.py"))

    # Package into ZIP in OUT_ROOT
    zip_out = os.path.join(OUT_ROOT, "yuki_nagato_xdg_sound_theme.zip")
    with zipfile.ZipFile(zip_out, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for root, dirs, files in os.walk(pkg_root):
            dirs.sort()
            files.sort()
            for f in files:
                full_p = os.path.join(root, f)
                rel_p = os.path.relpath(full_p, BUILD_ROOT)
                zf.write(full_p, rel_p)

    print(f"[OK] Built XDG Sound Theme suite: {mapped_sfx_cnt} SFX + {mapped_voice_cnt} Voice = {mapped_sfx_cnt + mapped_voice_cnt} mapped events, {unmapped_cnt} unmapped fallback events.")
    print(f"[OK] ZIP size: {os.path.getsize(zip_out)} bytes")


if __name__ == "__main__":
    build_all()
