# ImageView

Component that loads and displays images(.svg/.png/.jpg/.jpeg) form asset/file/internet.

Uses SVGKit(https://github.com/SVGKit/SVGKit) library for displaying SVG images. \
Uses Kingfisher(https://github.com/onevcat/Kingfisher) library for downloading and caching images.

Usage: 
1. Install `SVGKit` and `Kingfisher` libraries.
2. Copy files from `Source` folder to the project.
3. Create new `ImageContainer` and add it on some view.
4. If you layout views programmaticaly you should also call method `setupConstraints()` in the `viewDidLoad()`.
5. Set an image via suitable setter.
6. Enjoy :)
