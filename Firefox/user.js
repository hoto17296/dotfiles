// 最後のタブを閉じてもウィンドウを閉じない
user_pref("browser.tabs.closeWindowWithLastTab", false);

// 複数タブを閉じるときに確認
user_pref("browser.tabs.warnOnClose", true);

// Esc でフルスクリーンを解除しない
user_pref("browser.fullscreen.exit_on_escape", false);

// コンパクト表示
user_pref("browser.uidensity", 1);

// ブックマークツールバーを常に非表示
user_pref("browser.toolbars.bookmarks.visibility", "never");

// 垂直タブ
user_pref("sidebar.verticalTabs", true);

// サイドバー下部のツールは「履歴」以外は非表示にする
user_pref("sidebar.main.tools", "history");

// 「新しいタブ」画面の壁紙を指定
user_pref("browser.newtabpage.activity-stream.newtabWallpapers.user.enabled", true);
user_pref("browser.newtabpage.activity-stream.newtabWallpapers.wallpaper", "abstract-green");

// 「新しいタブ」画面でトップサイト表示を無効化
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false); 

// 英語は翻訳を提案しない
user_pref("browser.translations.neverTranslateLanguages", "en");

// パスワードを保存しない
user_pref("signon.rememberSignons", false);

// 開発ツールを右側に表示
user_pref("devtools.toolbox.host", "right");

// ツールバーの並びを指定
user_pref("browser.uiCustomization.state", '{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":[],"nav-bar":["sidebar-button","back-button","forward-button","stop-reload-button","vertical-spacer","urlbar-container","downloads-button","reset-pbm-toolbar-button","screenshot-button","developer-button","unified-extensions-button","_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action","smartwindow-group-tabs-button","ai-window-toggle","_b635fb0d-80bd-477f-91c8-d6cb60028077_-browser-action","copytabtitleurl_bugbugnow_net-browser-action"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["reset-pbm-toolbar-button","smartwindow-group-tabs-button","ai-window-toggle","developer-button","screenshot-button","ipprotection-button","_b635fb0d-80bd-477f-91c8-d6cb60028077_-browser-action","copytabtitleurl_bugbugnow_net-browser-action","_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action"],"dirtyAreaCache":["nav-bar","TabsToolbar","vertical-tabs","PersonalToolbar","unified-extensions-area","widget-overflow-fixed-list"],"currentVersion":26,"newElementCount":5}');
