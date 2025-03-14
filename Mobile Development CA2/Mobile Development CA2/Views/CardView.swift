//
//  CardView.swift
//  Mobile Development CA2
//
//  Created by Student on 13/03/2025.
//

import SwiftUI

struct CardView: View {
    @State private var xOffset:CGFloat = 0
    var employee: CardsForEmployee
    var body: some View {
        
        ZStack(alignment:.bottom){
//            CardsForEmployee(profileImage: "", // Replace with actual asset name
//                             name: "Chelsea Knight",
//                             rating: "4.8",
//                             location: "New York",
//                             experience: "3+ year",
//                             jobType: "Full-time",
//                             jobTitle: "Hardware Engineer",
//                             seniority: "Senior",
//                             salary: "$2400 / month")
//            ForEach(employee) { employee in
//                /*@START_MENU_TOKEN@*/Text(employee.profileImage)/*@END_MENU_TOKEN@*/
//            }
//            employee[0]
//            .offset(x: xOffset)
//            .animation(.snappy, value: xOffset)
//            .gesture(
//                DragGesture()
//                    .onChanged({value in
//                        xOffset = value.translation.width
//                    })
//                    .onEnded({value in
//                        onDragEnded(value)})
//            )
            employee
                        .offset(x: xOffset)
                        .animation(.snappy, value: xOffset)
                        .gesture(
                            DragGesture()
                                .onChanged({value in
                                    xOffset = value.translation.width
                                })
                                .onEnded({value in
                                    onDragEnded(value)})
                        )
            }
//
        }
        
        
    
}

private extension CardView
{
    func onDragEnded(_ value : _ChangedGesture<DragGesture>.Value )
    {
        let width = value.translation.width
        if abs(width) <= abs(screenCutoff){
        xOffset = 0
            
        }
        if abs(width) >= abs(screenCutoff){
            xOffset = xOffset*10
            
            
            
        }
       
    }
}

private extension CardView{
    var screenCutoff :CGFloat{
        (UIScreen.main.bounds.width / 2)*0.80
    }
     var cardWidth:CGFloat{
        UIScreen.main.bounds.width - 20
    }
     var cardHeight: CGFloat{
        UIScreen.main.bounds.height/1.45
    }
}
#Preview {
    CardView(employee :CardsForEmployee(
        id :UUID(),profileImage: "", // Replace with actual asset name
                               name: "Chelsea Knight",
                               rating: "4.8",
                               location: "New York",
                               experience: "3+ year",
                               jobType: "Full-time",
                               jobTitle: "Hardware Engineer",
                               seniority: "Senior",
                               salary: "$2400 / month"))
                     
    
}
