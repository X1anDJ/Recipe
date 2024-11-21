# Recipe App

This is an one-screen app that shows a list of recipes. 

# Steps to Run the App

- Clone the repository 'git clone https://github.com/X1anDJ/Recipe.git'
- Open the xcodeproject in Xcode

# Focus Areas

I mainly focused on two area: UI/UX and Architecture. 
- UI/UX is what makes iOS unique. It makes iOS outstanding than other platforms
- Architecture is the key to maintainable and scalable software.

## UI/UX
- 2-level filtering mechanism. The list of cuisine filter buttons allow users to filter cuisine by country, then the sorting button allows them to sort from A~Z or in random order. This is for showcasing how to handle real-world data display.
- Dynamic background: Once user taps filter button, the navigation background will be changed to the photo of the recipe.
- Animation: Almost every interaction is animated. Try it then you will know.
- All the design are strictly following Apple's Human Interface Guidelines. Fonts hierarchy, color hierarchy, corner radius and so on, are carefully designed.
- It supports both light and dark mode.

## Architecture
- MVVM: I used MVVM as the main architecture, making the view as dumb as possible. Viewmodel is the core to separate business logic from view. It is the perfect architecture when using SwiftUI.
- Atomic View design: Each view is designed to be atomic, meaning it can be easily reused in other places. 
- Short code: Each view file is designed to be short, making it easy to read and maintain.

# Time Spent:

About 4.5 hours.
- 1 hour for designing the UI/UX
- 0.5 hour for designing the architecture
- 2 hours for coding
- 1 hour for testing

# Trade-offs and Decisions

Limited Unit Test Scope: I didn't fully test all the functions. Since it's a small app with only one screen, I only create test for the networking. I decided to test the network functions to demonstrate the approach in creating mock data instead of using the actual backend in testing, by creating 'MockNetworkManager' and 'MockURLProtocol' class.

# Weakest Part of the Project

Unit testing. I only testewd the network functions as I mentioned above. In production code, viewmodel should be tested as well. 

# External Code and Dependencies

Kingfisher: I used Kingfisher to download and cache images, to reduce network usage.

# Additional Information

As mentioned above, UI/UX are my main focus of this project. Wish you like it :)

