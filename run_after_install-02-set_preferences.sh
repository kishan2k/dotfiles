#!/bin/bash

set -eufo pipefail


info() {
  printf "  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

user() {
  printf "\r  [ \033[0;33m?\033[0m ] %s " "$1"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
  echo ''
  exit
}

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################
info "Setting General UI/UX"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "


# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true


# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName



###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################
info "Trackpad, mouse, keyboard, Bluetooth accessories, and input"

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1


# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3



# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false



###############################################################################
# Energy saving                                                               #
###############################################################################

info "Energy Related"

# Enable lid wakeup
sudo pmset -a lidwake 1

# Restart automatically on power loss
sudo pmset -a autorestart 1

# Sleep the display after 15 minutes
sudo pmset -a displaysleep 15

# Disable machine sleep while charging (use 0)
sudo pmset -c sleep 0

# Set machine sleep to 5 minutes on battery
sudo pmset -b sleep 5



###############################################################################
# Screen                                                                      #
###############################################################################

info "Screen Related"

# Re-enable subpixel antialiasing
defaults write -g CGFontRenderingFontSmoothingDisabled -bool FALSE

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1


###############################################################################
# Finder                                                                      #
###############################################################################

info "Finder Related"

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true


# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"


# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true



# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true


# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

###############################################################################
# Dock, Dashboard#
###############################################################################

info "Dock & Dashboard"

defaults write com.apple.dock "show-recents" -boolean false
defaults write com.apple.dock "autohide" -boolean true
defaults write com.apple.dock "autohide-delay" -float 0.0
defaults write com.apple.dock "autohide-time-modifier" -float 0.15000000596046448
defaults write com.apple.dock "enable-spring-load-actions-on-all-items" -boolean false
defaults write com.apple.dock "expose-group-apps" -boolean false
defaults write com.apple.dock "largesize" -float 128


defaults write com.apple.dock "loc" -string 'en_GB:GB'
defaults write com.apple.dock "magnification" -boolean false
defaults write com.apple.dock "mineffect" -string 'scale'
defaults write com.apple.dock "minimize-to-application" -boolean false
defaults write com.apple.dock "mod-count" -integer 48
defaults write com.apple.dock "persistent-apps" '
<array>
	<dict>
		<key>GUID</key>
		<integer>2160425540</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9va1ACAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAcAEAAAQAAAADAwAAAAAAIAYA
			AAABAQAAU3lzdGVtAAAMAAAAAQEAAEFwcGxpY2F0aW9u
			cxYAAAABAQAAU3lzdGVtIFByZWZlcmVuY2VzLmFwcAAA
			DAAAAAEGAAAQAAAAIAAAADQAAAAIAAAABAMAABUAAAD/
			//8PCAAAAAQDAAAXAAAA////DwgAAAAEAwAA5CYBAP//
			/w8MAAAAAQYAAGgAAAB4AAAAiAAAAAgAAAAABAAAQcHe
			RIAAAAAYAAAAAQIAAAIAAAAAAAAADwAAAAAAAAAAAAAA
			AAAAAAgAAAABCQAAZmlsZTovLy8MAAAAAQEAAE1hY2lu
			dG9zaCBIRAgAAAAEAwAAAKAgaHQAAAAkAAAAAQEAADRF
			RDE1NUEzLUY5QTMtNDg1Qy05NUZFLTg3NEQ5QzZBQTQz
			RRgAAAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAA
			AQAAAAEBAAAvAAAAAAAAAAEFAACoAAAA/v///wEAAAAA
			AAAADQAAAAQQAABUAAAAAAAAAAUQAACYAAAAAAAAABAQ
			AAC8AAAAAAAAAEAQAACsAAAAAAAAAAIgAABcAQAAAAAA
			AAUgAADcAAAAAAAAABAgAADsAAAAAAAAABEgAAAQAQAA
			AAAAABIgAAAAAQAAAAAAABMgAACsAAAAAAAAACAgAAA8
			AQAAAAAAADAgAABoAQAAAAAAABDQAAAEAAAAAAAAAA==
			</data>
			<key>bundle-identifier</key>
			<string>com.apple.systempreferences</string>
			<key>dock-extra</key>
			<true/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///System/Applications/System%20Preferences.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>System Preferences</string>
			<key>file-mod-date</key>
			<integer>3660710400</integer>
			<key>file-type</key>
			<integer>41</integer>
			<key>parent-mod-date</key>
			<integer>3660710400</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>2160425521</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9va0gCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAaAEAAAQAAAADAwAAAAAAIAYA
			AAABAQAAU3lzdGVtAAAMAAAAAQEAAEFwcGxpY2F0aW9u
			cw0AAAABAQAATGF1bmNocGFkLmFwcAAAAAwAAAABBgAA
			EAAAACAAAAA0AAAACAAAAAQDAAAVAAAA////DwgAAAAE
			AwAAFwAAAP///w8IAAAABAMAAI9tAAD///8PDAAAAAEG
			AABgAAAAcAAAAIAAAAAIAAAAAAQAAEHB3kSAAAAAGAAA
			AAECAAACAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAIAAAA
			AQkAAGZpbGU6Ly8vDAAAAAEBAABNYWNpbnRvc2ggSEQI
			AAAABAMAAACgIGh0AAAAJAAAAAEBAAA0RUQxNTVBMy1G
			OUEzLTQ4NUMtOTVGRS04NzREOUM2QUE0M0UYAAAAAQIA
			AIEAAAABAAAA7xMAAAEAAAAAAAAAAAAAAAEAAAABAQAA
			LwAAAAAAAAABBQAAqAAAAP7///8BAAAAAAAAAA0AAAAE
			EAAATAAAAAAAAAAFEAAAkAAAAAAAAAAQEAAAtAAAAAAA
			AABAEAAApAAAAAAAAAACIAAAVAEAAAAAAAAFIAAA1AAA
			AAAAAAAQIAAA5AAAAAAAAAARIAAACAEAAAAAAAASIAAA
			+AAAAAAAAAATIAAApAAAAAAAAAAgIAAANAEAAAAAAAAw
			IAAAYAEAAAAAAAAQ0AAABAAAAAAAAAA=
			</data>
			<key>bundle-identifier</key>
			<string>com.apple.launchpad.launcher</string>
			<key>dock-extra</key>
			<false/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///System/Applications/Launchpad.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>Launchpad</string>
			<key>file-mod-date</key>
			<integer>3660710400</integer>
			<key>file-type</key>
			<integer>169</integer>
			<key>parent-mod-date</key>
			<integer>3660710400</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>2160425539</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9va0gCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAaAEAAAQAAAADAwAAAAAAIAYA
			AAABAQAAU3lzdGVtAAAMAAAAAQEAAEFwcGxpY2F0aW9u
			cw0AAAABAQAAQXBwIFN0b3JlLmFwcAAAAAwAAAABBgAA
			EAAAACAAAAA0AAAACAAAAAQDAAAVAAAA////DwgAAAAE
			AwAAFwAAAP///w8IAAAABAMAABkAAAD///8PDAAAAAEG
			AABgAAAAcAAAAIAAAAAIAAAAAAQAAEHB3kSAAAAAGAAA
			AAECAAACAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAIAAAA
			AQkAAGZpbGU6Ly8vDAAAAAEBAABNYWNpbnRvc2ggSEQI
			AAAABAMAAACgIGh0AAAAJAAAAAEBAAA0RUQxNTVBMy1G
			OUEzLTQ4NUMtOTVGRS04NzREOUM2QUE0M0UYAAAAAQIA
			AIEAAAABAAAA7xMAAAEAAAAAAAAAAAAAAAEAAAABAQAA
			LwAAAAAAAAABBQAAqAAAAP7///8BAAAAAAAAAA0AAAAE
			EAAATAAAAAAAAAAFEAAAkAAAAAAAAAAQEAAAtAAAAAAA
			AABAEAAApAAAAAAAAAACIAAAVAEAAAAAAAAFIAAA1AAA
			AAAAAAAQIAAA5AAAAAAAAAARIAAACAEAAAAAAAASIAAA
			+AAAAAAAAAATIAAApAAAAAAAAAAgIAAANAEAAAAAAAAw
			IAAAYAEAAAAAAAAQ0AAABAAAAAAAAAA=
			</data>
			<key>bundle-identifier</key>
			<string>com.apple.AppStore</string>
			<key>dock-extra</key>
			<true/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///System/Applications/App%20Store.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>App Store</string>
			<key>file-mod-date</key>
			<integer>3660710400</integer>
			<key>file-type</key>
			<integer>41</integer>
			<key>parent-mod-date</key>
			<integer>3660710400</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870045</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9vaywCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAATAEAAAQAAAADAwAAAAAAIAwA
			AAABAQAAQXBwbGljYXRpb25zDAAAAAEBAABXaGF0c0Fw
			cC5hcHAIAAAAAQYAABAAAAAkAAAACAAAAAQDAAAPWwAA
			AAAAAAgAAAAEAwAAnFYMAAAAAAAIAAAAAQYAAEgAAABY
			AAAACAAAAAAEAABBw5XU3YAAABgAAAABAgAAAgAAAAAA
			AAAPAAAAAAAAAAAAAAAAAAAACAAAAAEJAABmaWxlOi8v
			LwwAAAABAQAATWFjaW50b3NoIEhECAAAAAQDAAAAoCBo
			dAAAAAgAAAAABAAAQcHeRIAAAAAkAAAAAQEAADRFRDE1
			NUEzLUY5QTMtNDg1Qy05NUZFLTg3NEQ5QzZBQTQzRRgA
			AAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAAAQAA
			AAEBAAAvAAAAAAAAAAEFAACoAAAA/v///wEAAAAAAAAA
			DQAAAAQQAAA4AAAAAAAAAAUQAABoAAAAAAAAABAQAACI
			AAAAAAAAAEAQAAB4AAAAAAAAAAIgAAA4AQAAAAAAAAUg
			AACoAAAAAAAAABAgAAC4AAAAAAAAABEgAADsAAAAAAAA
			ABIgAADMAAAAAAAAABMgAADcAAAAAAAAACAgAAAYAQAA
			AAAAADAgAABEAQAAAAAAABDQAAAEAAAAAAAAAA==
			</data>
			<key>bundle-identifier</key>
			<string>WhatsApp</string>
			<key>dock-extra</key>
			<false/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Applications/WhatsApp.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>WhatsApp</string>
			<key>file-mod-date</key>
			<integer>3718324923</integer>
			<key>file-type</key>
			<integer>1</integer>
			<key>parent-mod-date</key>
			<integer>5531341780244</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870043</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9vaywCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAATAEAAAQAAAADAwAAAAAAIAwA
			AAABAQAAQXBwbGljYXRpb25zCwAAAAEBAABTcG90aWZ5
			LmFwcAAIAAAAAQYAABAAAAAkAAAACAAAAAQDAAAPWwAA
			AAAAAAgAAAAEAwAArwQMAAAAAAAIAAAAAQYAAEgAAABY
			AAAACAAAAAAEAABBw5Sw+wAAABgAAAABAgAAAgAAAAAA
			AAAPAAAAAAAAAAAAAAAAAAAACAAAAAEJAABmaWxlOi8v
			LwwAAAABAQAATWFjaW50b3NoIEhECAAAAAQDAAAAoCBo
			dAAAAAgAAAAABAAAQcHeRIAAAAAkAAAAAQEAADRFRDE1
			NUEzLUY5QTMtNDg1Qy05NUZFLTg3NEQ5QzZBQTQzRRgA
			AAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAAAQAA
			AAEBAAAvAAAAAAAAAAEFAACoAAAA/v///wEAAAAAAAAA
			DQAAAAQQAAA4AAAAAAAAAAUQAABoAAAAAAAAABAQAACI
			AAAAAAAAAEAQAAB4AAAAAAAAAAIgAAA4AQAAAAAAAAUg
			AACoAAAAAAAAABAgAAC4AAAAAAAAABEgAADsAAAAAAAA
			ABIgAADMAAAAAAAAABMgAADcAAAAAAAAACAgAAAYAQAA
			AAAAADAgAABEAQAAAAAAABDQAAAEAAAAAAAAAA==
			</data>
			<key>bundle-identifier</key>
			<string>com.spotify.client</string>
			<key>dock-extra</key>
			<false/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Applications/Spotify.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>Spotify</string>
			<key>file-mod-date</key>
			<integer>3718175478</integer>
			<key>file-type</key>
			<integer>1</integer>
			<key>parent-mod-date</key>
			<integer>5531341780244</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870038</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9vazQCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAVAEAAAQAAAADAwAAAAAAIAwA
			AAABAQAAQXBwbGljYXRpb25zEQAAAAEBAABBdXRoeSBE
			ZXNrdG9wLmFwcAAAAAgAAAABBgAAEAAAACQAAAAIAAAA
			BAMAAA9bAAAAAAAACAAAAAQDAAAGAgwAAAAAAAgAAAAB
			BgAAUAAAAGAAAAAIAAAAAAQAAEHDj5wvAAAAGAAAAAEC
			AAACAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAIAAAAAQkA
			AGZpbGU6Ly8vDAAAAAEBAABNYWNpbnRvc2ggSEQIAAAA
			BAMAAACgIGh0AAAACAAAAAAEAABBwd5EgAAAACQAAAAB
			AQAANEVEMTU1QTMtRjlBMy00ODVDLTk1RkUtODc0RDlD
			NkFBNDNFGAAAAAECAACBAAAAAQAAAO8TAAABAAAAAAAA
			AAAAAAABAAAAAQEAAC8AAAAAAAAAAQUAAKgAAAD+////
			AQAAAAAAAAANAAAABBAAAEAAAAAAAAAABRAAAHAAAAAA
			AAAAEBAAAJAAAAAAAAAAQBAAAIAAAAAAAAAAAiAAAEAB
			AAAAAAAABSAAALAAAAAAAAAAECAAAMAAAAAAAAAAESAA
			APQAAAAAAAAAEiAAANQAAAAAAAAAEyAAAOQAAAAAAAAA
			ICAAACABAAAAAAAAMCAAAEwBAAAAAAAAENAAAAQAAAAA
			AAAA
			</data>
			<key>bundle-identifier</key>
			<string>com.authy.authy-mac</string>
			<key>dock-extra</key>
			<false/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Applications/Authy%20Desktop.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>Authy Desktop</string>
			<key>file-mod-date</key>
			<integer>3717509470</integer>
			<key>file-type</key>
			<integer>1</integer>
			<key>parent-mod-date</key>
			<integer>5531341780244</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870041</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9vaywCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAATAEAAAQAAAADAwAAAAAAIAwA
			AAABAQAAQXBwbGljYXRpb25zCQAAAAEBAABpVGVybS5h
			cHAAAAAIAAAAAQYAABAAAAAkAAAACAAAAAQDAAAPWwAA
			AAAAAAgAAAAEAwAAsvYLAAAAAAAIAAAAAQYAAEgAAABY
			AAAACAAAAAAEAABBw5RNa4AAABgAAAABAgAAAgAAAAAA
			AAAPAAAAAAAAAAAAAAAAAAAACAAAAAEJAABmaWxlOi8v
			LwwAAAABAQAATWFjaW50b3NoIEhECAAAAAQDAAAAoCBo
			dAAAAAgAAAAABAAAQcHeRIAAAAAkAAAAAQEAADRFRDE1
			NUEzLUY5QTMtNDg1Qy05NUZFLTg3NEQ5QzZBQTQzRRgA
			AAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAAAQAA
			AAEBAAAvAAAAAAAAAAEFAACoAAAA/v///wEAAAAAAAAA
			DQAAAAQQAAA4AAAAAAAAAAUQAABoAAAAAAAAABAQAACI
			AAAAAAAAAEAQAAB4AAAAAAAAAAIgAAA4AQAAAAAAAAUg
			AACoAAAAAAAAABAgAAC4AAAAAAAAABEgAADsAAAAAAAA
			ABIgAADMAAAAAAAAABMgAADcAAAAAAAAACAgAAAYAQAA
			AAAAADAgAABEAQAAAAAAABDQAAAEAAAAAAAAAA==
			</data>
			<key>bundle-identifier</key>
			<string>com.googlecode.iterm2</string>
			<key>dock-extra</key>
			<false/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Applications/iTerm.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>iTerm</string>
			<key>file-mod-date</key>
			<integer>3718124503</integer>
			<key>file-type</key>
			<integer>1</integer>
			<key>parent-mod-date</key>
			<integer>5531341780244</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870040</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9vazQCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAVAEAAAQAAAADAwAAAAAAIAwA
			AAABAQAAQXBwbGljYXRpb25zEQAAAAEBAABHb29nbGUg
			Q2hyb21lLmFwcAAAAAgAAAABBgAAEAAAACQAAAAIAAAA
			BAMAAA9bAAAAAAAACAAAAAQDAABV8gsAAAAAAAgAAAAB
			BgAAUAAAAGAAAAAIAAAAAAQAAEHDlRuoAAAAGAAAAAEC
			AAACAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAIAAAAAQkA
			AGZpbGU6Ly8vDAAAAAEBAABNYWNpbnRvc2ggSEQIAAAA
			BAMAAACgIGh0AAAACAAAAAAEAABBwd5EgAAAACQAAAAB
			AQAANEVEMTU1QTMtRjlBMy00ODVDLTk1RkUtODc0RDlD
			NkFBNDNFGAAAAAECAACBAAAAAQAAAO8TAAABAAAAAAAA
			AAAAAAABAAAAAQEAAC8AAAAAAAAAAQUAAKgAAAD+////
			AQAAAAAAAAANAAAABBAAAEAAAAAAAAAABRAAAHAAAAAA
			AAAAEBAAAJAAAAAAAAAAQBAAAIAAAAAAAAAAAiAAAEAB
			AAAAAAAABSAAALAAAAAAAAAAECAAAMAAAAAAAAAAESAA
			APQAAAAAAAAAEiAAANQAAAAAAAAAEyAAAOQAAAAAAAAA
			ICAAACABAAAAAAAAMCAAAEwBAAAAAAAAENAAAAQAAAAA
			AAAA
			</data>
			<key>bundle-identifier</key>
			<string>com.google.Chrome</string>
			<key>dock-extra</key>
			<false/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Applications/Google%20Chrome.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>Google Chrome</string>
			<key>file-mod-date</key>
			<integer>3718230096</integer>
			<key>file-type</key>
			<integer>1</integer>
			<key>parent-mod-date</key>
			<integer>5531341780244</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870039</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9vazQCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAVAEAAAQAAAADAwAAAAAAIAwA
			AAABAQAAQXBwbGljYXRpb25zEgAAAAEBAABHaXRIdWIg
			RGVza3RvcC5hcHAAAAgAAAABBgAAEAAAACQAAAAIAAAA
			BAMAAA9bAAAAAAAACAAAAAQDAABJZwwAAAAAAAgAAAAB
			BgAAUAAAAGAAAAAIAAAAAAQAAEHDhsjjAAAAGAAAAAEC
			AAACAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAIAAAAAQkA
			AGZpbGU6Ly8vDAAAAAEBAABNYWNpbnRvc2ggSEQIAAAA
			BAMAAACgIGh0AAAACAAAAAAEAABBwd5EgAAAACQAAAAB
			AQAANEVEMTU1QTMtRjlBMy00ODVDLTk1RkUtODc0RDlD
			NkFBNDNFGAAAAAECAACBAAAAAQAAAO8TAAABAAAAAAAA
			AAAAAAABAAAAAQEAAC8AAAAAAAAAAQUAAKgAAAD+////
			AQAAAAAAAAANAAAABBAAAEAAAAAAAAAABRAAAHAAAAAA
			AAAAEBAAAJAAAAAAAAAAQBAAAIAAAAAAAAAAAiAAAEAB
			AAAAAAAABSAAALAAAAAAAAAAECAAAMAAAAAAAAAAESAA
			APQAAAAAAAAAEiAAANQAAAAAAAAAEyAAAOQAAAAAAAAA
			ICAAACABAAAAAAAAMCAAAEwBAAAAAAAAENAAAAQAAAAA
			AAAA
			</data>
			<key>bundle-identifier</key>
			<string>com.github.GitHubClient</string>
			<key>dock-extra</key>
			<false/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Applications/GitHub%20Desktop.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>GitHub Desktop</string>
			<key>file-mod-date</key>
			<integer>3716352710</integer>
			<key>file-type</key>
			<integer>1</integer>
			<key>parent-mod-date</key>
			<integer>5531341780244</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870042</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9vaywCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAATAEAAAQAAAADAwAAAAAAIAwA
			AAABAQAAQXBwbGljYXRpb25zCQAAAAEBAABTbGFjay5h
			cHAAAAAIAAAAAQYAABAAAAAkAAAACAAAAAQDAAAPWwAA
			AAAAAAgAAAAEAwAAGAgMAAAAAAAIAAAAAQYAAEgAAABY
			AAAACAAAAAAEAABBw5G/QAAAABgAAAABAgAAAgAAAAAA
			AAAPAAAAAAAAAAAAAAAAAAAACAAAAAEJAABmaWxlOi8v
			LwwAAAABAQAATWFjaW50b3NoIEhECAAAAAQDAAAAoCBo
			dAAAAAgAAAAABAAAQcHeRIAAAAAkAAAAAQEAADRFRDE1
			NUEzLUY5QTMtNDg1Qy05NUZFLTg3NEQ5QzZBQTQzRRgA
			AAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAAAQAA
			AAEBAAAvAAAAAAAAAAEFAACoAAAA/v///wEAAAAAAAAA
			DQAAAAQQAAA4AAAAAAAAAAUQAABoAAAAAAAAABAQAACI
			AAAAAAAAAEAQAAB4AAAAAAAAAAIgAAA4AQAAAAAAAAUg
			AACoAAAAAAAAABAgAAC4AAAAAAAAABEgAADsAAAAAAAA
			ABIgAADMAAAAAAAAABMgAADcAAAAAAAAACAgAAAYAQAA
			AAAAADAgAABEAQAAAAAAABDQAAAEAAAAAAAAAA==
			</data>
			<key>bundle-identifier</key>
			<string>com.tinyspeck.slackmacgap</string>
			<key>dock-extra</key>
			<false/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Applications/Slack.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>Slack</string>
			<key>file-mod-date</key>
			<integer>3717789568</integer>
			<key>file-type</key>
			<integer>1</integer>
			<key>parent-mod-date</key>
			<integer>5531341780244</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870044</integer>
		<key>tile-data</key>
		<dict>
			<key>book</key>
			<data>
			Ym9vazgCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAWAEAAAQAAAADAwAAAAAAIAwA
			AAABAQAAQXBwbGljYXRpb25zFgAAAAEBAABWaXN1YWwg
			U3R1ZGlvIENvZGUuYXBwAAAIAAAAAQYAABAAAAAkAAAA
			CAAAAAQDAAAPWwAAAAAAAAgAAAAEAwAAzk0MAAAAAAAI
			AAAAAQYAAFQAAABkAAAACAAAAAAEAABBw4NnIQAAABgA
			AAABAgAAAgAAAAAAAAAPAAAAAAAAAAAAAAAAAAAACAAA
			AAEJAABmaWxlOi8vLwwAAAABAQAATWFjaW50b3NoIEhE
			CAAAAAQDAAAAoCBodAAAAAgAAAAABAAAQcHeRIAAAAAk
			AAAAAQEAADRFRDE1NUEzLUY5QTMtNDg1Qy05NUZFLTg3
			NEQ5QzZBQTQzRRgAAAABAgAAgQAAAAEAAADvEwAAAQAA
			AAAAAAAAAAAAAQAAAAEBAAAvAAAAAAAAAAEFAACoAAAA
			/v///wEAAAAAAAAADQAAAAQQAABEAAAAAAAAAAUQAAB0
			AAAAAAAAABAQAACUAAAAAAAAAEAQAACEAAAAAAAAAAIg
			AABEAQAAAAAAAAUgAAC0AAAAAAAAABAgAADEAAAAAAAA
			ABEgAAD4AAAAAAAAABIgAADYAAAAAAAAABMgAADoAAAA
			AAAAACAgAAAkAQAAAAAAADAgAABQAQAAAAAAABDQAAAE
			AAAAAAAAAA==
			</data>
			<key>bundle-identifier</key>
			<string>com.microsoft.VSCode</string>
			<key>dock-extra</key>
			<false/>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Applications/Visual%20Studio%20Code.app/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>Visual Studio Code</string>
			<key>file-mod-date</key>
			<integer>3715909442</integer>
			<key>file-type</key>
			<integer>1</integer>
			<key>parent-mod-date</key>
			<integer>5531341780244</integer>
		</dict>
		<key>tile-type</key>
		<string>file-tile</string>
	</dict>
</array>
'
defaults write com.apple.dock "persistent-others" '
<array>
	<dict>
		<key>GUID</key>
		<integer>2160425541</integer>
		<key>tile-data</key>
		<dict>
			<key>arrangement</key>
			<integer>2</integer>
			<key>book</key>
			<data>
			Ym9va5gCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAlAEAAAQAAAADAwAAAAAAIAUA
			AAABAQAAVXNlcnMAAAAPAAAAAQEAAGtpc2hhbi5hbWJh
			c2FuYQAJAAAAAQEAAERvd25sb2FkcwAAAAwAAAABBgAA
			EAAAACAAAAA4AAAACAAAAAQDAAALWwAAAAAAAAgAAAAE
			AwAA24cEAAAAAAAIAAAABAMAADeIBAAAAAAADAAAAAEG
			AABgAAAAcAAAAIAAAAAIAAAAAAQAAEHDGo3pgAAAGAAA
			AAECAAACAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAIAAAA
			BAMAAAEAAAAAAAAABAAAAAMDAAD3AQAACAAAAAEJAABm
			aWxlOi8vLwwAAAABAQAATWFjaW50b3NoIEhECAAAAAQD
			AAAAoCBodAAAAAgAAAAABAAAQcHeRIAAAAAkAAAAAQEA
			ADRFRDE1NUEzLUY5QTMtNDg1Qy05NUZFLTg3NEQ5QzZB
			QTQzRRgAAAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAA
			AAAAAQAAAAEBAAAvAAAAAAAAAAEFAADMAAAA/v///wEA
			AAAAAAAAEAAAAAQQAABMAAAAAAAAAAUQAACQAAAAAAAA
			ABAQAAC0AAAAAAAAAEAQAACkAAAAAAAAAAIgAACAAQAA
			AAAAAAUgAADwAAAAAAAAABAgAAAAAQAAAAAAABEgAAA0
			AQAAAAAAABIgAAAUAQAAAAAAABMgAAAkAQAAAAAAACAg
			AABgAQAAAAAAADAgAACMAQAAAAAAAAHAAADUAAAAAAAA
			ABHAAAAgAAAAAAAAABLAAADkAAAAAAAAABDQAAAEAAAA
			AAAAAA==
			</data>
			<key>displayas</key>
			<integer>0</integer>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Users/kishan.ambasana/Downloads/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>Downloads</string>
			<key>file-mod-date</key>
			<integer>25764932705386</integer>
			<key>file-type</key>
			<integer>2</integer>
			<key>parent-mod-date</key>
			<integer>225614055956345</integer>
			<key>preferreditemsize</key>
			<integer>-1</integer>
			<key>showas</key>
			<integer>1</integer>
		</dict>
		<key>tile-type</key>
		<string>directory-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870036</integer>
		<key>tile-data</key>
		<dict>
			<key>arrangement</key>
			<integer>1</integer>
			<key>book</key>
			<data>
			Ym9vawACAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAIAEAAAQAAAADAwAAAAAAIAwA
			AAABAQAAQXBwbGljYXRpb25zBAAAAAEGAAAQAAAACAAA
			AAQDAAAPWwAAAAAAAAQAAAABBgAAMAAAAAgAAAAABAAA
			QcMajeK6iI4YAAAAAQIAAAIAAAAAAAAADwAAAAAAAAAA
			AAAAAAAAAAgAAAABCQAAZmlsZTovLy8MAAAAAQEAAE1h
			Y2ludG9zaCBIRAgAAAAEAwAAAKAgaHQAAAAIAAAAAAQA
			AEHB3kSAAAAAJAAAAAEBAAA0RUQxNTVBMy1GOUEzLTQ4
			NUMtOTVGRS04NzREOUM2QUE0M0UYAAAAAQIAAIEAAAAB
			AAAA7xMAAAEAAAAAAAAAAAAAAAEAAAABAQAALwAAAAAA
			AAABBQAAqAAAAP7///8BAAAAAAAAAA0AAAAEEAAAJAAA
			AAAAAAAFEAAAQAAAAAAAAAAQEAAAXAAAAAAAAABAEAAA
			TAAAAAAAAAACIAAADAEAAAAAAAAFIAAAfAAAAAAAAAAQ
			IAAAjAAAAAAAAAARIAAAwAAAAAAAAAASIAAAoAAAAAAA
			AAATIAAAsAAAAAAAAAAgIAAA7AAAAAAAAAAwIAAAGAEA
			AAAAAAAQ0AAABAAAAAAAAAA=
			</data>
			<key>displayas</key>
			<integer>0</integer>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Applications/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>Applications</string>
			<key>file-mod-date</key>
			<integer>5531341780244</integer>
			<key>file-type</key>
			<integer>2</integer>
			<key>parent-mod-date</key>
			<integer>3660710400</integer>
			<key>preferreditemsize</key>
			<integer>-1</integer>
			<key>showas</key>
			<integer>0</integer>
		</dict>
		<key>tile-type</key>
		<string>directory-tile</string>
	</dict>
	<dict>
		<key>GUID</key>
		<integer>3070870037</integer>
		<key>tile-data</key>
		<dict>
			<key>arrangement</key>
			<integer>1</integer>
			<key>book</key>
			<data>
			Ym9va2wCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAaAEAAAQAAAADAwAAAAAAIAUA
			AAABAQAAVXNlcnMAAAAPAAAAAQEAAGtpc2hhbi5hbWJh
			c2FuYQAIAAAAAQYAABAAAAAgAAAACAAAAAQDAAALWwAA
			AAAAAAgAAAAEAwAA24cEAAAAAAAIAAAAAQYAAEgAAABY
			AAAACAAAAAAEAABBw5nxtIDArxgAAAABAgAAAgAAAAAA
			AAAPAAAAAAAAAAAAAAAAAAAACAAAAAQDAAAAAAAAAAAA
			AAQAAAADAwAA9wEAAAgAAAABCQAAZmlsZTovLy8MAAAA
			AQEAAE1hY2ludG9zaCBIRAgAAAAEAwAAAKAgaHQAAAAI
			AAAAAAQAAEHB3kSAAAAAJAAAAAEBAAA0RUQxNTVBMy1G
			OUEzLTQ4NUMtOTVGRS04NzREOUM2QUE0M0UYAAAAAQIA
			AIEAAAABAAAA7xMAAAEAAAAAAAAAAAAAAAEAAAABAQAA
			LwAAAAAAAAABBQAAzAAAAP7///8BAAAAAAAAABAAAAAE
			EAAAOAAAAAAAAAAFEAAAaAAAAAAAAAAQEAAAiAAAAAAA
			AABAEAAAeAAAAAAAAAACIAAAVAEAAAAAAAAFIAAAxAAA
			AAAAAAAQIAAA1AAAAAAAAAARIAAACAEAAAAAAAASIAAA
			6AAAAAAAAAATIAAA+AAAAAAAAAAgIAAANAEAAAAAAAAw
			IAAAYAEAAAAAAAABwAAAqAAAAAAAAAARwAAAIAAAAAAA
			AAASwAAAuAAAAAAAAAAQ0AAABAAAAAAAAAA=
			</data>
			<key>displayas</key>
			<integer>0</integer>
			<key>file-data</key>
			<dict>
				<key>_CFURLString</key>
				<string>file:///Users/kishan.ambasana/</string>
				<key>_CFURLStringType</key>
				<integer>15</integer>
			</dict>
			<key>file-label</key>
			<string>kishan.ambasana</string>
			<key>file-mod-date</key>
			<integer>176350781082747</integer>
			<key>file-type</key>
			<integer>2</integer>
			<key>parent-mod-date</key>
			<integer>1695935978601</integer>
			<key>preferreditemsize</key>
			<integer>-1</integer>
			<key>showas</key>
			<integer>0</integer>
		</dict>
		<key>tile-type</key>
		<string>directory-tile</string>
	</dict>
</array>
'


# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 54

# Change minimize/maximize window effect (scale or genie)
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool false

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool false

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true



###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################
info "iTerm 2"

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Time Machine                                                                #
###############################################################################
info "Time Machine"
# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# Activity Monitor                                                            #
###############################################################################
info "Activity Monitor"

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Disk Utility              											      #
###############################################################################
info "Disk Utility"

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true


###############################################################################
# Photos                                                                      #
###############################################################################
info "Photos App"
# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true


###############################################################################
# Finished                                                                    #
###############################################################################
success "Done. Note that some of these changes require a logout/restart to take effect."