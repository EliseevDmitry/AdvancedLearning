//
//  CustomBindings.swift
//  AdvancedLearning
//
//  Created by Dmitriy Eliseev on 22.02.2025.
//

import SwiftUI


extension Binding where Value == Bool {
    init(value: Binding<String?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
        
    }
    
    //создаем extension через Generic где T = Bool
    //    Binding(get: {
    //        errorTitle2 != nil
    //    }, set: { newValue in
    //        if !newValue {
    //            errorTitle2 = nil
    //        }
    
}


struct CustomBindings: View {
    @State private var title: String = "Start"
    
    
    /*
     Пример с кнопкой
     вся идея кастомного биндинга - избавится от лишних - @State private var showError: Bool = false
     */
    @State private var errorTitle: String? = nil
    @State private var showError: Bool = false
    
    /*
     второй пример с кнопкой
     */
    @State private var errorTitle2: String? = nil
    @State private var showError2: Bool = false
    var body: some View {
        VStack {
            Text(title)
            //привязка Binding только с $
            ChildView(title: $title)
            ChildViewTwo(title: title) {newTitle in
                title = newTitle
            }
            //по-сути @Binding var title: String -> (эквивалентно) -> (var title: Binding<String>)
            ChildViewThree(title: $title)
            ChildViewThree(title: Binding(get: {
                return title
            }, set: { newValue in
                title = newValue
            }))
            
            /*
             так бы выглядел бы код со стандартным  @State private var showError: Bool = false переданным как Binding<Bool>
             */
            //пример с кнопкой (избавление от лишнего Binding)
            Button("Click ME"){
                errorTitle = "New error!!!"
                showError.toggle()
            }
            .alert(errorTitle ?? "Error", isPresented: $showError) {
                Button("OK") {
                    
                }
            }
            
            /*
             Второй пример с кнопкой
             реализуем через расширение и кастомизацию
             */
            Button("Click ME"){
                errorTitle2 = "New second error!!!"
                // showError2.toggle()
            }
            
            //Реализовываем закомментированный код через реализованный extension
            /*
             //заменяем $showError2 на Binding
             .alert(errorTitle2 ?? "Error second", isPresented:
             Binding(get: {
             
             //return errorTitle2 != nil ? true : false
             //условие errorTitle2 != nil по умолчанию возвращает true или false
             errorTitle2 != nil
             }, set: { newValue in
             if !newValue {
             errorTitle2 = nil
             }
             })) {
             Button("OK") {
             
             }
             }
             */
            
            //мы избавились от промежуточного - @State private var showError: Bool = false - это реально очень КРУТО!
            .alert(errorTitle2 ?? "Error second", isPresented: Binding(value: $errorTitle2)) {
                Button("OK") {
                    
                }
            }
            
        }
    }
}

//связь с ChildView через @Binding
struct ChildView: View {
    @Binding var title: String
    var body: some View {
        Text(title)
            .onAppear{
                /*
                 //убираем на время тестирования ChildViewTwo
                 DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                 title = "Binding работает в две стороны"
                 }
                 */
            }
    }
}


//связь с ChildViewTwo БЕЗ! @Binding
struct ChildViewTwo: View {
    let title: String
    let setTitle: (String) -> Void
    var body: some View {
        Text(title)
            .onAppear{
                /*
                 //убираем на время тестирования ChildViewThree
                 DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                 setTitle("Устанавливаем новый title БЕЗ @Binding")
                 }
                 */
            }
    }
}

//связь с ChildView через @Binding: Binding<String>
struct ChildViewThree: View {
    var title: Binding<String>
    var body: some View {
        Text(title.wrappedValue)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    title.wrappedValue = "Binding работает в две стороны c Binding<String>"
                }
            }
    }
}

#Preview {
    CustomBindings()
}
