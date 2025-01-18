import 'dart:developer';

const kLogTag = "NAVY";
const kLogEnable = true;

printLog(dynamic data) {
  if (kLogEnable) {
    log(data.toString(), name: kLogTag);
  }
}
