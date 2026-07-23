import SwiftUI

/// Fixed popover navigation chrome. It always reads the destination screen, so both pages mounted
/// during a slide draw the same bar and only the scrolling content moves.
struct PopoverTopBar: View {
    let layout: LayoutStore
    let height: CGFloat
    let horizontalPadding: CGFloat
    let onResetAll: () -> Void

    @Binding var isPresentingResetAllConfirm: Bool

    /// Read for the live card name, so a renamed card's Customize detail title follows the rename.
    @Environment(AppContainer.self) private var container

    @ViewBuilder
    var body: some View {
        switch layout.screen {
        case .dashboard:
            EmptyView()
        case .customize:
            if let providerID = layout.customizeProviderID {
                navigationBar(title: customizeTitle, back: customizeBack) {
                    resetButton(for: providerID)
                }
            } else {
                navigationBar(title: customizeTitle, back: customizeBack) {
                    resetAllButton
                }
                .alert("重置所有自訂設定？", isPresented: $isPresentingResetAllConfirm) {
                    Button("重置全部", role: .destructive) {
                        withAnimation(Motion.spring) { onResetAll() }
                    }
                    Button("取消", role: .cancel) {}
                } message: {
                    Text("這將重新啟用已安裝工具的提供者，並重置每個提供者的指標與順序。確定要重置嗎？")
                }
            }
        case .settings:
            navigationBar(title: "偏好設定") {
                withAnimation(Motion.modeSwitch) { layout.screen = .dashboard }
            } trailing: {
                EmptyView()
            }
        }
    }

    private var customizeTitle: String {
        layout.customizeProviderID.flatMap { id in
            layout.provider(id: id).map { container.displayName(for: $0) }
        } ?? "自訂介面"
    }

    private func customizeBack() {
        if layout.customizeProviderID != nil {
            withAnimation(Motion.spring) { layout.customizeProviderID = nil }
        } else {
            withAnimation(Motion.modeSwitch) { layout.screen = .dashboard }
        }
    }

    private func navigationBar<Trailing: View>(
        title: String,
        back: @escaping () -> Void,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        ZStack {
            Text(title)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: .infinity)

            HStack(spacing: 0) {
                backButton(action: back)
                Spacer(minLength: 8)
                trailing()
            }
        }
        .padding(.horizontal, horizontalPadding)
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .barGlass()
    }

    private func backButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label("返回", systemImage: "chevron.backward")
                .labelStyle(.iconOnly)
                .frame(width: 16, height: 16)
        }
        .glassButtonStyle()
        .buttonBorderShape(.circle)
        .controlSize(.large)
        .hoverTooltip("返回")
        .accessibilityLabel("返回")
    }

    private func resetButton(for providerID: String) -> some View {
        Button {
            withAnimation(Motion.spring) { layout.resetProvider(providerID) }
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .font(.system(size: 13, weight: .semibold))
                .frame(width: 16, height: 16)
                .contentShape(Rectangle())
        }
        .glassButtonStyle()
        .buttonBorderShape(.circle)
        .controlSize(.large)
        .hoverTooltip("Reset \(layout.provider(id: providerID).map { container.displayName(for: $0) } ?? providerID)")
        .accessibilityLabel("Reset")
    }

    private var resetAllButton: some View {
        Button {
            isPresentingResetAllConfirm = true
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .font(.system(size: 13, weight: .semibold))
                .frame(width: 16, height: 16)
                .contentShape(Rectangle())
        }
        .glassButtonStyle()
        .buttonBorderShape(.circle)
        .controlSize(.large)
        .hoverTooltip("Reset All Customization")
        .accessibilityLabel("Reset All Customization")
    }
}
