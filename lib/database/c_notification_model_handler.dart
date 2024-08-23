class CNotificationModelHandler {
  var wake = _WakeHandler();
  var std = _StdHandler();
  var flash = _FlashHandler();
}

class _StdHandler {
  download() {}

  markAsRead() {}

  ignoreIt() {}
}

class _WakeHandler {
  download() {}

  markAsRead() {}

  ignoreIt() {}
}

class _FlashHandler {
  download() {}

  markAsRead() {}

  ignoreIt() {}
}
