# url-to-appimage

how to compile a URL to .AppImage:

```bash
gh repo clone VermelhoAmongUs/url-to-appimage
cd url-to-appimage
chmod +x ./url-to-appimage.sh
magick convert example.ico[0] -resize 256x256 example.png
./url-to-appimage.sh Example https://example.com example.png
cd example-app
npm install
npm run build
cd dist
chmod +x ./Example-1.0.0.AppImage
./Example-1.0.0.AppImage
```

URLs pre-compiled to .AppImage:

[WhatsApp (web.whatsapp.com)](https://github.com/VermelhoAmongUs/url-to-appimage/releases/tag/whatsapp) \
[Discord (discord.com/app)](https://github.com/VermelhoAmongUs/url-to-appimage/releases/tag/discord)

how to see a version of browser:

Ctrl + Shift + I
Console
allow pasting
navigator.userAgent