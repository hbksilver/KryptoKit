/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  @State var horcruxes: [Horcrux] = []
  let secretsURL = FileManager.documentsDirectoryURL
    .appendingPathComponent("Secrets.enc")

  // Call initHorcruxes to create 1.3MB Secrets.enc
  let names = ["Cup", "Diadem", "Journal", "Locket", "Ring", "Snake"]
  let labels = [
    "Hufflepuff's Cup",
    "Ravenclaw's Diadem",
    "Riddle's Diary",
    "Slytherin's Locket",
    "Gaunt's Ring",
    "Nagini"
  ]
  func initHorcruxes() {
    for i in 0..<names.count {
      // swiftlint:disable:next force_unwrapping
      let horcrux = Horcrux(name: names[i], imageData: (UIImage(named: names[i])?.pngData())!, label: labels[i])
      horcruxes.append(horcrux)
    }
  }

  // Once Secrets.enc exists, call readFile instead of initHorcruxes
  func readFile() {
    let decoder = PropertyListDecoder()
    do {
      let data = try Data.init(contentsOf: secretsURL)
      horcruxes = try decoder.decode([Horcrux].self, from: data)
      print("Secrets read from file \(secretsURL.absoluteString)")
    } catch {
      print(error)
    }
  }

  func writeFile(items: [Horcrux]) {
    // Don't overwrite Secrets.enc with empty array
    guard !items.isEmpty else { return }
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    do {
      let data = try encoder.encode(items)
      //      try data.write(to: secretsURL)
      try data.write(to: secretsURL, options: .completeFileProtection)
      print("Secrets written to file \(secretsURL.absoluteString)")
    } catch {
      print(error)
    }
  }

  var body: some View {
    List(horcruxes, id: \.name) { horcrux in
      HStack {
        // swiftlint:disable:next force_unwrapping
        Image(uiImage: UIImage(data: horcrux.imageData)!)
          .resizable()
          .frame(maxHeight: 100)
          .aspectRatio(1 / 1, contentMode: .fit)
        Text(horcrux.label)
      }
    }
    .onAppear {
      //      self.initHorcruxes()
      self.readFile()
      self.writeFile(items: self.horcruxes)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(horcruxes: [])
  }
}

public extension FileManager {
  static var documentsDirectoryURL: URL {
    `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
