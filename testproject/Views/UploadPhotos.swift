import SwiftUI
import PhotosUI

struct UploadPhotos : View {
    @Binding var selectedImage: UIImage?
    var body : some View {
        PhotoUploadView(selectedImage: $selectedImage)
    }
}

struct PhotoUploadView: View {
    @Binding var selectedImage : UIImage?
    @State private var pickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
            
            if let uiImage = selectedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No image selected")
            }
        }
        .task(id: pickerItem) {
            guard let item = pickerItem else { return }
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data:data) {
                selectedImage = uiImage
            }
        }
        
    }
}


