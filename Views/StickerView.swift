import SwiftUI

enum StickerSize {
    case small   // 36pt - for weekly view
    case medium  // 52pt - for task rows
    case large   // 80pt - for picker grid
    case xlarge  // 120pt - for celebration

    var diameter: CGFloat {
        switch self {
        case .small: return 36
        case .medium: return 52
        case .large: return 80
        case .xlarge: return 120
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .small: return 1.5
        case .medium: return 2.5
        case .large: return 3
        case .xlarge: return 4
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 18
        case .large: return 26
        case .xlarge: return 40
        }
    }

    var labelSize: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 11
        case .xlarge: return 16
        }
    }

    var showLabel: Bool {
        switch self {
        case .small: return false
        default: return true
        }
    }

    var shadowRadius: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 3
        case .large: return 5
        case .xlarge: return 8
        }
    }
}

struct StickerView: View {
    let design: StickerDesign
    var size: StickerSize = .large

    var body: some View {
        ZStack {
            // Background gradient circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: design.bgColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Pattern overlay
            patternOverlay
                .clipShape(Circle())

            // Inner glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.35), .clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size.diameter * 0.7
                    )
                )

            // Icon + label
            VStack(spacing: size == .small ? 0 : 1) {
                Image(systemName: design.icon)
                    .font(.system(size: size.iconSize, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, y: 1)

                if size.showLabel {
                    Text(design.label)
                        .font(.system(size: size.labelSize, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
                }
            }
            .padding(size == .small ? 2 : 4)

            // White border
            Circle()
                .strokeBorder(design.borderColor, lineWidth: size.borderWidth)

            // Glossy highlight
            Circle()
                .trim(from: 0, to: 0.35)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.5), .white.opacity(0)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: size.borderWidth * 0.8
                )
                .rotationEffect(.degrees(-30))
                .padding(size.borderWidth / 2)
        }
        .frame(width: size.diameter, height: size.diameter)
        .shadow(color: .black.opacity(0.2), radius: size.shadowRadius, y: size.shadowRadius * 0.5)
    }

    // MARK: - Pattern Overlays

    @ViewBuilder
    private var patternOverlay: some View {
        switch design.pattern {
        case .rays:
            raysPattern
        case .stripes:
            stripesPattern
        case .dots:
            dotsPattern
        case .stars:
            starsPattern
        case .hearts:
            heartsPattern
        case .sparkles:
            sparklesPattern
        case .zigzag:
            zigzagPattern
        case .none:
            EmptyView()
        }
    }

    private var raysPattern: some View {
        Canvas { context, canvasSize in
            let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
            let radius = max(canvasSize.width, canvasSize.height)
            let rayCount = 12
            let rayWidth: CGFloat = .pi / CGFloat(rayCount * 2)
            for i in 0..<rayCount {
                let angle = CGFloat(i) * .pi * 2 / CGFloat(rayCount)
                var path = Path()
                path.move(to: center)
                path.addArc(center: center, radius: radius,
                           startAngle: .radians(Double(angle - rayWidth)),
                           endAngle: .radians(Double(angle + rayWidth)),
                           clockwise: false)
                path.closeSubpath()
                context.fill(path, with: .color(.white.opacity(0.12)))
            }
        }
    }

    private var stripesPattern: some View {
        Canvas { context, canvasSize in
            let stripeWidth: CGFloat = canvasSize.width / 10
            for i in stride(from: 0, to: canvasSize.width * 2, by: stripeWidth * 2) {
                var path = Path()
                path.move(to: CGPoint(x: i - canvasSize.height, y: 0))
                path.addLine(to: CGPoint(x: i, y: canvasSize.height))
                path.addLine(to: CGPoint(x: i + stripeWidth, y: canvasSize.height))
                path.addLine(to: CGPoint(x: i + stripeWidth - canvasSize.height, y: 0))
                path.closeSubpath()
                context.fill(path, with: .color(.white.opacity(0.1)))
            }
        }
    }

    private var dotsPattern: some View {
        Canvas { context, canvasSize in
            let dotRadius: CGFloat = canvasSize.width / 24
            let spacing: CGFloat = canvasSize.width / 6
            for row in 0..<8 {
                let offsetX: CGFloat = row.isMultiple(of: 2) ? 0 : spacing / 2
                for col in 0..<8 {
                    let x = CGFloat(col) * spacing + offsetX
                    let y = CGFloat(row) * spacing
                    let rect = CGRect(x: x - dotRadius, y: y - dotRadius,
                                     width: dotRadius * 2, height: dotRadius * 2)
                    context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.15)))
                }
            }
        }
    }

    private var starsPattern: some View {
        Canvas { context, canvasSize in
            let positions: [(CGFloat, CGFloat, CGFloat)] = [
                (0.15, 0.2, 0.06), (0.8, 0.15, 0.05), (0.25, 0.75, 0.04),
                (0.75, 0.8, 0.06), (0.5, 0.12, 0.04), (0.1, 0.5, 0.03),
                (0.85, 0.5, 0.04), (0.6, 0.65, 0.03),
            ]
            for (px, py, scale) in positions {
                let center = CGPoint(x: canvasSize.width * px, y: canvasSize.height * py)
                let starSize = canvasSize.width * scale
                let star = starPath(center: center, outerRadius: starSize, innerRadius: starSize * 0.4, points: 5)
                context.fill(star, with: .color(.white.opacity(0.2)))
            }
        }
    }

    private var heartsPattern: some View {
        Canvas { context, canvasSize in
            let positions: [(CGFloat, CGFloat, CGFloat)] = [
                (0.2, 0.18, 6), (0.78, 0.22, 5), (0.15, 0.7, 5),
                (0.82, 0.75, 6), (0.5, 0.15, 4), (0.5, 0.85, 5),
                (0.1, 0.45, 4), (0.88, 0.48, 4),
            ]
            for (px, py, heartSize) in positions {
                let x = canvasSize.width * px
                let y = canvasSize.height * py
                let s = heartSize as CGFloat
                var path = Path()
                path.move(to: CGPoint(x: x, y: y + s * 0.4))
                path.addCurve(to: CGPoint(x: x, y: y - s * 0.2),
                             control1: CGPoint(x: x - s * 0.6, y: y + s * 0.1),
                             control2: CGPoint(x: x - s * 0.6, y: y - s * 0.5))
                path.addCurve(to: CGPoint(x: x, y: y + s * 0.4),
                             control1: CGPoint(x: x + s * 0.6, y: y - s * 0.5),
                             control2: CGPoint(x: x + s * 0.6, y: y + s * 0.1))
                context.fill(path, with: .color(.white.opacity(0.18)))
            }
        }
    }

    private var sparklesPattern: some View {
        Canvas { context, canvasSize in
            let positions: [(CGFloat, CGFloat, CGFloat)] = [
                (0.2, 0.2, 5), (0.8, 0.15, 4), (0.15, 0.75, 4),
                (0.8, 0.8, 5), (0.5, 0.1, 3), (0.9, 0.45, 3),
                (0.1, 0.45, 3), (0.65, 0.6, 3),
            ]
            for (px, py, sparkleSize) in positions {
                let center = CGPoint(x: canvasSize.width * px, y: canvasSize.height * py)
                let s = sparkleSize as CGFloat
                // 4-pointed sparkle
                var path = Path()
                path.move(to: CGPoint(x: center.x, y: center.y - s))
                path.addQuadCurve(to: CGPoint(x: center.x + s, y: center.y),
                                 control: CGPoint(x: center.x + s * 0.15, y: center.y - s * 0.15))
                path.addQuadCurve(to: CGPoint(x: center.x, y: center.y + s),
                                 control: CGPoint(x: center.x + s * 0.15, y: center.y + s * 0.15))
                path.addQuadCurve(to: CGPoint(x: center.x - s, y: center.y),
                                 control: CGPoint(x: center.x - s * 0.15, y: center.y + s * 0.15))
                path.addQuadCurve(to: CGPoint(x: center.x, y: center.y - s),
                                 control: CGPoint(x: center.x - s * 0.15, y: center.y - s * 0.15))
                context.fill(path, with: .color(.white.opacity(0.25)))
            }
        }
    }

    private var zigzagPattern: some View {
        Canvas { context, canvasSize in
            let amplitude: CGFloat = canvasSize.height / 14
            let wavelength: CGFloat = canvasSize.width / 4
            for row in stride(from: amplitude, to: canvasSize.height, by: amplitude * 3.5) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: row))
                for x in stride(from: 0, through: canvasSize.width, by: wavelength / 2) {
                    let isUp = Int(x / (wavelength / 2)).isMultiple(of: 2)
                    path.addLine(to: CGPoint(x: x, y: isUp ? row - amplitude : row + amplitude))
                }
                context.stroke(path, with: .color(.white.opacity(0.15)),
                              lineWidth: 1.5)
            }
        }
    }

    // MARK: - Helpers

    private func starPath(center: CGPoint, outerRadius: CGFloat, innerRadius: CGFloat, points: Int) -> Path {
        var path = Path()
        let angleStep = .pi * 2 / CGFloat(points * 2)
        for i in 0..<(points * 2) {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = CGFloat(i) * angleStep - .pi / 2
            let point = CGPoint(x: center.x + cos(angle) * radius,
                               y: center.y + sin(angle) * radius)
            if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Empty Sticker Placeholder

struct EmptyStickerSlot: View {
    var size: StickerSize = .medium

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(.systemGray6))

            Circle()
                .strokeBorder(
                    style: StrokeStyle(lineWidth: 2, dash: [4, 3])
                )
                .foregroundColor(Color(.systemGray3))

            Image(systemName: "plus")
                .font(.system(size: size.iconSize * 0.7, weight: .medium))
                .foregroundColor(Color(.systemGray3))
        }
        .frame(width: size.diameter, height: size.diameter)
    }
}

// MARK: - Previews

#Preview("Sticker Sizes") {
    let design = StickerDesign.motivational[0]
    HStack(spacing: 20) {
        StickerView(design: design, size: .small)
        StickerView(design: design, size: .medium)
        StickerView(design: design, size: .large)
        StickerView(design: design, size: .xlarge)
    }
    .padding()
}

#Preview("All Stickers") {
    ScrollView {
        LazyVGrid(columns: [
            GridItem(.flexible()), GridItem(.flexible()),
            GridItem(.flexible()), GridItem(.flexible()),
        ], spacing: 16) {
            ForEach(StickerDesign.allStickers) { sticker in
                VStack(spacing: 4) {
                    StickerView(design: sticker, size: .large)
                    Text(sticker.label.replacingOccurrences(of: "\n", with: " "))
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}

#Preview("Empty Slots") {
    HStack(spacing: 20) {
        EmptyStickerSlot(size: .small)
        EmptyStickerSlot(size: .medium)
        EmptyStickerSlot(size: .large)
    }
    .padding()
}
