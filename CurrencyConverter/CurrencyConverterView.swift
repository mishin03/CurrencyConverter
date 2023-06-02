//
//  CurrencyConverterView.swift
//  CurrencyConverter
//
//  Created by Илья Мишин on 02.06.2023.
//

import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.currencies.isEmpty {
                    ProgressView()
                } else {
                    Form {
                        Section {
                            TextField("Enter an Amount...", value: $viewModel.amount, format: .number)
                                .keyboardType(.decimalPad)
                            Picker(selection: $viewModel.selectedCurrencyFrom, label: Text("From")) {
                                ForEach(0..<viewModel.currencies.count, id: \.self) { index in
                                    Text(viewModel.currencies[index]).tag(index)
                                }
                            }

                            Picker(selection: $viewModel.selectedCurrencyTo, label: Text("To")) {
                                ForEach(0..<viewModel.currencies.count, id: \.self) { index in
                                    Text(viewModel.currencies[index]).tag(index)
                                }
                            }
                        }

                        Section(header: Text("Result")) {
                            Text("\(viewModel.conversionResult, specifier: "%.2f")")
                        }
                        
                        Section {
                            Button(action: {
                                viewModel.convertCurrency()
                            }) {
                                Text("Convert")
                            }
                        }
                        
                        Section(header: Text("Favorite Pairs")) {
                            ForEach(viewModel.favoritePairs.indices, id: \.self) { index in
                                let pair = viewModel.favoritePairs[index]
                                HStack {
                                    Text(pair)
                                    Spacer()
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(action: {
                                        viewModel.removeFavoritePair(at: index)
                                        if viewModel.selectedCurrencyFrom == index || viewModel.selectedCurrencyTo == index {
                                            viewModel.selectedCurrencyFrom = 0
                                            viewModel.selectedCurrencyTo = 1
                                        }
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                                .onTapGesture {
                                    viewModel.selectedCurrencyFrom = viewModel.currencies.firstIndex(of: pair.components(separatedBy: " to ")[0]) ?? 0
                                    viewModel.selectedCurrencyTo = viewModel.currencies.firstIndex(of: pair.components(separatedBy: " to ")[1]) ?? 1
                                }
                            }
                        }
                        Section {
                            Button(action: {
                                viewModel.addFavoritePair()
                                viewModel.saveFavoritePairs()
                            }) {
                                Text("Add to Favorites")
                            }
                        }
                    }
                    .navigationTitle("Currency Converter")
                }
            }
            .onAppear {
                viewModel.loadFavoritePairs()
            }
            .onDisappear {
                viewModel.saveFavoritePairs()
            }
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            })
        }
    }
}

struct CurrencyConverterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterView()
    }
}
