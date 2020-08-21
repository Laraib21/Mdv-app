//
//  EventPopup.swift
//  MdvApp
//
//  Created by School on 2020-07-20.
//

import SwiftUI

struct NoShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path()
    }
}

final class TextViewDelegate: NSObject {
    private var text: Binding<String>
    private var isEditing: Binding<Bool>
    init(text: Binding<String>, isEditing: Binding<Bool>) {
        self.text = text
        self.isEditing = isEditing
        super.init()
    }
}

extension TextViewDelegate: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        isEditing.wrappedValue = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        isEditing.wrappedValue = false
    }

    func textViewDidChange(_ textView: UITextView) {
        text.wrappedValue = textView.text
    }
}

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isEditing: Bool
    private let textViewDelegate: TextViewDelegate

    init(text: Binding<String>, isEditing: Binding<Bool>) {
        self._text = text
        self._isEditing = isEditing
        self.textViewDelegate = TextViewDelegate(text: text, isEditing: isEditing)
    }

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 17)
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.delegate = textViewDelegate
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {}
}

struct EventPopup: View {
    @State var start = Date()
    @State var end = Date()
    @State var title = ""
    @State var description = ""
    var dismiss: ((Event) -> Void)?
    var saveButton: some View {
        Button(action: SaveEvent) {
            Text("Save")
        }
    }

    @State private var isEditing = false
    @State private var isValid = true
    var body: some View{
        NavigationView {
            Form {
                TextField("Title", text: $title)
                DatePicker(selection: $start, displayedComponents: [.date, .hourAndMinute]) {
                    Text("Start")
                }
                DatePicker(selection: $end, displayedComponents: [.date, .hourAndMinute]) {
                    Text("End")
                }
                ZStack(alignment: .topLeading) {
                    MultilineTextView(text: $description, isEditing: $isEditing)
                        .frame(height: 200)
                    if !isEditing && description.isEmpty {
                        Text("Enter some event details")
                        .contentShape(NoShape())
                        .foregroundColor(Color.gray.opacity(0.7))
                    }
                }
            }
            .navigationBarTitle("New Event")
            .navigationBarItems(trailing: saveButton)

        }
    }
    func SaveEvent () {
        // TODO: Validate none of the fields are empty. If any are, don't dismiss!
        // NOTES:
        //    SwiftUI lets you use statements like this:
        //    .foregroundColor(isValidated ? Color.white : Color.red)
        let newEvent = Event(title: title, body: description, startDate: start, endDate: end)
        self.dismiss?(newEvent)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct EventPopup_Previews: PreviewProvider {
    static var previews: some View {
        EventPopup()
    }
}


