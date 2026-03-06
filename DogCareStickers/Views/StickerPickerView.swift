import SwiftUI

struct StickerPickerView: View {
    let onPick: (String) -> Void  // passes StickerDesign.id
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSheet: StickerSheet = .motivational
    @State private var peelingStickerID: String?

    var body: some View {
        NavigationStack {
            ZStack {
                // Grid paper background (like the example image)
                gridPaperBackground

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerSection

                        // Sheet tabs
                        sheetTabs

                        // Sticker sheet card (dark background like real sticker sheet)
                        stickerSheetCard

                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(.systemGray3))
                    }
                }
            }
        }
    }

    // MARK: - Grid Paper Background

    private var gridPaperBackground: some View {
        ZStack {
            Color(hex: "EDE8F5")
                .ignoresSafeArea()

            // Grid lines like graph paper
            Canvas { context, canvasSize in
                let spacing: CGFloat = 20
                // Vertical lines
                for x in stride(from: 0, to: canvasSize.width, by: spacing) {
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: canvasSize.height))
                    context.stroke(path, with: .color(Color(hex: "C5BDE0").opacity(0.3)), lineWidth: 0.5)
                }
                // Horizontal lines
                for y in stride(from: 0, to: canvasSize.height, by: spacing) {
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: canvasSize.width, y: y))
                    context.stroke(path, with: .color(Color(hex: "C5BDE0").opacity(0.3)), lineWidth: 0.5)
                }
            }
            .ignoresSafeArea()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("Pick a Sticker!")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FF6B6B"), Color(hex: "FFD93D"), Color(hex: "22C55E"), Color(hex: "3B82F6")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text("Peel your reward off the sheet!")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(Color(.systemGray))
        }
        .padding(.top, 8)
    }

    // MARK: - Sheet Tabs

    private var sheetTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(StickerSheet.allCases, id: \.self) { sheet in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedSheet = sheet
                        }
                    } label: {
                        Text(sheet.rawValue)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(selectedSheet == sheet
                                          ? sheetTabColor(sheet)
                                          : Color(.systemGray5))
                            )
                            .foregroundColor(selectedSheet == sheet ? .white : Color(.systemGray))
                    }
                }
            }
        }
    }

    private func sheetTabColor(_ sheet: StickerSheet) -> Color {
        switch sheet {
        case .motivational: return Color(hex: "FF6B6B")
        case .dogTheme: return Color(hex: "F97316")
        case .funShapes: return Color(hex: "8B5CF6")
        case .superKid: return Color(hex: "3B82F6")
        }
    }

    // MARK: - Sticker Sheet Card (dark background like real sticker sheets)

    private var stickerSheetCard: some View {
        let stickers = StickerDesign.stickers(for: selectedSheet)
        // Deterministic rotations per sticker position
        let rotations: [Double] = [-3, 2, -1.5, 3, 1, -2.5, 2.5, -1]

        return ZStack {
            // Dark sheet background with rounded top
            UnevenRoundedRectangle(
                topLeadingRadius: 28,
                bottomLeadingRadius: 16,
                bottomTrailingRadius: 16,
                topTrailingRadius: 28
            )
            .fill(
                LinearGradient(
                    colors: [sheetBgColor(selectedSheet).opacity(0.85), sheetBgColor(selectedSheet)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .black.opacity(0.15), radius: 12, y: 6)

            // Subtle texture on dark sheet
            Canvas { context, canvasSize in
                // Faint math/doodle scribbles like the example
                let symbols = ["★", "♪", "♡", "✿", "◆", "○"]
                for i in 0..<20 {
                    let x = CGFloat((i * 47 + 13) % Int(canvasSize.width))
                    let y = CGFloat((i * 73 + 29) % Int(canvasSize.height))
                    let symbol = symbols[i % symbols.count]
                    let text = Text(symbol)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.08))
                    context.draw(context.resolve(text), at: CGPoint(x: x, y: y))
                }
            }
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 28,
                bottomLeadingRadius: 16,
                bottomTrailingRadius: 16,
                topTrailingRadius: 28
            ))

            // Sheet title label
            VStack {
                Text(selectedSheet.rawValue.uppercased())
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .kerning(2)
                    .padding(.top, 18)
                Spacer()
            }

            // Stickers grid arranged on the sheet
            let columns = [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8),
            ]
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(stickers.enumerated()), id: \.element.id) { index, sticker in
                    stickerOnSheet(sticker, rotation: rotations[index % rotations.count])
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 44)
            .padding(.bottom, 20)
        }
    }

    private func sheetBgColor(_ sheet: StickerSheet) -> Color {
        switch sheet {
        case .motivational: return Color(hex: "3D4F5F")
        case .dogTheme: return Color(hex: "4A3728")
        case .funShapes: return Color(hex: "2D2B55")
        case .superKid: return Color(hex: "1E3A5F")
        }
    }

    private func stickerOnSheet(_ sticker: StickerDesign, rotation: Double) -> some View {
        let isPeeling = peelingStickerID == sticker.id

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                peelingStickerID = sticker.id
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                onPick(sticker.id)
                dismiss()
            }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    // Shadow/indent where sticker sits
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.black.opacity(0.15))
                        .frame(width: 90, height: 90)
                        .blur(radius: 2)

                    // The sticker itself
                    StickerView(design: sticker, size: .large)
                        .rotationEffect(.degrees(isPeeling ? rotation - 12 : rotation))
                        .scaleEffect(isPeeling ? 1.25 : 1.0)
                        .offset(y: isPeeling ? -14 : 0)
                        .opacity(isPeeling ? 0.5 : 1.0)
                }

                Text(sticker.label.replacingOccurrences(of: "\n", with: " "))
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    StickerPickerView { stickerID in
        print("Picked: \(stickerID)")
    }
}
