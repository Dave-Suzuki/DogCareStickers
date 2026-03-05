import SwiftUI

struct TaskRowView: View {
    let task: DogTask
    let isCompleted: Bool
    let stickerDesign: StickerDesign?
    let onTap: () -> Void
    let onUndo: () -> Void

    @State private var bounceScale: CGFloat = 1.0
    @State private var stickerRotation: Double = 0

    var body: some View {
        HStack(spacing: 12) {
            // Task icon in colored circle
            ZStack {
                Circle()
                    .fill(task.color.opacity(0.2))
                    .frame(width: 46, height: 46)

                Text(task.emoji)
                    .font(.system(size: 24))
            }

            // Task info
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(isCompleted ? task.color : .primary)

                Text(task.description)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(Color(.systemGray))
            }

            Spacer()

            // Sticker or empty slot
            if isCompleted, let design = stickerDesign {
                Button {
                    onUndo()
                } label: {
                    StickerView(design: design, size: .medium)
                        .scaleEffect(bounceScale)
                        .rotationEffect(.degrees(stickerRotation))
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    onTap()
                } label: {
                    EmptyStickerSlot(size: .medium)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isCompleted
                      ? task.color.opacity(0.08)
                      : Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    isCompleted ? task.color.opacity(0.3) : Color(.systemGray5),
                    lineWidth: 1.5
                )
        )
        .onChange(of: isCompleted) { _, newValue in
            if newValue {
                stickerRotation = Double.random(in: -6...6)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                    bounceScale = 1.3
                }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.15)) {
                    bounceScale = 1.0
                }
            }
        }
    }
}

#Preview("Incomplete Task") {
    TaskRowView(
        task: DogTask.defaultTasks[0],
        isCompleted: false,
        stickerDesign: nil,
        onTap: {},
        onUndo: {}
    )
    .padding()
}

#Preview("Completed Task") {
    TaskRowView(
        task: DogTask.defaultTasks[0],
        isCompleted: true,
        stickerDesign: StickerDesign.motivational[0],
        onTap: {},
        onUndo: {}
    )
    .padding()
}

#Preview("All Tasks") {
    ScrollView {
        VStack(spacing: 8) {
            ForEach(Array(DogTask.defaultTasks.enumerated()), id: \.element.id) { i, task in
                TaskRowView(
                    task: task,
                    isCompleted: i < 3,
                    stickerDesign: i < 3 ? StickerDesign.allStickers[i] : nil,
                    onTap: {},
                    onUndo: {}
                )
            }
        }
        .padding()
    }
}
