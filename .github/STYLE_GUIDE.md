# Style Guide
**This is a fake document for demo purposes**
Producing a real one depends on decisions with respect to the documentation app.

Check [GDDSG](https://developers.google.com/style/) for inspiration.
Not a law but a suggestions, helps us to achieve consistency.

## Basics
We use UK/US spelling, please spell check your stuff.

Politeness is great, but can make documentation hard to read.
*   GOOD: ``To launch exist without desktop integration use the shell: <filename>bin/startup.sh</filename>``
*   BAD: ``However, you may always use the provided shell scripts <filename>bin/startup.sh</filename>
to launch eXist-db in the normal way without desktop integration.``

The documentation consists of two basic types of contents:
*   Tutorials
*   Documentation

When editing existing documents, or when creating new ones please make sure which category you are contributing to.

### Tutorials
Most how-to's and tutorials are aimed at new users, don't assume familiarity with *basic* web-technologies such as javascript, XML concepts, etc. Tutorials should get new users going quickly, so they often skip technical information.
e.g. in a tutorial it just matters what a function, document, app, etc does.

Tutorials are conversational, and talk their audience through a program step-by-step. Screencasts, and or screenshots are great tools for that.

### Documentation
Consider multiple audiences. Documentation on the other hand, is used by beginners, intermediate and advanced users alike. Does your explanation of the topic address all three groups? If not consider splitting your topic into both a tutorial and a documentation.

Be specific. Details of how a function, document or app does what it does are important. So links to external javadocs, function definitions, XQuery specs, or similar materials are important. Avoid value language like: "It is easy to" stick to what users who would like to adapt your topic to their own needs require to know.

Instead of screencasts and screenshots, use code listings, try to cover various usage scenarios.


## Docbook

Use ``exist-db`` for greater consistency, stick to describing the current version of exist-db, but avoid mentioning its version number in the prose content.   

### code listings
avoid silent glyphs like ``""`` or ``()`` around code listings.
*   GOOD: ``use the shell scripts <filename>bin/startup.sh</filename>
to ...``
*   BAD: ``use the  shell scripts (<filename>bin/startup.sh</filename>)
to ...``

### info boxes
we has them consistency would help. Avoid putting ``Warning`` ``Note`` etc into the title, use the appropriate box types instead.
*   warning
*   note

```xml
<docbook>
  <note> ... </note>
</docbook>  
```

### screenshots
Screenshots of, e.g. eXide or Dashboard, should be versioned so they can be more easily updated. Simply include the version in the file name of the png:
``dashboard-v0.0.2.png``

### links
avoid links to external resources from within the main text. Such links should go into further reading table at the bottom of each page.
