//
//  Cube3DView.swift
//  SSP_UI_Final
//
//

import SwiftUI
import RealityKit
import RealityKitContent
import simd

struct BoxSize: Equatable, Hashable {
    var width: CGFloat
    var height: CGFloat
    var depth: CGFloat
    
    init(_ width: CGFloat, _ height: CGFloat, _ depth: CGFloat) {
        self.width = width
        self.height = height
        self.depth = depth
    }
}

private let nativeCubeSize = BoxSize(1, 1, 1)

struct Cube3DView: View {
    let modelName: String           // customisable Preset Primitive
    let size: BoxSize               // writable W×H×D
    let onTap: () -> Void
    
    @State private var entity: ModelEntity?
    @State private var rotationY: Double = 0 // horizontal drag rotation
    @State private var scale: CGFloat = 1.0 // for resize
    @State private var baseScale: CGFloat = 1.0 // for resize

    // Scale factors relative to the model’s native dimensions
    private var scaleX: CGFloat { max(size.width  / nativeCubeSize.width,  0.0001) }
    private var scaleY: CGFloat { max(size.height / nativeCubeSize.height, 0.0001) }
    private var scaleZ: CGFloat { max(size.depth  / nativeCubeSize.depth,  0.0001) }
    
    

    var body: some View {
        Model3D(named: modelName) { model in
            model
                .rotation3DEffect(.degrees(rotationY), axis: (x: 0, y: 1, z: 0))
                .scaleEffect(
                    .init(width: scaleX, height: scaleY, depth: scaleZ),
                    anchor: .center
                )
        } placeholder: {
            ProgressView()
        }
        // Tap to notify parent (parent opens numpad)
        .onTapGesture { onTap() }
        // Drag-to-rotate (horizontal only)
        .gesture(
            DragGesture(minimumDistance: 10).onChanged { value in
                rotationY -= Double(value.translation.width / 100)
                rotationY.formTruncatingRemainder(dividingBy: 360)
            }
        )
        .ornament(attachmentAnchor: .scene(.bottom)) {
            VStack(spacing: 4) {
                Text("Rotation: \(rotationY, specifier: "%.1f")º")
                Text(String(format: "W×H×D: %.2f × %.2f × %.2f m",
                            size.width, size.height, size.depth))
            }
            .padding()
            .glassBackgroundEffect()
        }
    }
}


#Preview {
    Cube3DView(modelName: "Cube", size: .init(5,0.5,1), onTap: {})
}
