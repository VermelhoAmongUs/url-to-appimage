# url-to-appimage

how to compile a URL to .AppImage:

```bash
gh repo clone VermelhoAmongUs/url-to-appimage
cd url-to-appimage
chmod +x ./url-to-appimage.sh
magick convert exemple.ico[0] -resize 256x256 exemple.png
./url-to-appimage.sh Exemple https://exemple.com exemple.png
cd exemple-app
npm install
npm run build
cd dist
chmod +x ./Exemple-1.0.0.AppImage
./Exemple-1.0.0.AppImage
```