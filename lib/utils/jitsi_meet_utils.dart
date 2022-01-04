import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class JitsiMeetUtils {
  var isAudioOnly = false;
  var isAudioMuted = true;
  var isVideoMuted = false;
  String serverUrl = 'https://meet.jit.si/'; // get it from the backend code;
  joinMeeting({String? roomCode, String? nameText}) async {
    try {
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };

      if (Platform.isAndroid) {
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      }

      featureFlags[FeatureFlagEnum.INVITE_ENABLED] = false;

      var options = JitsiMeetingOptions(room: roomCode!)
        ..serverURL = serverUrl
        ..userDisplayName = nameText
        ..featureFlags = featureFlags
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;
        // ..webOptions = {
        //   // "roomName": roomText.text,
        //   "width": "100%",
        //   "height": "100%",
        //   "enableWelcomePage": false,
        //   "chromeExtensionBanner": null,
        //   // "interfaceConfigOverwrite": {
        //   //   "DEFAULT_BACKGROUND": '#000000',
        //   // },
        //   "userInfo": {"displayName": nameText}
        // };

      // debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: (message) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: (message) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: (message) {
          debugPrint("${options.room} terminated with message: $message");
        }),
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  hostMeeting({
    String? roomCode,
    String? meetingTitle,
  }) async {
    try {
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        FeatureFlagEnum.INVITE_ENABLED: false,
      };
      if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }

      var options = JitsiMeetingOptions(room: roomCode!)
        ..serverURL = serverUrl
        ..featureFlags.addAll(featureFlags)
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..webOptions = {
          // "roomName": roomText.text,
          "width": "100%",
          "height": "100%",
          "enableWelcomePage": false,
          "chromeExtensionBanner": null,
          // "interfaceConfigOverwrite": {
          //   "DEFAULT_BACKGROUND": '#000000',
          // },
          "userInfo": {"displayName": "host"}
        };

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: (message) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: (message) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: (message) {
          debugPrint("${options.room} terminated with message: $message");
        }),
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  void onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
