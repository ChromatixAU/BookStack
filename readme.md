# BookStack
[![Build Status](https://travis-ci.org/ChromatixAU/BookStack.svg)](https://travis-ci.org/ChromatixAU/BookStack)

This is the Chromatix version of the BookstackApp project, which is also
buildable as a Docker image.

## Tagging
So that we don't conflict with the existing tagging formats used by upstream,
when we make deployment tags, the general format we use is:

```
build-YYYYMMDD-NN # e.g. build-20170821-01
```
YYYYMMDD is Year-Month-Date, and an incremental build number for the day
appended after a hyphen.

## Attribution

In addition to the [https://github.com/BookStackApp/BookStack#attribution](main BookStack attribution list), 

We also:

* Based our Docker implementation off [https://github.com/solidnerd/docker-bookstack](solidnerd/docker-bookstack).
