#!/usr/bin/osascript -l JavaScript

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Window Width 90%
// @raycast.mode silent

// Optional parameters:
// @raycast.icon 🪟
// @raycast.packageName Window

// Documentation:
// @raycast.description 最前面のウィンドウを画面幅の 90% (中央寄せ)・高さいっぱいにする

ObjC.import('AppKit');

function run() {
  const se = Application('System Events');
  const proc = se.processes.whose({ frontmost: true })[0];
  if (proc.windows.length === 0) {
    return 'ウィンドウがありません';
  }
  const win = proc.windows[0];
  const [wx, wy] = win.position();
  const [ww, wh] = win.size();
  const cx = wx + ww / 2;
  const cy = wy + wh / 2;

  // NSScreen は左下原点、System Events はメイン画面の左上原点なので変換する
  const screens = $.NSScreen.screens;
  const primaryH = screens.objectAtIndex(0).frame.size.height;
  const toTopLeft = (r) => ({
    x: r.origin.x,
    y: primaryH - (r.origin.y + r.size.height),
    w: r.size.width,
    h: r.size.height,
  });

  // ウィンドウの中心がある画面を対象にする (見つからなければメイン画面)
  let target = toTopLeft(screens.objectAtIndex(0).visibleFrame);
  for (let i = 0; i < screens.count; i++) {
    const s = screens.objectAtIndex(i);
    const f = toTopLeft(s.frame);
    if (cx >= f.x && cx < f.x + f.w && cy >= f.y && cy < f.y + f.h) {
      target = toTopLeft(s.visibleFrame);
      break;
    }
  }

  const width = Math.round(target.w * 0.9);
  const x = Math.round(target.x + (target.w - width) / 2);
  const y = Math.round(target.y);
  const height = Math.round(target.h);

  // 位置 → サイズ → 位置 の順で設定する (画面端でサイズが制限されるアプリ対策)
  win.position = [x, y];
  win.size = [width, height];
  win.position = [x, y];
}
