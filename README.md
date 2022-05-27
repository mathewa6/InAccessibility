# InAccessibility

A SwiftUI app that's not very accessible... On purpose

This app is part of the [Accessibility](https://www.swiftuiseries.com/accessibility) event during the SwiftUI Series. This project has been made inaccessible and non-inclusive on purpose. Can you fix the 20+ areas that can be improved?

---

I’ll begin by apologizing - I made some drastic changes to the provided layout. Perhaps it'll be my fault more rules exist in SwiftUI Series 2 😆

As someone who’s worked at the intersection of accessibility, prototyping and  iOS dev for most of my professional career, in my opinion approaching mobile accessibility *only* to accommodate people with disabilities is a rather myopic view of the field (no pun?). There’s always more that can be done (and not just because time's up like it is for me) - using a11y APIs only scratches the surface. For this challenge, I focused on VoiceOver and in particular focused on easing the cognitive load of navigating by audio. I certainly made changes to accommodate as many modalities possible, but mostly by deferring to system paradigms

**Noteworthy Changes made**
- One particular gripe of mine is how VoiceOver gets selective amnesia over which cell you selected (this happens even in the default Stocks app), so I implemented a rather hacky accessibilityFocusState workaround to ensure VO focus is returned to the cell clicked on after a pop segue
- Relevance: Allowing sorting of companies lets the user be in control (especially of screen readers) for how far down they scroll or what their priority stocks are. TODO: Drag and drop in favorites?
- Control: Allowing un-favoriting by swiping and/or long pressing for a context menu (Free accessibilityAction included) instead of nested tap targets for info/favorite
- Using accessibilityCustomRotor to allow skimming upward/downward trending stocks
- Use of image & text for buttons such as the settings/customize buttons
- Moving buttons to the bottom toolbar for easier reach (as well as not having it where the back button goes)
- Consequently moving the "Add" button allowed moving all stocks to a separate modal
- Footer text changed to state status vs. expected functioning whilst allowing pull to refresh
- Trading stocks is a numbers focused task, so numbers, trends and symbols need to be easily parsed. From accessibilityRotor to jump to either up or down trending stocks, to audioGraphs, to custom accessibilitySortPriority information should feel easier to skim through now

<img width="369" alt="A screenshot of a very modified project showing a list of favorited stocks" src="https://user-images.githubusercontent.com/5402357/170651202-d9460172-9309-42a4-819e-ad2a2dd0c1cf.png">


There's a lot more to list and I'll leave those in the code comments. 
Thank you for the event - I've learnt a lot!
