NAME=$1; URL=$2; ICON=$3
DIR="$(echo "$NAME" | tr 'A-Z' 'a-z')-app"
mkdir -p "$DIR" && cp "$ICON" "$DIR/icon.png" && cd "$DIR" || exit 1

cat > main.js <<'EOF'
const { app, BrowserWindow, Tray, Menu, nativeImage, shell } = require('electron');
const path = require('path');
const SITE = '__URL__';
const UA = `Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/${process.versions.chrome.split('.')[0]}.0.0.0 Safari/537.36`;
let win, tray, quitting = false;

app.commandLine.appendSwitch('ozone-platform-hint', 'auto');
if (!app.requestSingleInstanceLock()) app.quit();
app.on('second-instance', () => win && (win.show(), win.focus()));

app.whenReady().then(() => {
  win = new BrowserWindow({ width: 1280, height: 720, autoHideMenuBar: true,
    icon: path.join(__dirname, 'icon.png') });
  win.webContents.setUserAgent(UA);
  win.loadURL(SITE);

  const host = new URL(SITE).hostname;
  win.webContents.setWindowOpenHandler(({ url }) => {
    if (new URL(url).hostname.endsWith(host.split('.').slice(-2).join('.')))
      return { action: 'allow' };
    shell.openExternal(url);
    return { action: 'deny' };
  });

  win.on('close', e => { if (!quitting) { e.preventDefault(); win.hide(); } });

  const icon = nativeImage.createFromPath(path.join(__dirname, 'icon.png')).resize({ width: 24, height: 24 });
  tray = new Tray(icon);
  tray.setToolTip('__NAME__');
  tray.setContextMenu(Menu.buildFromTemplate([
    { label: 'Open', click: () => win.show() },
    { label: 'Close', click: () => { quitting = true; app.quit(); } },
  ]));
  tray.on('click', () => win.isVisible() ? win.hide() : win.show());
});
EOF

cat > package.json <<'EOF'
{
  "name": "__SLUG__",
  "version": "1.0.0",
  "description": "__NAME__",
  "main": "main.js",
  "author": "VermelhoAmongUs",
  "scripts": { "build": "electron-builder --linux AppImage" },
  "devDependencies": { "electron": "latest", "electron-builder": "latest" },
  "build": {
    "asar": false,
    "appId": "com.exemplo.__SLUG__",
    "productName": "__NAME__",
    "files": ["main.js", "icon.png"],
    "linux": { "target": "AppImage", "icon": "icon.png", "category": "Network" }
  }
}
EOF

SLUG=$(echo "$NAME" | tr 'A-Z' 'a-z')
sed -i "s|__URL__|$URL|g; s|__NAME__|$NAME|g; s|__SLUG__|$SLUG|g" main.js package.json
