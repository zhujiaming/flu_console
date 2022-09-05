#include "include/flu_console/flu_console_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flu_console_plugin.h"

void FluConsolePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flu_console::FluConsolePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
