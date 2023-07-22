import '../../../domain/authentication_and_settings/usecases/launch_website.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


part 'website_launcher_state.dart';

class WebsiteLauncherCubit extends Cubit<WebsiteLauncherState> {
  final LaunchWebsite launchWebsiteUsecase;

  WebsiteLauncherCubit({required this.launchWebsiteUsecase}) : super(WebsiteLauncherBase());

  // resets the cubit state to base
  void setContactStateToBase() => emit(WebsiteLauncherBase());

  // launch posted content link
  void launchPostLink(String link) async {
    (await launchWebsiteUsecase.call(link)).fold(
      (failure) {
        emit(WebsiteLauncherError(message: "Unable to open website."));
      },
      (success) => {}, // Nothing needed if it works, as the mail client would be clearly opening
    );
  }

  // opens our website to the home page
  void launchWebsiteHome() async {
    (await launchWebsiteUsecase.call("https://confesi.com")).fold(
      (failure) {
        emit(WebsiteLauncherError(message: "Unable to open website."));
      },
      (success) => {}, // Nothing needed if it works, as the webpage would be clearly opening
    );
  }

  // opens our website to the terms of service page
  void launchWebsiteTermsOfService() async {
    (await launchWebsiteUsecase.call("https://confesi.com/terms-of-service.html")).fold(
      (failure) {
        emit(WebsiteLauncherError(message: "Unable to open terms of service."));
      },
      (success) => {}, // Nothing needed if it works, as the webpage would be clearly opening
    );
  }

  // opens our website to the community rules page
  void launchWebsiteCommunityRules() async {
    (await launchWebsiteUsecase.call("https://confesi.com/community-guidelines.html")).fold(
      (failure) {
        emit(WebsiteLauncherError(message: "Unable to open community rules."));
      },
      (success) => {}, // Nothing needed if it works, as the webpage would be clearly opening
    );
  }

  // opens our website to the privacy statement page
  void launchWebsitePrivacyStatement() async {
    (await launchWebsiteUsecase.call("https://confesi.com/privacy-policy.html")).fold(
      (failure) {
        emit(WebsiteLauncherError(message: "Unable to open privacy statement."));
      },
      (success) => {}, // Nothing needed if it works, as the webpage would be clearly opening
    );
  }
}
