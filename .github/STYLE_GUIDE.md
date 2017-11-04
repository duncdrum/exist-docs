# Style Guide
Not a law but a suggestions, helps us to achieve consistency.

## Basics
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
