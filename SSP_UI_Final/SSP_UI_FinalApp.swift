import SwiftUI
import Combine

@MainActor
final class CubeAppModel: ObservableObject {
    @Published var cubeSize = BoxSize(1,1,1)
}

@main
struct SSP_UI_FinalApp: App {
    @StateObject private var model = CubeAppModel()
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        //---------Cube-------------
        WindowGroup(id: "CubeWindow") {
            //------HERE: YOU CAN SPECIFY YOUR MODEL PRESET (.USDZ) IN HIEARCHY------
            Cube3DView(
                modelName: "Cube",
                size: model.cubeSize,
                onTap: { openWindow(id: "NumpadWindow") }
            )
                .environmentObject(model)
        }
        WindowGroup(id: "NumpadWindow") {
            NumpadWindow()
                .environmentObject(model)
        }
        .windowStyle(.plain)
        .defaultSize(width: 420, height: 520)
    }
    
    
}

struct NumpadWindow: View {
    @EnvironmentObject var model: CubeAppModel
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        CubeNumpad(initial: model.cubeSize) { newSize in
            model.cubeSize = newSize
            dismissWindow(id: "NumpadWindow")
        }
        .padding()
    }
}
