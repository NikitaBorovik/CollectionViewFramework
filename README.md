# CollectionViewFramework
Framework to provide UICollectionView in SwiftUI
`CollectionViewFramework` is a powerful and flexible SwiftUI component that allows for the integration of a UICollectionView into SwiftUI projects.
It offers a range of customizations and is designed to work seamlessly with SwiftUI data flow.

## Key Features

- **SwiftUI Integration**: Integrates UICollectionView into SwiftUI.
- **Customizable Layout**: Allows customizing item size, section insets, header and footer spaces, and more.
- **Dynamic Data Binding**: Supports SwiftUI's data binding model to update the UI automatically based on your data source.
- **Header and Footer Support**: Easily add custom headers and footers to your collection view sections.
- **Flexible Cell Configuration**: Use any SwiftUI view as a cell.

## Installation
### CocoaPods
Add the following line to your Podfile:   
```ruby
pod 'CollectionViewFramework'
```

Then, run the following command:  
pod install

### SwiftPackageManager
Add the package to your project by selecting File -> Add Package Dependencies.  
Enter the following URL:  
https://github.com/NikitaBorovik/CollectionViewFramework

## Usage Example
```swift
struct ContentView: View {

    // An array of numbers from 0 to 9.
    private let numbers = Array(0...9)

    var body: some View {
        // Initializing the CollectionView with various parameters.
        CollectionView(
            data: .constant(numbers), // Binding the numbers array as a constant data source.
            cell: { indexPath in      // Cell configuration using a closure.
                GeometryReader { geometry in //Using geometry reader to make cell items fit hte given space
                    Text("\(numbers[indexPath.row])") // Displaying the number in each cell.
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .background(Color.yellow)      // Setting the cell background color to yellow.
                        .cornerRadius(10)              // Applying rounded corners.
                }
            },
            selectionHandler: { indexPath in
                print("Selected item at \(indexPath.row)") // Handling cell selection.
            },
            header: { sectionNumber in  // Adding a header view.
                Text("Section \(sectionNumber) start")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.pink))
                    .padding()
            },
            footer: { sectionNumber in  // Adding a footer view.
                Text("Section \(sectionNumber) end")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.pink))
                    .padding()
            }
        )
        .scrollDirection(.vertical) // Setting the scroll direction to vertical.
        .numberOfSections(1)        // Defining the number of sections in the collection view.
        .itemSpace(CGSize(width: 115, height: 115)) // Setting the space given for each item.
        .minimumLineSpacing(10)     // Setting the minimum line spacing.
        .minimumInteritemSpacing(10)// Setting the minimum interitem spacing.
        .headerSpace(CGSize(width: 350, height: 35)) // Setting the space for header.
        .footerSpace(CGSize(width: 350, height: 35)) // Setting the space for footer.
        .sectionInset(UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)) // Setting the section insets.
    }
}
```
The result of executing the code will be as follows:  

<img src="https://drive.google.com/uc?export=view&id=1-jXNdfLgsQuLJsmqI5-y8-6Dco5qudLp" width="258" height="522">
