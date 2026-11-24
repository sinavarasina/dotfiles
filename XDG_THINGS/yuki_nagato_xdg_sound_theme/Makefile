PREFIX ?= $(HOME)/.local/share/sounds
THEME ?= yuki-nagato

.PHONY: all install install-all uninstall test

all:
	@echo "Available targets:"
	@echo "  make install       - Install default hybrid theme (yuki-nagato) to $(PREFIX)"
	@echo "  make install-all   - Install all 3 profiles (yuki-nagato, yuki-nagato-sfx, yuki-nagato-voice) to $(PREFIX)"
	@echo "  make uninstall     - Remove installed Yuki Nagato themes from $(PREFIX)"
	@echo "  make test          - Play sample notification & login sounds via canberra-gtk-play or paplay"

install:
	mkdir -p "$(PREFIX)"
	cp -r themes/$(THEME) "$(PREFIX)/"
	touch "$(PREFIX)/$(THEME)"
	@echo "[OK] Installed $(THEME) to $(PREFIX)/$(THEME)"

install-all:
	mkdir -p "$(PREFIX)"
	cp -r themes/yuki-nagato themes/yuki-nagato-sfx themes/yuki-nagato-voice "$(PREFIX)/"
	touch "$(PREFIX)/yuki-nagato" "$(PREFIX)/yuki-nagato-sfx" "$(PREFIX)/yuki-nagato-voice"
	@echo "[OK] Installed yuki-nagato, yuki-nagato-sfx, and yuki-nagato-voice to $(PREFIX)"

uninstall:
	rm -rf "$(PREFIX)/yuki-nagato" "$(PREFIX)/yuki-nagato-sfx" "$(PREFIX)/yuki-nagato-voice"
	@echo "[OK] Removed Yuki Nagato sound themes from $(PREFIX)"

test:
	@if command -v canberra-gtk-play >/dev/null 2>&1; then \
		canberra-gtk-play --id="message-new-instant" --description="Test IM Notification"; \
		canberra-gtk-play --id="desktop-login" --description="Test Login"; \
	elif command -v paplay >/dev/null 2>&1; then \
		paplay "themes/$(THEME)/stereo/message-new-instant.oga"; \
		paplay "themes/$(THEME)/stereo/desktop-login.oga"; \
	fi
