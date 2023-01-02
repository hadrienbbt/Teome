import SwiftUI
import QRCode

struct TeomeQRCode: View {
    
    // https://teome.fedutia.fr/new/13861322
    func createQRCode() -> Image? {
        let qrCode = QRCode(string: "WIFI:S:Teome-13861322;P:la grenouille ne pleure pas;T:WPA;;",
            size: CGSize(width: 250, height: 250)
        )
        let qrCodeUIImage: UIImage? = try? qrCode?.image()
        guard let qrCodeUIImage = qrCodeUIImage else {
            print("Invalid QR Code")
            return nil
        }
        return Image(uiImage: qrCodeUIImage)
    }
    
    var body: some View {
        createQRCode()
    }
}

struct QRCode_Previews: PreviewProvider {
    static var previews: some View {
        TeomeQRCode()
    }
}
