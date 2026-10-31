import SwiftUI

struct SaveButton: View {
    var action: () -> Void
    var isEnabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text("Save")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 344, height: 58)
                .background(
                    isEnabled
                    ? Color("Primary-buttons")
                    : Color("Deactivated-buttons")
                )
                .clipShape(RoundedRectangle(cornerRadius: 36))
                .contentShape(RoundedRectangle(cornerRadius: 36))
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

#Preview {
    SaveButton(action: {}, isEnabled: true)
}
