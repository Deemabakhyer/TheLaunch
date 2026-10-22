import SwiftUI

struct SkipButton: View {
    var action: (() -> Void)

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text("Skip")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("Primary-Text"))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color("Primary-Text"))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Color("Primary-tan"))
            .clipShape(Capsule())
        }
    }
}

#Preview {
    SkipButton(action: {})
}
