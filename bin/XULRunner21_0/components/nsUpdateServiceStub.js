/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/*
//@line 6 "c:\WSG\Projects\ABCpdf\Source\mozilla-release\toolkit\mozapps\update\nsUpdateServiceStub.js"
*/
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
Components.utils.import("resource://gre/modules/FileUtils.jsm");

const Ci = Components.interfaces;

const DIR_UPDATES         = "updates";
const FILE_UPDATE_STATUS  = "update.status";

const KEY_UPDROOT         = "UpdRootD";

/**
//@line 24 "c:\WSG\Projects\ABCpdf\Source\mozilla-release\toolkit\mozapps\update\nsUpdateServiceStub.js"
 */
function getUpdateDirNoCreate(pathArray) {
  return FileUtils.getDir(KEY_UPDROOT, pathArray, false);
}

function UpdateServiceStub() {
  let statusFile = getUpdateDirNoCreate([DIR_UPDATES, "0"]);
  statusFile.append(FILE_UPDATE_STATUS);
  // If the update.status file exists then initiate post update processing.
  if (statusFile.exists()) {
    let aus = Components.classes["@mozilla.org/updates/update-service;1"].
              getService(Ci.nsIApplicationUpdateService).
              QueryInterface(Ci.nsIObserver);
    aus.observe(null, "post-update-processing", "");
  }
}
UpdateServiceStub.prototype = {
  observe: function(){},
  classID: Components.ID("{e43b0010-04ba-4da6-b523-1f92580bc150}"),
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIObserver])
};

this.NSGetFactory = XPCOMUtils.generateNSGetFactory([UpdateServiceStub]);
