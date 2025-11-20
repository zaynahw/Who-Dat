import SwiftUI
import PhotosUI

struct UploadPhotos: View {
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        PhotoUploadView(selectedImage: $selectedImage)
    }
}

struct PhotoUploadView: View {
    @Binding var selectedImage: UIImage?
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var showCamera = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(10)
                }
            }
            .padding(20)
            
            Spacer()
            
            VStack() {
                PhotosPicker("Choose from Library", selection: $pickerItem, matching: .images)
                
                // Camera button
                Button("Take Photo") {
                    showCamera = true
                }
                .sheet(isPresented: $showCamera) {
                    CameraPicker(image: $selectedImage)
                }
                
                // Preview image
                if let uiImage = selectedImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("No image selected")
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .task(id: pickerItem) {
            if let item = pickerItem,
               let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
            }
        }
    }
}
