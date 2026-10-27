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
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 55)
        .background(Color.sand)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

#Preview {
    TaskField()
        .frame(width: 340)
        .padding()
}
