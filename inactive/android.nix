# Setup ADB for unpriviledge user
{
  programs.adb.enable = true;
  users.users.peter.extraGroups = ["adbusers"];
}

