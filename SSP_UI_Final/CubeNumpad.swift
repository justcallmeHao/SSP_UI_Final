import SwiftUI

enum CubeField: String, CaseIterable { case width = "Width", height = "Height", depth = "Depth" }

struct CubeNumpad: View {
    let initial: BoxSize
    let onApply: (BoxSize) -> Void

    @State private var activeField: CubeField = .width
    @State private var wText: String
    @State private var hText: String
    @State private var dText: String

    init(initial: BoxSize, onApply: @escaping (BoxSize) -> Void) {
        self.initial = initial
        self.onApply = onApply
        _wText = State(initialValue: String(format: "%.2f", initial.width))
        _hText = State(initialValue: String(format: "%.2f", initial.height))
        _dText = State(initialValue: String(format: "%.2f", initial.depth))
    }

    private func binding(for f: CubeField) -> Binding<String> {
        switch f {
        case .width:  return $wText
        case .height: return $hText
        case .depth:  return $dText
        }
    }

    private func parsedSize() -> BoxSize {
        let w = CGFloat(Double(wText) ?? Double(initial.width))
        let h = CGFloat(Double(hText) ?? Double(initial.height))
        let d = CGFloat(Double(dText) ?? Double(initial.depth))
        return .init(max(0.01, w), max(0.01, h), max(0.01, d))
    }

    private func tap(_ token: String) {
        let b = binding(for: activeField)
        var s = b.wrappedValue
        switch token {
        case "⌫": if !s.isEmpty { s.removeLast() }
        case "C": s.removeAll()
        case ".": if !s.contains(".") { s.append(".") }
        default:  s.append(token)
        }
        b.wrappedValue = s
    }

    var body: some View {
        VStack(spacing: 16) {
            // Display-only “fields” (no system keyboard)
            HStack(spacing: 10) {
                ForEach([CubeField.width, .height, .depth], id: \.self) { f in
                    Button {
                        activeField = f
                    } label: {
                        VStack(spacing: 4) {
                            Text(f.rawValue).font(.caption2).foregroundStyle(.secondary)
                            Text(binding(for: f).wrappedValue)
                                .font(.title3.monospacedDigit())
                                .padding(.horizontal, 6)
                        }
                        .frame(width: 100, height: 60)
                        .background(activeField == f ? .ultraThinMaterial : .thinMaterial,
                                    in: RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.primary.opacity(activeField == f ? 0.25 : 0.1), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                GridRow { num("7"); num("8"); num("9"); num("⌫") }
                GridRow { num("4"); num("5"); num("6"); num("C") }
                GridRow { num("1"); num("2"); num("3"); num(".") }
                GridRow {
                    num("0").gridCellColumns(3)
                    Button("Apply") { onApply(parsedSize()) }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
        .frame(maxWidth: 420)
        .shadow(radius: 8)
    }

    @ViewBuilder private func num(_ t: String) -> some View {
        Button(t) { tap(t) }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .font(.title3.monospacedDigit())
    }
}

#Preview {
    CubeNumpad(initial: .init(1,1,1)) { _ in }
}
