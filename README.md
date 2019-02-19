# HumbleBundleDownloader

This is a bulk downloader for your Humble Bundle Purchases. It was written with Delphi 10.3 Rio using VCL for Windows. It makes use of the [Chromium based CEF4Delphi](https://github.com/salvadordf/CEF4Delphi) to manage the cookie and authentication to access the Humble Bundle API. 

The app is currently working, but may require some effort to get setup and working for you. I plan to add a lot more polish and options to it. Currently all the files & cache are downloaded into the Windows Temporary folder. 

**Installation:** You need to install [CEF4Delphi](https://github.com/salvadordf/CEF4Delphi) and place the necessary binaries in your bin folder.

**Usage:** When you click *Get Keys* then it will make a connection to the API and prompt you to login. After that the cookies are persisted by the Chromium instance. Then click Get URLs and it will cycle through each key and grab all the URLs for them. It persists keys and the JSON details in between runs in the Temp folder. It also stores the JSON instances in a FDMemTable that is persisted as a bin file.

Use TabSheet2 to specify a filter and then download everything that matches that filter. It creates a thread pool to download everything, but I don't have any management on the threadpool yet.

Use TabSheet3 to get a total of how much you've spent on HumbleBundle. If you are like me you may want to make sure you are sitting down for that.

**See also**: When I started this I didn't see any other downloaders, but since then I've discovered this [one written in Python by Talonius](https://github.com/talonius/hb-downloader), but I haven't tried it.
