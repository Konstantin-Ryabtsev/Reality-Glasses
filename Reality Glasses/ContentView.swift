//
//  ContentView.swift
//  Reality Glasses
//
//  Created by Konstantin Ryabtsev on 22.01.2022.
//

import ARKit
import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func createCircle(x: Float = 0, y: Float = 0, z: Float = 0) -> Entity {
        // Create circle mesh
        let circle = MeshResource.generateBox(size: 0.05, cornerRadius: 0.025)
        
        // Create material
        let material = SimpleMaterial(color: .blue, isMetallic: true)
        
        // Create entity
        let circleEntity = ModelEntity(mesh: circle, materials: [material])
        circleEntity.position = SIMD3(x, y, z)
        circleEntity.scale.x = 1.1
        circleEntity.scale.z = 0.01
        
        return circleEntity
    }
    
    func createGlasses(anchor: AnchorEntity) -> AnchorEntity {
        anchor.addChild(createPlane(width: 0.12, x: 0, y: 0.035))
        
        for i in stride(from: -1, through: 1, by: 2) {
            for index in 0...3 {
                let width = 0.05 - 0.01 * Float(index)
                let x = 0.035 * Float(i)
                let y = 0.03 - 0.005 * Float(index)
                
                anchor.addChild(createPlane(width: width, x: x, y: y))
            }
        }
        
        return anchor
    }
    
    func createPlane(width: Float, height: Float = 0.01, x: Float = 0, y: Float = 0, z: Float = 0.06) -> Entity {
        // Create mesh (geometry)
        let mesh = MeshResource.generatePlane(width: width, height: height)
        
        // Create material
        let material = SimpleMaterial(color: .black, isMetallic: true)
        
        // Create entity based on mesh
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = SIMD3(x, y, z)
        entity.scale.z = 0.01
                
        return entity
    }
    
    func createSphere(x: Float = 0, y: Float = 0, z: Float = 0, color: UIColor = .red, radius: Float = 1) -> Entity {
        // Create sphere mesh
        let sphere = MeshResource.generateSphere(radius: radius)
        
        // Create material
        let material = SimpleMaterial(color: color, isMetallic: true)
        
        // Create sphere entity
        let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
        sphereEntity.position = SIMD3(x, y, z)
        
        return sphereEntity
    }
    
    func makeUIView(context: Context) -> ARView {
        // Create AR view
        let arView = ARView(frame: .zero)
        
        // Check face tracking configuration is supported
        guard ARFaceTrackingConfiguration.isSupported else {
            print(#line, #function, "Face tracking is not supported on this device")
            return arView
        }
        
        // Create face tracking configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Run face tracking session
        arView.session.run(configuration, options: [])
        
        // Create face anchor
        var faceAnchor = AnchorEntity(.face)
        
        // Add glasses to the face anchor
        faceAnchor = createGlasses(anchor: faceAnchor)
                
        // Add face anchor to the scene
        arView.scene.anchors.append(faceAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
