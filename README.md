#Demo Project#

This is a demo project that builds a Flybits-enabled App using a step by step process with Xcode snippets.

Before using this project, be sure to add ``FlybitsSDK.framework``, ``Alamofire.framework`` and ``MQTTFramework.framework`` as downloaded from the Flybits Developer Portal [https://developer.flybits.com](https://developer.flybits.com) to the ``Frameworks`` directory of this project.

After cloning the project, you will find code in the `Snippets` directory that should be placed in your personal `CodeSnippets` directory:

``cp Snippets/* ~/Library/Developer/Xcode/UserData/CodeSnippets``

From there, you can auto-complete each of the sections in the sample by typing a `t` followed by the section number i.e.

```
#!Swift
// Tutorial Section 0.0
t00
```

Translates into:

```
#!Swift
// Tutorial Section 0.0
Session.sharedInstance.configuration.APIKey = "API KEY"
print("Server: \(Session.sharedInstance.configuration.serverURL)")

Session.sharedInstance.configuration.preferredLocales = [
    NSLocale(localeIdentifier: "en_US"),
    NSLocale(localeIdentifier: "fr_FR")
]
```