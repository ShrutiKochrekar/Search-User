# ios-code-exercise
# Slack Coding excerise README

## Background :
- The application is used to fetch the names for the users from the API exposed and display on the screen
- The architure used here is MVVM, where each class has a protocol that exposes specific methods making them public
- MVVM helps to keep the code modularized and clean for optimum testability
- The application maintains a local cache which can be used to store the user searched results in case of loss of connectivity or network failure. This cache gets cleared on every launch so as to avoid stale results

### SlackAPIService
- Modified the function to return the escaping block of Result type with [UserSearchResult]


### UI Layer
- Added UITableView+ Extensions file which defines emptyTableViewCell

- AutoCompleteTableViewCell 
  1) This is the custom cell used to represent the search results
  2) The class consists of UI components and 'configureCell' method which will set the API parsed response values
  3) Used custom fonts provided in the project and as per specs

- AutoCompleteViewController
  1) Added a label called 'noUserFoundLabel' 
    - This label is displayed when there are no search result values either from denied list or API response gives back empty response
    - At inital state the label is hidden
    
- AutoCompleteViewModelDelegate
  1) new method 'displayNoUserFoundLabelFor(string: )'
    - This method will display the noUserFoundLabel and hide the tableView
    - if the searched string is empty ("") then both the 'noUserFoundLabel' and 'tableView' is hidden
    
- AutoCompleteViewModel
  1) Added Denied list methods to read values from denyList.txt and update local variable for deniedList
  2) Modified the 'fetchUserNames..' function to return [UserSearchResult]
  3) Added the methods to populate the tableView cell
  4) Exposed relevant methods to protocol
    -
    
- Added test cases for the business logic class ( AutoCompleteViewModel)

### User search logic explanation
     - When the application loads, and user searches for a value in the search bar ->
        - The value is first checked in the denied list which is fetched from the denylist.txt
        - If the value exists -> display the user with noUserFoundLabel 
        - If the value does not exists -> check if the searched string is present in the local cache
            - If the value exists -> return the value from cache
            - If the value does not exists -> make API call
            
      After the API response is fetched
        - if the response has empty UserSearch results -> update the denied list 
        - If the response has users return the users as table view data source
        - Update the local cache
        


### Future Scope / Scalability:
- We will need to account for the cases where the search resultsare not suitable for local storage on the device due to the size for results saved on the local cache. We can enhance this for performace by suing something like core data.
- On selecting a user we can display details with another API fetch call for details
