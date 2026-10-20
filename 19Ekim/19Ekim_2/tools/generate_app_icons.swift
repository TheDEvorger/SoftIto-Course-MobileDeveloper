import AppKit
import Foundation

func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> NSColor {
  NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1)
}

/// Optional source artwork (2nd CLI argument). When nil, the vector drop is drawn.
let sourceImage: NSImage? = CommandLine.arguments.count > 2
  ? NSImage(contentsOfFile: CommandLine.arguments[2])
  : nil

func createIcon(size: Int, destination: URL) throws {
  guard
    let bitmap = NSBitmapImageRep(
      bitmapDataPlanes: nil,
      pixelsWide: size,
      pixelsHigh: size,
      bitsPerSample: 8,
      samplesPerPixel: 4,
      hasAlpha: true,
      isPlanar: false,
      colorSpaceName: .deviceRGB,
      bytesPerRow: 0,
      bitsPerPixel: 0
    ),
    let context = NSGraphicsContext(bitmapImageRep: bitmap)
  else {
    throw NSError(
      domain: "SusadimIcon",
      code: 1,
      userInfo: [NSLocalizedDescriptionKey: "Could not create an icon bitmap."]
    )
  }

  NSGraphicsContext.saveGraphicsState()
  NSGraphicsContext.current = context
  context.imageInterpolation = .high
  context.cgContext.scaleBy(x: CGFloat(size) / 1024, y: CGFloat(size) / 1024)

  color(0.043, 0.071, 0.094).setFill()
  NSBezierPath(rect: NSRect(x: 0, y: 0, width: 1024, height: 1024)).fill()

  if let sourceImage {
    sourceImage.draw(
      in: NSRect(x: 0, y: 0, width: 1024, height: 1024),
      from: .zero,
      operation: .copy,
      fraction: 1
    )
  } else {
    drawVectorDrop()
  }

  NSGraphicsContext.restoreGraphicsState()

  guard let data = bitmap.representation(using: .png, properties: [:]) else {
    throw NSError(
      domain: "SusadimIcon",
      code: 2,
      userInfo: [NSLocalizedDescriptionKey: "Could not encode the icon as PNG."]
    )
  }
  try data.write(to: destination)
}

func drawVectorDrop() {
  let drop = NSBezierPath()
  drop.move(to: NSPoint(x: 512, y: 842))
  drop.curve(
    to: NSPoint(x: 260, y: 470),
    controlPoint1: NSPoint(x: 410, y: 730),
    controlPoint2: NSPoint(x: 260, y: 610)
  )
  drop.curve(
    to: NSPoint(x: 512, y: 226),
    controlPoint1: NSPoint(x: 260, y: 320),
    controlPoint2: NSPoint(x: 405, y: 226)
  )
  drop.curve(
    to: NSPoint(x: 764, y: 470),
    controlPoint1: NSPoint(x: 619, y: 226),
    controlPoint2: NSPoint(x: 764, y: 320)
  )
  drop.curve(
    to: NSPoint(x: 512, y: 842),
    controlPoint1: NSPoint(x: 764, y: 610),
    controlPoint2: NSPoint(x: 614, y: 730)
  )
  drop.close()
  color(0.38, 0.89, 0.83).setFill()
  drop.fill()

  let wave = NSBezierPath()
  wave.move(to: NSPoint(x: 365, y: 395))
  wave.curve(
    to: NSPoint(x: 659, y: 395),
    controlPoint1: NSPoint(x: 430, y: 445),
    controlPoint2: NSPoint(x: 594, y: 345)
  )
  wave.lineWidth = 25
  wave.lineCapStyle = .round
  color(0.043, 0.071, 0.094).setStroke()
  wave.stroke()
}

func generateCatalog(at directory: URL) throws {
  let catalog = directory.appending(path: "Contents.json")
  let data = try Data(contentsOf: catalog)
  guard
    let contents = try JSONSerialization.jsonObject(with: data) as? [String: Any],
    let images = contents["images"] as? [[String: String]]
  else {
    throw NSError(
      domain: "SusadimIcon",
      code: 3,
      userInfo: [NSLocalizedDescriptionKey: "Invalid icon catalog at \(catalog.path)."]
    )
  }

  for image in images {
    guard
      let filename = image["filename"],
      let dimensions = image["size"]?.split(separator: "x").first,
      let logicalSize = Double(dimensions),
      let scaleValue = image["scale"]?.dropLast(),
      let scale = Double(scaleValue)
    else {
      continue
    }
    let pixels = Int((logicalSize * scale).rounded())
    try createIcon(size: pixels, destination: directory.appending(path: filename))
  }
}

let root = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
try generateCatalog(
  at: root.appending(path: "ios/Runner/Assets.xcassets/AppIcon.appiconset")
)
try generateCatalog(
  at: root.appending(path: "macos/Runner/Assets.xcassets/AppIcon.appiconset")
)

for (density, pixels) in [
  ("mdpi", 48),
  ("hdpi", 72),
  ("xhdpi", 96),
  ("xxhdpi", 144),
  ("xxxhdpi", 192),
] {
  try createIcon(
    size: pixels,
    destination: root.appending(path: "android/app/src/main/res/mipmap-\(density)/ic_launcher.png")
  )
}

for (relativePath, pixels) in [
  ("web/favicon.png", 32),
  ("web/icons/Icon-192.png", 192),
  ("web/icons/Icon-512.png", 512),
  ("web/icons/Icon-maskable-192.png", 192),
  ("web/icons/Icon-maskable-512.png", 512),
] {
  try createIcon(size: pixels, destination: root.appending(path: relativePath))
}

print("Generated Susadım v1 icons for iOS, Android, web, and macOS.")
