//
//  DateView.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//
import SwiftUI
import SwiftData

struct DateView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var taskItems: [TaskItem]
        
    // ---- Dates
    @State var today: Date = .init()
    @State var dateVM: DateViewModel = DateViewModel()
    
    //----Sheet
    @State var sheetIsPresented: Bool = false
    
    @Namespace private var animation
    
    @State private var offset: CGFloat = 0.0
    @AppStorage("colorTheme") private var colorTheme = "#00CC00"

    var body: some View {
        NavigationStack{
            VStack{
                //MARK: Header View
                HeaderView()
                
                //MARK: Tab View
                TabView(selection: $dateVM.weekSliderIndex,
                        content:  {
                    ForEach(dateVM.weekSlider.indices, id: \.self){ index in
                        let week = dateVM.weekSlider[index]
                        WeekView(week: week, taskItems: taskItems)
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .padding(.horizontal,15)
                .frame(height: 85)
                .onChange(of: dateVM.weekSliderIndex) { oldValue, newValue in
                    if newValue == 2 || newValue == 0 {
                        dateVM.createWeek = true
                    }
                }
                .onAppear(perform: {
                    dateVM.fillWeekSlider()
                })
                
                //MARK: TaskView
                TaskView(currentDate: dateVM.currentDate)
                    
                Spacer()
                    .sheet(isPresented: $sheetIsPresented, content: {
                        SheetView(currentDateSelected: dateVM.currentDate)
                            .presentationDetents([.medium])
                    })
                    
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    sheetIsPresented = true
                    //Vibration
                    HapticManager.instance.impactVibrate(style: .rigid)
                }, label: {
                    ZStack{
                        Circle()
                            .frame(width: 50, height: 50)
                            .padding(.trailing)
                            .foregroundStyle(Color(hex: colorTheme))
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.trailing)
                            .foregroundStyle(.white)
                    }
                })
                .padding(.bottom)
            }
            .navigationTitle(Text(dateVM.currentDate.formatDate(template: "MMMM").capitalized))
            .navigationDestination(for: TaskItem.self, destination: { taskItem in
                EditWorkView(workItem: taskItem)
            })
        }
    }
    
    @ViewBuilder
    private func HeaderView () -> some View {
        HStack{
            VStack{
                Text(dateVM.currentDate.formatDate(template: "yyyy"))
                    .foregroundStyle(Color(hex: colorTheme))
                    .fontWeight(.bold)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                Text(dateVM.currentDate.formatDate(template: "EEEE d"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            Spacer()
        }
    }
    
    
    @ViewBuilder
    private func WeekView (week: [WeekDay], taskItems: [TaskItem]) -> some View {
        HStack(spacing: 8){
            ForEach(week) { weekday in
                VStack(spacing: 6){
                    Text(weekday.date.formatDate(template: "E"))
                    Text(weekday.date.formatDate(template: "dd"))
                    if taskItems.contains(where: { $0.entryHour.isTheSameDay(to: weekday.date) }) {
                            Circle()
                                .frame(width: 8, height: 8)
                        }

                }
                .padding(.top, 10)
                .frame(width: 44, height: 80, alignment: .top)
                .foregroundStyle(weekday.date.isTheSameDay(to: dateVM.currentDate) ? .white : .black)
                .background{
                    Capsule()
                        .stroke(Color(hex: colorTheme), lineWidth: 1)
                    
                    //Secondary color
                    if weekday.date.isTheSameDay(to: today) {
                        Capsule()
                            .fill(Color(hex: colorTheme).secondary.secondary)
                    }
                    //Principal Color - Stronght color
                    if weekday.date.isTheSameDay(to: dateVM.currentDate) {
                        Capsule()
                            .fill(Color(hex: colorTheme))
                            .matchedGeometryEffect(id: "effect2", in: animation)
                            

                    }
                }
                .onTapGesture {
                    withAnimation(.snappy) {
                        dateVM.currentDate = weekday.date
                        //Vibration per every change
                        HapticManager.instance.impactVibrate(style: .soft)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            GeometryReader{ proxy in
                let minX: CGFloat = proxy.frame(in: .global).minX
                
                Color.clear
                    .preference(key: WidthPreferenceKey.self, value: minX)
                    .onPreferenceChange(WidthPreferenceKey.self, perform: { value in
                        offset = value
                        if value.rounded() == 15 && dateVM.createWeek == true {
                            dateVM.changePagination()
                        }
                    })
            }
        )
    }
    
}


#Preview {
    DateView()
        .modelContainer(for: TaskItem.self)
        .environmentObject(WorkViewModel())
}
