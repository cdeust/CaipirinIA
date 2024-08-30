import SwiftUI

struct CocktailDetailView: View {
    @EnvironmentObject var appState: AppState
    @State private var cocktail: Cocktail?
    @State private var errorMessage: String?
    @Environment(\.colorScheme) var colorScheme // To detect dark mode

    let cocktailName: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let cocktail = cocktail {
                    // Cocktail Image
                    CocktailImageView(url: cocktail.strDrinkThumb)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.primary.opacity(0.2), radius: 5, x: 0, y: 2)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)

                    // Cocktail Title
                    CocktailTitleView(title: cocktail.strDrink)
                        .padding(.horizontal)

                    // Cocktail Info Section
                    CocktailInfoSection(cocktail: cocktail)
                        .padding(.horizontal)
                        .padding(.top, 8) // Additional padding to match the layout

                    // Ingredients Section
                    if !cocktail.ingredients.isEmpty {
                        CocktailIngredientsView(ingredients: cocktail.ingredients)
                            .padding(.horizontal)
                            .padding(.vertical)
                    }

                    // Instructions Section
                    if let instructions = cocktail.strInstructions, !instructions.isEmpty {
                        CocktailInstructionsView(instructions: instructions)
                            .padding(.horizontal)
                            .padding(.vertical)
                    } else {
                        Text("No instructions available.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color(UIColor.systemGray5).opacity(0.8))
                            .cornerRadius(12)
                            .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                    }
                } else if let errorMessage = errorMessage {
                    // Error Message
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                } else {
                    // Loading Indicator
                    ProgressView("Loading...")
                        .padding()
                        .background(Color(UIColor.systemGray5).opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark ? [Color.blue.opacity(0.2), Color.white] : [Color.blue.opacity(0.2), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle(cocktail?.strDrink ?? "Cocktail Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchCocktailDetails)
    }

    private func fetchCocktailDetails() {
        NetworkManager.fetchCocktailDetails(forCocktailName: cocktailName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cocktails):
                    self.cocktail = cocktails.first
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct CocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CocktailDetailView(cocktailName: "Margarita")
                .environmentObject(AppState())
        }
    }
}
