//
//  TaskField.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//

import SwiftUI

struct TaskField: View {
    
    var taskName: String = "Task name"
    
    var body: some View {
        HStack {
            Text(taskName)
                .italic()
                .font(.body)
                .foregroundStyle(Color(red: 0.3, green: 0.28, blue: 0.25))
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 55)
        .background(Color(red: 228/255, green: 219/255, blue: 187/255))
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

#Preview {
    TaskField()
        .frame(width: 340)
        .padding()
}
