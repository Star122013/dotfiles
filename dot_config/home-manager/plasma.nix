{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
    })
    kde-rounded-corners
    kdePackages.kcalc
    kdotool
    libnotify
  ];
  programs.plasma = {
    enable = true;

    overrideConfig = true;

    fonts = {
      fixedWidth = {
        family = "Maple Mono NF CN";
        pointSize = 12;
      };
      general = {
        family = "Maple Mono NF CN";
        pointSize = 12;
      };
      menu = {
        family = "Maple Mono NF CN";
        pointSize = 12;
      };
      small = {
        family = "Maple Mono NF CN";
        pointSize = 9;
      };
      toolbar = {
        family = "Maple Mono NF CN";
        pointSize = 12;
      };
      windowTitle = {
        family = "Maple Mono NF CN";
        pointSize = 12;
      };
    };

    hotkeys.commands = {
      clear-notifications = {
        name = "Clear all KDE Plasma notifications";
        key = "Meta+Shift+Backspace";
        command = "clear-kde-notifications";
      };
      launch-alacritty = {
        name = "Launch Kitty";
        key = "Meta+Shift+Return";
        command = "kitty";
      };
      launch-browser = {
        name = "Launch Browser";
        key = "Meta+Shift+B";
        command = "firefox";
      };
      launch-ocr = {
        name = "Launch OCR";
        key = "Alt+@";
        command = "ocr-kde";
      };
      move-window-and-focus-to-desktop-1 = {
        name = "Move Window and Focus to Desktop 1";
        key = "Meta+!";
        command = "kde_mv_window 1";
      };
      move-window-and-focus-to-desktop-2 = {
        name = "Move Window and Focus to Desktop 2";
        key = "Meta+@";
        command = "kde_mv_window 2";
      };
      move-window-and-focus-to-desktop-3 = {
        name = "Move Window and Focus to Desktop 3";
        key = "Meta+#";
        command = "kde_mv_window 3";
      };
      move-window-and-focus-to-desktop-4 = {
        name = "Move Window and Focus to Desktop 4";
        key = "Meta+$";
        command = "kde_mv_window 4";
      };
      move-window-and-focus-to-desktop-5 = {
        name = "Move Window and Focus to Desktop 5";
        key = "Meta+%";
        command = "kde_mv_window 5";
      };
      screenshot-region = {
        name = "Capture a rectangular region of the screen";
        key = "Meta+Shift+S";
        command = "spectacle --region";
      };
      screenshot-screen = {
        name = "Capture the entire desktop";
        key = "Meta+Ctrl+S";
        command = "spectacle --fullscreen";
      };
    };

    input = {
      keyboard = {
        layouts = [
          { layout = "us"; }
        ];
        repeatDelay = 250;
        repeatRate = 40;
      };
      # mice = [
      #   {
      #     acceleration = -0.5;
      #     accelerationProfile = "none";
      #     name = "Razer Razer Viper V3 Pro";
      #     productId = "00c1";
      #     vendorId = "1532";
      #   }
      #   {
      #     acceleration = -0.5;
      #     accelerationProfile = "none";
      #     name = "Logitech USB Receiver";
      #     productId = "c547";
      #     vendorId = "046d";
      #   }
      # ];
    };

    krunner = {
      shortcuts.launch = "Ctrl+Space";
      position = "center";
    };

    kscreenlocker = {
      appearance.showMediaControls = false;
      # appearance.wallpaper = "";
      autoLock = false;
      timeout = 0;
    };

    kwin = {
      nightLight = {
        enable = true;
        mode = "times";
        temperature.day = 6500;
        temperature.night = 4000;
        time.evening = "20:00";
        time.morning = "07:00";
        transitionTime = 1;
      };

      virtualDesktops = {
        number = 5;
        rows = 1;
      };
    };

    panels = [
      {
        alignment = "center";
        height = 30;
        lengthMode = "fill";
        location = "top";
        opacity = "translucent";
        widgets = [
          {
            name = "org.dhruv8sh.kara";
            config = {
              general = {
                animationDuration = 0;
                highlightType = 1;
                spacing = 3;
                type = 1;
              };
              type1 = {
                fixedLen = 3;
                labelSource = 0;
              };
            };
          }
          {
            panelSpacer = {
              expanding = true;
            };
          }
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                autoFontAndSize = true;
                customDateFormat = "ddd, MMM dd";
                dateDisplayFormat = "BesideTime";
                dateFormat = "custom";
                use24hFormat = 2;
              };
            };
          }
          {
            panelSpacer = {
              expanding = true;
            };
          }
          {
            systemTray = {
              icons.scaleToFit = true;
              items = {
                showAll = false;
                shown = [
                  "org.kde.plasma.keyboardlayout"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.volume"
                ];
                hidden = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.devicenotifier"
                  "org.kde.plasma.mediacontroller"
                  "plasmashell_microphone"
                  "xdg-desktop-portal-kde"
                ];
              };
            };
          }
        ];
      }
    ];

    powerdevil = {
      AC = {
        autoSuspend.action = "nothing";
        dimDisplay.enable = false;
        powerButtonAction = "shutDown";
        turnOffDisplay.idleTimeout = "never";
      };
      battery = {
        autoSuspend.action = "nothing";
        dimDisplay.enable = false;
        powerButtonAction = "shutDown";
        turnOffDisplay.idleTimeout = "never";
      };
    };

    session = {
      general.askForConfirmationOnLogout = false;
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

    shortcuts = {
      kmix = {
        decrease_microphone_volume = "Shift+Volume Down";
        increase_microphone_volume = "Shift+Volume Up";
        mic_mute = "Shift+Volume Mute";
      };

      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          "Ctrl+Alt+L"
        ];
        "LogOut" = [
          "Ctrl+Alt+Q"
        ];
      };

      "KDE Keyboard Layout Switcher" = {
        "Switch to Next Keyboard Layout" = "Meta+Space";
      };

      kwin = {
        "KrohnkiteMonocleLayout" = [ ];
        "Overview" = "Meta+O";
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Window Close" = "Meta+Q";
        "Window Fullscreen" = "Meta+Shift+M";
        "Window Maximize" = "Meta+M";
        "Window Move Center" = "Ctrl+Alt+C";
      };

      plasmashell = {
        "show-on-mouse-pos" = "Shift+Alt+V";
      };

      "services/org.kde.dolphin.desktop"."_launch" = "Meta+Shift+F";
    };

    spectacle = {
      shortcuts = {
        captureEntireDesktop = "";
        captureRectangularRegion = "";
        launch = "";
        recordRegion = "Meta+Shift+R";
        recordScreen = "Meta+Ctrl+R";
        recordWindow = "";
      };
    };

    window-rules = [
      {
        apply = {
          noborder = {
            value = true;
            apply = "initially";
          };
        };
        description = "Hide titlebar by default";
        match = {
          window-class = {
            value = ".*";
            type = "regex";
          };
        };
      }
      {
        apply = {
          desktops = "Desktop_1";
          desktopsrule = "3";
        };
        description = "Assign Brave to Desktop 1";
        match = {
          window-class = {
            value = "brave-browser";
            type = "substring";
          };
          window-types = [ "normal" ];
        };
      }
      {
        apply = {
          desktops = "Desktop_2";
          desktopsrule = "3";
        };
        description = "Assign Alacritty to Desktop 2";
        match = {
          window-class = {
            value = "Alacritty";
            type = "substring";
          };
          window-types = [ "normal" ];
        };
      }
      {
        apply = {
          desktops = "Desktop_3";
          desktopsrule = "3";
        };
        description = "Assign Telegram to Desktop 3";
        match = {
          window-class = {
            value = "org.telegram.desktop";
            type = "substring";
          };
          window-types = [ "normal" ];
        };
      }
      {
        apply = {
          desktops = "Desktop_4";
          desktopsrule = "3";
          fsplevel = "4";
          fsplevelrule = "2";
          minimizerule = "2";
        };
        description = "Assign Steam to Desktop 4";
        match = {
          window-class = {
            value = "steam";
            type = "exact";
            match-whole = false;
          };
          window-types = [ "normal" ];
        };
      }
      {
        apply = {
          desktops = "Desktop_5";
          desktopsrule = "3";
        };
        description = "Assign Steam Games to Desktop 5";
        match = {
          window-class = {
            value = "steam_app_";
            type = "substring";
            match-whole = false;
          };
        };
      }
      {
        apply = {
          fullscreen = true;
          fullscreenrule = "2";
        };
        description = "Fullscreen Steam Games";
        match = {
          window-class = {
            value = "steam_app_";
            type = "substring";
            match-whole = false;
          };
          window-types = [ "normal" ];
        };
      }
    ];

    workspace = {
      enableMiddleClickPaste = false;
      # lookAndFeel = "org.kde.catppuccin.Mocha.Mauve";
      clickItemTo = "select";
      colorScheme = "CatppuccinMochaMauve";
      # cursor.theme = config.profile.appearance.cursorTheme.name;
      splashScreen.engine = "none";
      splashScreen.theme = "none";
      tooltipDelay = 1;
      # wallpaper = "${config.profile.wallpaper}";
    };

    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      gwenviewrc.ThumbnailView.AutoplayVideos = true;
      kdeglobals = {
        General = {
          BrowserApplication = "brave-browser.desktop";
        };
        # Icons = ;
        KDE = {
          AnimationDurationFactor = 0;
        };
      };
      klaunchrc.FeedbackStyle.BusyCursor = false;
      klipperrc.General.MaxClipItems = 1000;
      krunnerrc = {
        General = {
          ActivateWhenTypingOnDesktop = false;
          FreeFloating = true;
          historyBehavior = "Disabled";
        };
        Plugins = {
          baloosearchEnabled = false;
          calculatorEnabled = false;
          helprunnerEnabled = false;
          krunner_appstreamEnabled = false;
          krunner_bookmarksrunnerEnabled = false;
          krunner_charrunnerEnabled = false;
          krunner_colorsEnabled = false;
          krunner_dictionaryEnabled = false;
          krunner_katesessionsEnabled = false;
          krunner_killEnabled = false;
          krunner_konsoleprofilesEnabled = false;
          krunner_kwinEnabled = false;
          krunner_placesrunnerEnabled = false;
          krunner_plasma-desktopEnabled = false;
          krunner_powerdevilEnabled = false;
          krunner_recentdocumentsEnabled = false;
          krunner_shellEnabled = false;
          krunner_spellcheckEnabled = false;
          krunner_webshortcutsEnabled = false;
          locationsEnabled = false;
          "org.kde.activities2Enabled" = false;
          "org.kde.datetimeEnabled" = false;
          unitconverterEnabled = false;
          windowsEnabled = false;
        };
      };
      kwinrc = {
        Effect-overview.BorderActivate = 9;
        Plugins = {
          blurEnabled = false;
          dimscreenEnabled = false;
          krohnkiteEnabled = true;
          screenedgeEnabled = false;
        };
        "Round-Corners" = {
          ActiveOutlineAlpha = 255;
          ActiveOutlineUseCustom = false;
          ActiveOutlineUsePalette = true;
          AnimationDuration = 0;
          DisableOutlineTile = false;
          DisableRoundTile = false;
          InactiveCornerRadius = 8;
          InactiveOutlineUseCustom = false;
          InactiveOutlineUsePalette = true;
          InactiveSecondOutlineThickness = 0;
          SecondOutlineThickness = 0;
          Size = 8;
        };
        "Script-krohnkite" = {
          floatingClass = "brave-nngceckbapebfimnlniiiahkandclblb-Default,org.kde.kcalc,org.freedesktop.impl.portal.desktop.kde";
          screenGapBetween = 6;
          screenGapBottom = 6;
          screenGapLeft = 6;
          screenGapRight = 6;
          screenGapTop = 6;
        };
        Windows = {
          DelayFocusInterval = 0;
          FocusPolicy = "FocusFollowsMouse";
        };
      };
      plasmanotifyrc = {
        DoNotDisturb = {
          WhenFullscreen = false;
          WhenScreenSharing = false;
          WhenScreensMirrored = false;
        };
        Notifications = {
          PopupPosition = "TopRight";
          PopupTimeout = 8000;
        };
      };
      plasmarc.OSD.kbdLayoutChangedEnabled = false;
      spectaclerc = {
        Annotations = {
          annotationToolType = 8;
          rectangleStrokeColor = "255,0,0";
        };
        General = {
          launchAction = "DoNotTakeScreenshot";
          showCaptureInstructions = false;
          useReleaseToCapture = true;
        };
        ImageSave.imageCompressionQuality = 100;
      };
    };

    dataFile = {
      "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
      "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
    };
  };
}
