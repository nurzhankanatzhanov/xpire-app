# CSE439-Project - Food Waste Tracking App - XPIRE

![XPIRE APP](https://nurzhankanatzhanov.github.io/portfolio/images/motto.png)

## Group 7 Members:
 - Nurzhan Kanatzhanov (458329)
 - Armando Quintana (457418)
 - Anderson Gonzalez Jeronimo (476195)
 - Maclee Machado (470695)

## Purpose and Target Users
### Purpose
Food waste is a huge problem in the United States. We want to create an app that will allow our users to track their food’s expiration dates, preventing food waste. Our app will give reminders to our users so they can consume their food before it goes bad. 

### Target Users
People who often forget about the food in their fridge/pantries like college students, families, people with multiple roommates. 

![XPIRE LOGO](https://nurzhankanatzhanov.github.io/portfolio/images/vectorized.svg)

## Final App Review
 - **Novelty/Creativity of App Concept** – we believe our idea to help prevent food waste by tracking expiring foods is pretty novel. After doing some 'market research' on apps that are similar to ours, other apps have been focusing on the storage part of produce rather than expiration tracking. We also provide an option to the users to look up recipes for any food item they have in their inventory.
 - **Utility** – XPIRE could definitely be a real-world product, as during our initial brainstorming for app ideas, we tried to target students like us, who are more likely to share a common fridge with other people and who would benefit from being reminded about food they have left over. Many of our test users (who are also college students) really resonated with the usefulness of the app and admitted that food waste is an important issue in their lives.
 - **Error-free** – We made an effort to ensure that XPIRE is bug-free and error-free, without any warnings or unexpected behavior as well. We tried to follow Swift's programming guidelines to safely unwrap optionals and use guard statements when working with 3rd party APIs so that our app does not crash.
 - **Consistency** – After working on our initial wireframes on Figma, we tried to make sure to follow the outline in order to have a consistent, smooth look to our app. We also worked in pairs to make sure storyboards look cohesive.
 - **User Experience** – While testing XPIRE, our app testers thought that the flow of the app was pretty straightforward, with the flow of data being evident enough and easy enough to understand. 
 - **User Interface** – We were careful with the consistency of the color scheme of our app, especially taking into consideration the Apple Human Interface Guidelines about contrast ratios between background color and text. We tried to give the app a bit of individuality with our logos and gamification to make the user feel good about themselves when they prevent food waste. We also added sounds to our app for a better experience.
 - **iOS Feel** – For the iOS feel, we heavily utilized Apple's own components like the tab bar, navigation controllers, and action sheets, as well as following Apple's HIG (dynamic text, contrast, hit areas, auto-layout, etc.)
 - **Framework Usage** – We incroporated Cocoa Pods into XPIRE [(ConfettiView)](https://github.com/sudeepag/SAConfettiView) to gamify our app a bit more and create a reward/punishment system if they add foods and consume them in time before their expiration. 
 - **Swifty Code** – Our team tried to follow all Swifty guidelines, from working with optionals and asynchronous API calls to using Core Data, entitlements, and User Defaults throughout our app to ensure a smooth data flow.
 - **Modern iOS Features** – We have created a widget for our app that shows the next few food items in a user's inventory that are about to go bad. We also let the users choose between a medium widget size and a large widget size, whatever fits their needs.

#### Note: make sure to also check out our widget we created with the app! If it doesn't show up at first, switch the target to XPIRE-widget and run it, it should pop up.
