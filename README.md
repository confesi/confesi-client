## Confesi - Mobile App Repo (Flutter)
### Installing and running the project
#### Fork the repository
 1. Create a Github account.
 2. Go to https://github.com/mattrltrent/confesi-frontend
 3. Go to the `main` branch and click the "Fork" button on the top right corner.
 4. This will allow you to have your own copy of the project.
#### Clone your fork to local machine
 1. Open the directory on your computer where you want to put the code. For example, `mkdir project`.
 2. Go into your newly created directory: `cd project`.
 3. Open your newly forked repository on Github.
 4. Click "Clone or Download" and copy the url.
 5. Run the command `git clone <COPIED_URL_HERE>` in your `project` directory. This will download the project to your local machine.
#### Initial setup
 1. Go into the directory of the server (you just cloned it) by running `cd confesi-frontend`.
 2. Run the command `flutter pub get` to install the project's [pub](https://pub.dev/) dependencies.
#### Running the project
 1. Inside the `confesi-frontend` directory, run the command `flutter run` with a physical device attached to your computer via USB (ensure USB debugging is enabled on the physical device). This command will start run the app in [debug mode](https://docs.flutter.dev/testing/build-modes). The `flutter run` command can be complimented with a `--profile` at the end to run it in [profile mode](https://docs.flutter.dev/testing/build-modes) like so: `flutter run --profile`. This will run the app without debug tools, making it much faster (getting closer to production build speeds).
 2. Alternatively, inside the `confesi-frontend` directory, run the command `flutter run -d chrome` to run the app on web (this is buggy - Flutter web isn't fully stable yet). In place of "chrome" in the command, you can substitute it for another device name (device names found by running `flutter devices`). The `--profile` flag can also be appended to the end of this command like so: `flutter run -d chrome --profile` to achieve [profile mode](https://docs.flutter.dev/testing/build-modes) on the web. 
 3. To hot restart the app, press `SHIFT + r` while in the terminal (updates changes and resets state). To hot reload the app, press `r` while in the terminal (updates changes while keeping state).
 4. Your app is now running!
