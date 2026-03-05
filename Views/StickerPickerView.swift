import SwiftUI

struct StickerPickerView: View {
    let onPick: (String) -> Void  // passes StickerDesign.id
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSheet: StickerSheet = .motivational
    @State private var peelingStickerID: String?

    var body: some View {
        NavigationStack {
            ZStack {
                // Sticker sheet backing paper texture
                sheetBackground

                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection

                        // Sheet tabs
                        sheetTabs

                        // Sticker grid
                        stickerGrid

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

    // MARK: - Background

    private var sheetBackground: some View {
        ZStack {
            Color(hex: "FFF8F0")
                .ignoresSafeArea()

            // Subtle dot grid like sticker sheet backing
            Canvas { context, canvasSize in
                let spacing: CGFloat = 16
                for x in stride(from: 0, to: canvasSize.width, by: spacing) {
                    for y in stride(from: 0, to: canvasSize.height, by: spacing) {
                        let rect = CGRect(x: x - 1, y: y - 1, width: 2, height: 2)
                        context.fill(Path(ellipseIn: rect),
                                    with: .color(Color(.systemGray4).opacity(0.3)))
                    }
                }
            }
            .ignoresSafeArea()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("Peel a Sticker!")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FF6B6B"), Color(hex: "FFD93D"), Color(hex: "22C55E"), Color(hex: "3B82F6")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text("You earned it! Pick your reward")
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

    // MARK: - Sticker Grid

    private var stickerGrid: some View {
        let stickers = StickerDesign.stickers(for: selectedSheet)
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
        ]

        return LazyVGrid(columns: columns, spacing: 20) {
            ForEach(stickers) { sticker in
                stickerCell(sticker)
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }

    private func stickerCell(_ sticker: StickerDesign) -> some View {
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
            VStack(spacing: 6) {
                ZStack {
                    // Indent/hole where sticker sat
                    Circle()
                        .fill(Color(.systemGray5).opacity(0.5))
                        .frame(width: 72, height: 72)

                    // The sticker
                    StickerView(design: sticker, size: .large)
                        .scaleEffect(isPeeling ? 1.2 : 1.0)
                        .rotationEffect(.degrees(isPeeling ? -8 : 0))
                        .offset(y: isPeeling ? -10 : 0)
                        .opacity(isPeeling ? 0.6 : 1.0)
                }

                Text(sticker.label.replacingOccurrences(of: "\n", with: " "))
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(.systemGray))
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
